import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

export 'app_dimensions.dart';
export 'widgets/widgets.dart';

extension ThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);

  TagChipTheme? get tagChipTheme => theme.extension<TagChipTheme>();
}

class AppTheme {
  static ColorScheme colorScheme = ColorScheme.fromSwatch(
    accentColor: Colors.indigoAccent,
  );

  static ThemeData standard = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.inversePrimary,
    ),
    useMaterial3: true,
  );
}

class TagChipTheme extends ThemeExtension<TagChipTheme> {
  const TagChipTheme({
    required this.chipColor,
    required this.onChipColor,
  });

  final Color chipColor;
  final Color onChipColor;

  // Note: original Figma file uses Google Sans
  // which is not available on GoogleFonts.
  TextStyle get textStyle {
    return GoogleFonts.openSans(
      textStyle: TextStyle(
        color: onChipColor,
        fontWeight: FontWeight.w500,
        textBaseline: TextBaseline.alphabetic,
      ),
    );
  }

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
