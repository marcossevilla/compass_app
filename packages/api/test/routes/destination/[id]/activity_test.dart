import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../../../routes/destination/[id]/activity.dart';

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('/destination/[id]/activity', () {
    late Uri uri;
    late RequestContext context;

    setUp(() {
      uri = Uri.parse('http://localhost/destination/id/activity');
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
          onRequest(context, 'id'),
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

      test('returns a list of activities', () async {
        final response = onRequest(context, 'alaska');
        final body = jsonDecode(await response.body()) as List;

        expect(response.statusCode, HttpStatus.ok);
        expect(
          body.cast<Map<String, dynamic>>().map(Activity.fromJson),
          isA<Iterable<Activity>>(),
        );
        expect(body, hasLength(20));
      });
    });
  });
}
