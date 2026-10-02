import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group(TagChip, () {
    Widget buildGroup() {
      return GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 200),
        children: [
          GoldenTestScenario(name: 'beach', child: const TagChip('Beach')),
          GoldenTestScenario(name: 'unknown', child: const TagChip('Unknown')),
          GoldenTestScenario(
            name: 'custom colors',
            child: const TagChip(
              'City',
              chipColor: Colors.black,
              onChipColor: Colors.amber,
            ),
          ),
        ],
      );
    }

    unawaited(
      goldenTest(
        'renders correctly',
        fileName: 'tag_chip',
        builder: buildGroup,
      ),
    );

    testWidgets('renders the tag label', (tester) async {
      await tester.pumpApp(const TagChip('Beach'));

      expect(find.text('Beach'), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('uses custom chip and on-chip colors when provided', (
      tester,
    ) async {
      await tester.pumpApp(
        const TagChip('City', chipColor: Colors.black, onChipColor: Colors.red),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, Colors.red);
    });

    testWidgets('uses colors from the TagChipTheme extension', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: const [
              TagChipTheme(chipColor: Colors.green, onChipColor: Colors.orange),
            ],
          ),
          home: const Scaffold(body: TagChip('Beach')),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, Colors.orange);
    });

    group('iconTag', () {
      const tags = <String, IconData>{
        'Adventure sports': Icons.kayaking_outlined,
        'Beach': Icons.beach_access_outlined,
        'City': Icons.location_city_outlined,
        'Cultural experiences': Icons.museum_outlined,
        'Foodie': Icons.restaurant,
        'Food tours': Icons.restaurant,
        'Hiking': Icons.hiking,
        'Historic': Icons.menu_book_outlined,
        'Island': Icons.water,
        'Coastal': Icons.water,
        'Lake': Icons.water,
        'River': Icons.water,
        'Luxury': Icons.attach_money_outlined,
        'Mountain': Icons.landscape_outlined,
        'Wildlife watching': Icons.landscape_outlined,
        'Nightlife': Icons.local_bar_outlined,
        'Off-the-beaten-path': Icons.do_not_step_outlined,
        'Romantic': Icons.favorite_border_outlined,
        'Rural': Icons.agriculture_outlined,
        'Secluded': Icons.church_outlined,
        'Sightseeing': Icons.attractions_outlined,
        'Skiing': Icons.downhill_skiing_outlined,
        'Wine tasting': Icons.wine_bar_outlined,
        'Winter destination': Icons.ac_unit,
        'Unknown tag': Icons.label_outlined,
      };

      tags.forEach((tag, expectedIcon) {
        testWidgets('maps "$tag" to the correct icon', (tester) async {
          await tester.pumpApp(TagChip(tag));

          expect(find.byIcon(expectedIcon), findsOneWidget);
        });
      });
    });
  });
}
