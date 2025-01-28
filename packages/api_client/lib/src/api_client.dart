import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';

/// Adds the `Authentication` header to a header configuration.
typedef AuthHeaderProvider = String? Function();

/// {@template api_client}
/// Client for the Compass API.
/// {@endtemplate}
class ApiClient {
  /// {@macro api_client}
  ApiClient({
    String? host,
    int? port,
    HttpClient? client,
    AuthHeaderProvider? authHeaderProvider,
  })  : _host = host ?? 'localhost',
        _port = port ?? 8080,
        _client = client ?? HttpClient(),
        _authHeaderProvider = authHeaderProvider;

  final String _host;
  final int _port;
  final HttpClient _client;
  final AuthHeaderProvider? _authHeaderProvider;

  void _authHeader(HttpHeaders headers) {
    final header = _authHeaderProvider?.call();
    if (header != null) headers.add(HttpHeaders.authorizationHeader, header);
  }

  /// Returns a [List] of [Continent]s.
  Future<List<Continent>> getContinents() async {
    try {
      final request = await _client.get(_host, _port, '/continent');
      _authHeader(request.headers);
      final response = await request.close();

      if (response.statusCode != 200) {
        throw const HttpException('Invalid response');
      }

      final stringData = await response.transform(utf8.decoder).join();
      final json = jsonDecode(stringData) as List<Map<String, dynamic>>;
      return json.map(Continent.fromJson).toList();
    } on Exception {
      rethrow;
    }
  }

  /// Returns a [List] of [Destination]s.
  Future<List<Destination>> getDestinations() async {
    try {
      final request = await _client.get(_host, _port, '/destination');
      _authHeader(request.headers);
      final response = await request.close();

      if (response.statusCode != 200) {
        throw const HttpException('Invalid response');
      }

      final stringData = await response.transform(utf8.decoder).join();
      final json = jsonDecode(stringData) as List<Map<String, dynamic>>;
      return json.map(Destination.fromJson).toList();
    } on Exception {
      rethrow;
    }
  }

  /// Returns a [List] of [Activity]s.
  Future<List<Activity>> getActivityByDestination(String ref) async {
    try {
      final request = await _client.get(
        _host,
        _port,
        '/destination/$ref/activity',
      );
      _authHeader(request.headers);
      final response = await request.close();

      if (response.statusCode != 200) {
        throw const HttpException('Invalid response');
      }

      final stringData = await response.transform(utf8.decoder).join();
      final json = jsonDecode(stringData) as List<Map<String, dynamic>>;
      return json.map(Activity.fromJson).toList();
    } on Exception {
      rethrow;
    }
  }

  /// Returns a [List] of [BookingApiModel]s.
  Future<List<BookingApiModel>> getBookings() async {
    try {
      final request = await _client.get(_host, _port, '/booking');
      _authHeader(request.headers);
      final response = await request.close();

      if (response.statusCode != 200) {
        throw const HttpException('Invalid response');
      }

      final stringData = await response.transform(utf8.decoder).join();
      final json = jsonDecode(stringData) as List<Map<String, dynamic>>;
      return json.map(BookingApiModel.fromJson).toList();
    } on Exception {
      rethrow;
    }
  }

  /// Returns a [BookingApiModel] by [id].
  Future<BookingApiModel> getBooking(int id) async {
    try {
      final request = await _client.get(_host, _port, '/booking/$id');
      _authHeader(request.headers);
      final response = await request.close();

      if (response.statusCode != 200) {
        throw const HttpException('Invalid response');
      }

      final stringData = await response.transform(utf8.decoder).join();

      return BookingApiModel.fromJson(
        jsonDecode(stringData) as Map<String, dynamic>,
      );
    } on Exception {
      rethrow;
    }
  }

  /// Posts a [BookingApiModel] and returns the created [BookingApiModel].
  Future<BookingApiModel> postBooking(BookingApiModel booking) async {
    try {
      final request = await _client.post(_host, _port, '/booking');
      _authHeader(request.headers);
      request.write(jsonEncode(booking));
      final response = await request.close();

      if (response.statusCode != 201) {
        throw const HttpException('Invalid response');
      }

      final stringData = await response.transform(utf8.decoder).join();

      return BookingApiModel.fromJson(
        jsonDecode(stringData) as Map<String, dynamic>,
      );
    } on Exception {
      rethrow;
    }
  }

  /// Returns a [UserApiModel].
  Future<UserApiModel> getUser() async {
    try {
      final request = await _client.get(_host, _port, '/user');
      _authHeader(request.headers);
      final response = await request.close();

      if (response.statusCode != 200) {
        throw const HttpException('Invalid response');
      }

      final stringData = await response.transform(utf8.decoder).join();

      return UserApiModel.fromJson(
        jsonDecode(stringData) as Map<String, dynamic>,
      );
    } on Exception {
      rethrow;
    }
  }

  /// Deletes a booking by [id].
  Future<void> deleteBooking(int id) async {
    try {
      final request = await _client.delete(_host, _port, '/booking/$id');
      _authHeader(request.headers);
      final response = await request.close();

      if (response.statusCode != 204) {
        throw const HttpException('Invalid response');
      }

      // Response 204 "No Content", delete was successful
    } on Exception {
      rethrow;
    }
  }
}
