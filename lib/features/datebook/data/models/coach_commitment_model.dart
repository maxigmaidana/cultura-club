import 'package:cultura_club/features/datebook/domain/entities/coach_commitment_entity.dart';

class CoachCommitmentModel extends CoachCommitmentEntity {
  const CoachCommitmentModel({
    required super.activityId,
    required super.categoryId,
    required super.categoryName,
    required super.tipo,
    required super.titulo,
    required super.fechaHora,
    super.lugar,
    required super.estado,
    required super.citedPlayersCount,
    required super.unavailablePlayersCount,
    required super.requiresAttention,
    super.acknowledgedAt,
  });

  factory CoachCommitmentModel.fromJson(Map<String, dynamic> json) {
    return CoachCommitmentModel(
      activityId: json['activity_id'] as String? ?? '',
      categoryId: json['category_id'] as String? ?? '',
      categoryName: json['category_name'] as String? ?? '',
      tipo: json['tipo'] as String? ?? '',
      titulo: json['titulo'] as String? ?? '',
      fechaHora: DateTime.parse(json['fecha_hora'] as String),
      lugar: json['lugar'] as String?,
      estado: json['estado'] as String? ?? '',
      citedPlayersCount: (json['cited_players_count'] as num?)?.toInt() ?? 0,
      unavailablePlayersCount:
          (json['unavailable_players_count'] as num?)?.toInt() ?? 0,
      requiresAttention: json['requires_attention'] as bool? ?? false,
      acknowledgedAt: json['acknowledged_at'] != null
          ? DateTime.parse(json['acknowledged_at'] as String)
          : null,
    );
  }
}
