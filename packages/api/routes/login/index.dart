import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';

FutureOr<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => _post(context),
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}

Future<Response> _post(RequestContext context) async {
  final body = await context.request.body();
  final loginRequest = LoginRequest.fromJson(
    json.decode(body) as Map<String, dynamic>,
  );

  if (loginRequest.email != Constants.email ||
      loginRequest.password != Constants.password) {
    return Response(
      statusCode: HttpStatus.unauthorized,
      body: 'Invalid credentials',
    );
  }

  return Response.json(
    body: const LoginResponse(token: Constants.token, userId: Constants.userId),
  );
}
