import 'package:api_client/api_client.dart';

/// {@template activity_repository}
/// Repository that manages the activity domain.
/// {@endtemplate}
class ActivityRepository {
  /// {@macro activity_repository}
  ActivityRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  final Map<String, List<Activity>> _cachedData = {};

  /// Get activities by destination reference.
  Future<List<Activity>> getByDestination(String ref) async {
    // Return cached data if available.
    if (_cachedData.containsKey(ref)) return _cachedData[ref]!;

    // No cached data, request activities.
    final result = await _apiClient.getActivityByDestination(ref);

    _cachedData[ref] = result;

    return result;
  }
}
