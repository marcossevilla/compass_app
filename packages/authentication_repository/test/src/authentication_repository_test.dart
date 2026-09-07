import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

class _MockAuthApiClient extends Mock implements AuthApiClient;

class _FakeLoginRequest extends Fake implements LoginRequest {}

void main() {
  group(AuthenticationRepository, () {
    late AuthApiClient authApiClient;
    late AuthenticationRepository authenticationRepository;

    setUpAll(() {
      registerFallbackValue(_FakeLoginRequest());
    });

    setUp(() {
      authApiClient = _MockAuthApiClient();
      authenticationRepository = AuthenticationRepository(
        authApiClient: authApiClient,
      );
    });

    test('can be instantiated', () {
      expect(authenticationRepository, isNotNull);
    });

    group('isAuthenticated', () {
      test('emits values from the api client', () {
        when(
          () => authApiClient.isAuthenticated,
        ).thenAnswer((_) => Stream.value(true));

        expect(authenticationRepository.isAuthenticated, emits(true));
      });
    });

    group('login', () {
      const email = 'email@example.com';
      const password = 'password';

      test('calls AuthApiClient.login with the given credentials', () async {
        when(() => authApiClient.login(any())).thenAnswer((_) async {});

        await expectLater(
          authenticationRepository.login(email: email, password: password),
          completes,
        );

        verify(
          () => authApiClient.login(
            const LoginRequest(email: email, password: password),
          ),
        ).called(1);
      });

      test('rethrows when AuthApiClient.login throws', () async {
        final exception = Exception('login failed');
        when(() => authApiClient.login(any())).thenThrow(exception);

        await expectLater(
          () =>
              authenticationRepository.login(email: email, password: password),
          throwsA(exception),
        );
      });
    });

    group('logout', () {
      test('calls AuthApiClient.logout', () async {
        when(() => authApiClient.logout()).thenAnswer((_) async {});

        await expectLater(authenticationRepository.logout(), completes);

        verify(() => authApiClient.logout()).called(1);
      });

      test('rethrows when AuthApiClient.logout throws', () async {
        final exception = Exception('logout failed');
        when(() => authApiClient.logout()).thenThrow(exception);

        await expectLater(authenticationRepository.logout, throwsA(exception));
      });
    });
  });
}
