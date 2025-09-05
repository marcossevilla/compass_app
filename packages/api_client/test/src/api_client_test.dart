// ignore_for_file: prefer_const_constructors
import 'package:api_client/api_client.dart';
import 'package:test/test.dart';

void main() {
  group(ApiClient, () {
    test('can be instantiated', () {
      expect(ApiClient(authHeaderProvider: Stream.empty()), isNotNull);
    });
  });
}
