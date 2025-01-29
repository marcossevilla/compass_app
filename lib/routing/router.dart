import 'package:authentication_repository/authentication_repository.dart';
import 'package:compass_app/routing/routing.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Top go_router entry point.
///
/// Listens to changes in [isAuthenticated] to redirect the user
/// to /login when the user logs out.
GoRouter router(ValueNotifier<bool> isAuthenticated) {
  return GoRouter(
    initialLocation: Routes.home,
    debugLogDiagnostics: true,
    redirect: _redirect,
    refreshListenable: isAuthenticated,
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) {
          return const Placeholder(
            child: Center(
              child: Text('Login'),
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) {
          return const Placeholder(
            child: Center(
              child: Text('Home'),
            ),
          );
        },
      ),
    ],
  );
}

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // If the user is not logged in, they need to login.
  final loggedIn = context.read<AuthenticationRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == Routes.login;

  if (!await loggedIn.last) return Routes.login;

  // If the user is logged in but still on the login page, send them to
  // the home page.
  if (loggingIn) return Routes.home;

  // No need to redirect at all.
  return null;
}
