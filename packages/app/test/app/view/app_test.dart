import 'dart:async';

import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:compass_app/app/app.dart';
import 'package:compass_app/booking/booking.dart';
import 'package:compass_app/home/home.dart';
import 'package:compass_app/login/login.dart';
import 'package:continent_repository/continent_repository.dart';
import 'package:destination_repository/destination_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:models/models.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group(App, () {
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

      when(() => authenticationRepository.isAuthenticated)
          .thenAnswer((_) => Stream.value(true));
    });

    testWidgets(
      'renders $AppView',
      (tester) => mockNetworkImages(() async {
        await tester.pumpWidget(
          App(
            activityRepository: activityRepository,
            authenticationRepository: authenticationRepository,
            bookingRepository: bookingRepository,
            continentRepository: continentRepository,
            deepLinks: const Stream.empty(),
            destinationRepository: destinationRepository,
            itineraryConfigRepository: itineraryConfigRepository,
            userRepository: userRepository,
          ),
        );
        expect(find.byType(AppView), findsOneWidget);
      }),
    );

    testWidgets(
      'follows authentication changes',
      (tester) => mockNetworkImages(() async {
        final isAuthenticated = StreamController<bool>();
        addTearDown(isAuthenticated.close);
        when(() => authenticationRepository.isAuthenticated)
            .thenAnswer((_) => isAuthenticated.stream);
        when(userRepository.getUser).thenAnswer(
          (_) async => const User(name: 'Alice', picture: 'assets/user.jpg'),
        );
        when(bookingRepository.getBookingsList).thenAnswer((_) async => []);

        await tester.pumpWidget(
          App(
            activityRepository: activityRepository,
            authenticationRepository: authenticationRepository,
            bookingRepository: bookingRepository,
            continentRepository: continentRepository,
            deepLinks: const Stream.empty(),
            destinationRepository: destinationRepository,
            itineraryConfigRepository: itineraryConfigRepository,
            userRepository: userRepository,
          ),
        );
        expect(find.byType(LoginPage), findsOneWidget);

        isAuthenticated.add(true);
        await tester.pump();
        await tester.pump();
        expect(find.byType(HomePage), findsOneWidget);
      }),
    );
    group('deep links', () {
      late StreamController<Uri> deepLinks;

      setUp(() {
        deepLinks = StreamController<Uri>();
        when(userRepository.getUser).thenAnswer(
          (_) async => const User(name: 'Alice', picture: 'assets/user.jpg'),
        );
        when(bookingRepository.getBookingsList).thenAnswer((_) async => []);
        when(() => bookingRepository.getBooking(1)).thenThrow(Exception());
      });

      tearDown(() => deepLinks.close());

      Future<void> pumpApp(WidgetTester tester) async {
        await tester.pumpWidget(
          App(
            activityRepository: activityRepository,
            authenticationRepository: authenticationRepository,
            bookingRepository: bookingRepository,
            continentRepository: continentRepository,
            deepLinks: deepLinks.stream,
            destinationRepository: destinationRepository,
            itineraryConfigRepository: itineraryConfigRepository,
            userRepository: userRepository,
          ),
        );
        await tester.pump();
      }

      testWidgets(
        'opens the linked page',
        (tester) => mockNetworkImages(() async {
          await pumpApp(tester);
          expect(find.byType(HomePage), findsOneWidget);

          deepLinks.add(Uri.parse('https://compass.app/booking/1'));
          await tester.pump();
          await tester.pump();
          expect(find.byType(BookingPage), findsOneWidget);
        }),
      );

      testWidgets(
        'returns to the linked page after login',
        (tester) => mockNetworkImages(() async {
          final isAuthenticated = StreamController<bool>();
          addTearDown(isAuthenticated.close);
          when(() => authenticationRepository.isAuthenticated)
              .thenAnswer((_) => isAuthenticated.stream);

          await pumpApp(tester);
          deepLinks.add(Uri.parse('https://compass.app/booking/1'));
          await tester.pump();
          await tester.pump();
          expect(find.byType(LoginPage), findsOneWidget);

          isAuthenticated.add(true);
          await tester.pump();
          await tester.pump();
          expect(find.byType(BookingPage), findsOneWidget);
        }),
      );

      testWidgets(
        'falls back to home for a malformed link',
        (tester) => mockNetworkImages(() async {
          await pumpApp(tester);

          deepLinks.add(Uri.parse('https://compass.app/booking/abc'));
          await tester.pump();
          await tester.pump();
          expect(find.byType(HomePage), findsOneWidget);
          expect(find.byType(BookingPage), findsNothing);
        }),
      );
    });
  });
}
