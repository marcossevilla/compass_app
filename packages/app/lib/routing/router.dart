import 'package:compass_app/routing/routes.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Top go_router entry point.
///
/// Routes are declared as type-safe [GoRouteData] classes in `routes.dart` and
/// wired up through the generated `$appRoutes` list, which also powers deep
/// linking: any external URL that matches a declared path opens the
/// corresponding in-app destination.
///
/// Listens to changes in [isAuthenticated] to redirect the user
/// to /login when the user logs out.
GoRouter router(ValueNotifier<bool> isAuthenticated) {
  return GoRouter(
    initialLocation: const HomeRoute().location,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // If the user is not logged in, they need to login.
      if (!isAuthenticated.value) return const LoginRoute().location;

      // If the user is logged in but still on the login page, send them to
      // the home page.
      final loggingIn = state.matchedLocation == const LoginRoute().location;
      if (loggingIn) return const HomeRoute().location;

      // No need to redirect at all.
      return null;
    },
    refreshListenable: isAuthenticated,
    routes: $appRoutes,
  );
}
