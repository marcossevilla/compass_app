import 'package:api_client/api_client.dart';
import 'package:models/models.dart';

/// Repository that manages the destinations domain.
class DestinationRepository({required final ApiClient _apiClient}) {
  List<Destination>? _cachedData;

  /// Fetches a list of destinations.
  Future<List<Destination>> getDestinations() async {
    if (_cachedData != null) return _cachedData!;

    // No cached data, request destinations
    final destinations = await _apiClient.getDestinations();

    // Store value
    _cachedData = destinations;

    return destinations;
  }
}
