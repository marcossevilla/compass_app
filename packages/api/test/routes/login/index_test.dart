import 'dart:convert';
import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../../routes/login/index.dart';

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('/login', () {
    late Uri uri;
    late RequestContext context;

    setUp(() {
      uri = Uri.parse('http://localhost/login');
      context = _MockRequestContext();
    });

    test('returns method not allowed when request method is not [POST]', () {
      final unallowedRequests = [
        Request.put(uri),
        Request.get(uri),
        Request.patch(uri),
        Request.delete(uri),
      ];

      for (final request in unallowedRequests) {
        when(() => context.request).thenReturn(request);
        expect(
          onRequest(context),
          isA<Response>().having(
            (response) => response.statusCode,
            'statusCode',
            equals(HttpStatus.methodNotAllowed),
          ),
        );
      }
    });

    group('POST', () {
      test('returns unauthorized when credentials are invalid', () async {
        when(() => context.request).thenReturn(
          Request.post(
            uri,
            body: jsonEncode(
              LoginRequest(email: 'email', password: 'password'),
            ),
          ),
        );

        final response = await onRequest(context);

        expect(response.statusCode, equals(HttpStatus.unauthorized));
        expect(response.body(), completion(equals('Invalid credentials')));
      });

      test('returns ok when credentials are valid', () async {
        when(() => context.request).thenReturn(
          Request.post(
            uri,
            body: jsonEncode(
              LoginRequest(
                email: Constants.email,
                password: Constants.password,
              ),
            ),
          ),
        );

        final response = await onRequest(context);
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;

        expect(response.statusCode, equals(HttpStatus.ok));
        expect(
          LoginResponse.fromJson(body),
          equals(
            LoginResponse(token: Constants.token, userId: Constants.userId),
          ),
        );
      });
    });
  });
}
