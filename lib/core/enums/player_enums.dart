enum PiernaHabil {
  derecha,
  izquierda,
  ambas;

  // Método para parsear lo que viene de la base de datos
  static PiernaHabil fromString(String? value) {
    switch (value?.toUpperCase()) {
      case 'DERECHA':
        return PiernaHabil.derecha;
      case 'IZQUIERDA':
        return PiernaHabil.izquierda;
      case 'AMBAS':
        return PiernaHabil.ambas;
      default:
        return PiernaHabil.derecha; // Fallback por defecto
    }
  }
}

enum Posicion {
  po,
  dfc,
  li,
  ld,
  cai,
  cad,
  mcd,
  mc,
  mco,
  mi,
  md,
  ei,
  ed,
  sd,
  dc;

  // Método para parsear la lista que viene de Supabase
  static Posicion fromString(String value) {
    return Posicion.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => Posicion.mc, // Fallback en caso de error
    );
  }
}

/// Sector de cancha para sectorizar jugadores
/// Viene de la columna sector_cancha en la tabla jugadores_perfil
enum SectorCancha {
  arquero,
  defensa,
  medio,
  delantero;

  /// Retorna el label legible en español
  String get label => switch (this) {
    SectorCancha.arquero => 'Arqueros',
    SectorCancha.defensa => 'Defensas',
    SectorCancha.medio => 'Mediocampistas',
    SectorCancha.delantero => 'Delanteros',
  };

  /// Parsea el valor que viene de la base de datos
  static SectorCancha fromString(String? value) {
    return switch (value?.toUpperCase()) {
      'ARQUERO' => SectorCancha.arquero,
      'DEFENSA' => SectorCancha.defensa,
      'MEDIO' => SectorCancha.medio,
      'DELANTERO' => SectorCancha.delantero,
      _ => SectorCancha.medio, // Fallback por defecto
    };
  }
}
