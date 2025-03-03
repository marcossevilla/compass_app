import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context, String id) {
  return switch (context.request.method) {
    HttpMethod.get => _get(context, id),
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}

Response _get(RequestContext context, String id) {
  final activities =
      Assets.activities
          .where((activity) => activity.destinationRef == id)
          .toList();
  return Response.json(body: activities);
}
