import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  group(LoginResponse, () {
    test('supports value comparisons', () {
      expect(
        LoginResponse(token: 'token', userId: 'userId'),
        equals(LoginResponse(token: 'token', userId: 'userId')),
      );
    });

    test(
      'can be instantiated',
      () => expect(
        LoginResponse.fromJson({'token': 'token', 'userId': 'userId'}),
        isNotNull,
      ),
    );

    test(
      'fromJson returns a valid LoginResponse',
      () => expect(
        LoginResponse.fromJson({'token': 'token', 'userId': 'userId'}),
        isNotNull,
      ),
    );

    test(
      'toJson returns a valid map',
      () => expect(
        LoginResponse(token: 'token', userId: 'userId').toJson(),
        equals({'token': 'token', 'userId': 'userId'}),
      ),
    );
  });
}
