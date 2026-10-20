import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/activities/activities.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

class MockActivitiesCubit extends MockCubit<ActivitiesState>
    implements ActivitiesCubit;

void main() {
  group(ActivitiesTitle, () {
    const daytime = Activity(
      name: 'Day',
      description: 'description',
      locationName: 'location',
      duration: 1,
      timeOfDay: TimeOfDay.morning,
      familyFriendly: true,
      price: 1,
      destinationRef: 'alaska',
      ref: 'day',
      imageUrl: 'https://example.com/day.jpg',
    );
    const evening = Activity(
      name: 'Evening',
      description: 'description',
      locationName: 'location',
      duration: 1,
      timeOfDay: TimeOfDay.evening,
      familyFriendly: true,
      price: 1,
      destinationRef: 'alaska',
      ref: 'evening',
      imageUrl: 'https://example.com/evening.jpg',
    );

    late ActivitiesCubit cubit;
    late AppLocalizations l10n;

    setUp(() async {
      cubit = MockActivitiesCubit();
      l10n = await AppLocalizations.delegate.load(const Locale('en'));
    });

    Widget buildSubject(ActivityTimeOfDay activityTimeOfDay) {
      return BlocProvider.value(
        value: cubit,
        child: CustomScrollView(
          slivers: [ActivitiesTitle(activityTimeOfDay: activityTimeOfDay)],
        ),
      );
    }

    testWidgets('renders nothing when list is empty', (tester) async {
      when(() => cubit.state).thenReturn(const ActivitiesState());

      await tester.pumpApp(buildSubject(ActivityTimeOfDay.daytime));

      expect(find.text(l10n.daytime), findsNothing);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('renders daytime label', (tester) async {
      when(() => cubit.state)
          .thenReturn(const ActivitiesState(daytimeActivities: [daytime]));

      await tester.pumpApp(buildSubject(ActivityTimeOfDay.daytime));

      expect(find.text(l10n.daytime), findsOneWidget);
    });

    testWidgets('renders evening label', (tester) async {
      when(() => cubit.state)
          .thenReturn(const ActivitiesState(eveningActivities: [evening]));

      await tester.pumpApp(buildSubject(ActivityTimeOfDay.evening));

      expect(find.text(l10n.evening), findsOneWidget);
    });
  });
}
