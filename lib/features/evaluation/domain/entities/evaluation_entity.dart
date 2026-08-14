class EvaluationEntity {
  final String? id; // Nullable porque cuando la creamos todavía no tiene ID
  final String jugadorId;
  final String categoriaId; // Nueva: ID de la categoría
  final String evaluadorId;
  final DateTime fechaEvaluacion;

  // Métricas (int4) - Ahora representan el DELTA (+/- cambios)
  final int velocidad;
  final int resistencia;
  final int tecnica;
  final int tactica;
  final int actitud;
  final int asistencia;

  final String? comentariosDt; // Puede estar vacío
  final DateTime? createdAt;

  EvaluationEntity({
    this.id,
    required this.jugadorId,
    required this.categoriaId,
    required this.evaluadorId,
    required this.fechaEvaluacion,
    required this.velocidad,
    required this.resistencia,
    required this.tecnica,
    required this.tactica,
    required this.actitud,
    required this.asistencia,
    this.comentariosDt,
    this.createdAt,
  });
}
