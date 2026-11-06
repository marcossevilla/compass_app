import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/login/login.dart';
import 'package:compass_app/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../helpers/helpers.dart';

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group(LoginPage, () {
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
    });

    testWidgets('renders $LoginView', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpApp(
          RepositoryProvider.value(
            value: authenticationRepository,
            child: const LoginPage(),
          ),
        );
      });

      expect(find.byType(LoginView), findsOneWidget);
    });

    testWidgets('logs in with the default credentials when tapping login', (
      tester,
    ) async {
      when(
        () => authenticationRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});

      await mockNetworkImages(() async {
        await tester.pumpApp(
          RepositoryProvider.value(
            value: authenticationRepository,
            child: const LoginPage(),
          ),
        );
        await tester.tap(find.byType(FilledButton));
        await tester.pump();
      });

      verify(
        () => authenticationRepository.login(
          email: 'email@example.com',
          password: 'password',
        ),
      ).called(1);
    });
  });

  group(LoginView, () {
    late LoginCubit loginCubit;
    late GoRouter goRouter;

    setUp(() {
      loginCubit = MockLoginCubit();
      goRouter = MockGoRouter();
      when(() => loginCubit.state).thenReturn(const LoginState());
      when(() => loginCubit.login(any())).thenAnswer((_) async {});
    });

    Future<void> pumpSubject(WidgetTester tester) {
      return mockNetworkImages(() async {
        await tester.pumpApp(
          BlocProvider.value(value: loginCubit, child: const LoginView()),
          goRouter: goRouter,
        );
      });
    }

    testWidgets('renders email and password fields and login button', (
      tester,
    ) async {
      await pumpSubject(tester);

      expect(find.byType(TiltedCards), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text(l10n.login), findsOneWidget);
    });

    testWidgets('calls login with entered credentials when tapping login', (
      tester,
    ) async {
      await pumpSubject(tester);

      await tester.enterText(find.byType(TextField).first, 'a@b.com');
      await tester.enterText(find.byType(TextField).last, 'secret');
      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      verify(() => loginCubit.login(('a@b.com', 'secret'))).called(1);
    });

    testWidgets('navigates home when status is success', (tester) async {
      whenListen(
        loginCubit,
        Stream.fromIterable(const [
          LoginState(status: LoginStatus.loading),
          LoginState(status: LoginStatus.success),
        ]),
        initialState: const LoginState(),
      );

      await pumpSubject(tester);
      await tester.pump();

      verify(() => goRouter.go(Routes.home)).called(1);
    });

    testWidgets('does nothing when status is initial', (tester) async {
      whenListen(
        loginCubit,
        Stream.fromIterable(const [
          LoginState(status: LoginStatus.loading),
          LoginState(),
        ]),
        initialState: const LoginState(),
      );

      await pumpSubject(tester);
      await tester.pump();

      verifyNever(() => goRouter.go(any()));
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('shows a snackbar when status is failure', (tester) async {
      whenListen(
        loginCubit,
        Stream.fromIterable(const [LoginState(status: LoginStatus.failure)]),
        initialState: const LoginState(),
      );

      await pumpSubject(tester);
      await tester.pump();

      expect(find.text(l10n.errorWhileLogin), findsOneWidget);
    });

    testWidgets('retries login when tapping the snackbar action', (
      tester,
    ) async {
      whenListen(
        loginCubit,
        Stream.fromIterable(const [LoginState(status: LoginStatus.failure)]),
        initialState: const LoginState(),
      );

      await pumpSubject(tester);
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.tryAgain));
      await tester.pump();

      verify(() => loginCubit.login(('email@example.com', 'password')))
          .called(1);
    });
  });
}
