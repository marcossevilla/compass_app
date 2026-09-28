import 'dart:async';

import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/routing/routing.dart';
import 'package:continent_repository/continent_repository.dart';
import 'package:destination_repository/destination_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  const new({
    required this._activityRepository,
    required this._authenticationRepository,
    required this._bookingRepository,
    required this._continentRepository,
    required this._deepLinks,
    required this._destinationRepository,
    required this._itineraryConfigRepository,
    required this._userRepository,
    super.key,
  });

  final ActivityRepository _activityRepository;
  final AuthenticationRepository _authenticationRepository;
  final BookingRepository _bookingRepository;
  final ContinentRepository _continentRepository;
  final Stream<Uri> _deepLinks;
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
      child: AppView(deepLinks: _deepLinks),
    );
  }
}

class AppView extends StatefulWidget {
  const new({required this.deepLinks, super.key});

  final Stream<Uri> deepLinks;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final StreamValueNotifier<bool> _isAuthenticated;
  late final GoRouter _router;
  late final StreamSubscription<Uri> _deepLinkSubscription;

  @override
  void initState() {
    super.initState();
    _isAuthenticated = StreamValueNotifier(
      context.read<AuthenticationRepository>().isAuthenticated,
      initialValue: false,
    );
    _router = router(_isAuthenticated);
    _deepLinkSubscription = widget.deepLinks.listen(_onDeepLink);
  }

  void _onDeepLink(Uri uri) => _router.go(
    Uri(
      path: uri.path.isEmpty ? '/' : uri.path,
      query: uri.hasQuery ? uri.query : null,
    ).toString(),
  );

  @override
  void dispose() {
    unawaited(_deepLinkSubscription.cancel());
    _router.dispose();
    _isAuthenticated.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
