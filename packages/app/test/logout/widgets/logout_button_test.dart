import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/logout/logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockLogoutCubit extends MockCubit<LogoutState> implements LogoutCubit {}

void main() {
  group(LogoutButton, () {
    late AuthenticationRepository authenticationRepository;
    late ItineraryConfigRepository itineraryConfigRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      itineraryConfigRepository = MockItineraryConfigRepository();
    });

    Widget buildSubject() {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: authenticationRepository),
          RepositoryProvider.value(value: itineraryConfigRepository),
        ],
        child: const LogoutButton(),
      );
    }

    testWidgets('renders $LogoutButtonView with a logout icon', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(LogoutButtonView), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('calls logout when tapped', (tester) async {
      when(() => authenticationRepository.logout()).thenAnswer((_) async {});

      await tester.pumpApp(buildSubject());
      await tester.tap(find.byType(InkResponse));
      await tester.pump();

      verify(() => authenticationRepository.logout()).called(1);
    });
  });

  group(LogoutButtonView, () {
    late LogoutCubit logoutCubit;

    setUp(() {
      logoutCubit = MockLogoutCubit();
      when(() => logoutCubit.logout()).thenAnswer((_) async {});
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: logoutCubit,
        child: const LogoutButtonView(),
      );
    }

    testWidgets('shows a snackbar when status becomes failure', (tester) async {
      whenListen(
        logoutCubit,
        Stream.fromIterable(const [LogoutState(status: LogoutStatus.failure)]),
        initialState: const LogoutState(),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l10n.errorWhileLogout), findsOneWidget);
      expect(find.text(l10n.tryAgain), findsOneWidget);
    });

    testWidgets('retries logout when the snackbar action is tapped', (
      tester,
    ) async {
      whenListen(
        logoutCubit,
        Stream.fromIterable(const [LogoutState(status: LogoutStatus.failure)]),
        initialState: const LogoutState(),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      await tester.tap(find.text(l10n.tryAgain));
      await tester.pump();

      verify(() => logoutCubit.logout()).called(1);
    });

    testWidgets('does not show a snackbar for non-failure statuses', (
      tester,
    ) async {
      whenListen(
        logoutCubit,
        Stream.fromIterable(const [
          LogoutState(status: LogoutStatus.loading),
          LogoutState(status: LogoutStatus.success),
        ]),
        initialState: const LogoutState(),
      );

      await tester.pumpApp(buildSubject());
      await tester.pump();

      expect(find.byType(SnackBar), findsNothing);
    });
  });
}
