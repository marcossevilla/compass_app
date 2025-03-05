import 'package:activity_repository/activity_repository.dart';
import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:compass_app/app/app.dart';
import 'package:compass_app/bootstrap.dart';
import 'package:continent_repository/continent_repository.dart';
import 'package:destination_repository/destination_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:logging/logging.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = Level.ALL;

  final sharedPreferences = await SharedPreferences.getInstance();

  final authApiClient = AuthApiClient(sharedPreferences: sharedPreferences);

  final apiClient = ApiClient(
    authHeaderProvider: authApiClient.authHeaderProvider,
  );

  final authenticationRepository = AuthenticationRepository(
    authApiClient: authApiClient,
  );

  final activityRepository = ActivityRepository(apiClient: apiClient);

  final bookingRepository = BookingRepository(apiClient: apiClient);

  final continentRepository = ContinentRepository(apiClient: apiClient);

  final destinationRepository = DestinationRepository(apiClient: apiClient);

  final itineraryConfigRepository = ItineraryConfigRepository();

  final userRepository = UserRepository(apiClient: apiClient);

  await bootstrap(
    () => App(
      activityRepository: activityRepository,
      authenticationRepository: authenticationRepository,
      bookingRepository: bookingRepository,
      continentRepository: continentRepository,
      destinationRepository: destinationRepository,
      itineraryConfigRepository: itineraryConfigRepository,
      userRepository: userRepository,
    ),
  );
}
