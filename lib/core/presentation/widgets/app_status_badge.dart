import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar un badge/etiqueta de estado
/// Usado en actividades, evaluaciones, gamificación, etc.
class AppStatusBadge extends StatelessWidget {
  /// Texto del badge
  final String label;

  /// Color del badge (color del borde y texto)
  final Color color;

  /// Padding interno (default: horizontal 10, vertical 6)
  final EdgeInsets? padding;

  /// Border radius (default: 6)
  final double borderRadius;

  /// Tamaño de fuente (default: 11)
  final double fontSize;

  const AppStatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.padding,
    this.borderRadius = 6.0,
    this.fontSize = 11.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
