import 'dart:async';

import 'package:booking_repository/booking_repository.dart';
import 'package:compass_app/activities/activities.dart';
import 'package:compass_app/booking/booking.dart';
import 'package:compass_app/home/home.dart';
import 'package:compass_app/login/login.dart';
import 'package:compass_app/results/results.dart';
import 'package:compass_app/search_form/search_form.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_repository/user_repository.dart';

part 'routes.g.dart';

/// The login screen.
///
/// [from] is the location to return to after logging in, so a deep link
/// opened while signed out still lands on its destination.
@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  const new({this.from});

  final String? from;

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginPage();
}

/// The home screen. Nested routes pop back to it, e.g. `/booking/1` to `/`.
@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<SearchRoute>(path: 'search'),
    TypedGoRoute<ResultsRoute>(path: 'results'),
    TypedGoRoute<ActivitiesRoute>(path: 'activities'),
    TypedGoRoute<BookingRoute>(
      path: 'booking',
      routes: [TypedGoRoute<BookingDetailsRoute>(path: ':id')],
    ),
  ],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final cubit = HomeCubit(
      userRepository: context.read<UserRepository>(),
      bookingRepository: context.read<BookingRepository>(),
    );
    unawaited(cubit.load());
    return HomePage(
      // Passing the [HomeCubit] here to trigger load each time
      // the home page is opened.
      homeCubit: cubit,
    );
  }
}

/// The search form used to configure a new itinerary.
class SearchRoute extends GoRouteData with $SearchRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SearchFormPage();
}

/// The list of destination results for the configured search.
class ResultsRoute extends GoRouteData with $ResultsRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ResultsPage();
}

/// The activities available for the selected destination.
class ActivitiesRoute extends GoRouteData with $ActivitiesRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ActivitiesPage();
}

/// Creates a new booking from the current itinerary configuration.
///
/// Opening it saves the booking right away, so it is meant for the in-app
/// flow, not for sharing as a deep link.
class BookingRoute extends GoRouteData with $BookingRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const BookingPage.createBooking();
}

/// Loads and displays an existing booking identified by [id].
class BookingDetailsRoute extends GoRouteData with $BookingDetailsRoute {
  const new({required this.id});

  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      BookingPage.loadBooking(id: id);
}
