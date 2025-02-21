import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  const isRunningInCi = bool.fromEnvironment('GITHUB_ACTIONS');

  final theme = AppTheme.standard;

  final goldenTestTheme = GoldenTestTheme(
    borderColor: theme.colorScheme.primaryContainer,
    nameTextStyle: theme.textTheme.bodyMedium ?? const TextStyle(),
    backgroundColor: theme.colorScheme.onSecondary,
  );

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig.current().copyWith(
      theme: theme,
      goldenTestTheme: goldenTestTheme,
      platformGoldensConfig: const PlatformGoldensConfig(
        // This might not be redundant.
        // ignore: avoid_redundant_argument_values
        enabled: !isRunningInCi,
      ),
    ),
    run: testMain,
  );
}
