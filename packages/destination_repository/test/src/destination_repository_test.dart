import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:destination_repository/destination_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient;

void main() {
  group(DestinationRepository, () {
    late ApiClient apiClient;
    late DestinationRepository destinationRepository;

    const destination = Destination(
      ref: 'ref',
      name: 'name',
      country: 'country',
      continent: 'continent',
      knownFor: 'knownFor',
      tags: ['tag'],
      imageUrl: 'imageUrl',
    );

    const otherDestination = Destination(
      ref: 'otherRef',
      name: 'otherName',
      country: 'otherCountry',
      continent: 'otherContinent',
      knownFor: 'otherKnownFor',
      tags: ['otherTag'],
      imageUrl: 'otherImageUrl',
    );

    setUp(() {
      apiClient = _MockApiClient();
      destinationRepository = DestinationRepository(apiClient: apiClient);
    });

    test('can be instantiated', () {
      expect(destinationRepository, isNotNull);
    });

    group('getDestinations', () {
      test('returns destinations from the api client', () async {
        when(() => apiClient.getDestinations())
            .thenAnswer((_) async => [destination, otherDestination]);

        final result = await destinationRepository.getDestinations();

        expect(result, equals([destination, otherDestination]));
        verify(() => apiClient.getDestinations()).called(1);
      });

      test(
        'returns cached destinations without calling the api client again',
        () async {
          when(() => apiClient.getDestinations())
              .thenAnswer((_) async => [destination]);

          final firstResult = await destinationRepository.getDestinations();
          final secondResult = await destinationRepository.getDestinations();

          expect(firstResult, equals([destination]));
          expect(secondResult, equals([destination]));
          verify(() => apiClient.getDestinations()).called(1);
        },
      );

      test('rethrows and does not cache when the api client throws', () async {
        when(() => apiClient.getDestinations())
            .thenThrow(const HttpException('Invalid response'));

        await expectLater(
          destinationRepository.getDestinations(),
          throwsA(isA<HttpException>()),
        );

        when(() => apiClient.getDestinations())
            .thenAnswer((_) async => [destination]);

        final result = await destinationRepository.getDestinations();

        expect(result, equals([destination]));
        verify(() => apiClient.getDestinations()).called(2);
      });
    });
  });
}
