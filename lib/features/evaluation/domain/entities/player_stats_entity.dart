class PlayerStatsEntity {
  final String? id;
  final String jugadorId;
  final String categoriaId;
  final String? categoriaNombre; // Nombre de la categoría (del join) - opcional
  final int velocidad;
  final int resistencia;
  final int tecnica;
  final int tactica;
  final int actitud;
  final int asistencia;
  final DateTime? updatedAt;

  PlayerStatsEntity({
    this.id,
    required this.jugadorId,
    required this.categoriaId,
    this.categoriaNombre,
    required this.velocidad,
    required this.resistencia,
    required this.tecnica,
    required this.tactica,
    required this.actitud,
    required this.asistencia,
    this.updatedAt,
  });

  // Factory para crear un estado por defecto (todos en 50)
  factory PlayerStatsEntity.defaultStats({
    required String jugadorId,
    required String categoriaId,
    String categoriaNombre = 'Sin categoría',
  }) {
    return PlayerStatsEntity(
      jugadorId: jugadorId,
      categoriaId: categoriaId,
      categoriaNombre: categoriaNombre,
      velocidad: 50,
      resistencia: 50,
      tecnica: 50,
      tactica: 50,
      actitud: 50,
      asistencia: 50,
    );
  }
}
