import 'package:activity_repository/activity_repository.dart';
import 'package:compass_app/activities/activities.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/routing/routes.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:itinerary_config_repository/itinerary_config_repository.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActivitiesCubit(
        activityRepository: context.read<ActivityRepository>(),
        itineraryConfigRepository: context.read<ItineraryConfigRepository>(),
      )..loadActivities(),
      child: const ActivitiesView(),
    );
  }
}

class ActivitiesView extends StatelessWidget {
  const ActivitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<ActivitiesCubit, ActivitiesState>(
      listener: (context, state) {
        if (state.status == ActivitiesStatus.savedActivities) {
          return context.go(Routes.booking);
        }

        if (state.status == ActivitiesStatus.failedSavingActivities) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(l10n.errorWhileSavingActivities),
                action: SnackBarAction(
                  label: l10n.tryAgain,
                  onPressed: context.read<ActivitiesCubit>().saveActivities,
                ),
              ),
            );
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) context.go(Routes.results);
        },
        child: Scaffold(
          body: BlocBuilder<ActivitiesCubit, ActivitiesState>(
            builder: (context, state) {
              if (state.status == ActivitiesStatus.loadedActivities) {
                return Column(
                  children: [
                    const Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: ActivitiesHeader(),
                          ),
                          ActivitiesTitle(
                            activityTimeOfDay: ActivityTimeOfDay.daytime,
                          ),
                          ActivitiesList(
                            activityTimeOfDay: ActivityTimeOfDay.daytime,
                          ),
                          ActivitiesTitle(
                            activityTimeOfDay: ActivityTimeOfDay.evening,
                          ),
                          ActivitiesList(
                            activityTimeOfDay: ActivityTimeOfDay.evening,
                          ),
                        ],
                      ),
                    ),
                    BottomArea(
                      selectedActivities: state.selectedActivities,
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  const ActivitiesHeader(),
                  if (state.status == ActivitiesStatus.loadingActivities)
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (state.status == ActivitiesStatus.failedLoadingActivities)
                    Expanded(
                      child: Center(
                        child: ErrorIndicator(
                          title: l10n.errorWhileLoadingActivities,
                          label: l10n.tryAgain,
                          onPressed:
                              context.read<ActivitiesCubit>().loadActivities,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class BottomArea extends StatelessWidget {
  const BottomArea({
    required this.selectedActivities,
    super.key,
  });

  final Set<String> selectedActivities;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dimensions = context.dimensions;

    return SafeArea(
      child: Material(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.only(
            left: dimensions.paddingScreenHorizontal,
            right: dimensions.paddingScreenVertical,
            top: dimensions.paddingVertical,
            bottom: dimensions.paddingScreenVertical,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.selected(selectedActivities.length),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              FilledButton(
                onPressed: selectedActivities.isNotEmpty
                    ? context.read<ActivitiesCubit>().saveActivities
                    : null,
                child: Text(l10n.confirm),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
