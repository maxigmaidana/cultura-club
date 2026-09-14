import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

// Leemos la variable inyectada desde el launch.json
const String _primaryColorHex = String.fromEnvironment(
  'PRIMARY_COLOR',
  defaultValue: '0xFFE2001A',
);

/// Provider que centraliza el color primario del club (white-label compatible)
///
/// Lee desde env var `PRIMARY_COLOR` en launch.json.
/// Un único punto de verdad para el color de la marca.
@riverpod
Color primaryColor(Ref ref) {
  return Color(int.parse(_primaryColorHex));
}
