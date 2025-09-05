import 'package:api_client/api_client.dart';
import 'package:continent_repository/continent_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group(ContinentRepository, () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = _MockApiClient();
    });

    test('can be instantiated', () {
      expect(ContinentRepository(apiClient: apiClient), isNotNull);
    });
  });
}
