import 'package:compass_app/activities/activities.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivitiesList extends StatelessWidget {
  const ActivitiesList({required this.activityTimeOfDay, super.key});

  final ActivityTimeOfDay activityTimeOfDay;

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    final daytimeActivities = context.select(
      (ActivitiesCubit cubit) => cubit.state.daytimeActivities,
    );

    final eveningActivities = context.select(
      (ActivitiesCubit cubit) => cubit.state.eveningActivities,
    );

    final selectedActivities = context.select(
      (ActivitiesCubit cubit) => cubit.state.selectedActivities,
    );

    final list = switch (activityTimeOfDay) {
      ActivityTimeOfDay.daytime => daytimeActivities,
      ActivityTimeOfDay.evening => eveningActivities,
    };

    return SliverPadding(
      padding: EdgeInsets.only(
        top: dimensions.paddingVertical,
        left: dimensions.paddingScreenHorizontal,
        right: dimensions.paddingScreenHorizontal,
        bottom: dimensions.paddingVertical,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final activity = list[index];
          return Padding(
            padding: EdgeInsets.only(bottom: index < list.length - 1 ? 20 : 0),
            child: ActivityEntry(
              key: ValueKey(activity.ref),
              activity: activity,
              selected: selectedActivities.contains(activity.ref),
              onChanged: (value) {
                if (value!) {
                  return context.read<ActivitiesCubit>().addActivity(
                    activity.ref,
                  );
                }
                return context.read<ActivitiesCubit>().removeActivity(
                  activity.ref,
                );
              },
            ),
          );
        }, childCount: list.length),
      ),
    );
  }
}
