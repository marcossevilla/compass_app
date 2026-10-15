import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

class _MockApiClient extends Mock implements ApiClient;

void main() {
  group(UserRepository, () {
    late ApiClient apiClient;
    late UserRepository userRepository;

    const userApiModel = UserApiModel(
      id: 'id',
      email: 'email@example.com',
      name: 'name',
      picture: 'picture',
    );

    setUp(() {
      apiClient = _MockApiClient();
      userRepository = UserRepository(apiClient: apiClient);
    });

    test('can be instantiated', () {
      expect(UserRepository(apiClient: apiClient), isNotNull);
    });

    group('getUser', () {
      test('returns the user mapped from the ApiClient response', () async {
        when(() => apiClient.getUser()).thenAnswer((_) async => userApiModel);

        final user = await userRepository.getUser();

        expect(user, const User(name: 'name', picture: 'picture'));
        verify(() => apiClient.getUser()).called(1);
      });

      test('returns the cached user on subsequent calls', () async {
        when(() => apiClient.getUser()).thenAnswer((_) async => userApiModel);

        final firstResult = await userRepository.getUser();
        final secondResult = await userRepository.getUser();

        expect(firstResult, secondResult);
        verify(() => apiClient.getUser()).called(1);
      });

      test('rethrows when the ApiClient throws', () async {
        when(() => apiClient.getUser())
            .thenThrow(const HttpException('Invalid response'));

        await expectLater(
          userRepository.getUser,
          throwsA(isA<HttpException>()),
        );
        verify(() => apiClient.getUser()).called(1);
      });

      test('does not cache the user when the ApiClient throws', () async {
        when(() => apiClient.getUser())
            .thenThrow(const HttpException('Invalid response'));

        await expectLater(
          userRepository.getUser,
          throwsA(isA<HttpException>()),
        );

        when(() => apiClient.getUser()).thenAnswer((_) async => userApiModel);

        final user = await userRepository.getUser();

        expect(user, const User(name: 'name', picture: 'picture'));
        verify(() => apiClient.getUser()).called(2);
      });
    });
  });
}
