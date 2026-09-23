import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:compass_app/booking/booking.dart';
import 'package:compass_app/home/home.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/login/login.dart';
import 'package:compass_app/routing/routing.dart';
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

    setUp(() {
      activityRepository = MockActivityRepository();
      authenticationRepository = MockAuthenticationRepository();
      bookingRepository = MockBookingRepository();
      continentRepository = MockContinentRepository();
      destinationRepository = MockDestinationRepository();
      itineraryConfigRepository = MockItineraryConfigRepository();
      userRepository = MockUserRepository();

      when(userRepository.getUser).thenAnswer(
        (_) async => const User(name: 'Alice', picture: 'assets/user.jpg'),
      );
      when(bookingRepository.getBookingsList).thenAnswer((_) async => []);
    });

    Future<GoRouter> pumpRouter(
      WidgetTester tester,
      ValueNotifier<bool> isAuthenticated,
    ) async {
      final goRouter = router(isAuthenticated);
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
            routerConfig: goRouter,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pump();
      return goRouter;
    }

    test('registers every deep-link route by name', () {
      final goRouter = router(ValueNotifier(true));

      expect(goRouter.namedLocation('login'), '/login');
      expect(goRouter.namedLocation('home'), '/');
      expect(goRouter.namedLocation('search'), '/search');
      expect(goRouter.namedLocation('results'), '/results');
      expect(goRouter.namedLocation('activities'), '/activities');
      expect(goRouter.namedLocation('booking'), '/booking');
      expect(
        goRouter.namedLocation('bookingDetails', pathParameters: {'id': '1'}),
        '/booking/1',
      );
    });

    testWidgets('starts on the home location', (tester) async {
      final goRouter = await pumpRouter(tester, ValueNotifier(true));
      expect(
        goRouter.routerDelegate.currentConfiguration.uri.path,
        const HomeRoute().location,
      );
    });

    testWidgets(
      'redirects unauthenticated users to the login page',
      (tester) => mockNetworkImages(() async {
        await pumpRouter(tester, ValueNotifier(false));
        expect(find.byType(LoginPage), findsOneWidget);
      }),
    );

    testWidgets(
      'renders the home page for authenticated users',
      (tester) => mockNetworkImages(() async {
        await pumpRouter(tester, ValueNotifier(true));
        expect(find.byType(HomePage), findsOneWidget);
      }),
    );

    testWidgets(
      'opens a booking deep link',
      (tester) => mockNetworkImages(() async {
        when(() => bookingRepository.getBooking(1)).thenThrow(Exception());
        final goRouter = await pumpRouter(tester, ValueNotifier(true));
        goRouter.go('/booking/1');
        await tester.pump();
        expect(find.byType(BookingPage), findsOneWidget);
      }),
    );

    testWidgets(
      'returns to a deep link after login',
      (tester) => mockNetworkImages(() async {
        when(() => bookingRepository.getBooking(1)).thenThrow(Exception());
        final isAuthenticated = ValueNotifier(false);
        final goRouter = await pumpRouter(tester, isAuthenticated);

        goRouter.go('/booking/1');
        await tester.pump();
        expect(find.byType(LoginPage), findsOneWidget);
        expect(goRouter.state.uri.queryParameters['from'], '/booking/1');

        isAuthenticated.value = true;
        await tester.pump();
        expect(find.byType(BookingPage), findsOneWidget);
      }),
    );

    for (final location in ['/booking/abc', '/unknown']) {
      testWidgets(
        'falls back to home for $location',
        (tester) => mockNetworkImages(() async {
          final goRouter = await pumpRouter(tester, ValueNotifier(true));
          goRouter.go(location);
          await tester.pump();
          expect(find.byType(HomePage), findsOneWidget);
          expect(goRouter.state.uri.path, const HomeRoute().location);
        }),
      );
    }
  });
}
