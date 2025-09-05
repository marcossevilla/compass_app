import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:test/test.dart';

void main() {
  group(ItineraryConfigRepository, () {
    test('can be instantiated', () {
      expect(ItineraryConfigRepository(), isNotNull);
    });
  });
}
