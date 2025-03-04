import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(authentication());
}

Middleware authentication() {
  return (handler) => (context) async {
    final request = context.request;

    if (request.url.path != 'login' &&
        request.headers['Authorization'] != 'Bearer ${Constants.token}') {
      // If the request is not a login request and the token is not present,
      // return a 401 Unauthorized response.
      return Response(
        statusCode: HttpStatus.unauthorized,
        body: 'Unauthorized',
      );
    }

    return handler(context);
  };
}
