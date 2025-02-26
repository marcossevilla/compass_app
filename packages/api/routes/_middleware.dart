import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';

Handler middleware(Handler handler) {
  return handler.use(
    bearerAuthentication(
      authenticator: (context, token) async {
        final request = context.request;

        if (request.url.path != 'login' &&
            request.headers['Authorization'] != 'Bearer ${Constants.token}') {
          // If the request is not a login request and the token is not present,
          // return a 401 Unauthorized response.
          return Response(statusCode: HttpStatus.unauthorized);
        }
      },
      applies: (context) async => context.request.method != HttpMethod.post,
    ),
  );
}
