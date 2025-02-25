import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template auth_api_client}
/// Authentication client for the Compass API.
/// {@endtemplate}
class AuthApiClient {
  /// {@macro auth_api_client}
  AuthApiClient({
    required SharedPreferences sharedPreferences,
    int? port,
    String? host,
    HttpClient? client,
  }) : _port = port ?? 8080,
       _host = host ?? 'localhost',
       _client = client ?? HttpClient(),
       _logger = Logger('AuthApiClient'),
       _sharedPreferences = sharedPreferences,
       _authToken = StreamController<String?>.broadcast(),
       _isAuthenticated = StreamController<bool>.broadcast() {
    _isAuthenticated.onListen = token;
  }

  static const _tokenKey = 'TOKEN';

  final int _port;
  final String _host;
  final Logger _logger;
  final HttpClient _client;
  final SharedPreferences _sharedPreferences;
  final StreamController<String?> _authToken;
  final StreamController<bool?> _isAuthenticated;

  /// Provides the authentication header.
  Stream<String?> get authHeaderProvider {
    return _authToken.stream.map(
      (token) => token != null ? 'Bearer $token' : null,
    );
  }

  /// Check if the user is authenticated.
  Stream<bool> get isAuthenticated {
    return _isAuthenticated.stream.asyncMap((isAuth) async {
      if (isAuth != null) return isAuth;
      // No status cached, fetch from storage.
      await token();
      return isAuth ?? false;
    });
  }

  /// Fetch token from shared preferences.
  Future<void> token() async {
    try {
      final token = _sharedPreferences.getString(_tokenKey);
      _authToken.sink.add(token);
      _isAuthenticated.sink.add(token != null);
      _logger.finer('Got token from SharedPreferences');
    } catch (error, stackTrace) {
      _logger.severe(
        'Failed to fetch Token from SharedPreferences',
        error,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Attempts to login a user.
  Future<void> login(LoginRequest loginRequest) async {
    try {
      final request = await _client.post(_host, _port, '/login');
      request.write(jsonEncode(loginRequest));
      final response = await request.close();

      if (response.statusCode != 200) {
        throw const HttpException('Login error');
      }

      final stringData = await response.transform(utf8.decoder).join();
      final loginResponse = LoginResponse.fromJson(
        jsonDecode(stringData) as Map<String, Object?>,
      );

      // Set auth status.
      _isAuthenticated.sink.add(true);
      _authToken.sink.add(loginResponse.token);

      // Store in Shared preferences.
      await _sharedPreferences.setString(_tokenKey, loginResponse.token);
      _logger.finer('Replaced token');
    } on Exception {
      rethrow;
    }
  }

  /// Log the user out.
  Future<void> logout() async {
    try {
      // Clear stored auth token.
      _logger.finer('Removed token');
      await _sharedPreferences.remove(_tokenKey);

      // Clear token.
      _authToken.sink.add(null);

      // Clear authenticated status.
      _isAuthenticated.sink.add(false);
      _logger.info('User logged out');
    } catch (error) {
      _logger.severe('Failed to clear stored auth token');
      rethrow;
    }
  }
}
