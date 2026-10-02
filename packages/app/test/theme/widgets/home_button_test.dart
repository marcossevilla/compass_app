import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:compass_app/routing/routes.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group(HomeButton, () {
    late GoRouter goRouter;

    setUp(() {
      goRouter = MockGoRouter();
      when(() => goRouter.go(any())).thenAnswer((_) {});
    });

    Widget buildGroup() {
      return GoldenTestGroup(
        children: [
          GoldenTestScenario(name: 'default', child: const HomeButton()),
          GoldenTestScenario(
            name: 'blurred',
            child: const HomeButton(blur: true),
          ),
        ],
      );
    }

    unawaited(
      goldenTest(
        'renders correctly',
        fileName: 'home_button',
        builder: buildGroup,
      ),
    );

    testWidgets('renders a home icon', (tester) async {
      await tester.pumpApp(const HomeButton(), goRouter: goRouter);

      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    });

    testWidgets('navigates to home when tapped', (tester) async {
      await tester.pumpApp(const HomeButton(), goRouter: goRouter);

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      verify(() => goRouter.go(Routes.home)).called(1);
    });
  });
}
