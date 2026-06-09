import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../fixtures/fixtures.dart';

void main() {
  group(ItineraryConfig, () {
    late DateTime date;

    setUp(() {
      date = DateTime.now();
    });

    test('supports value comparisons', () {
      expect(
        ItineraryConfig(
          continent: 'continent',
          startDate: date,
          endDate: date,
          guests: 0,
          destination: 'destination',
          activities: ['activities'],
        ),
        equals(
          ItineraryConfig(
            continent: 'continent',
            startDate: date,
            endDate: date,
            guests: 0,
            destination: 'destination',
            activities: ['activities'],
          ),
        ),
      );
    });

    test(
      'can be instantiated',
      () => expect(
        ItineraryConfig(
          continent: 'continent',
          startDate: date,
          endDate: date,
          guests: 0,
          destination: 'destination',
          activities: ['activities'],
        ),
        isNotNull,
      ),
    );

    test('fromJson returns a valid ItineraryConfig', () {
      expect(ItineraryConfig.fromJson(itineraryConfigMap(date)), isNotNull);
    });

    test('toJson returns a valid map', () {
      final itineraryConfig = ItineraryConfig.fromJson(
        itineraryConfigMap(date),
      );
      expect(itineraryConfig.toJson(), equals(itineraryConfigMap(date)));
    });

    group('copyWith', () {
      test('returns same instance', () {
        final itineraryConfig = ItineraryConfig.fromJson(
          itineraryConfigMap(date),
        );
        expect(itineraryConfig.copyWith(), equals(itineraryConfig));
      });

      test('returns updated instance', () {
        final itineraryConfig = ItineraryConfig.fromJson(
          itineraryConfigMap(date),
        );
        final updatedItineraryConfig = itineraryConfig.copyWith(
          continent: 'updatedContinent',
          startDate: date,
          endDate: date,
          guests: 0,
          destination: 'updatedDestination',
          activities: ['updatedActivities'],
        );

        expect(
          updatedItineraryConfig,
          equals(
            ItineraryConfig(
              continent: 'updatedContinent',
              startDate: date,
              endDate: date,
              guests: 0,
              destination: 'updatedDestination',
              activities: ['updatedActivities'],
            ),
          ),
        );
      });

      test('preserves existing values when no overrides are provided', () {
        final itineraryConfig = ItineraryConfig.fromJson(
          itineraryConfigMap(date),
        );

        final copy = itineraryConfig.copyWith(continent: 'updatedContinent');

        expect(copy.continent, equals('updatedContinent'));
        expect(copy.startDate, equals(itineraryConfig.startDate));
        expect(copy.endDate, equals(itineraryConfig.endDate));
        expect(copy.guests, equals(itineraryConfig.guests));
        expect(copy.destination, equals(itineraryConfig.destination));
        expect(copy.activities, equals(itineraryConfig.activities));
      });
    });

    group('with default/empty values', () {
      test('can be instantiated with no arguments', () {
        expect(const ItineraryConfig(), isNotNull);
      });

      test('defaults activities to an empty list', () {
        expect(const ItineraryConfig().activities, isEmpty);
      });

      test('supports value comparisons when empty', () {
        expect(const ItineraryConfig(), equals(const ItineraryConfig()));
      });

      test('toJson serializes null optional fields', () {
        expect(
          const ItineraryConfig().toJson(),
          equals({
            'continent': null,
            'startDate': null,
            'endDate': null,
            'guests': null,
            'destination': null,
            'activities': <String>[],
          }),
        );
      });

      test('fromJson handles a minimal map', () {
        final itineraryConfig = ItineraryConfig.fromJson(
          const <String, Object?>{},
        );

        expect(itineraryConfig, equals(const ItineraryConfig()));
        expect(itineraryConfig.activities, isEmpty);
      });
    });
  });
}
