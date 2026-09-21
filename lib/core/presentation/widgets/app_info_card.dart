import 'package:flutter/material.dart';

/// Color scheme para AppInfoCard
enum AppCardColorScheme { red, orange, green, blue }

/// Extensión para obtener colores del scheme
extension AppCardColorSchemeColors on AppCardColorScheme {
  /// Color de fondo de la tarjeta (tono claro)
  Color get backgroundColor => switch (this) {
    AppCardColorScheme.red => Colors.red[50]!,
    AppCardColorScheme.orange => Colors.orange[50]!,
    AppCardColorScheme.green => Colors.green[50]!,
    AppCardColorScheme.blue => Colors.blue[50]!,
  };

  /// Color del icono y título (tono oscuro)
  Color get accentColor => switch (this) {
    AppCardColorScheme.red => Colors.red[900]!,
    AppCardColorScheme.orange => Colors.orange[800]!,
    AppCardColorScheme.green => Colors.green[800]!,
    AppCardColorScheme.blue => Colors.blue[900]!,
  };

  /// Color del borde (tono medio)
  Color get borderColor => switch (this) {
    AppCardColorScheme.red => Colors.red.shade200,
    AppCardColorScheme.orange => Colors.orange.shade200,
    AppCardColorScheme.green => Colors.green.shade200,
    AppCardColorScheme.blue => Colors.blue.shade200,
  };
}

/// Widget reutilizable para tarjetas de información
/// Encapsula patrón: Icon + Title + Content en una Card estilizada
class AppInfoCard extends StatelessWidget {
  /// Ícono a mostrar a la izquierda
  final IconData icon;

  /// Título de la tarjeta (línea pequeña, negrita)
  final String title;

  /// Contenido principal (Column con detalles)
  final Widget content;

  /// Esquema de colores de la tarjeta
  final AppCardColorScheme colorScheme;

  /// Tamaño del ícono (default: 40)
  final double iconSize;

  /// Espaciado entre ícono y contenido (default: 16)
  final double iconSpacing;

  const AppInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    required this.colorScheme,
    this.iconSize = 40.0,
    this.iconSpacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorScheme.backgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.accentColor, size: iconSize),
            SizedBox(width: iconSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colorScheme.accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  content,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
