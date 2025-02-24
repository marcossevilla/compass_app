import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group(LoginRequest, () {
    test('supports value comparisons', () {
      expect(
        LoginRequest(email: 'email', password: 'password'),
        equals(LoginRequest(email: 'email', password: 'password')),
      );
    });

    test('can be instantiated', () {
      expect(LoginRequest(email: 'email', password: 'password'), isNotNull);
    });

    test('fromJson returns a valid LoginRequest', () {
      expect(
        LoginRequest.fromJson({'email': 'email', 'password': 'password'}),
        isNotNull,
      );
    });

    test('toJson returns a valid map', () {
      final loginRequest = LoginRequest(email: 'email', password: 'password');
      expect(
        loginRequest.toJson(),
        equals({'email': 'email', 'password': 'password'}),
      );
    });
  });
}
