import 'package:alchemist/alchemist.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppCheckbox', () {
    Widget buildGroup() {
      return GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'unchecked',
            child: AppCheckbox(value: false, onChanged: (_) {}),
          ),
          GoldenTestScenario(
            name: 'checked',
            child: AppCheckbox(value: true, onChanged: (_) {}),
          ),
        ],
      );
    }

    goldenTest(
      'renders correctly',
      fileName: 'app_checkbox',
      builder: buildGroup,
    );

    goldenTest(
      'renders correctly when pressed',
      fileName: 'app_checkbox_pressed',
      builder: buildGroup,
      whilePerforming: press(find.byType(AppCheckbox)),
    );
  });
}
