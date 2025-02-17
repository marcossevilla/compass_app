import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:compass_app/app/app.dart';
import 'package:continent_repository/continent_repository.dart';
import 'package:destination_repository/destination_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('App', () {
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

      when(() => authenticationRepository.isAuthenticated).thenAnswer(
        (_) => Stream.value(true),
      );
    });

    testWidgets(
      'renders AppView',
      (tester) => mockNetworkImages(() async {
        await tester.pumpWidget(
          App(
            activityRepository: activityRepository,
            authenticationRepository: authenticationRepository,
            bookingRepository: bookingRepository,
            continentRepository: continentRepository,
            destinationRepository: destinationRepository,
            itineraryConfigRepository: itineraryConfigRepository,
            userRepository: userRepository,
          ),
        );
        expect(find.byType(AppView), findsOneWidget);
      }),
    );
  });
}
