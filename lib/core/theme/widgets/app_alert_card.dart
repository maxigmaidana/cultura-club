import 'package:flutter/material.dart';

import 'app_semantic_colors.dart';

enum AppAlertStatus { info, success, warning, error, urgent }

/// Alert banner: 1px border of the status color + 5% opacity fill + leading icon.
class AppAlertCard extends StatelessWidget {
  final String? message;
  final Widget? child;
  final AppAlertStatus status;
  final String? title;
  final double iconSize;

  const AppAlertCard({
    super.key,
    this.message,
    this.child,
    this.status = AppAlertStatus.info,
    this.title,
    this.iconSize = 24,
  }) : assert(message != null || child != null, 'Provide either message or child');

  Color _colorFor(ColorScheme scheme) {
    switch (status) {
      case AppAlertStatus.info:
        return scheme.secondary;
      case AppAlertStatus.success:
        return AppSemanticColors.success;
      case AppAlertStatus.warning:
        return AppSemanticColors.warning;
      case AppAlertStatus.error:
      case AppAlertStatus.urgent:
        return scheme.primary;
    }
  }

  IconData _iconFor() {
    switch (status) {
      case AppAlertStatus.info:
        return Icons.info_outline;
      case AppAlertStatus.success:
        return Icons.check_circle_outline;
      case AppAlertStatus.warning:
        return Icons.warning_amber_rounded;
      case AppAlertStatus.error:
      case AppAlertStatus.urgent:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _colorFor(scheme);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_iconFor(), color: color, size: iconSize),
          const SizedBox(width: 10),
          Expanded(
            child:
                child ??
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(title!, style: Theme.of(context).textTheme.titleSmall),
                    Text(message!, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
          ),
        ],
      ),
    );
  }
}
