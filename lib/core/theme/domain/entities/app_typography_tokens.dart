import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Raw values for a single typography scale step, as delivered by the design payload.
class AppTextStyleToken {
  final String fontFamily;
  final double fontSize;
  final FontWeight fontWeight;
  final double lineHeight;
  final double letterSpacing;

  const AppTextStyleToken({
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    required this.lineHeight,
    this.letterSpacing = 0,
  });

  TextStyle toTextStyle() {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: lineHeight / fontSize,
      letterSpacing: letterSpacing,
    );
  }

  /// Returns a scaled copy, used to derive [TextTheme] slots absent from the payload.
  AppTextStyleToken scaled({double sizeFactor = 1, FontWeight? weightOverride}) {
    return AppTextStyleToken(
      fontFamily: fontFamily,
      fontSize: fontSize * sizeFactor,
      fontWeight: weightOverride ?? fontWeight,
      lineHeight: lineHeight * sizeFactor,
      letterSpacing: letterSpacing,
    );
  }
}

/// Typography tokens from the design payload, mapped to Flutter's [TextTheme] slots.
class AppTypographyTokens {
  final AppTextStyleToken display;
  final AppTextStyleToken headlineLg;
  final AppTextStyleToken headlineLgMobile;
  final AppTextStyleToken headlineMd;
  final AppTextStyleToken bodyLg;
  final AppTextStyleToken bodyMd;
  final AppTextStyleToken labelSm;

  const AppTypographyTokens({
    required this.display,
    required this.headlineLg,
    required this.headlineLgMobile,
    required this.headlineMd,
    required this.bodyLg,
    required this.bodyMd,
    required this.labelSm,
  });

  /// Builds the full 15-slot [TextTheme]. Slots not defined by the payload are
  /// derived from the nearest defined token to keep a consistent scale.
  TextTheme toTextTheme({required bool isCompact}) {
    final headline = isCompact ? headlineLgMobile : headlineLg;
    return TextTheme(
      displayLarge: display.toTextStyle(),
      displayMedium: display.scaled(sizeFactor: 0.85).toTextStyle(),
      displaySmall: display.scaled(sizeFactor: 0.7).toTextStyle(),
      headlineLarge: headline.toTextStyle(),
      headlineMedium: headlineMd.toTextStyle(),
      headlineSmall: headlineMd.scaled(sizeFactor: 0.85).toTextStyle(),
      titleLarge: headlineMd.toTextStyle(),
      titleMedium: bodyLg.scaled(weightOverride: FontWeight.w600).toTextStyle(),
      titleSmall: bodyMd.scaled(weightOverride: FontWeight.w600).toTextStyle(),
      bodyLarge: bodyLg.toTextStyle(),
      bodyMedium: bodyMd.toTextStyle(),
      bodySmall: labelSm.scaled(weightOverride: FontWeight.w400).toTextStyle(),
      labelLarge: bodyMd.scaled(weightOverride: FontWeight.w600).toTextStyle(),
      labelMedium: labelSm.scaled(sizeFactor: 1.08).toTextStyle(),
      labelSmall: labelSm.toTextStyle(),
    );
  }
}
