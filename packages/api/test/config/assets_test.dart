import 'package:api/api.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Assets', () {
    group('destinations', () {
      test('returns a list of destinations', () {
        expect(Assets.destinations, isA<List<Destination>>());
        expect(Assets.destinations, isNotEmpty);
      });
    });

    group('activities', () {
      test('returns a list of activities', () {
        expect(Assets.activities, isA<List<Activity>>());
        expect(Assets.activities, isNotEmpty);
      });
    });
  });
}
