import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../helpers/helpers.dart';

void main() {
  group(BackButton, () {
    late GoRouter goRouter;

    setUp(() {
      goRouter = MockGoRouter();
    });

    Widget buildGroup() {
      return GoldenTestGroup(
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

    unawaited(
      goldenTest(
        'renders correctly',
        fileName: 'back_button',
        builder: buildGroup,
      ),
    );

    unawaited(
      goldenTest(
        'renders correctly when pressed',
        fileName: 'back_button_pressed',
        pumpWidget: (tester, widget) async {
          await tester.pumpApp(widget, goRouter: goRouter);
        },
        whilePerforming: longPress(find.byType(AppBackButton)),
        builder: buildGroup,
      ),
    );
  });
}
