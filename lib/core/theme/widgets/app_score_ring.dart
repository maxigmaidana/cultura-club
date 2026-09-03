import 'package:flutter/material.dart';

/// Circular progress ring with a centered value, e.g. an average score out of 100.
class AppScoreRing extends StatelessWidget {
  final double value;
  final String centerLabel;
  final String? subtitle;
  final double size;

  const AppScoreRing({
    super.key,
    required this.value,
    required this.centerLabel,
    this.subtitle,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SizedBox(
          height: size,
          width: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: value.clamp(0, 1),
                  strokeWidth: 10,
                  backgroundColor: scheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(scheme.primary),
                ),
              ),
              Text(
                centerLabel,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}
