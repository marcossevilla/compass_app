// ignore_for_file: prefer_const_constructors
import 'package:api_client/api_client.dart';
import 'package:destination_repository/destination_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('DestinationRepository', () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = _MockApiClient();
    });

    test('can be instantiated', () {
      expect(DestinationRepository(apiClient: apiClient), isNotNull);
    });
  });
}
