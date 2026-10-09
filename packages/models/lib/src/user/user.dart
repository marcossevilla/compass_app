import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// {@template user}
/// A user that can be authenticated.
/// {@endtemplate}
@JsonSerializable()
class const User({
  /// The user's name.
  required final String name,

  /// The user's picture URL.
  required final String picture,
}) extends Equatable {
  /// {@macro user}
  this;

  /// Creates a [User] from a JSON object.
  factory fromJson(Map<String, Object?> json) => _$UserFromJson(json);

  /// Converts this [User] to a JSON object.
  Map<String, Object?> toJson() => _$UserToJson(this);

  @override
  List<Object> get props => [name, picture];
}

/// {@template user_api_model}
/// A user that can be authenticated.
/// {@endtemplate}
@JsonSerializable()
class const UserApiModel({
  /// The user's ID.
  required final String id,

  /// The user's email.
  required final String email,
  required super.name,
  required super.picture,
}) extends User {
  /// {@macro user_api_model}
  this;

  /// Creates a [UserApiModel] from a JSON object.
  factory fromJson(Map<String, Object?> json) {
    return _$UserApiModelFromJson(json);
  }

  /// Converts this [UserApiModel] to a JSON object.
  @override
  Map<String, Object?> toJson() => _$UserApiModelToJson(this);

  @override
  List<Object> get props => [id, name, email, picture];
}
