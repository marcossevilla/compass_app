import 'package:compass_app/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('AppCheckbox', () {
    testWidgets('renders AppCheckbox with value false', (tester) async {
      await tester.pumpApp(
        AppCheckbox(
          value: false,
          onChanged: (_) {},
        ),
      );

      await expectLater(
        find.byType(AppCheckbox),
        matchesGoldenFile('goldens/app_checkbox_unchecked.png'),
      );
    });

    testWidgets('renders AppCheckbox with value true', (tester) async {
      await tester.pumpApp(
        AppCheckbox(
          value: true,
          onChanged: (_) {},
        ),
      );

      await expectLater(
        find.byType(AppCheckbox),
        matchesGoldenFile('goldens/app_checkbox_checked.png'),
      );
    });
  });
}
