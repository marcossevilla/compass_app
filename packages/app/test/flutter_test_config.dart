import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  const isRunningInCi = bool.fromEnvironment('CI');

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
      ciGoldensConfig: CiGoldensConfig(theme: theme),
      platformGoldensConfig: PlatformGoldensConfig(
        theme: theme,
        // This might not be redundant.
        // ignore: avoid_redundant_argument_values
        enabled: !isRunningInCi,
      ),
    ),
    run: testMain,
  );
}
