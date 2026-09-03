import 'package:flutter/material.dart';

import 'app_semantic_colors.dart';

enum AppButtonVariant { primary, secondary, ghost, success, danger }

/// Single button widget covering the design system's button variants.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    final Widget child;
    if (isLoading) {
      final spinnerColor = variant == AppButtonVariant.danger
          ? Theme.of(context).colorScheme.error
          : variant == AppButtonVariant.secondary
          ? Theme.of(context).colorScheme.onSurface
          : Colors.white;
      child = SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: spinnerColor),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    } else {
      child = Text(label);
    }

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(onPressed: effectiveOnPressed, child: child);
      case AppButtonVariant.secondary:
        return OutlinedButton(onPressed: effectiveOnPressed, child: child);
      case AppButtonVariant.ghost:
        return TextButton(onPressed: effectiveOnPressed, child: child);
      case AppButtonVariant.success:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppSemanticColors.success,
            foregroundColor: Colors.white,
          ),
          onPressed: effectiveOnPressed,
          child: child,
        );
      case AppButtonVariant.danger:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
            side: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          onPressed: effectiveOnPressed,
          child: child,
        );
    }
  }
}

