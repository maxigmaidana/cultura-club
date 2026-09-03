import 'package:flutter/widgets.dart';

/// Corner-radius scale from the design payload, values in logical pixels.
class AppRadiusTokens {
  final double sm;
  final double defaultRadius;
  final double md;
  final double lg;
  final double xl;
  final double full;

  const AppRadiusTokens({
    required this.sm,
    required this.defaultRadius,
    required this.md,
    required this.lg,
    required this.xl,
    required this.full,
  });

  BorderRadius get smRadius => BorderRadius.circular(sm);
  BorderRadius get defaultBorderRadius => BorderRadius.circular(defaultRadius);
  BorderRadius get mdRadius => BorderRadius.circular(md);
  BorderRadius get lgRadius => BorderRadius.circular(lg);
  BorderRadius get xlRadius => BorderRadius.circular(xl);
  BorderRadius get fullRadius => BorderRadius.circular(full);
}
