import 'package:flutter/material.dart';

import '../domain/entities/app_theme.dart';

/// Builds Flutter [ThemeData] from the dynamic [AppTheme] design tokens.
ThemeData buildLightThemeData(AppTheme theme, {required bool isCompact}) {
  return _buildThemeData(
    theme,
    colorScheme: theme.colors.toColorScheme(),
    isCompact: isCompact,
  );
}

/// The brief only defines a light palette; the dark scheme is derived (see
/// [AppColorPalette.toDarkColorScheme]).
ThemeData buildDarkThemeData(AppTheme theme, {required bool isCompact}) {
  return _buildThemeData(
    theme,
    colorScheme: theme.colors.toDarkColorScheme(),
    isCompact: isCompact,
  );
}

ThemeData _buildThemeData(
  AppTheme theme, {
  required ColorScheme colorScheme,
  required bool isCompact,
}) {
  final radius = theme.radius;
  final textTheme = theme.typography.toTextTheme(isCompact: isCompact);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      color: colorScheme.surfaceContainerLowest,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: radius.xlRadius),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: radius.lgRadius),
        textStyle: textTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.onSurface,
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: radius.lgRadius),
        textStyle: textTheme.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: radius.lgRadius),
        textStyle: textTheme.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerLowest,
      border: OutlineInputBorder(
        borderRadius: radius.lgRadius,
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius.lgRadius,
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius.lgRadius,
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surfaceContainerLowest,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
    ),
  );
}
