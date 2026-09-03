import 'package:flutter/material.dart';

import '../../domain/entities/app_color_palette.dart';
import '../../domain/entities/app_radius_tokens.dart';
import '../../domain/entities/app_spacing_tokens.dart';
import '../../domain/entities/app_theme.dart';
import '../../domain/entities/app_typography_tokens.dart';

/// Parses the design-system JSON payload (today hardcoded, tomorrow from the API)
/// into domain entities.
class AppThemeModel {
  final AppTheme entity;

  const AppThemeModel(this.entity);

  factory AppThemeModel.fromJson(Map<String, dynamic> json) {
    final colorsJson = json['colors'] as Map<String, dynamic>;
    final typographyJson = json['typography'] as Map<String, dynamic>;
    final roundedJson = json['rounded'] as Map<String, dynamic>;
    final spacingJson = json['spacing'] as Map<String, dynamic>;

    return AppThemeModel(
      AppTheme(
        name: json['name'] as String,
        colors: _colorsFromJson(colorsJson),
        typography: _typographyFromJson(typographyJson),
        radius: _radiusFromJson(roundedJson),
        spacing: _spacingFromJson(spacingJson),
      ),
    );
  }

  static AppColorPalette _colorsFromJson(Map<String, dynamic> json) {
    Color color(String key) => _colorFromHex(json[key] as String);

    return AppColorPalette(
      surface: color('surface'),
      surfaceDim: color('surface-dim'),
      surfaceBright: color('surface-bright'),
      surfaceContainerLowest: color('surface-container-lowest'),
      surfaceContainerLow: color('surface-container-low'),
      surfaceContainer: color('surface-container'),
      surfaceContainerHigh: color('surface-container-high'),
      surfaceContainerHighest: color('surface-container-highest'),
      onSurface: color('on-surface'),
      onSurfaceVariant: color('on-surface-variant'),
      inverseSurface: color('inverse-surface'),
      inverseOnSurface: color('inverse-on-surface'),
      outline: color('outline'),
      outlineVariant: color('outline-variant'),
      surfaceTint: color('surface-tint'),
      primary: color('primary'),
      onPrimary: color('on-primary'),
      primaryContainer: color('primary-container'),
      onPrimaryContainer: color('on-primary-container'),
      inversePrimary: color('inverse-primary'),
      secondary: color('secondary'),
      onSecondary: color('on-secondary'),
      secondaryContainer: color('secondary-container'),
      onSecondaryContainer: color('on-secondary-container'),
      tertiary: color('tertiary'),
      onTertiary: color('on-tertiary'),
      tertiaryContainer: color('tertiary-container'),
      onTertiaryContainer: color('on-tertiary-container'),
      error: color('error'),
      onError: color('on-error'),
      errorContainer: color('error-container'),
      onErrorContainer: color('on-error-container'),
      primaryFixed: color('primary-fixed'),
      primaryFixedDim: color('primary-fixed-dim'),
      onPrimaryFixed: color('on-primary-fixed'),
      onPrimaryFixedVariant: color('on-primary-fixed-variant'),
      secondaryFixed: color('secondary-fixed'),
      secondaryFixedDim: color('secondary-fixed-dim'),
      onSecondaryFixed: color('on-secondary-fixed'),
      onSecondaryFixedVariant: color('on-secondary-fixed-variant'),
      tertiaryFixed: color('tertiary-fixed'),
      tertiaryFixedDim: color('tertiary-fixed-dim'),
      onTertiaryFixed: color('on-tertiary-fixed'),
      onTertiaryFixedVariant: color('on-tertiary-fixed-variant'),
      background: color('background'),
      onBackground: color('on-background'),
      surfaceVariant: color('surface-variant'),
    );
  }

  static AppTypographyTokens _typographyFromJson(Map<String, dynamic> json) {
    AppTextStyleToken style(String key) =>
        _textStyleTokenFromJson(json[key] as Map<String, dynamic>);

    return AppTypographyTokens(
      display: style('display'),
      headlineLg: style('headline-lg'),
      headlineLgMobile: style('headline-lg-mobile'),
      headlineMd: style('headline-md'),
      bodyLg: style('body-lg'),
      bodyMd: style('body-md'),
      labelSm: style('label-sm'),
    );
  }

  static AppTextStyleToken _textStyleTokenFromJson(Map<String, dynamic> json) {
    final fontSize = _px(json['fontSize'] as String);
    return AppTextStyleToken(
      fontFamily: json['fontFamily'] as String,
      fontSize: fontSize,
      fontWeight: _fontWeightFromString(json['fontWeight'] as String),
      lineHeight: _px(json['lineHeight'] as String),
      letterSpacing: json['letterSpacing'] != null
          ? _em(json['letterSpacing'] as String, fontSize)
          : 0,
    );
  }

  static AppRadiusTokens _radiusFromJson(Map<String, dynamic> json) {
    return AppRadiusTokens(
      sm: _remOrPx(json['sm'] as String),
      defaultRadius: _remOrPx(json['DEFAULT'] as String),
      md: _remOrPx(json['md'] as String),
      lg: _remOrPx(json['lg'] as String),
      xl: _remOrPx(json['xl'] as String),
      full: _remOrPx(json['full'] as String),
    );
  }

  static AppSpacingTokens _spacingFromJson(Map<String, dynamic> json) {
    return AppSpacingTokens(
      containerMargin: _remOrPx(json['container-margin'] as String),
      stackGap: _remOrPx(json['stack-gap'] as String),
      sectionGap: _remOrPx(json['section-gap'] as String),
      gutter: _remOrPx(json['gutter'] as String),
    );
  }

  static Color _colorFromHex(String hex) {
    final normalized = hex.replaceFirst('#', '');
    return Color(int.parse('FF$normalized', radix: 16));
  }

  static FontWeight _fontWeightFromString(String value) {
    switch (value) {
      case '100':
        return FontWeight.w100;
      case '200':
        return FontWeight.w200;
      case '300':
        return FontWeight.w300;
      case '400':
        return FontWeight.w400;
      case '500':
        return FontWeight.w500;
      case '600':
        return FontWeight.w600;
      case '700':
        return FontWeight.w700;
      case '800':
        return FontWeight.w800;
      case '900':
        return FontWeight.w900;
      default:
        return FontWeight.w400;
    }
  }

  /// Parses a `'Npx'` literal into logical pixels.
  static double _px(String value) {
    return double.parse(value.replaceAll('px', ''));
  }

  /// Parses a `'Nem'` literal into logical pixels, relative to [fontSize].
  static double _em(String value, double fontSize) {
    return double.parse(value.replaceAll('em', '')) * fontSize;
  }

  /// Parses a `'Nrem'` or `'Npx'` literal into logical pixels (1rem = 16px).
  static double _remOrPx(String value) {
    if (value.endsWith('rem')) {
      return double.parse(value.replaceAll('rem', '')) * 16;
    }
    return double.parse(value.replaceAll('px', ''));
  }
}
