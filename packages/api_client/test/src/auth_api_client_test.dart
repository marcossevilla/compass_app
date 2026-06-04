// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

class _MockHttpClient extends Mock implements HttpClient {}

class _MockHttpClientRequest extends Mock implements HttpClientRequest {}

class _MockSharedPreferences extends Mock implements SharedPreferences {}

/// A fake [HttpClientResponse] backed by an in-memory [body].
///
/// `transform` and `join` are implemented in terms of [listen], so delegating
/// [listen] to a real stream is enough for the whole decode pipeline to work.
class _FakeHttpClientResponse extends Fake implements HttpClientResponse {
  _FakeHttpClientResponse(this.body, {this.statusCode = 200});

  final String body;

  @override
  final int statusCode;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(utf8.encode(body)).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

void main() {
  group(AuthApiClient, () {
    const tokenKey = 'TOKEN';

    late HttpClient httpClient;
    late HttpClientRequest request;
    late SharedPreferences sharedPreferences;
    late AuthApiClient authApiClient;

    setUp(() {
      httpClient = _MockHttpClient();
      request = _MockHttpClientRequest();
      sharedPreferences = _MockSharedPreferences();

      when(() => sharedPreferences.getString(tokenKey)).thenReturn(null);

      authApiClient = AuthApiClient(
        sharedPreferences: sharedPreferences,
        client: httpClient,
      );
    });

    /// Stubs a POST request that returns [response].
    void stubPost(HttpClientResponse response) {
      when(
        () => httpClient.post(any(), any(), any()),
      ).thenAnswer((_) async => request);
      when(request.close).thenAnswer((_) async => response);
    }

    test('can be instantiated', () {
      expect(authApiClient, isNotNull);
    });

    group('token', () {
      test('emits the stored token on the auth header provider', () async {
        when(() => sharedPreferences.getString(tokenKey)).thenReturn('abc');

        expect(authApiClient.authHeaderProvider, emits('Bearer abc'));

        await authApiClient.token();
      });

      test('emits null when no token is stored', () async {
        when(() => sharedPreferences.getString(tokenKey)).thenReturn(null);

        expect(authApiClient.authHeaderProvider, emits(null));

        await authApiClient.token();
      });

      test('rethrows when shared preferences fails', () async {
        when(
          () => sharedPreferences.getString(tokenKey),
        ).thenThrow(Exception('oops'));

        await expectLater(authApiClient.token(), throwsException);
      });
    });

    group('isAuthenticated', () {
      test('emits true when a token is stored', () {
        when(() => sharedPreferences.getString(tokenKey)).thenReturn('abc');

        expect(authApiClient.isAuthenticated, emits(true));
      });

      test('emits false when no token is stored', () {
        when(() => sharedPreferences.getString(tokenKey)).thenReturn(null);

        expect(authApiClient.isAuthenticated, emits(false));
      });
    });

    group('login', () {
      const loginRequest = LoginRequest(
        email: 'me@example.com',
        password: 'password',
      );
      const loginResponse = LoginResponse(token: 'abc', userId: '1');

      test('stores the token and emits auth state on success', () async {
        stubPost(_FakeHttpClientResponse(jsonEncode(loginResponse.toJson())));
        when(
          () => sharedPreferences.setString(tokenKey, 'abc'),
        ).thenAnswer((_) async => true);

        // Listening only to the auth header provider keeps the token() side
        // effect of isAuthenticated from interleaving emissions.
        expect(authApiClient.authHeaderProvider, emits('Bearer abc'));

        await authApiClient.login(loginRequest);

        verify(() => httpClient.post('localhost', 8080, '/login')).called(1);
        verify(() => request.write(jsonEncode(loginRequest))).called(1);
        verify(() => sharedPreferences.setString(tokenKey, 'abc')).called(1);
      });

      test('uses the provided host and port', () async {
        authApiClient = AuthApiClient(
          sharedPreferences: sharedPreferences,
          client: httpClient,
          host: 'example.com',
          port: 9090,
        );
        stubPost(_FakeHttpClientResponse(jsonEncode(loginResponse.toJson())));
        when(
          () => sharedPreferences.setString(tokenKey, 'abc'),
        ).thenAnswer((_) async => true);

        await authApiClient.login(loginRequest);

        verify(() => httpClient.post('example.com', 9090, '/login')).called(1);
      });

      test('throws HttpException on non-200 response', () async {
        stubPost(_FakeHttpClientResponse('', statusCode: 401));

        await expectLater(
          authApiClient.login(loginRequest),
          throwsA(isA<HttpException>()),
        );
      });
    });

    group('logout', () {
      test('removes the stored token and emits cleared auth state', () async {
        when(
          () => sharedPreferences.remove(tokenKey),
        ).thenAnswer((_) async => true);

        expect(authApiClient.authHeaderProvider, emits(null));
        expect(authApiClient.isAuthenticated, emits(false));

        await authApiClient.logout();

        verify(() => sharedPreferences.remove(tokenKey)).called(1);
      });

      test('rethrows when removing the token fails', () async {
        when(
          () => sharedPreferences.remove(tokenKey),
        ).thenThrow(Exception('oops'));

        await expectLater(authApiClient.logout(), throwsException);
      });
    });
  });
}
