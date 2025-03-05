import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:models/models.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(
        bearerAuthentication<UserApiModel>(
          authenticator: (context, token) async {
            if (context.request.headers['Authorization'] ==
                'Bearer ${Constants.token}') {
              return Constants.user;
            }

            // If the request is not a login request and the token is not
            // present, return a 401 Unauthorized response.
            return null;
          },
          applies: (context) async => context.request.url.path != 'login',
        ),
      );
}
