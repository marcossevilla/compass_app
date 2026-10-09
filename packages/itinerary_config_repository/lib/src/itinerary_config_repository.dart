import 'package:models/models.dart';

/// Repository that manages the itinerary configuration domain.
class ItineraryConfigRepository {
  ItineraryConfig? _itineraryConfig;

  /// Returns the current itinerary configuration.
  ItineraryConfig get itineraryConfig {
    return _itineraryConfig ?? const ItineraryConfig();
  }

  /// Sets the itinerary configuration.
  set itineraryConfig(ItineraryConfig itineraryConfig) {
    _itineraryConfig = itineraryConfig;
  }
}
