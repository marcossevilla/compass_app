// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TagChip extends StatelessWidget {
  const TagChip({
    required this.tag,
    this.fontSize = 10,
    this.height = 20,
    this.chipColor,
    this.onChipColor,
    super.key,
  });

  final String tag;
  final double fontSize;
  final double height;
  final Color? chipColor;
  final Color? onChipColor;

  @override
  Widget build(BuildContext context) {
    final tagChipTheme = Theme.of(context).extension<TagChipTheme>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: chipColor ?? tagChipTheme?.chipColor ?? Colors.transparent,
          ),
          child: SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    iconTag,
                    color: onChipColor ??
                        tagChipTheme?.onChipColor ??
                        Colors.white,
                    size: fontSize,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    tag,
                    textAlign: TextAlign.center,
                    style: _textStyle(tagChipTheme),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData? get iconTag {
    return switch (tag) {
      'Adventure sports' => Icons.kayaking_outlined,
      'Beach' => Icons.beach_access_outlined,
      'City' => Icons.location_city_outlined,
      'Cultural experiences' => Icons.museum_outlined,
      'Foodie' || 'Food tours' => Icons.restaurant,
      'Hiking' => Icons.hiking,
      'Historic' => Icons.menu_book_outlined,
      'Island' || 'Coastal' || 'Lake' || 'River' => Icons.water,
      'Luxury' => Icons.attach_money_outlined,
      'Mountain' || 'Wildlife watching' => Icons.landscape_outlined,
      'Nightlife' => Icons.local_bar_outlined,
      'Off-the-beaten-path' => Icons.do_not_step_outlined,
      'Romantic' => Icons.favorite_border_outlined,
      'Rural' => Icons.agriculture_outlined,
      'Secluded' => Icons.church_outlined,
      'Sightseeing' => Icons.attractions_outlined,
      'Skiing' => Icons.downhill_skiing_outlined,
      'Wine tasting' => Icons.wine_bar_outlined,
      'Winter destination' => Icons.ac_unit,
      _ => Icons.label_outlined,
    };
  }

  // Note: original Figma file uses Google Sans
  // which is not available on GoogleFonts.
  TextStyle _textStyle(TagChipTheme? tagChipTheme) {
    return GoogleFonts.openSans(
      textStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: fontSize,
        color: onChipColor ?? tagChipTheme?.onChipColor ?? Colors.white,
        textBaseline: TextBaseline.alphabetic,
      ),
    );
  }
}

class TagChipTheme extends ThemeExtension<TagChipTheme> {
  const TagChipTheme({
    required this.chipColor,
    required this.onChipColor,
  });

  final Color chipColor;
  final Color onChipColor;

  @override
  ThemeExtension<TagChipTheme> copyWith({
    Color? chipColor,
    Color? onChipColor,
  }) {
    return TagChipTheme(
      chipColor: chipColor ?? this.chipColor,
      onChipColor: onChipColor ?? this.onChipColor,
    );
  }

  @override
  ThemeExtension<TagChipTheme> lerp(
    covariant ThemeExtension<TagChipTheme> other,
    double t,
  ) {
    if (other is! TagChipTheme) return this;

    return TagChipTheme(
      chipColor: Color.lerp(chipColor, other.chipColor, t) ?? chipColor,
      onChipColor: Color.lerp(onChipColor, other.onChipColor, t) ?? onChipColor,
    );
  }
}
