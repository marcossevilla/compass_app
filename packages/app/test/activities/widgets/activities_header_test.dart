import 'package:compass_app/activities/activities.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/routing/routes.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group(ActivitiesHeader, () {
    late GoRouter goRouter;

    setUp(() {
      goRouter = MockGoRouter();
    });

    testWidgets('renders title, back and home buttons', (tester) async {
      await tester.pumpApp(const ActivitiesHeader());

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l10n.activities), findsOneWidget);
      expect(find.byType(AppBackButton), findsOneWidget);
      expect(find.byType(HomeButton), findsOneWidget);
    });

    testWidgets('navigates to results when back button is tapped', (
      tester,
    ) async {
      await tester.pumpApp(const ActivitiesHeader(), goRouter: goRouter);

      await tester.tap(find.byType(AppBackButton));

      verify(() => goRouter.go(Routes.results)).called(1);
    });
  });
}
