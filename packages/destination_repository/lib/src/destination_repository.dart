import 'package:api_client/api_client.dart';

/// {@template destination_repository}
/// Repository that manages the destinations domain.
/// {@endtemplate}
class DestinationRepository {
  /// {@macro destination_repository}
  DestinationRepository({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

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
