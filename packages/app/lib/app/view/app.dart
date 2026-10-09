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

class const App({
  required final ActivityRepository _activityRepository,
  required final AuthenticationRepository _authenticationRepository,
  required final BookingRepository _bookingRepository,
  required final ContinentRepository _continentRepository,
  required final DestinationRepository _destinationRepository,
  required final ItineraryConfigRepository _itineraryConfigRepository,
  required final UserRepository _userRepository,
  super.key,
}) extends StatelessWidget {
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

class const AppView({super.key}) extends StatelessWidget {
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
