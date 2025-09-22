import 'package:api/api.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group(Assets, () {
    group('.destinations', () {
      test('returns a list of [$Destination]', () {
        expect(Assets.destinations, isA<List<Destination>>());
        expect(Assets.destinations, isNotEmpty);
      });
    });

    group('.activities', () {
      test('returns a list of [$Activity]', () {
        expect(Assets.activities, isA<List<Activity>>());
        expect(Assets.activities, isNotEmpty);
      });
    });
  });
}
