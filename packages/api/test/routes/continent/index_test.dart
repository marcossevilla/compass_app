import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../../routes/continent/index.dart';

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('/continent', () {
    late Uri uri;
    late RequestContext context;

    setUp(() {
      uri = Uri.parse('http://localhost/continent/');
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
            equals(HttpStatus.methodNotAllowed),
          ),
        );
      }
    });

    group('GET', () {
      setUp(() {
        when(() => context.request).thenReturn(Request.get(uri));
      });

      test('returns a list of continents', () async {
        final response = onRequest(context);
        final body = jsonDecode(await response.body()) as List;

        expect(response.statusCode, equals(HttpStatus.ok));
        expect(
          body.cast<Map<String, dynamic>>().map(Continent.fromJson),
          isA<Iterable<Continent>>(),
        );
        expect(body, hasLength(7));
      });
    });
  });
}
