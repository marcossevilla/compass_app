import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:logging/logging.dart';

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
  })  : _port = port ?? 8080,
        _host = host ?? 'localhost',
        _client = client ?? HttpClient(),
        _logger = Logger('AuthApiClient'),
        _sharedPreferences = sharedPreferences,
        _authToken = StreamController<String?>(),
        _isAuthenticated = StreamController<bool>();

  static const _tokenKey = 'TOKEN';

  final String _host;
  final int _port;
  final Logger _logger;
  final HttpClient _client;
  final StreamController<bool?> _isAuthenticated;
  final StreamController<String?> _authToken;
  final SharedPreferences _sharedPreferences;

  /// Provides the authentication token.
  Stream<String?> get authToken {
    return _authToken.stream.asBroadcastStream();
  }

  /// Check if the user is authenticated.
  Stream<bool> get isAuthenticated {
    return _isAuthenticated.stream.asyncMap((isAuth) async {
      if (isAuth != null) return isAuth;
      // No status cached, fetch from storage.
      await token();
      return isAuth ?? false;
    }).asBroadcastStream();
  }

  /// Provides the authentication header.
  Stream<String?> get authHeaderProvider {
    return authToken.map((token) {
      if (token != null) return 'Bearer $token';
      return null;
    }).asBroadcastStream();
  }

  /// Fetch token from shared preferences.
  Future<void> token() async {
    try {
      final result = _sharedPreferences.getString(_tokenKey);
      _authToken.sink.add(result);
      _isAuthenticated.sink.add(result != null);
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
    _logger.info('User logged out');
    try {
      // Clear stored auth token
      _logger.finer('Removed token');
      await _sharedPreferences.remove(_tokenKey);

      // Clear token in ApiClient
      _authToken.sink.add(null);

      // Clear authenticated status
      _isAuthenticated.sink.add(false);
    } catch (error) {
      _logger.severe('Failed to clear stored auth token');
      rethrow;
    }
  }
}
