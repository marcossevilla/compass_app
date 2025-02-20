import 'package:authentication_repository/authentication_repository.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/logout/logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => LogoutCubit(
            authenticationRepository: context.read<AuthenticationRepository>(),
            itineraryConfigRepository:
                context.read<ItineraryConfigRepository>(),
          ),
      child: const LogoutButtonView(),
    );
  }
}

class LogoutButtonView extends StatelessWidget {
  const LogoutButtonView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<LogoutCubit, LogoutState>(
      listenWhen:
          (previous, current) =>
              previous.status != current.status &&
              current.status == LogoutStatus.failure,
      listener: (context, state) {
        // We do not need to navigate to `/login` on logout,
        // it is done automatically by GoRouter.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorWhileLogout),
            action: SnackBarAction(
              label: l10n.tryAgain,
              onPressed: context.read<LogoutCubit>().logout,
            ),
          ),
        );
      },
      child: SizedBox(
        height: 40,
        width: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade100),
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
          ),
          child: InkResponse(
            borderRadius: BorderRadius.circular(8),
            onTap: context.read<LogoutCubit>().logout,
            child: Center(
              child: Icon(
                size: 24,
                Icons.logout,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
