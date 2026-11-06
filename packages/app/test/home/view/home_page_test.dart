import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/home/home.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/routing/routing.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

void main() {
  late AppLocalizations l10n;

  const user = User(name: 'Sofie', picture: 'assets/user.jpg');
  final booking = BookingSummary(
    id: 7,
    name: 'Alaska, North America',
    startDate: DateTime(2024),
    endDate: DateTime(2024, 1, 5),
  );

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group(HomePage, () {
    late HomeCubit homeCubit;

    setUp(() {
      homeCubit = MockHomeCubit();
      when(() => homeCubit.state).thenReturn(const HomeState());
    });

    testWidgets('renders $HomeView', (tester) async {
      await tester.pumpApp(HomePage(homeCubit: homeCubit));

      expect(find.byType(HomeView), findsOneWidget);
    });
  });

  group(HomeView, () {
    late HomeCubit homeCubit;
    late GoRouter goRouter;
    late AuthenticationRepository authenticationRepository;
    late ItineraryConfigRepository itineraryConfigRepository;

    setUp(() {
      homeCubit = MockHomeCubit();
      goRouter = MockGoRouter();
      authenticationRepository = MockAuthenticationRepository();
      itineraryConfigRepository = MockItineraryConfigRepository();
      when(() => homeCubit.state).thenReturn(const HomeState());
      when(() => homeCubit.load()).thenAnswer((_) async {});
      when(() => homeCubit.deleteBooking(any())).thenAnswer((_) async {});
      when(() => goRouter.push<Object?>(any(), extra: any(named: 'extra')))
          .thenAnswer((_) async => null);
    });

    Future<void> pumpSubject(WidgetTester tester) {
      return tester.pumpApp(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: authenticationRepository),
            RepositoryProvider.value(value: itineraryConfigRepository),
          ],
          child: BlocProvider.value(value: homeCubit, child: const HomeView()),
        ),
        goRouter: goRouter,
      );
    }

    void stubSuccess() {
      when(() => homeCubit.state).thenReturn(
        HomeState(user: user, bookings: [booking], status: HomeStatus.success),
      );
    }

    testWidgets('renders a progress indicator when status is initial', (
      tester,
    ) async {
      await pumpSubject(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders a progress indicator when status is loading', (
      tester,
    ) async {
      when(() => homeCubit.state)
          .thenReturn(const HomeState(status: HomeStatus.loading));

      await pumpSubject(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders $ErrorIndicator and retries load on tap', (
      tester,
    ) async {
      when(() => homeCubit.state)
          .thenReturn(const HomeState(status: HomeStatus.errorInitializing));

      await pumpSubject(tester);

      expect(find.byType(ErrorIndicator), findsOneWidget);
      expect(find.text(l10n.errorWhileLoadingHome), findsOneWidget);

      await tester.tap(find.text(l10n.tryAgain));
      await tester.pump();

      verify(() => homeCubit.load()).called(1);
    });

    testWidgets('renders header and bookings when status is success', (
      tester,
    ) async {
      stubSuccess();

      await pumpSubject(tester);

      expect(find.byType(HomeHeader), findsOneWidget);
      expect(find.text(booking.name), findsOneWidget);
    });

    testWidgets('navigates to search when tapping the booking button', (
      tester,
    ) async {
      stubSuccess();

      await pumpSubject(tester);
      await tester.tap(find.byKey(const ValueKey('booking-button')));
      await tester.pump();

      verify(() => goRouter.go(Routes.search)).called(1);
    });

    testWidgets('pushes booking route when tapping a booking', (tester) async {
      stubSuccess();

      await pumpSubject(tester);
      await tester.tap(find.text(booking.name));
      await tester.pump();

      verify(() => goRouter.push<Object?>(Routes.bookingWithId(booking.id)))
          .called(1);
    });

    testWidgets('deletes booking when dismissing it', (tester) async {
      stubSuccess();

      await pumpSubject(tester);
      await tester.drag(find.text(booking.name), const Offset(-1000, 0));
      await tester.pumpAndSettle();

      verify(() => homeCubit.deleteBooking(booking.id)).called(1);
      expect(find.text(booking.name), findsNothing);
    });

    testWidgets('shows a snackbar when booking is deleted', (tester) async {
      whenListen(
        homeCubit,
        Stream.fromIterable(const [
          HomeState(status: HomeStatus.bookingDeleted),
        ]),
        initialState: const HomeState(status: HomeStatus.success),
      );

      await pumpSubject(tester);
      await tester.pump();

      expect(find.text(l10n.bookingDeleted), findsOneWidget);
    });

    testWidgets('shows a snackbar when deleting a booking fails', (
      tester,
    ) async {
      whenListen(
        homeCubit,
        Stream.fromIterable(const [
          HomeState(status: HomeStatus.errorWhileDeletingBooking),
        ]),
        initialState: const HomeState(status: HomeStatus.success),
      );

      await pumpSubject(tester);
      await tester.pump();

      expect(find.text(l10n.errorWhileDeletingBooking), findsOneWidget);
    });
  });
}
