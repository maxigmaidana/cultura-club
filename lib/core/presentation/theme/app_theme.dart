import 'package:flutter/material.dart';

/// Tema centralizado de la app
/// Centraliza colores, spacing, border radius y decoraciones reutilizables
class AppTheme {
  // Colores estándar (no varían por club)
  static const Color surfaceColor = Colors.white;
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color disabledColor = Color(0xFFBDBDBD);
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color infoColor = Color(0xFF2196F3);
  static const Color warningColor = Color(0xFFFFC107);

  // Border radius estándar
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;

  // Spacing estándar
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Button dimensions
  static const double buttonHeight = 52.0;
  static const double buttonHeightSmall = 40.0;

  // Input field dimensions
  static const double inputBorderWidth = 1.0;
  static const double inputBorderWidthFocused = 2.0;

  /// Construye InputDecoration reutilizable para TextField
  static InputDecoration buildInputDecoration({
    required String label,
    required Color primaryColor,
    IconData? prefixIcon,
    String? hintText,
    bool obscureText = false,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      labelStyle: TextStyle(color: textSecondaryColor),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: primaryColor)
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(
          color: borderColor,
          width: inputBorderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: BorderSide(
          color: primaryColor,
          width: inputBorderWidthFocused,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingMedium,
        vertical: spacingMedium,
      ),
    );
  }
}
