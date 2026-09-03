import 'package:flutter/material.dart';

/// Pill-shaped status badge: muted background, high-contrast text.
class AppStatusBadge extends StatelessWidget {
  final String label;
  final Color? color;

  const AppStatusBadge({super.key, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final badgeColor = color ?? scheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: badgeColor),
      ),
    );
  }
}
