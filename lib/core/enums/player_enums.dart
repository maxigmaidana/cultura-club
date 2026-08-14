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
  po, dfc, li, ld, cai, cad, mcd, mc, mco, mi, md, ei, ed, sd, dc;

  // Método para parsear la lista que viene de Supabase
  static Posicion fromString(String value) {
    return Posicion.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => Posicion.mc, // Fallback en caso de error
    );
  }
}