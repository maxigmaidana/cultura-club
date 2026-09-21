import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar un ícono + texto en una fila
/// Usado en listados de actividades, eventos, detalles, etc.
class AppInfoRow extends StatelessWidget {
  /// Ícono a mostrar a la izquierda
  final IconData icon;

  /// Texto a mostrar a la derecha del ícono
  final String text;

  /// Color del ícono (default: grey[600])
  final Color? iconColor;

  /// Tamaño del ícono (default: 16)
  final double iconSize;

  /// Color del texto (default: grey[700])
  final Color? textColor;

  /// Tamaño del texto (default: 13)
  final double fontSize;

  /// Número máximo de líneas (default: 2)
  final int maxLines;

  const AppInfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
    this.iconSize = 16.0,
    this.textColor,
    this.fontSize = 13.0,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: iconSize, color: iconColor ?? Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor ?? Colors.grey[700],
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
