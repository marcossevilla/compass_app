import 'dart:convert';
import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../routes/user/index.dart';

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('/user', () {
    late Uri uri;
    late RequestContext context;

    setUp(() {
      uri = Uri.parse('http://localhost/user');
      context = _MockRequestContext();
    });

    test('returns method not allowed when request method is not [GET]', () {
      final unallowedRequests = [
        Request.put(uri),
        Request.post(uri),
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
            HttpStatus.methodNotAllowed,
          ),
        );
      }
    });

    group('GET', () {
      setUp(() {
        when(() => context.request).thenReturn(Request.get(uri));
      });

      test('returns default user', () async {
        final response = onRequest(context);
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;

        expect(response.statusCode, equals(HttpStatus.ok));
        expect(UserApiModel.fromJson(body), equals(Constants.user));
      });
    });
  });
}
