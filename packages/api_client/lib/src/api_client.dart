import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';

/// {@template api_client}
/// Client for the Compass API.
/// {@endtemplate}
class ApiClient {
  /// {@macro api_client}
  ApiClient({
    required Stream<String?> authHeaderProvider,
    String? host,
    int? port,
    HttpClient? client,
  })  : _host = host ?? 'localhost',
        _port = port ?? 8080,
        _client = client ?? HttpClient(),
        _authHeaderProvider = authHeaderProvider {
    _authHeaderProviderSubscription = _authHeaderProvider.listen(
      (data) => data != null ? _authHeader = data : null,
    );
  }

  final String _host;
  final int _port;
  final HttpClient _client;
  final Stream<String?> _authHeaderProvider;
  late StreamSubscription<String?> _authHeaderProviderSubscription;

  String? _authHeader;

  /// Adds the authorization header to the [headers].
  void authHeader(HttpHeaders headers) {
    if (_authHeader != null) {
      headers.add(HttpHeaders.authorizationHeader, _authHeader!);
    }
  }

  /// Returns a [List] of [Continent]s.
  Future<List<Continent>> getContinents() async {
    final request = await _client.get(_host, _port, '/continent');
    authHeader(request.headers);
    final response = await request.close();

    if (response.statusCode != 200) {
      throw const HttpException('Invalid response');
    }

    final stringData = await response.transform(utf8.decoder).join();
    final json = jsonDecode(stringData) as List<dynamic>;
    final jsonList = json.cast<Map<String, dynamic>>();

    return jsonList.map(Continent.fromJson).toList();
  }

  /// Returns a [List] of [Destination]s.
  Future<List<Destination>> getDestinations() async {
    final request = await _client.get(_host, _port, '/destination');
    authHeader(request.headers);
    final response = await request.close();

    if (response.statusCode != 200) {
      throw const HttpException('Invalid response');
    }

    final stringData = await response.transform(utf8.decoder).join();
    final json = jsonDecode(stringData) as List<dynamic>;
    final jsonList = json.cast<Map<String, dynamic>>();

    return jsonList.map(Destination.fromJson).toList();
  }

  /// Returns a [List] of [Activity]s.
  Future<List<Activity>> getActivityByDestination(String ref) async {
    final request = await _client.get(
      _host,
      _port,
      '/destination/$ref/activity',
    );
    authHeader(request.headers);
    final response = await request.close();

    if (response.statusCode != 200) {
      throw const HttpException('Invalid response');
    }

    final stringData = await response.transform(utf8.decoder).join();
    final json = jsonDecode(stringData) as List<dynamic>;
    final jsonList = json.cast<Map<String, dynamic>>();

    return jsonList.map(Activity.fromJson).toList();
  }

  /// Returns a [List] of [BookingApiModel]s.
  Future<List<BookingApiModel>> getBookings() async {
    final request = await _client.get(_host, _port, '/booking');
    authHeader(request.headers);
    final response = await request.close();

    if (response.statusCode != 200) {
      throw const HttpException('Invalid response');
    }

    final stringData = await response.transform(utf8.decoder).join();
    final json = jsonDecode(stringData) as List<dynamic>;
    final jsonList = json.cast<Map<String, dynamic>>();

    return jsonList.map(BookingApiModel.fromJson).toList();
  }

  /// Returns a [BookingApiModel] by [id].
  Future<BookingApiModel> getBooking(int id) async {
    final request = await _client.get(_host, _port, '/booking/$id');
    authHeader(request.headers);
    final response = await request.close();

    if (response.statusCode != 200) {
      throw const HttpException('Invalid response');
    }

    final stringData = await response.transform(utf8.decoder).join();

    return BookingApiModel.fromJson(
      jsonDecode(stringData) as Map<String, dynamic>,
    );
  }

  /// Posts a [BookingApiModel] and returns the created [BookingApiModel].
  Future<BookingApiModel> postBooking(BookingApiModel booking) async {
    final request = await _client.post(_host, _port, '/booking');
    authHeader(request.headers);
    request.write(jsonEncode(booking));
    final response = await request.close();

    if (response.statusCode != 201) {
      throw const HttpException('Invalid response');
    }

    final stringData = await response.transform(utf8.decoder).join();

    return BookingApiModel.fromJson(
      jsonDecode(stringData) as Map<String, dynamic>,
    );
  }

  /// Returns a [UserApiModel].
  Future<UserApiModel> getUser() async {
    final request = await _client.get(_host, _port, '/user');
    authHeader(request.headers);
    final response = await request.close();

    if (response.statusCode != 200) {
      throw const HttpException('Invalid response');
    }

    final stringData = await response.transform(utf8.decoder).join();

    return UserApiModel.fromJson(
      jsonDecode(stringData) as Map<String, dynamic>,
    );
  }

  /// Deletes a booking by [id].
  Future<void> deleteBooking(int id) async {
    final request = await _client.delete(_host, _port, '/booking/$id');
    authHeader(request.headers);
    final response = await request.close();

    if (response.statusCode != 204) {
      throw const HttpException('Invalid response');
    }

    // Response 204 "No Content", delete was successful.
  }

  /// Closes the [ApiClient].
  /// This method should be called when the [ApiClient] is no longer needed.
  void close() {
    _authHeaderProviderSubscription.cancel();
    _client.close(force: true);
  }
}
