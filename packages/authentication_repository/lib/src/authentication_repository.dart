import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:logging/logging.dart';

/// {@template authentication_repository}
/// Repository that manages the authentication domain.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({required AuthApiClient authApiClient})
      : _logger = Logger('AuthenticationRepository'),
        _authApiClient = authApiClient;

  final Logger _logger;
  final AuthApiClient _authApiClient;

  /// Fetch the user's profile.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await _authApiClient.login(
        LoginRequest(
          email: email,
          password: password,
        ),
      );

      _logger.info('User logged int');
    } catch (error) {
      _logger.warning('Error logging in: $error');
      rethrow;
    }
  }

  /// Log the user out.
  Future<void> logout() async {
    try {
      await _authApiClient.logout();
    } catch (error) {
      _logger.severe('Failed to logout');
      rethrow;
    }
  }
}
