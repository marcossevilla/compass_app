import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group(Continent, () {
    test('supports value comparisons', () {
      expect(
        Continent(name: 'name', imageUrl: 'imageUrl'),
        equals(Continent(name: 'name', imageUrl: 'imageUrl')),
      );
    });

    test(
      'can be instantiated',
      () => expect(Continent(name: 'name', imageUrl: 'imageUrl'), isNotNull),
    );

    test(
      'fromJson returns a valid Continent',
      () => expect(
        Continent.fromJson({'name': 'name', 'imageUrl': 'imageUrl'}),
        isNotNull,
      ),
    );

    test('toJson returns a valid map', () {
      expect(
        Continent(name: 'name', imageUrl: 'imageUrl').toJson(),
        equals({'name': 'name', 'imageUrl': 'imageUrl'}),
      );
    });
  });
}
