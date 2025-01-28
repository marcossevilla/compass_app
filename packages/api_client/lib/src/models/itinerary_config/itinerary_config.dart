import 'package:api_client/api_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'itinerary_config.g.dart';

/// {@template itinerary_config}
/// Configuration for an itinerary.
/// {@endtemplate}
@JsonSerializable()
class ItineraryConfig {
  /// {@macro itinerary_config}
  const ItineraryConfig({
    this.continent,
    this.startDate,
    this.endDate,
    this.guests,
    this.destination,
    this.activities = const [],
  });

  /// Creates an [ItineraryConfig] from a JSON object.
  factory ItineraryConfig.fromJson(Map<String, Object?> json) =>
      _$ItineraryConfigFromJson(json);

  /// [Continent] name.
  final String? continent;

  /// Start date (check in) of itinerary.
  final DateTime? startDate;

  /// End date (check out) of itinerary.
  final DateTime? endDate;

  /// Number of guests.
  final int? guests;

  /// Selected [Destination] reference.
  final String? destination;

  /// Selected [Activity] references.
  final List<String> activities;
}
