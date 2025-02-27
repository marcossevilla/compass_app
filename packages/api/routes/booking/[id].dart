import 'dart:async';
import 'dart:io';

import 'package:api/api.dart';
import 'package:collection/collection.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context, String id) {
  return switch (context.request.method) {
    HttpMethod.get => _get(context, id),
    HttpMethod.delete => _delete(context, id),
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}

Response _get(RequestContext context, String id) {
  final bookingId = int.parse(id);
  final bookingBloc = context.read<BookingBloc>();

  final booking = bookingBloc.state.bookings.firstWhereOrNull(
    (booking) => booking.id == bookingId,
  );

  if (booking == null) {
    return Response(statusCode: HttpStatus.notFound, body: 'Invalid id');
  }

  return Response.json(body: booking);
}

Response _delete(RequestContext context, String id) {
  final bookingId = int.parse(id);
  final bookingBloc = context.read<BookingBloc>();

  final booking = bookingBloc.state.bookings.firstWhereOrNull(
    (booking) => booking.id == bookingId,
  );

  if (booking == null) {
    return Response(statusCode: HttpStatus.notFound, body: 'Invalid id');
  }

  context.read<BookingBloc>().add(BookingRemoved(booking));

  // 240: no content.
  return Response(statusCode: HttpStatus.noContent);
}
