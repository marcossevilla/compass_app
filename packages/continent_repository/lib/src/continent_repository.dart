import 'package:api_client/api_client.dart';
import 'package:models/models.dart';

/// {@template continent_repository}
/// Repository that manages the continents domain.
/// {@endtemplate}
class ContinentRepository({required final ApiClient _apiClient}) {
  /// {@macro continent_repository}
  this;

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
