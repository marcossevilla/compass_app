import 'package:compass_app/activities/activities.dart';
import 'package:compass_app/booking/booking.dart';
import 'package:compass_app/home/home.dart';
import 'package:compass_app/login/login.dart';
import 'package:compass_app/results/results.dart';
import 'package:compass_app/routing/routing.dart';
import 'package:compass_app/search_form/search_form.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Top go_router entry point.
///
/// Listens to changes in [isAuthenticated] to redirect the user
/// to /login when the user logs out.
GoRouter router(ValueNotifier<bool> isAuthenticated) {
  return GoRouter(
    initialLocation: Routes.home,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // If the user is not logged in, they need to login.
      if (!isAuthenticated.value) return Routes.login;

      // If the user is logged in but still on the login page, send them to
      // the home page.
      final loggingIn = state.matchedLocation == Routes.login;
      if (loggingIn) return Routes.home;

      // No need to redirect at all.
      return null;
    },
    refreshListenable: isAuthenticated,
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: Routes.searchRelative,
            builder: (context, state) => const SearchFormPage(),
          ),
          GoRoute(
            path: Routes.resultsRelative,
            builder: (context, state) => const ResultsPage(),
          ),
          GoRoute(
            path: Routes.activitiesRelative,
            builder: (context, state) => const ActivitiesPage(),
          ),
          GoRoute(
            path: Routes.bookingRelative,
            builder: (context, state) => const BookingPage.createBooking(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);

                  // When opening the booking screen with an existing id
                  // load and display that booking.
                  return BookingPage.loadBooking(id: id);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
