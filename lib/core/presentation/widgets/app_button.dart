import 'package:cultura_club/core/presentation/theme/app_theme.dart';
import 'package:cultura_club/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tipos de botón soportados
enum AppButtonType { primary, secondary }

/// Widget de botón reutilizable y tipado
/// Lee el color primario del provider centralizado (no requiere pasarlo)
class AppButton extends ConsumerWidget {
  final VoidCallback? onPressed;
  final String label;
  final AppButtonType type;
  final bool isLoading;
  final bool disabled;
  final double? customHeight;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.disabled = false,
    this.customHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = ref.watch(primaryColorProvider);
    final height = customHeight ?? AppTheme.buttonHeight;
    final isClickable = !isLoading && !disabled && onPressed != null;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(isClickable, primaryColor),
          foregroundColor: _getForegroundColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          ),
          disabledBackgroundColor: AppTheme.disabledColor,
          elevation: 0,
        ),
        onPressed: isClickable ? onPressed : null,
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getForegroundColor(),
                  ),
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  /// Retorna el color de fondo según el tipo y estado
  Color _getBackgroundColor(bool isClickable, Color primaryColor) {
    if (!isClickable) {
      return AppTheme.disabledColor;
    }

    return switch (type) {
      AppButtonType.primary => primaryColor,
      AppButtonType.secondary => Colors.grey[200] ?? Colors.grey,
    };
  }

  /// Retorna el color del texto según el tipo
  Color _getForegroundColor() {
    return switch (type) {
      AppButtonType.primary => Colors.white,
      AppButtonType.secondary => Colors.grey[800] ?? Colors.black,
    };
  }
}
