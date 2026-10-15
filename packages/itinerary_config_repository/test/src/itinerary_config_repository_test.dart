import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group(ItineraryConfigRepository, () {
    late ItineraryConfigRepository repository;

    setUp(() {
      repository = ItineraryConfigRepository();
    });

    test('can be instantiated', () {
      expect(ItineraryConfigRepository(), isNotNull);
    });

    group('itineraryConfig', () {
      test('returns an empty config by default', () {
        expect(repository.itineraryConfig, equals(const ItineraryConfig()));
      });

      test('returns the config set through the setter', () {
        final config = ItineraryConfig(
          continent: 'continent',
          startDate: DateTime(2024),
          endDate: DateTime(2024, 1, 7),
          guests: 2,
          destination: 'destination',
          activities: const ['activity'],
        );

        repository.itineraryConfig = config;

        expect(repository.itineraryConfig, equals(config));
      });

      test('overwrites the config on each set', () {
        const first = ItineraryConfig(continent: 'first');
        const second = ItineraryConfig(continent: 'second');

        repository.itineraryConfig = first;
        expect(repository.itineraryConfig, equals(first));

        repository.itineraryConfig = second;
        expect(repository.itineraryConfig, equals(second));
      });
    });
  });
}
