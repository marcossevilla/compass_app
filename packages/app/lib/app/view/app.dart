import 'dart:async';

import 'package:activity_repository/activity_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:booking_repository/booking_repository.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/routing/router.dart';
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

  /// Incoming deep links, including the one that launched the app.
  final Stream<Uri> deepLinks;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  // A single router for the app's lifetime, so an auth change refreshes its
  // redirect instead of recreating it and dropping the current location.
  final ValueNotifier<bool> _isAuthenticated = ValueNotifier(false);
  late final GoRouter _router = router(_isAuthenticated);
  late final StreamSubscription<bool> _subscription;
  late final StreamSubscription<Uri> _deepLinkSubscription;

  @override
  void initState() {
    super.initState();
    _subscription = context
        .read<AuthenticationRepository>()
        .isAuthenticated
        .listen((value) => _isAuthenticated.value = value);
    _deepLinkSubscription = widget.deepLinks.listen(_onDeepLink);
  }

  // Drops the scheme and host so the router only sees the location. The
  // router's redirect and exception handling take it from there.
  void _onDeepLink(Uri uri) => _router.go(
    Uri(
      path: uri.path.isEmpty ? '/' : uri.path,
      query: uri.hasQuery ? uri.query : null,
    ).toString(),
  );

  @override
  void dispose() {
    unawaited(_subscription.cancel());
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
