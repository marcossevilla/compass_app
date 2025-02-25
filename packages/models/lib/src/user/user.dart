import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// {@template user}
/// A user that can be authenticated.
/// {@endtemplate}
@JsonSerializable()
class User extends Equatable {
  /// {@macro user}
  const User({required this.name, required this.picture});

  /// Creates a [User] from a JSON object.
  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);

  /// Converts this [User] to a JSON object.
  Map<String, Object?> toJson() => _$UserToJson(this);

  /// The user's name.
  final String name;

  /// The user's picture URL.
  final String picture;

  @override
  List<Object> get props => [name, picture];
}

/// {@template user_api_model}
/// A user that can be authenticated.
/// {@endtemplate}
@JsonSerializable()
class UserApiModel extends User {
  /// {@macro user_api_model}
  const UserApiModel({
    required this.id,
    required this.email,
    required super.name,
    required super.picture,
  });

  /// Creates a [UserApiModel] from a JSON object.
  factory UserApiModel.fromJson(Map<String, Object?> json) {
    return _$UserApiModelFromJson(json);
  }

  /// Converts this [UserApiModel] to a JSON object.
  @override
  Map<String, Object?> toJson() => _$UserApiModelToJson(this);

  /// The user's ID.
  final String id;

  /// The user's email.
  final String email;

  @override
  List<Object> get props => [id, name, email, picture];
}
