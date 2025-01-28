import 'package:json_annotation/json_annotation.dart';

part 'destination.g.dart';

/// {@template destination}
/// A destination that can be visited.
/// {@endtemplate}
@JsonSerializable()
class Destination {
  /// {@macro destination}
  const Destination({
    required this.ref,
    required this.name,
    required this.country,
    required this.continent,
    required this.knownFor,
    required this.tags,
    required this.imageUrl,
  });

  /// Creates a [Destination] from a JSON object.
  factory Destination.fromJson(Map<String, Object?> json) =>
      _$DestinationFromJson(json);

  /// Converts this [Destination] to a JSON object.
  Map<String, Object?> toJson() => _$DestinationToJson(this);

  /// e.g. 'alaska'
  final String ref;

  /// e.g. 'Alaska'
  final String name;

  /// e.g. 'United States'
  final String country;

  /// e.g. 'North America'
  final String continent;

  /// e.g. 'Alaska is a haven for outdoor enthusiasts ...'
  final String knownFor;

  /// e.g. ['Mountain', 'Off-the-beaten-path', 'Wildlife watching']
  final List<String> tags;

  /// e.g. 'https://storage.googleapis.com/tripedia-images/destinations/alaska.jpg'
  final String imageUrl;
}
