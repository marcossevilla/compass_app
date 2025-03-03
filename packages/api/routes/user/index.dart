import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => _get(context),
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}

Response _get(RequestContext context) {
  return Response.json(body: Constants.user);
}
