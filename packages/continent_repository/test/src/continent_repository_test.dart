import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:continent_repository/continent_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient;

void main() {
  group(ContinentRepository, () {
    late ApiClient apiClient;
    late ContinentRepository continentRepository;

    const continent = Continent(name: 'name', imageUrl: 'imageUrl');

    setUp(() {
      apiClient = _MockApiClient();
      continentRepository = ContinentRepository(apiClient: apiClient);
    });

    test('can be instantiated', () {
      expect(continentRepository, isNotNull);
    });

    group('getContinents', () {
      test('returns continents from the api client', () async {
        when(() => apiClient.getContinents())
            .thenAnswer((_) async => [continent]);

        final result = await continentRepository.getContinents();

        expect(result, equals([continent]));
        verify(() => apiClient.getContinents()).called(1);
      });

      test(
        'returns cached continents without calling the api client again',
        () async {
          when(() => apiClient.getContinents())
              .thenAnswer((_) async => [continent]);

          final firstResult = await continentRepository.getContinents();
          final secondResult = await continentRepository.getContinents();

          expect(firstResult, equals([continent]));
          expect(secondResult, equals([continent]));
          verify(() => apiClient.getContinents()).called(1);
        },
      );

      test('rethrows and does not cache when the api client throws', () async {
        when(() => apiClient.getContinents())
            .thenThrow(const HttpException('Invalid response'));

        await expectLater(
          continentRepository.getContinents(),
          throwsA(isA<HttpException>()),
        );

        when(() => apiClient.getContinents())
            .thenAnswer((_) async => [continent]);

        final result = await continentRepository.getContinents();

        expect(result, equals([continent]));
        verify(() => apiClient.getContinents()).called(2);
      });
    });
  });
}
