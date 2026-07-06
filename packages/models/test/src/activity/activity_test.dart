import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../fixtures/fixtures.dart';

void main() {
  group(Activity, () {
    test('supports value comparisons', () {
      expect(
        Activity(
          name: 'name',
          description: 'description',
          locationName: 'locationName',
          duration: 1,
          timeOfDay: TimeOfDay.any,
          familyFriendly: true,
          price: 1,
          destinationRef: 'destinationRef',
          ref: 'ref',
          imageUrl: 'imageUrl',
        ),
        equals(
          Activity(
            name: 'name',
            description: 'description',
            locationName: 'locationName',
            duration: 1,
            timeOfDay: TimeOfDay.any,
            familyFriendly: true,
            price: 1,
            destinationRef: 'destinationRef',
            ref: 'ref',
            imageUrl: 'imageUrl',
          ),
        ),
      );
    });

    test('can be instantiated', () {
      expect(
        Activity(
          name: 'name',
          description: 'description',
          locationName: 'locationName',
          duration: 1,
          timeOfDay: TimeOfDay.any,
          familyFriendly: true,
          price: 1,
          destinationRef: 'destinationRef',
          ref: 'ref',
          imageUrl: 'imageUrl',
        ),
        isNotNull,
      );
    });

    test(
      'fromJson returns a valid Activity',
      () => expect(Activity.fromJson(activityMap), isNotNull),
    );

    test('toJson returns a valid map', () {
      final activity = Activity(
        name: 'name',
        description: 'description',
        locationName: 'locationName',
        duration: 1,
        timeOfDay: TimeOfDay.any,
        familyFriendly: true,
        price: 1,
        destinationRef: 'destinationRef',
        ref: 'ref',
        imageUrl: 'imageUrl',
      );

      expect(activity.toJson(), equals(activityMap));
    });

    test('round-trips every TimeOfDay value', () {
      for (final timeOfDay in TimeOfDay.values) {
        final activity = Activity(
          name: 'name',
          description: 'description',
          locationName: 'locationName',
          duration: 1,
          timeOfDay: timeOfDay,
          familyFriendly: true,
          price: 1,
          destinationRef: 'destinationRef',
          ref: 'ref',
          imageUrl: 'imageUrl',
        );

        expect(Activity.fromJson(activity.toJson()), equals(activity));
        expect(activity.toJson()['timeOfDay'], equals(timeOfDay.name));
      }
    });

    test('imageUrl is excluded from equality', () {
      const base = Activity(
        name: 'name',
        description: 'description',
        locationName: 'locationName',
        duration: 1,
        timeOfDay: TimeOfDay.any,
        familyFriendly: true,
        price: 1,
        destinationRef: 'destinationRef',
        ref: 'ref',
        imageUrl: 'imageUrl',
      );

      const differentImage = Activity(
        name: 'name',
        description: 'description',
        locationName: 'locationName',
        duration: 1,
        timeOfDay: TimeOfDay.any,
        familyFriendly: true,
        price: 1,
        destinationRef: 'destinationRef',
        ref: 'ref',
        imageUrl: 'otherImageUrl',
      );

      expect(base, equals(differentImage));
    });
  });
}
