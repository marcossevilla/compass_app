import 'dart:convert';
import 'dart:io';

import 'package:api/api.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../../../routes/booking/index.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockBookingBloc extends MockBloc<BookingEvent, BookingState>
    implements BookingBloc {}

void main() {
  group('/booking', () {
    late Uri uri;
    late RequestContext context;
    late BookingBloc bookingBloc;

    setUp(() {
      uri = Uri.parse('http://localhost/booking/');
      context = _MockRequestContext();
      bookingBloc = _MockBookingBloc();

      when(context.read<BookingBloc>).thenReturn(bookingBloc);
    });

    test(
      'returns method not allowed when request method is not [GET, POST]',
      () {
        final unallowedRequests = [
          Request.put(uri),
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
      },
    );

    group('GET', () {
      setUp(() {
        when(() => context.request).thenReturn(Request.get(uri));
      });

      test('returns a list of bookings', () async {
        final booking = BookingState.defaultBooking(sequentialId: 0);

        when(
          () => bookingBloc.state,
        ).thenReturn(BookingState(bookings: [booking], sequentialId: 0));

        final response = await onRequest(context);
        final body = await response.body();
        final decodedBody = jsonDecode(body) as List;
        final bookings = decodedBody.cast<Map<String, dynamic>>();

        expect(response.statusCode, equals(HttpStatus.ok));
        expect(bookings, equals([booking.toJson()]));
      });
    });

    group('POST', () {
      test('returns bad request when booking id is not null', () async {
        final bookingWithId = BookingState.defaultBooking(sequentialId: 0);

        when(() => context.request).thenReturn(
          Request.post(uri, body: jsonEncode(bookingWithId.toJson())),
        );

        final response = await onRequest(context);

        expect(response.statusCode, equals(HttpStatus.badRequest));
        expect(
          response.body(),
          completion(equals('Booking already has id, use PUT instead.')),
        );
      });

      test(
        'returns created and booking object when booking id is null',
        () async {
          final booking = BookingApiModel(
            startDate: DateTime(2025),
            endDate: DateTime(2025),
            name: 'name',
            destinationRef: 'destinationRef',
            activitiesRef: ['activitiesRef'],
          );

          when(
            () => context.request,
          ).thenReturn(Request.post(uri, body: jsonEncode(booking.toJson())));

          when(
            () => bookingBloc.state,
          ).thenReturn(BookingState(bookings: [booking], sequentialId: 0));

          final response = await onRequest(context);
          final body = await response.body();
          final decodedBody = jsonDecode(body) as Map<String, dynamic>;
          final bookingResponse = BookingApiModel.fromJson(decodedBody);

          expect(response.statusCode, equals(HttpStatus.created));
          expect(bookingResponse, equals(booking));
          verify(() => bookingBloc.add(BookingAdded(booking))).called(1);
        },
      );
    });
  });
}
