import '../../domain/entities/evaluation_entity.dart';

class EvaluationModel extends EvaluationEntity {
  EvaluationModel({
    super.id,
    required super.jugadorId,
    required super.categoriaId,
    required super.evaluadorId,
    required super.fechaEvaluacion,
    required super.velocidad,
    required super.resistencia,
    required super.tecnica,
    required super.tactica,
    required super.actitud,
    required super.asistencia,
    super.comentariosDt,
    super.createdAt,
  });

  // Para enviar a Supabase (Insert/Update)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'jugador_id': jugadorId,
      'categoria_id': categoriaId,
      'evaluador_id': evaluadorId,
      // Formateamos la fecha para que Postgres 'date' la entienda (YYYY-MM-DD)
      'fecha_evaluacion': fechaEvaluacion.toIso8601String().split('T')[0],
      'velocidad': velocidad,
      'resistencia': resistencia,
      'tecnica': tecnica,
      'tactica': tactica,
      'actitud': actitud,
      'asistencia': asistencia,
      if (comentariosDt != null) 'comentarios_dt': comentariosDt,
    };
  }
}
