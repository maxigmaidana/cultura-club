import 'package:flutter/material.dart';

/// Utilidad para mapear tipo de actividad a ícono correspondiente
class ActivityIconMapper {
  /// Retorna el ícono según el tipo de actividad
  static IconData getIconForActivityType(String tipo) {
    final tipoUpper = tipo.toUpperCase();

    if (tipoUpper.contains('PARTIDO')) {
      return Icons.sports_soccer;
    } else if (tipoUpper.contains('ENTRENAMIENTO')) {
      return Icons.fitness_center;
    } else if (tipoUpper.contains('EVENTO')) {
      return Icons.event;
    }

    return Icons.calendar_today;
  }
}
