import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

FutureOr<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => _get(context),
    HttpMethod.post => _post(context),
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}

Response _get(RequestContext context) {
  final bookingBloc = context.read<BookingBloc>();
  final bookings = bookingBloc.state.bookings;
  return Response.json(body: bookings);
}

Future<Response> _post(RequestContext context) async {
  final body = await context.request.body();
  final booking = BookingApiModel.fromJson(
    json.decode(body) as Map<String, dynamic>,
  );

  if (booking.id != null) {
    // POST endpoint only allows newly created bookings.
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'Booking already has id, use PUT instead.',
    );
  }

  // Store booking.
  context.read<BookingBloc>().add(BookingAdded(booking));

  // Get newly created booking.
  final bookingWithId = context.read<BookingBloc>().state.bookings.last;

  // Respond with newly created booking.
  return Response.json(statusCode: HttpStatus.created, body: bookingWithId);
}
