import 'package:api_client/api_client.dart';

/// {@template continent_repository}
/// Repository that manages the continents domain.
/// {@endtemplate}
class ContinentRepository {
  /// {@macro continent_repository}
  ContinentRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  List<Continent>? _cachedData;

  /// Get a list of continents.
  Future<List<Continent>> getContinents() async {
    // Return cached data if available.
    if (_cachedData != null) return _cachedData!;

    // No cached data, request continents.
    final continents = await _apiClient.getContinents();

    // Store value.
    _cachedData = continents;

    return continents;
  }
}
