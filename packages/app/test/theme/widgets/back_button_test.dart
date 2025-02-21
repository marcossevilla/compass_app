import 'package:alchemist/alchemist.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../helpers/helpers.dart';

void main() {
  group('BackButton', () {
    late GoRouter goRouter;

    const constraints = BoxConstraints(
      maxWidth: 300,
      minWidth: 150,
      maxHeight: 200,
      minHeight: 100,
    );

    setUp(() {
      goRouter = MockGoRouter();
    });

    Widget buildGroup() {
      return GoldenTestGroup(
        columns: 3,
        columnWidthBuilder: (_) => const FlexColumnWidth(),
        children: [
          GoldenTestScenario(name: 'default', child: const AppBackButton()),
          GoldenTestScenario(
            name: 'blurred',
            child: const AppBackButton(blur: true),
          ),
          GoldenTestScenario(
            name: 'tappable',
            child: AppBackButton(onTap: () {}),
          ),
          GoldenTestScenario(
            name: 'tappable blurred',
            child: AppBackButton(blur: true, onTap: () {}),
          ),
        ],
      );
    }

    goldenTest(
      'renders correctly',
      fileName: 'back_button',
      constraints: constraints,
      builder: buildGroup,
    );

    goldenTest(
      'renders correctly when pressed',
      fileName: 'back_button_pressed',
      constraints: constraints,
      pumpWidget:
          (tester, widget) => tester.pumpApp(widget, goRouter: goRouter),
      whilePerforming: longPress(find.byType(AppBackButton)),
      builder: buildGroup,
    );
  });
}
