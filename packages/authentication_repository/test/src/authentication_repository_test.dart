// ignore_for_file: prefer_const_constructors
import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockAuthApiClient extends Mock implements AuthApiClient {}

void main() {
  group('AuthenticationRepository', () {
    late AuthApiClient authApiClient;

    setUp(() {
      authApiClient = _MockAuthApiClient();
    });

    test('can be instantiated', () {
      expect(AuthenticationRepository(authApiClient: authApiClient), isNotNull);
    });
  });
}
