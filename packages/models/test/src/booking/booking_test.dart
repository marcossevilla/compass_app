import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../fixtures/fixtures.dart';

void main() {
  group(Booking, () {
    late DateTime date;

    setUp(() {
      date = DateTime.now();
    });

    test('supports value comparisons', () {
      expect(
        Booking(
          startDate: date,
          endDate: date,
          destination: Destination.fromJson(destinationMap),
          activities: [],
        ),
        equals(
          Booking(
            startDate: date,
            endDate: date,
            destination: Destination.fromJson(destinationMap),
            activities: [],
          ),
        ),
      );
    });

    test('can be instantiated', () {
      expect(
        Booking(
          startDate: date,
          endDate: date,
          destination: Destination.fromJson(destinationMap),
          activities: [],
        ),
        isNotNull,
      );
    });

    test(
      'fromJson returns a valid Booking',
      () => expect(
        Booking.fromJson({
          'startDate': date.toIso8601String(),
          'endDate': date.toIso8601String(),
          'destination': destinationMap,
          'activities': [activityMap],
        }),
        isNotNull,
      ),
    );

    test('toJson returns a valid JSON', () {
      final booking = Booking(
        id: 0,
        startDate: date,
        endDate: date,
        destination: Destination.fromJson(destinationMap),
        activities: [Activity.fromJson(activityMap)],
      );

      final bookingMap = {
        'id': 0,
        'startDate': date.toIso8601String(),
        'endDate': date.toIso8601String(),
        'destination': destinationMap,
        'activities': [activityMap],
      };

      expect(booking.toJson(), equals(bookingMap));
    });
  });

  group(BookingSummary, () {
    late DateTime date;

    setUp(() {
      date = DateTime.now();
    });

    test('supports value comparisons', () {
      expect(
        BookingSummary(id: 0, startDate: date, endDate: date, name: 'name'),
        equals(
          BookingSummary(id: 0, startDate: date, endDate: date, name: 'name'),
        ),
      );
    });

    test(
      'can be instantiated',
      () => expect(
        BookingSummary(id: 0, startDate: date, endDate: date, name: 'name'),
        isNotNull,
      ),
    );

    test('fromJson returns a valid BookingSummary', () {
      expect(
        BookingSummary.fromJson({
          'id': 0,
          'startDate': date.toIso8601String(),
          'endDate': date.toIso8601String(),
          'name': 'name',
        }),
        isNotNull,
      );
    });

    test('toJson returns a valid JSON', () {
      final bookingSummary = BookingSummary(
        id: 0,
        startDate: date,
        endDate: date,
        name: 'name',
      );

      final bookingSummaryMap = {
        'id': 0,
        'startDate': date.toIso8601String(),
        'endDate': date.toIso8601String(),
        'name': 'name',
      };

      expect(bookingSummary.toJson(), equals(bookingSummaryMap));
    });
  });

  group(BookingApiModel, () {
    late DateTime date;

    setUp(() {
      date = DateTime.now();
    });

    test('supports value comparisons', () {
      expect(
        BookingApiModel(
          id: 0,
          startDate: date,
          endDate: date,
          name: 'name',
          destinationRef: 'destinationRef',
          activitiesRef: ['activitiesRef'],
        ),
        equals(
          BookingApiModel(
            id: 0,
            startDate: date,
            endDate: date,
            name: 'name',
            destinationRef: 'destinationRef',
            activitiesRef: ['activitiesRef'],
          ),
        ),
      );
    });

    test('can be instantiated', () {
      expect(
        BookingApiModel(
          id: 0,
          startDate: date,
          endDate: date,
          name: 'name',
          destinationRef: 'destinationRef',
          activitiesRef: ['activitiesRef'],
        ),
        isNotNull,
      );
    });

    test('fromJson returns a valid BookingApiModel', () {
      expect(
        BookingApiModel.fromJson({
          'id': 0,
          'startDate': date.toIso8601String(),
          'endDate': date.toIso8601String(),
          'name': 'name',
          'destinationRef': 'destinationRef',
          'activitiesRef': ['activitiesRef'],
        }),
        isNotNull,
      );
    });

    test('toJson returns a valid JSON', () {
      final bookingApiModel = BookingApiModel(
        id: 0,
        startDate: date,
        endDate: date,
        name: 'name',
        destinationRef: 'destinationRef',
        activitiesRef: ['activitiesRef'],
      );

      final bookingApiModelMap = {
        'id': 0,
        'startDate': date.toIso8601String(),
        'endDate': date.toIso8601String(),
        'name': 'name',
        'destinationRef': 'destinationRef',
        'activitiesRef': ['activitiesRef'],
      };

      expect(bookingApiModel.toJson(), equals(bookingApiModelMap));
    });

    group('copyWith', () {
      test('returns same instance', () {
        final bookingApiModel = BookingApiModel(
          id: 0,
          startDate: date,
          endDate: date,
          name: 'name',
          destinationRef: 'destinationRef',
          activitiesRef: ['activitiesRef'],
        );

        expect(bookingApiModel.copyWith(), equals(bookingApiModel));
      });

      test('returns updated instance', () {
        final bookingApiModel = BookingApiModel(
          id: 0,
          startDate: date,
          endDate: date,
          name: 'name',
          destinationRef: 'destinationRef',
          activitiesRef: ['activitiesRef'],
        );

        final bookingApiModelCopy = bookingApiModel.copyWith(
          id: 1,
          startDate: date,
          endDate: date,
          name: 'other name',
          destinationRef: 'other destinationRef',
          activitiesRef: ['other activitiesRef'],
        );

        expect(bookingApiModelCopy, isNot(bookingApiModel));
      });
    });
  });
}
