import 'package:bloc_test/bloc_test.dart';
import 'package:compass_app/activities/activities.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

class MockActivitiesCubit extends MockCubit<ActivitiesState>
    implements ActivitiesCubit;

Activity _activity(String ref, TimeOfDay timeOfDay) {
  return Activity(
    name: ref,
    description: 'description',
    locationName: 'location',
    duration: 1,
    timeOfDay: timeOfDay,
    familyFriendly: true,
    price: 1,
    destinationRef: 'alaska',
    ref: ref,
    imageUrl: 'https://example.com/$ref.jpg',
  );
}

void main() {
  group(ActivitiesList, () {
    final morning = _activity('morning', TimeOfDay.morning);
    final afternoon = _activity('afternoon', TimeOfDay.afternoon);
    final evening = _activity('evening', TimeOfDay.evening);

    late ActivitiesCubit cubit;

    setUp(() {
      cubit = MockActivitiesCubit();
      when(() => cubit.state).thenReturn(
        ActivitiesState(
          daytimeActivities: [morning, afternoon],
          eveningActivities: [evening],
          selectedActivities: const {'afternoon'},
        ),
      );
    });

    Future<void> pumpSubject(
      WidgetTester tester,
      ActivityTimeOfDay activityTimeOfDay,
    ) async {
      await mockNetworkImages(() async {
        await tester.pumpApp(
          BlocProvider.value(
            value: cubit,
            child: CustomScrollView(
              slivers: [ActivitiesList(activityTimeOfDay: activityTimeOfDay)],
            ),
          ),
        );
      });
    }

    testWidgets('renders daytime activities', (tester) async {
      await pumpSubject(tester, ActivityTimeOfDay.daytime);

      expect(find.byType(ActivityEntry), findsNWidgets(2));
      expect(find.byKey(const ValueKey('morning')), findsOneWidget);
      expect(find.byKey(const ValueKey('afternoon')), findsOneWidget);
    });

    testWidgets('renders evening activities', (tester) async {
      await pumpSubject(tester, ActivityTimeOfDay.evening);

      expect(find.byType(ActivityEntry), findsOneWidget);
      expect(find.byKey(const ValueKey('evening')), findsOneWidget);
    });

    testWidgets('adds activity when unselected checkbox is tapped', (
      tester,
    ) async {
      await pumpSubject(tester, ActivityTimeOfDay.daytime);

      await tester.tap(find.byKey(const ValueKey('morning-checkbox')));

      verify(() => cubit.addActivity('morning')).called(1);
    });

    testWidgets('removes activity when selected checkbox is tapped', (
      tester,
    ) async {
      await pumpSubject(tester, ActivityTimeOfDay.daytime);

      await tester.tap(find.byKey(const ValueKey('afternoon-checkbox')));

      verify(() => cubit.removeActivity('afternoon')).called(1);
    });
  });
}
