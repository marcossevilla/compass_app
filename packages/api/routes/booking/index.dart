import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}
