import 'package:compass_app/activities/activities.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivitiesTitle extends StatelessWidget {
  const ActivitiesTitle({required this.activityTimeOfDay, super.key});

  final ActivityTimeOfDay activityTimeOfDay;

  @override
  Widget build(BuildContext context) {
    final daytimeActivities = context.select(
      (ActivitiesCubit cubit) => cubit.state.daytimeActivities,
    );

    final eveningActivities = context.select(
      (ActivitiesCubit cubit) => cubit.state.eveningActivities,
    );

    final list = switch (activityTimeOfDay) {
      ActivityTimeOfDay.daytime => daytimeActivities,
      ActivityTimeOfDay.evening => eveningActivities,
    };

    if (list.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: context.dimensions.edgeInsetsScreenHorizontal,
        child: Text(_label(context.l10n)),
      ),
    );
  }

  String _label(AppLocalizations l10n) {
    return switch (activityTimeOfDay) {
      ActivityTimeOfDay.daytime => l10n.daytime,
      ActivityTimeOfDay.evening => l10n.evening,
    };
  }
}
