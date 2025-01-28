import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

/// {@template login_request}
/// Simple data class to hold login request data.
/// {@endtemplate}
@JsonSerializable()
class LoginRequest {
  /// {@macro login_request}
  const LoginRequest({
    required this.email,
    required this.password,
  });

  /// Converts a [Map] to an [LoginRequest].
  factory LoginRequest.fromJson(Map<String, Object?> json) {
    return _$LoginRequestFromJson(json);
  }

  /// Email address.
  final String email;

  /// Plain text password.
  final String password;
}
