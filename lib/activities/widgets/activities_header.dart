// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/routing/routes.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ActivitiesHeader extends StatelessWidget {
  const ActivitiesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dimensions = context.dimensions;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: dimensions.paddingScreenHorizontal,
          right: dimensions.paddingScreenHorizontal,
          top: dimensions.paddingScreenVertical,
          bottom: dimensions.paddingVertical,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppBackButton(
              // Navigate to ResultsScreen and edit search.
              onTap: () => context.go(Routes.results),
            ),
            Text(
              context.l10n.activities,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const HomeButton(),
          ],
        ),
      ),
    );
  }
}
