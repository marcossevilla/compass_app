import 'package:json_annotation/json_annotation.dart';

part 'continent.g.dart';

/// {@template continent}
/// A continent that can be visited.
/// {@endtemplate}
@JsonSerializable()
class Continent {
  /// {@macro continent}
  const Continent({required this.name, required this.imageUrl});

  /// Creates a [Continent] from a JSON object.
  factory Continent.fromJson(Map<String, Object?> json) {
    return _$ContinentFromJson(json);
  }

  /// e.g. 'Europe'
  final String name;

  /// e.g. 'https://rstr.in/google/tripedia/TmR12QdlVTT'
  final String imageUrl;
}
