import '../../domain/entities/player_stats_entity.dart';

class PlayerStatsModel extends PlayerStatsEntity {
  PlayerStatsModel({
    super.id,
    required super.jugadorId,
    required super.categoriaId,
    super.categoriaNombre,
    required super.velocidad,
    required super.resistencia,
    required super.tecnica,
    required super.tactica,
    required super.actitud,
    required super.asistencia,
    super.updatedAt,
  });

  factory PlayerStatsModel.fromJson(Map<String, dynamic> json) {
    // Parseo del join con categorías: puede venir como objeto o null
    String categoriaNombre = 'Sin categoría';
    if (json['categorias'] != null && json['categorias'] is Map) {
      categoriaNombre =
          (json['categorias'] as Map<String, dynamic>)['nombre'] as String? ??
          'Sin categoría';
    }

    return PlayerStatsModel(
      id: json['id'] as String?,
      jugadorId: json['jugador_id'] as String,
      categoriaId: json['categoria_id'] as String,
      categoriaNombre: categoriaNombre,
      velocidad: json['velocidad'] as int,
      resistencia: json['resistencia'] as int,
      tecnica: json['tecnica'] as int,
      tactica: json['tactica'] as int,
      actitud: json['actitud'] as int,
      asistencia: json['asistencia'] as int,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'jugador_id': jugadorId,
      'categoria_id': categoriaId,
      'velocidad': velocidad,
      'resistencia': resistencia,
      'tecnica': tecnica,
      'tactica': tactica,
      'actitud': actitud,
      'asistencia': asistencia,
    };
  }

  // Factory para crear stats por defecto
  factory PlayerStatsModel.defaultStats({
    required String jugadorId,
    required String categoriaId,
    String categoriaNombre = 'Sin categoría',
  }) {
    return PlayerStatsModel(
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
