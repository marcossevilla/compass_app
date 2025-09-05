import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group(UserRepository, () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = _MockApiClient();
    });

    test('can be instantiated', () {
      expect(UserRepository(apiClient: apiClient), isNotNull);
    });
  });
}
