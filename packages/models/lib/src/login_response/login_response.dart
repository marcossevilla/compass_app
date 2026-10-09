import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

/// {@template login_response}
/// LoginResponse model.
/// {@endtemplate}
@JsonSerializable()
class const LoginResponse({
  /// The token to be used for authentication.
  required final String token,

  /// The user id.
  required final String userId,
}) extends Equatable {
  /// {@macro login_response}
  this;

  /// Converts a [Map] to an [LoginResponse].
  factory fromJson(Map<String, Object?> json) {
    return _$LoginResponseFromJson(json);
  }

  /// Converts this [LoginResponse] to a JSON object.
  Map<String, Object?> toJson() => _$LoginResponseToJson(this);

  @override
  List<Object> get props => [token, userId];
}
