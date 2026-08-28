import 'dart:io';

import 'package:activity_repository/activity_repository.dart';
import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group(ActivityRepository, () {
    late ApiClient apiClient;
    late ActivityRepository activityRepository;

    const activity = Activity(
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

    const otherActivity = Activity(
      name: 'otherName',
      description: 'otherDescription',
      locationName: 'otherLocationName',
      duration: 2,
      timeOfDay: TimeOfDay.morning,
      familyFriendly: false,
      price: 2,
      destinationRef: 'otherDestinationRef',
      ref: 'otherRef',
      imageUrl: 'otherImageUrl',
    );

    setUp(() {
      apiClient = _MockApiClient();
      activityRepository = ActivityRepository(apiClient: apiClient);
    });

    test('can be instantiated', () {
      expect(activityRepository, isNotNull);
    });

    group('getByDestination', () {
      test('returns activities from the api client', () async {
        when(() => apiClient.getActivityByDestination('destinationRef'))
            .thenAnswer((_) async => [activity]);

        final result = await activityRepository.getByDestination(
          'destinationRef',
        );

        expect(result, equals([activity]));
        verify(() => apiClient.getActivityByDestination('destinationRef'))
            .called(1);
      });

      test(
        'returns cached activities without calling the api client again',
        () async {
          when(() => apiClient.getActivityByDestination('destinationRef'))
              .thenAnswer((_) async => [activity]);

          final firstResult = await activityRepository.getByDestination(
            'destinationRef',
          );
          final secondResult = await activityRepository.getByDestination(
            'destinationRef',
          );

          expect(firstResult, equals([activity]));
          expect(secondResult, equals([activity]));
          verify(() => apiClient.getActivityByDestination('destinationRef'))
              .called(1);
        },
      );

      test('caches activities independently per destination', () async {
        when(() => apiClient.getActivityByDestination('destinationRef'))
            .thenAnswer((_) async => [activity]);
        when(() => apiClient.getActivityByDestination('otherDestinationRef'))
            .thenAnswer((_) async => [otherActivity]);

        final result = await activityRepository.getByDestination(
          'destinationRef',
        );
        final otherResult = await activityRepository.getByDestination(
          'otherDestinationRef',
        );

        expect(result, equals([activity]));
        expect(otherResult, equals([otherActivity]));
        verify(() => apiClient.getActivityByDestination('destinationRef'))
            .called(1);
        verify(() => apiClient.getActivityByDestination('otherDestinationRef'))
            .called(1);
      });

      test('rethrows and does not cache when the api client throws', () async {
        when(() => apiClient.getActivityByDestination('destinationRef'))
            .thenThrow(const HttpException('Invalid response'));

        await expectLater(
          activityRepository.getByDestination('destinationRef'),
          throwsA(isA<HttpException>()),
        );

        when(() => apiClient.getActivityByDestination('destinationRef'))
            .thenAnswer((_) async => [activity]);

        final result = await activityRepository.getByDestination(
          'destinationRef',
        );

        expect(result, equals([activity]));
        verify(() => apiClient.getActivityByDestination('destinationRef'))
            .called(2);
      });
    });
  });
}
