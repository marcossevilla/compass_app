import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final isRunningInCi = Platform.environment.containsKey('GITHUB_ACTIONS');

  final theme = AppTheme.standard;

  final goldenTestTheme = GoldenTestTheme(
    borderColor: theme.colorScheme.primaryContainer,
    nameTextStyle: theme.textTheme.bodyMedium ?? const TextStyle(),
    backgroundColor: theme.colorScheme.onSecondary,
  );

  final currentConfig = AlchemistConfig.current();

  return AlchemistConfig.runWithConfig(
    config: currentConfig.copyWith(
      theme: theme,
      goldenTestTheme: goldenTestTheme,
      platformGoldensConfig: currentConfig.platformGoldensConfig.merge(
        PlatformGoldensConfig(enabled: !isRunningInCi),
      ),
    ),
    run: testMain,
  );
}
