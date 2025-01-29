// TODO(marcossevilla): remove once dependencies are provided to the app.
// ignore_for_file: unused_local_variable

import 'package:activity_repository/activity_repository.dart';
import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:compass_app/app/app.dart';
import 'package:compass_app/bootstrap.dart';

Future<void> main() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  final authApiClient = AuthApiClient(
    sharedPreferences: sharedPreferences,
  );

  final apiClient = ApiClient(
    authHeaderProvider: authApiClient.authHeaderProvider,
  );

  final authenticationRepository = AuthenticationRepository(
    authApiClient: authApiClient,
  );

  final activityRepository = ActivityRepository(
    apiClient: apiClient,
  );

  await bootstrap(() => const AppView());
}
