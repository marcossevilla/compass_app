import 'package:compass_app/login/login.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(LoginState, () {
    test('supports value equality', () {
      expect(const LoginState(), equals(const LoginState()));
    });

    group('copyWith', () {
      test('returns the same object when no arguments are passed', () {
        expect(const LoginState().copyWith(), equals(const LoginState()));
      });

      test('replaces status', () {
        expect(
          const LoginState().copyWith(status: LoginStatus.success),
          equals(const LoginState(status: LoginStatus.success)),
        );
      });
    });
  });
}
