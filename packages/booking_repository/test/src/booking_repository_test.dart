import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient;

void main() {
  group(BookingRepository, () {
    late ApiClient apiClient;
    late BookingRepository bookingRepository;

    final startDate = DateTime(2024);
    final endDate = DateTime(2024, 1, 7);

    const destination = Destination(
      ref: 'destinationRef',
      name: 'name',
      country: 'country',
      continent: 'continent',
      knownFor: 'knownFor',
      tags: ['tag'],
      imageUrl: 'imageUrl',
    );

    const activity = Activity(
      name: 'name',
      description: 'description',
      locationName: 'locationName',
      duration: 1,
      timeOfDay: TimeOfDay.any,
      familyFriendly: true,
      price: 1,
      destinationRef: 'destinationRef',
      ref: 'activityRef',
      imageUrl: 'imageUrl',
    );

    const otherActivity = Activity(
      name: 'otherName',
      description: 'otherDescription',
      locationName: 'otherLocationName',
      duration: 2,
      timeOfDay: TimeOfDay.morning,
      familyFriendly: false,
      price: 2,
      destinationRef: 'destinationRef',
      ref: 'otherActivityRef',
      imageUrl: 'otherImageUrl',
    );

    setUpAll(() {
      registerFallbackValue(
        BookingApiModel(
          startDate: startDate,
          endDate: endDate,
          name: 'name',
          destinationRef: 'destinationRef',
          activitiesRef: const [],
        ),
      );
    });

    setUp(() {
      apiClient = _MockApiClient();
      bookingRepository = BookingRepository(apiClient: apiClient);
    });

    test('can be instantiated', () {
      expect(bookingRepository, isNotNull);
    });

    group('createBooking', () {
      final booking = Booking(
        startDate: startDate,
        endDate: endDate,
        destination: destination,
        activities: const [activity, otherActivity],
      );

      final bookingApiModel = BookingApiModel(
        startDate: startDate,
        endDate: endDate,
        name: 'name, continent',
        destinationRef: 'destinationRef',
        activitiesRef: const ['activityRef', 'otherActivityRef'],
      );

      test('posts a BookingApiModel built from the given Booking', () async {
        when(() => apiClient.postBooking(any()))
            .thenAnswer((_) async => bookingApiModel);

        await bookingRepository.createBooking(booking);

        verify(() => apiClient.postBooking(bookingApiModel)).called(1);
      });

      test('rethrows when the api client throws', () async {
        when(() => apiClient.postBooking(any()))
            .thenThrow(const HttpException('Invalid response'));

        await expectLater(
          bookingRepository.createBooking(booking),
          throwsA(isA<HttpException>()),
        );
      });
    });

    group('getBooking', () {
      final bookingApiModel = BookingApiModel(
        id: 1,
        startDate: startDate,
        endDate: endDate,
        name: 'name, continent',
        destinationRef: 'destinationRef',
        activitiesRef: const ['activityRef'],
      );

      final expectedBooking = Booking(
        id: 1,
        startDate: startDate,
        endDate: endDate,
        destination: destination,
        activities: const [activity],
      );

      test('returns a Booking combining the booking, destination and '
          'activities from the api client', () async {
        when(() => apiClient.getBooking(1))
            .thenAnswer((_) async => bookingApiModel);
        when(() => apiClient.getDestinations())
            .thenAnswer((_) async => [destination]);
        when(() => apiClient.getActivityByDestination('destinationRef'))
            .thenAnswer((_) async => [activity, otherActivity]);

        final result = await bookingRepository.getBooking(1);

        expect(result, equals(expectedBooking));
      });

      test('caches destinations and does not fetch them again on '
          'subsequent calls', () async {
        when(() => apiClient.getBooking(1))
            .thenAnswer((_) async => bookingApiModel);
        when(() => apiClient.getDestinations())
            .thenAnswer((_) async => [destination]);
        when(() => apiClient.getActivityByDestination('destinationRef'))
            .thenAnswer((_) async => [activity]);

        final firstResult = await bookingRepository.getBooking(1);
        final secondResult = await bookingRepository.getBooking(1);

        expect(firstResult, equals(expectedBooking));
        expect(secondResult, equals(expectedBooking));
        verify(() => apiClient.getDestinations()).called(1);
      });

      test('rethrows when the api client fails to get the booking', () async {
        when(() => apiClient.getBooking(1))
            .thenThrow(const HttpException('Invalid response'));

        await expectLater(
          bookingRepository.getBooking(1),
          throwsA(isA<HttpException>()),
        );

        verifyNever(() => apiClient.getDestinations());
      });

      test('rethrows when the api client fails to get destinations', () async {
        when(() => apiClient.getBooking(1))
            .thenAnswer((_) async => bookingApiModel);
        when(() => apiClient.getDestinations())
            .thenThrow(const HttpException('Invalid response'));

        await expectLater(
          bookingRepository.getBooking(1),
          throwsA(isA<HttpException>()),
        );
      });

      test('rethrows when the api client fails to get activities', () async {
        when(() => apiClient.getBooking(1))
            .thenAnswer((_) async => bookingApiModel);
        when(() => apiClient.getDestinations())
            .thenAnswer((_) async => [destination]);
        when(() => apiClient.getActivityByDestination('destinationRef'))
            .thenThrow(const HttpException('Invalid response'));

        await expectLater(
          bookingRepository.getBooking(1),
          throwsA(isA<HttpException>()),
        );
      });
    });

    group('getBookingsList', () {
      test('returns a list of BookingSummary from the api client', () async {
        final bookingApiModels = [
          BookingApiModel(
            id: 1,
            startDate: startDate,
            endDate: endDate,
            name: 'name',
            destinationRef: 'destinationRef',
            activitiesRef: const [],
          ),
          BookingApiModel(
            id: 2,
            startDate: startDate,
            endDate: endDate,
            name: 'otherName',
            destinationRef: 'otherDestinationRef',
            activitiesRef: const [],
          ),
        ];

        when(() => apiClient.getBookings())
            .thenAnswer((_) async => bookingApiModels);

        final result = await bookingRepository.getBookingsList();

        expect(
          result,
          equals([
            BookingSummary(
              id: 1,
              name: 'name',
              startDate: startDate,
              endDate: endDate,
            ),
            BookingSummary(
              id: 2,
              name: 'otherName',
              startDate: startDate,
              endDate: endDate,
            ),
          ]),
        );
      });

      test('rethrows when the api client throws', () async {
        when(() => apiClient.getBookings())
            .thenThrow(const HttpException('Invalid response'));

        await expectLater(
          bookingRepository.getBookingsList(),
          throwsA(isA<HttpException>()),
        );
      });
    });

    group('delete', () {
      test('deletes the booking with the given id', () async {
        when(() => apiClient.deleteBooking(1)).thenAnswer((_) async {});

        await bookingRepository.delete(1);

        verify(() => apiClient.deleteBooking(1)).called(1);
      });

      test('rethrows when the api client throws', () async {
        when(() => apiClient.deleteBooking(1))
            .thenThrow(const HttpException('Invalid response'));

        await expectLater(
          () => bookingRepository.delete(1),
          throwsA(isA<HttpException>()),
        );
      });
    });
  });
}
