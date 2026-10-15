import 'dart:async';

import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:compass_app/activities/activities.dart';
import 'package:compass_app/booking/booking.dart';
import 'package:compass_app/home/home.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/login/login.dart';
import 'package:compass_app/results/results.dart';
import 'package:compass_app/routing/routing.dart';
import 'package:compass_app/search_form/search_form.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:continent_repository/continent_repository.dart';
import 'package:destination_repository/destination_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:models/models.dart';
import 'package:user_repository/user_repository.dart';

import '../helpers/helpers.dart';

void main() {
  group('router', () {
    late ActivityRepository activityRepository;
    late AuthenticationRepository authenticationRepository;
    late BookingRepository bookingRepository;
    late ContinentRepository continentRepository;
    late DestinationRepository destinationRepository;
    late ItineraryConfigRepository itineraryConfigRepository;
    late UserRepository userRepository;
    late ValueNotifier<bool> isAuthenticated;
    late GoRouter goRouter;

    setUp(() {
      activityRepository = MockActivityRepository();
      authenticationRepository = MockAuthenticationRepository();
      bookingRepository = MockBookingRepository();
      continentRepository = MockContinentRepository();
      destinationRepository = MockDestinationRepository();
      itineraryConfigRepository = MockItineraryConfigRepository();
      userRepository = MockUserRepository();

      // Keep every request pending so pages stay in their loading state.
      when(() => activityRepository.getByDestination(any()))
          .thenAnswer((_) => Completer<List<Activity>>().future);
      when(() => bookingRepository.getBooking(any()))
          .thenAnswer((_) => Completer<Booking>().future);
      when(() => bookingRepository.getBookingsList())
          .thenAnswer((_) => Completer<List<BookingSummary>>().future);
      when(() => continentRepository.getContinents())
          .thenAnswer((_) => Completer<List<Continent>>().future);
      when(() => destinationRepository.getDestinations())
          .thenAnswer((_) => Completer<List<Destination>>().future);
      when(() => userRepository.getUser())
          .thenAnswer((_) => Completer<User>().future);
      when(() => itineraryConfigRepository.itineraryConfig)
          .thenReturn(const ItineraryConfig());

      isAuthenticated = ValueNotifier(true);
      goRouter = router(isAuthenticated);
    });

    tearDown(() {
      goRouter.dispose();
      isAuthenticated.dispose();
    });

    Future<void> pumpRouter(WidgetTester tester) async {
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: activityRepository),
            RepositoryProvider.value(value: authenticationRepository),
            RepositoryProvider.value(value: bookingRepository),
            RepositoryProvider.value(value: continentRepository),
            RepositoryProvider.value(value: destinationRepository),
            RepositoryProvider.value(value: itineraryConfigRepository),
            RepositoryProvider.value(value: userRepository),
          ],
          child: MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.standard,
            routerConfig: goRouter,
          ),
        ),
      );
      await tester.pump();
    }

    Future<void> navigate(WidgetTester tester, String location) async {
      goRouter.go(location);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets(
      'renders $HomePage and loads home data when authenticated',
      (tester) => mockNetworkImages(() async {
        await pumpRouter(tester);

        expect(find.byType(HomePage), findsOneWidget);
        verify(() => userRepository.getUser()).called(1);
        verify(() => bookingRepository.getBookingsList()).called(1);
      }),
    );

    testWidgets(
      'redirects to $LoginPage when not authenticated',
      (tester) => mockNetworkImages(() async {
        isAuthenticated.value = false;

        await pumpRouter(tester);

        expect(find.byType(LoginPage), findsOneWidget);
        expect(find.byType(HomePage), findsNothing);
      }),
    );

    testWidgets(
      'redirects to $LoginPage when the user logs out',
      (tester) => mockNetworkImages(() async {
        await pumpRouter(tester);
        expect(find.byType(HomePage), findsOneWidget);

        isAuthenticated.value = false;
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(LoginPage), findsOneWidget);
      }),
    );

    testWidgets(
      'redirects from login to $HomePage when authenticated',
      (tester) => mockNetworkImages(() async {
        await pumpRouter(tester);

        await navigate(tester, Routes.login);

        expect(find.byType(HomePage), findsOneWidget);
        expect(find.byType(LoginPage), findsNothing);
      }),
    );

    testWidgets(
      'renders $SearchFormPage on ${Routes.search}',
      (tester) => mockNetworkImages(() async {
        await pumpRouter(tester);

        await navigate(tester, Routes.search);

        expect(find.byType(SearchFormPage), findsOneWidget);
      }),
    );

    testWidgets(
      'renders $ResultsPage on ${Routes.results}',
      (tester) => mockNetworkImages(() async {
        await pumpRouter(tester);

        await navigate(tester, Routes.results);

        expect(find.byType(ResultsPage), findsOneWidget);
      }),
    );

    testWidgets(
      'renders $ActivitiesPage on ${Routes.activities}',
      (tester) => mockNetworkImages(() async {
        await pumpRouter(tester);

        await navigate(tester, Routes.activities);

        expect(find.byType(ActivitiesPage), findsOneWidget);
      }),
    );

    testWidgets(
      'renders $BookingPage on ${Routes.booking}',
      (tester) => mockNetworkImages(() async {
        await pumpRouter(tester);

        await navigate(tester, Routes.booking);

        expect(find.byType(BookingPage), findsOneWidget);
      }),
    );

    testWidgets(
      'renders $BookingPage and loads the booking on ${Routes.booking}/:id',
      (tester) => mockNetworkImages(() async {
        await pumpRouter(tester);

        await navigate(tester, Routes.bookingWithId(42));

        expect(find.byType(BookingPage), findsOneWidget);
        verify(() => bookingRepository.getBooking(42)).called(1);
      }),
    );
  });
}
