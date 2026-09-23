import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group(ErrorIndicator, () {
    Widget buildGroup() {
      return GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'default',
            child: ErrorIndicator(
              title: 'Something went wrong',
              label: 'Try again',
              onPressed: () {},
            ),
          ),
        ],
      );
    }

    unawaited(
      goldenTest(
        'renders correctly',
        fileName: 'error_indicator',
        builder: buildGroup,
      ),
    );

    testWidgets('renders title and label', (tester) async {
      await tester.pumpApp(
        ErrorIndicator(
          title: 'Something went wrong',
          label: 'Try again',
          onPressed: () {},
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('calls onPressed when the button is tapped', (tester) async {
      var pressed = false;
      await tester.pumpApp(
        ErrorIndicator(
          title: 'Something went wrong',
          label: 'Try again',
          onPressed: () => pressed = true,
        ),
      );

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(pressed, isTrue);
    });
  });
}
