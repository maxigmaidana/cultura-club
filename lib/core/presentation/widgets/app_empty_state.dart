import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar un estado vacío genérico
/// Usado cuando no hay datos que mostrar en listas, grillas, etc.
class AppEmptyState extends StatelessWidget {
  /// Ícono a mostrar en el centro
  final IconData icon;

  /// Título del estado vacío
  final String title;

  /// Subtítulo/descripción (opcional)
  final String? subtitle;

  /// Color del ícono (default: grey[400])
  final Color? iconColor;

  /// Tamaño del ícono (default: 64)
  final double iconSize;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.iconSize = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: iconColor ?? Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                subtitle!,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
