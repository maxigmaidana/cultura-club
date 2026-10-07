/// Enum para el estado de la lesión/indisponibilidad
enum InjuryStatus {
  active,
  recovering,
  closed;

  /// Retorna la etiqueta en español
  String get label => switch (this) {
    InjuryStatus.active => 'Activa',
    InjuryStatus.recovering => 'En recuperación',
    InjuryStatus.closed => 'Alta médica',
  };

  /// Parsea el valor que viene de la base de datos
  static InjuryStatus fromString(String value) {
    return switch (value.toUpperCase()) {
      'ACTIVE' => InjuryStatus.active,
      'RECOVERING' => InjuryStatus.recovering,
      'CLOSED' => InjuryStatus.closed,
      _ => InjuryStatus.active,
    };
  }
}

/// Enum para la severidad de la lesión
enum InjurySeverity {
  mild,
  moderate,
  severe;

  /// Retorna la etiqueta en español
  String get label => switch (this) {
    InjurySeverity.mild => 'Leve',
    InjurySeverity.moderate => 'Moderada',
    InjurySeverity.severe => 'Grave',
  };

  /// Parsea el valor que viene de la base de datos
  static InjurySeverity? fromString(String? value) {
    if (value == null) return null;
    return switch (value.toUpperCase()) {
      'MILD' => InjurySeverity.mild,
      'MODERATE' => InjurySeverity.moderate,
      'SEVERE' => InjurySeverity.severe,
      _ => null,
    };
  }
}

/// Enum para el lado del cuerpo afectado
enum BodySide {
  left,
  right,
  bilateral,
  notApplicable;

  /// Retorna la etiqueta en español
  String get label => switch (this) {
    BodySide.left => 'Izquierda',
    BodySide.right => 'Derecha',
    BodySide.bilateral => 'Bilateral',
    BodySide.notApplicable => 'No aplica',
  };

  /// Retorna true si es un valor que debe mostrarse en UI
  bool get isDisplayable => this != BodySide.notApplicable;

  /// Parsea el valor que viene de la base de datos
  static BodySide? fromString(String? value) {
    if (value == null) return null;
    return switch (value.toUpperCase()) {
      'LEFT' => BodySide.left,
      'RIGHT' => BodySide.right,
      'BILATERAL' => BodySide.bilateral,
      'NOT_APPLICABLE' => BodySide.notApplicable,
      _ => null,
    };
  }
}
