import 'dart:ui' as ui;

import 'package:compass_app/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home button to navigate back to the '/' path.
class HomeButton extends StatelessWidget {
  const HomeButton({this.blur = false, super.key});

  final bool blur;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (blur)
            ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: const SizedBox(height: 40, width: 40),
              ),
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade100),
              borderRadius: BorderRadius.circular(8),
              color: Colors.transparent,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => context.go(Routes.home),
              child: Center(
                child: Icon(
                  size: 24,
                  Icons.home_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
