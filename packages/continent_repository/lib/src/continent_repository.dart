import 'package:api_client/api_client.dart';
import 'package:models/models.dart';

/// Repository that manages the continents domain.
class ContinentRepository({required final ApiClient _apiClient}) {
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
