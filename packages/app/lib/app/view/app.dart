import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/routing/router.dart';
import 'package:continent_repository/continent_repository.dart';
import 'package:destination_repository/destination_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  const App({
    required ActivityRepository activityRepository,
    required AuthenticationRepository authenticationRepository,
    required BookingRepository bookingRepository,
    required ContinentRepository continentRepository,
    required DestinationRepository destinationRepository,
    required ItineraryConfigRepository itineraryConfigRepository,
    required UserRepository userRepository,
    super.key,
  })  : _activityRepository = activityRepository,
        _authenticationRepository = authenticationRepository,
        _bookingRepository = bookingRepository,
        _continentRepository = continentRepository,
        _destinationRepository = destinationRepository,
        _itineraryConfigRepository = itineraryConfigRepository,
        _userRepository = userRepository;

  final ActivityRepository _activityRepository;
  final AuthenticationRepository _authenticationRepository;
  final BookingRepository _bookingRepository;
  final ContinentRepository _continentRepository;
  final DestinationRepository _destinationRepository;
  final ItineraryConfigRepository _itineraryConfigRepository;
  final UserRepository _userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _activityRepository),
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _bookingRepository),
        RepositoryProvider.value(value: _continentRepository),
        RepositoryProvider.value(value: _destinationRepository),
        RepositoryProvider.value(value: _itineraryConfigRepository),
        RepositoryProvider.value(value: _userRepository),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: context.read<AuthenticationRepository>().isAuthenticated,
      builder: (context, snapshot) {
        final isAuthenticated = ValueNotifier(snapshot.data ?? false);
        return MaterialApp.router(
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            useMaterial3: true,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router(isAuthenticated),
        );
      },
    );
  }
}
