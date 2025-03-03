import 'dart:convert';
import 'dart:io';

import 'package:api/api.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../../routes/booking/[id].dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockBookingBloc extends MockBloc<BookingEvent, BookingState>
    implements BookingBloc {}

void main() {
  group('/booking', () {
    late Uri uri;
    late RequestContext context;
    late BookingBloc bookingBloc;

    setUp(() {
      uri = Uri.parse('http://localhost/routes/booking/');
      context = _MockRequestContext();
      bookingBloc = _MockBookingBloc();

      when(context.read<BookingBloc>).thenReturn(bookingBloc);
    });

    test(
      'returns method not allowed when request method is not [GET, DELETE]',
      () {
        final unallowedRequests = [
          Request.put(uri),
          Request.post(uri),
          Request.patch(uri),
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
      },
    );

    group('GET', () {
      setUp(() {
        when(() => context.request).thenReturn(Request.get(uri));
      });

      test('returns not found when is invalid id', () async {
        when(() => bookingBloc.state).thenReturn(BookingState.initial());

        final response = await onRequest(context, '1');

        expect(response.statusCode, equals(HttpStatus.notFound));
        expect(response.body(), completion(equals('Invalid id')));
      });

      test('returns booking when is valid id', () async {
        when(() => bookingBloc.state).thenReturn(BookingState.initial());

        final booking = BookingState.defaultBooking(sequentialId: 0);
        final response = await onRequest(context, '0');
        final body = await response.body();
        final decodedBody = jsonDecode(body) as Map<String, dynamic>;
        final bookingResponse = BookingApiModel.fromJson(decodedBody);

        expect(response.statusCode, equals(HttpStatus.ok));
        expect(bookingResponse, equals(booking));
      });
    });

    group('DELETE', () {
      setUp(() {
        when(() => context.request).thenReturn(Request.delete(uri));
      });

      test('returns not found when is invalid id', () async {
        when(() => bookingBloc.state).thenReturn(BookingState.initial());

        final response = await onRequest(context, '1');

        expect(response.statusCode, equals(HttpStatus.notFound));
        expect(response.body(), completion(equals('Invalid id')));
      });

      test('returns no content when is valid id', () async {
        when(() => bookingBloc.state).thenReturn(BookingState.initial());

        final booking = BookingState.defaultBooking(sequentialId: 0);
        final response = await onRequest(context, '0');

        expect(response.statusCode, equals(HttpStatus.noContent));
        verify(() => bookingBloc.add(BookingRemoved(booking))).called(1);
      });
    });
  });
}
