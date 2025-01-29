import 'package:flutter/material.dart';

extension AppDimensionsX on BuildContext {
  AppDimensions get dimensions => AppDimensions.of(this);
}

abstract final class AppDimensions {
  const AppDimensions();

  /// Get dimensions definition based on screen size.
  factory AppDimensions.of(BuildContext context) {
    return switch (MediaQuery.sizeOf(context).width) {
      > 600 => desktop,
      _ => mobile,
    };
  }

  static const AppDimensions mobile = _DimensMobile();
  static const AppDimensions desktop = _DimensDesktop();

  /// General horizontal padding used to separate UI items
  double get paddingHorizontal => 20;

  /// General vertical padding used to separate UI items
  double get paddingVertical => 24;

  /// Horizontal padding for screen edges
  double get paddingScreenHorizontal;

  /// Vertical padding for screen edges
  double get paddingScreenVertical;

  double get profilePictureSize;

  /// Horizontal symmetric padding for screen edges
  EdgeInsets get edgeInsetsScreenHorizontal {
    return EdgeInsets.symmetric(
      horizontal: paddingScreenHorizontal,
    );
  }

  /// Symmetric padding for screen edges
  EdgeInsets get edgeInsetsScreenSymmetric {
    return EdgeInsets.symmetric(
      horizontal: paddingScreenHorizontal,
      vertical: paddingScreenVertical,
    );
  }
}

/// Mobile dimensions.
final class _DimensMobile extends AppDimensions {
  const _DimensMobile();

  @override
  double get paddingScreenHorizontal => paddingHorizontal;

  @override
  double get paddingScreenVertical => paddingVertical;

  @override
  double get profilePictureSize => 64;
}

/// Desktop/Web dimensions.
final class _DimensDesktop extends AppDimensions {
  const _DimensDesktop();

  @override
  double get paddingScreenHorizontal => 100;

  @override
  double get paddingScreenVertical => 64;

  @override
  double get profilePictureSize => 128;
}
