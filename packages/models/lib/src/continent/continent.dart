import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'continent.g.dart';

/// {@template continent}
/// A continent that can be visited.
/// {@endtemplate}
@JsonSerializable()
class const Continent({
  /// e.g. 'Europe'
  required final String name,

  /// e.g. 'https://rstr.in/google/tripedia/TmR12QdlVTT'
  required final String imageUrl,
}) extends Equatable {
  /// {@macro continent}
  this;

  /// Creates a [Continent] from a JSON object.
  factory fromJson(Map<String, Object?> json) {
    return _$ContinentFromJson(json);
  }

  /// Converts this [Continent] to a JSON object.
  Map<String, Object?> toJson() => _$ContinentToJson(this);

  @override
  List<Object> get props => [name, imageUrl];
}
