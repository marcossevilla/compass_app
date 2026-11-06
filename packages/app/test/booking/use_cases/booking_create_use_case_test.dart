import 'package:activity_repository/activity_repository.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:compass_app/booking/booking.dart';
import 'package:destination_repository/destination_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

void main() {
  const destination = Destination(
    ref: 'alaska',
    name: 'Alaska',
    country: 'United States',
    continent: 'North America',
    knownFor: 'Wildlife',
    tags: ['Mountain'],
    imageUrl: 'https://example.com/alaska.jpg',
  );

  const otherDestination = Destination(
    ref: 'peru',
    name: 'Peru',
    country: 'Peru',
    continent: 'South America',
    knownFor: 'Machu Picchu',
    tags: ['Hiking'],
    imageUrl: 'https://example.com/peru.jpg',
  );

  Activity buildActivity(String ref) {
    return Activity(
      name: 'Activity $ref',
      description: 'Description $ref',
      locationName: 'Location $ref',
      duration: 1,
      timeOfDay: TimeOfDay.morning,
      familyFriendly: true,
      price: 1,
      destinationRef: 'alaska',
      ref: ref,
      imageUrl: 'https://example.com/$ref.jpg',
    );
  }

  final activityA = buildActivity('a');
  final activityB = buildActivity('b');

  group(BookingCreateUseCase, () {
    late ActivityRepository activityRepository;
    late BookingRepository bookingRepository;
    late DestinationRepository destinationRepository;
    late BookingCreateUseCase useCase;

    setUpAll(() {
      registerFallbackValue(
        Booking(
          startDate: DateTime(2024),
          endDate: DateTime(2024),
          destination: destination,
          activities: const [],
        ),
      );
    });

    setUp(() {
      activityRepository = MockActivityRepository();
      bookingRepository = MockBookingRepository();
      destinationRepository = MockDestinationRepository();

      when(() => destinationRepository.getDestinations())
          .thenAnswer((_) async => [otherDestination, destination]);
      when(() => activityRepository.getByDestination(any()))
          .thenAnswer((_) async => [activityA, activityB]);
      when(() => bookingRepository.createBooking(any()))
          .thenAnswer((_) async {});

      useCase = BookingCreateUseCase(
        activityRepository: activityRepository,
        bookingRepository: bookingRepository,
        destinationRepository: destinationRepository,
      );
    });

    group('createFrom', () {
      test('throws when destination is not set', () async {
        await expectLater(
          useCase.createFrom(const ItineraryConfig()),
          throwsA(isA<Exception>()),
        );
        verifyNever(() => destinationRepository.getDestinations());
      });

      test('throws when activities are not set', () async {
        await expectLater(
          useCase.createFrom(const ItineraryConfig(destination: 'alaska')),
          throwsA(isA<Exception>()),
        );
        verifyNever(() => activityRepository.getByDestination(any()));
      });

      test('throws when dates are not set', () async {
        await expectLater(
          useCase.createFrom(
            ItineraryConfig(
              destination: 'alaska',
              activities: const ['a'],
              startDate: DateTime(2024),
            ),
          ),
          throwsA(isA<Exception>()),
        );
        verifyNever(() => bookingRepository.createBooking(any()));
      });

      test('creates and stores a booking with selected activities', () async {
        final startDate = DateTime(2024);
        final endDate = DateTime(2024, 1, 5);

        final booking = await useCase.createFrom(
          ItineraryConfig(
            destination: 'alaska',
            activities: const ['b'],
            startDate: startDate,
            endDate: endDate,
          ),
        );

        final expected = Booking(
          startDate: startDate,
          endDate: endDate,
          destination: destination,
          activities: [activityB],
        );

        expect(booking, expected);
        verify(() => activityRepository.getByDestination('alaska')).called(1);
        verify(() => bookingRepository.createBooking(expected)).called(1);
      });
    });

    group('fetchDestination', () {
      test('returns the destination matching the ref', () async {
        expect(await useCase.fetchDestination('peru'), otherDestination);
      });
    });
  });
}
