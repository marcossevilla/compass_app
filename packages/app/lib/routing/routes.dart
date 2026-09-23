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
/// Deep link: `/login`.
@TypedGoRoute<LoginRoute>(name: 'login', path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginPage();
}

/// The home screen and the root of the authenticated navigation tree.
///
/// Every other authenticated destination is nested underneath so that back
/// navigation and deep links follow the URL hierarchy, e.g. `/booking/1`
/// returns to `/` when popped.
@TypedGoRoute<HomeRoute>(
  name: 'home',
  path: '/',
  routes: [
    TypedGoRoute<SearchRoute>(name: 'search', path: 'search'),
    TypedGoRoute<ResultsRoute>(name: 'results', path: 'results'),
    TypedGoRoute<ActivitiesRoute>(name: 'activities', path: 'activities'),
    TypedGoRoute<BookingRoute>(
      name: 'booking',
      path: 'booking',
      routes: [
        TypedGoRoute<BookingDetailsRoute>(name: 'bookingDetails', path: ':id'),
      ],
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
///
/// Deep link: `/search`.
class SearchRoute extends GoRouteData with $SearchRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SearchFormPage();
}

/// The list of destination results for the configured search.
///
/// Deep link: `/results`.
class ResultsRoute extends GoRouteData with $ResultsRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ResultsPage();
}

/// The activities available for the selected destination.
///
/// Deep link: `/activities`.
class ActivitiesRoute extends GoRouteData with $ActivitiesRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ActivitiesPage();
}

/// Creates a new booking from the current itinerary configuration.
///
/// Deep link: `/booking`.
class BookingRoute extends GoRouteData with $BookingRoute {
  const new();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const BookingPage.createBooking();
}

/// Loads and displays an existing booking identified by [id].
///
/// Deep link: `/booking/:id`, e.g. `/booking/1`. The [id] path parameter is
/// parsed to an [int] by the generated route, enabling external links to open
/// a specific saved booking.
class BookingDetailsRoute extends GoRouteData with $BookingDetailsRoute {
  const new({required this.id});

  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      BookingPage.loadBooking(id: id);
}
