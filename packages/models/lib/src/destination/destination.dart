import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'destination.g.dart';

/// A destination that can be visited.
@JsonSerializable()
class const Destination({
  /// e.g. 'alaska'
  required final String ref,

  /// e.g. 'Alaska'
  required final String name,

  /// e.g. 'United States'
  required final String country,

  /// e.g. 'North America'
  required final String continent,

  /// e.g. 'Alaska is a haven for outdoor enthusiasts ...'
  required final String knownFor,

  /// e.g. ['Mountain', 'Off-the-beaten-path', 'Wildlife watching']
  required final List<String> tags,

  /// e.g. 'https://storage.googleapis.com/tripedia-images/destinations/alaska.jpg'
  required final String imageUrl,
}) extends Equatable {
  /// Creates a [Destination] from a JSON object.
  factory fromJson(Map<String, Object?> json) {
    return _$DestinationFromJson(json);
  }

  /// Converts this [Destination] to a JSON object.
  Map<String, Object?> toJson() => _$DestinationToJson(this);

  @override
  List<Object> get props => [
    ref,
    name,
    country,
    continent,
    knownFor,
    tags,
    imageUrl,
  ];
}
