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
    });
  });
}
