import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../routes/_middleware.dart';

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('middleware', () {
    late RequestContext context;

    setUpAll(() {
      registerFallbackValue(() => Constants.user);
    });

    setUp(() {
      context = _MockRequestContext();
    });

    test('skips authentication for login requests', () async {
      final request = Request.post(Uri.parse('http://localhost/login'));
      when(() => context.request).thenReturn(request);

      final handler = middleware((_) => Response(body: 'authenticated'));
      final response = await handler(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.body(), completion(equals('authenticated')));
      verifyNever(() => context.provide<UserApiModel>(any()));
    });

    test('returns unauthorized when the bearer token is invalid', () async {
      final request = Request.get(
        Uri.parse('http://localhost/user'),
        headers: const {HttpHeaders.authorizationHeader: 'Bearer invalid'},
      );
      when(() => context.request).thenReturn(request);

      final handler = middleware((_) => Response(body: 'authenticated'));
      final response = await handler(context);

      expect(response.statusCode, equals(HttpStatus.unauthorized));
      verifyNever(() => context.provide<UserApiModel>(any()));
    });

    test(
      'returns unauthorized when no authorization header is present',
      () async {
        final request = Request.get(Uri.parse('http://localhost/user'));
        when(() => context.request).thenReturn(request);

        final handler = middleware((_) => Response(body: 'authenticated'));
        final response = await handler(context);

        expect(response.statusCode, equals(HttpStatus.unauthorized));
        verifyNever(() => context.provide<UserApiModel>(any()));
      },
    );

    test(
      'provides the hardcoded user when the bearer token is valid',
      () async {
        final request = Request.get(
          Uri.parse('http://localhost/user'),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ${Constants.token}',
          },
        );
        when(() => context.request).thenReturn(request);
        when(() => context.provide<UserApiModel>(any())).thenReturn(context);

        final handler = middleware((_) => Response(body: 'authenticated'));
        final response = await handler(context);

        expect(response.statusCode, equals(HttpStatus.ok));
        expect(response.body(), completion(equals('authenticated')));

        final create =
            verify(
                  () => context.provide<UserApiModel>(captureAny()),
                ).captured.single
                as UserApiModel Function();

        expect(create(), equals(Constants.user));
      },
    );
  });
}
