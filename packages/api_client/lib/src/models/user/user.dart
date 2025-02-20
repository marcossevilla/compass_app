import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// {@template user}
/// A user that can be authenticated.
/// {@endtemplate}
@JsonSerializable()
class User {
  /// {@macro user}
  const User({required this.name, required this.picture});

  /// Creates a [User] from a JSON object.
  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);

  /// The user's name.
  final String name;

  /// The user's picture URL.
  final String picture;
}

/// {@template user_api_model}
/// A user that can be authenticated.
/// {@endtemplate}
@JsonSerializable()
class UserApiModel {
  /// {@macro user_api_model}
  const UserApiModel({
    required this.id,
    required this.name,
    required this.email,
    required this.picture,
  });

  /// Creates a [UserApiModel] from a JSON object.
  factory UserApiModel.fromJson(Map<String, Object?> json) =>
      _$UserApiModelFromJson(json);

  /// The user's ID.
  final String id;

  /// The user's name.
  final String name;

  /// The user's email.
  final String email;

  /// The user's picture URL.
  final String picture;
}
