// ignore_for_file: prefer_const_constructors
import 'package:activity_repository/activity_repository.dart';
import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('ActivityRepository', () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = _MockApiClient();
    });

    test('can be instantiated', () {
      expect(ActivityRepository(apiClient: apiClient), isNotNull);
    });
  });
}
