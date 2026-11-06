import 'package:compass_app/activities/activities.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

void main() {
  group(ActivityEntry, () {
    const activity = Activity(
      name: 'Glacier Trekking',
      description: 'description',
      locationName: 'location',
      duration: 1,
      timeOfDay: TimeOfDay.morning,
      familyFriendly: true,
      price: 1,
      destinationRef: 'alaska',
      ref: 'glacier-trekking',
      imageUrl: 'https://example.com/glacier.jpg',
    );

    testWidgets('renders activity name and time of day', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpApp(
          ActivityEntry(activity: activity, selected: false, onChanged: (_) {}),
        );
      });

      expect(find.text('Glacier Trekking'), findsOneWidget);
      expect(find.text('MORNING'), findsOneWidget);
    });

    testWidgets('calls onChanged when checkbox is tapped', (tester) async {
      bool? changedValue;
      await mockNetworkImages(() async {
        await tester.pumpApp(
          ActivityEntry(
            activity: activity,
            selected: true,
            onChanged: (value) => changedValue = value,
          ),
        );
      });

      await tester.tap(find.byType(AppCheckbox));
      expect(changedValue, isFalse);
    });
  });
}
