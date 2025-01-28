import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

/// {@template login_response}
/// LoginResponse model.
/// {@endtemplate}
@JsonSerializable()
class LoginResponse {
  /// {@macro login_response}
  const LoginResponse({
    required this.token,
    required this.userId,
  });

  /// Converts a [Map] to an [LoginResponse].
  factory LoginResponse.fromJson(Map<String, Object?> json) {
    return _$LoginResponseFromJson(json);
  }

  /// The token to be used for authentication.
  final String token;

  /// The user id.
  final String userId;
}
