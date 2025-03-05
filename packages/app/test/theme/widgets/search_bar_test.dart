import 'package:alchemist/alchemist.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';

import '../../helpers/helpers.dart';

void main() {
  group('AppSearchBar', () {
    late GoRouter goRouter;
    late ItineraryConfig config;

    setUp(() {
      goRouter = MockGoRouter();
      config = ItineraryConfig(
        continent: 'continent',
        destination: 'destination',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 1)),
        guests: 2,
      );
    });

    Widget buildGroup() {
      return GoldenTestGroup(
        children: [
          GoldenTestScenario(name: 'default', child: const AppSearchBar()),
          GoldenTestScenario(
            name: 'with config',
            child: AppSearchBar(config: config),
          ),
          GoldenTestScenario(
            name: 'tappable',
            child: AppSearchBar(onTap: () {}),
          ),
          GoldenTestScenario(
            name: 'tappable with config',
            child: AppSearchBar(onTap: () {}, config: config),
          ),
        ],
      );
    }

    goldenTest(
      'renders correctly',
      fileName: 'search_bar',
      pumpWidget: (tester, widget) => tester.pumpApp(widget),
      builder: buildGroup,
    );

    goldenTest(
      'renders correctly when pressed',
      fileName: 'search_bar_pressed',
      pumpWidget: (tester, widget) async {
        await tester.pumpApp(widget, goRouter: goRouter);
      },
      whilePerforming: press(find.byType(InkWell)),
      builder: buildGroup,
    );
  });
}
