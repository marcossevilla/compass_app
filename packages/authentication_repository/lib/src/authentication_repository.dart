import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:logging/logging.dart';
import 'package:models/models.dart';

/// Repository that manages the authentication domain.
class AuthenticationRepository({required final AuthApiClient _authApiClient}) {
  this : _logger = Logger('AuthenticationRepository');

  final Logger _logger;

  /// Check if the user is authenticated.
  Stream<bool> get isAuthenticated => _authApiClient.isAuthenticated;

  /// Fetch the user's profile.
  Future<void> login({required String email, required String password}) async {
    try {
      await _authApiClient.login(
        LoginRequest(email: email, password: password),
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
