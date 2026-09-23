import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(AppDimensions, () {
    Future<AppDimensions> dimensionsForWidth(
      WidgetTester tester,
      double width,
    ) async {
      late AppDimensions dimensions;
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: Size(width, 800)),
          child: Builder(
            builder: (context) {
              dimensions = context.dimensions;
              return const SizedBox();
            },
          ),
        ),
      );
      return dimensions;
    }

    testWidgets('resolves mobile dimensions for narrow screens', (
      tester,
    ) async {
      final dimensions = await dimensionsForWidth(tester, 400);

      expect(dimensions.paddingScreenHorizontal, 20);
      expect(dimensions.paddingScreenVertical, 24);
      expect(dimensions.profilePictureSize, 64);
      expect(
        dimensions.edgeInsetsScreenHorizontal,
        const EdgeInsets.symmetric(horizontal: 20),
      );
      expect(
        dimensions.edgeInsetsScreenSymmetric,
        const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      );
    });

    testWidgets('resolves desktop dimensions for wide screens', (tester) async {
      final dimensions = await dimensionsForWidth(tester, 800);

      expect(dimensions.paddingScreenHorizontal, 100);
      expect(dimensions.paddingScreenVertical, 64);
      expect(dimensions.profilePictureSize, 128);
      expect(
        dimensions.edgeInsetsScreenSymmetric,
        const EdgeInsets.symmetric(horizontal: 100, vertical: 64),
      );
    });

    test('exposes static mobile and desktop definitions', () {
      expect(AppDimensions.mobile.paddingHorizontal, 20);
      expect(AppDimensions.mobile.paddingVertical, 24);
      expect(AppDimensions.desktop.paddingScreenHorizontal, 100);
    });
  });
}
