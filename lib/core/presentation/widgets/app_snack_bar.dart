import 'package:cultura_club/core/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Tipos de SnackBar con semántica de uso
enum AppSnackBarType { success, error, info, warning }

/// Utility para mostrar SnackBar tipado y consistente
class AppSnackBar {
  AppSnackBar._(); // Constructor privado

  /// Muestra un SnackBar tipado
  ///
  /// Ejemplos:
  /// ```dart
  /// AppSnackBar.show(context, AppSnackBarType.success, 'Éxito');
  /// AppSnackBar.show(context, AppSnackBarType.error, 'Error al conectar');
  /// ```
  static void show(
    BuildContext context,
    AppSnackBarType type,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: _getColorForType(type),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(AppTheme.spacingMedium),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Retorna el color según el tipo de SnackBar
  static Color _getColorForType(AppSnackBarType type) {
    return switch (type) {
      AppSnackBarType.success => AppTheme.successColor,
      AppSnackBarType.error => AppTheme.errorColor,
      AppSnackBarType.info => AppTheme.infoColor,
      AppSnackBarType.warning => AppTheme.warningColor,
    };
  }
}
