import 'package:api_client/api_client.dart';

/// {@template user_repository}
/// Repository that manages the user domain.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  User? _cachedData;

  /// Fetches the user data.
  Future<User> getUser() async {
    if (_cachedData != null) return Future.value(_cachedData!);

    final result = await _apiClient.getUser();

    final user = User(name: result.name, picture: result.picture);

    _cachedData = user;

    return user;
  }
}
