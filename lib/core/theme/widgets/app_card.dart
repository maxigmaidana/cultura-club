import 'package:flutter/material.dart';

import 'app_elevation.dart';

enum AppCardLevel { level1, level2 }

/// Generic container card (activity cards, content cards) with the design
/// system's tonal border + soft shadow, no hardcoded colors.
class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardLevel level;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.level = AppCardLevel.level1,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = borderRadius ?? BorderRadius.circular(16);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: radius,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: level == AppCardLevel.level1
            ? AppElevation.level1
            : AppElevation.level2,
      ),
      child: child,
    );
  }
}
