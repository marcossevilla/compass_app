import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';

/// {@template auth_api_client}
/// Authentication client for the Compass API.
/// {@endtemplate}
class AuthApiClient {
  /// {@macro auth_api_client}
  AuthApiClient({
    String? host,
    int? port,
    HttpClient? client,
  })  : _host = host ?? 'localhost',
        _port = port ?? 8080,
        _client = client ?? HttpClient();

  final String _host;
  final int _port;
  final HttpClient _client;

  /// Attempts to login a user.
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    try {
      final request = await _client.post(_host, _port, '/login');
      request.write(jsonEncode(loginRequest));
      final response = await request.close();

      if (response.statusCode != 200) {
        throw const HttpException('Login error');
      }

      final stringData = await response.transform(utf8.decoder).join();

      return LoginResponse.fromJson(
        jsonDecode(stringData) as Map<String, Object?>,
      );
    } on Exception {
      rethrow;
    }
  }
}
