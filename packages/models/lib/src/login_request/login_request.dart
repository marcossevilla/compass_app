import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

/// {@template login_request}
/// Simple data class to hold login request data.
/// {@endtemplate}
@JsonSerializable()
class const LoginRequest({
  /// Email address.
  required final String email,

  /// Plain text password.
  required final String password,
}) extends Equatable {
  /// {@macro login_request}
  this;

  /// Converts a [Map] to an [LoginRequest].
  factory fromJson(Map<String, Object?> json) {
    return _$LoginRequestFromJson(json);
  }

  /// Converts a [LoginRequest] to a [Map].
  Map<String, Object?> toJson() => _$LoginRequestToJson(this);

  @override
  List<Object> get props => [email, password];
}
