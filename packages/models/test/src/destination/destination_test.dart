import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../fixtures/fixtures.dart';

void main() {
  group(Destination, () {
    test('supports value comparisons', () {
      expect(
        Destination(
          name: 'name',
          imageUrl: 'imageUrl',
          ref: 'ref',
          country: 'country',
          continent: 'continent',
          knownFor: 'knownFor',
          tags: ['tag'],
        ),
        equals(
          Destination(
            name: 'name',
            imageUrl: 'imageUrl',
            ref: 'ref',
            country: 'country',
            continent: 'continent',
            knownFor: 'knownFor',
            tags: ['tag'],
          ),
        ),
      );
    });

    test(
      'can be instantiated',
      () => expect(
        Destination(
          name: 'name',
          imageUrl: 'imageUrl',
          ref: 'ref',
          country: 'country',
          continent: 'continent',
          knownFor: 'knownFor',
          tags: ['tag'],
        ),
        isNotNull,
      ),
    );

    test(
      'fromJson returns a valid Destination',
      () => expect(Destination.fromJson(destinationMap), isNotNull),
    );

    test(
      'toJson returns a valid map',
      () => expect(
        Destination(
          name: 'name',
          imageUrl: 'imageUrl',
          ref: 'ref',
          country: 'country',
          continent: 'continent',
          knownFor: 'knownFor',
          tags: ['tag'],
        ).toJson(),
        equals(destinationMap),
      ),
    );
  });
}
