class CoachCommitmentEntity {
  final String activityId;
  final String categoryId;
  final String categoryName;
  final String tipo;
  final String titulo;
  final DateTime fechaHora;
  final String? lugar;
  final String estado;
  final int citedPlayersCount;
  final int unavailablePlayersCount;
  final bool requiresAttention;
  final DateTime? acknowledgedAt;

  const CoachCommitmentEntity({
    required this.activityId,
    required this.categoryId,
    required this.categoryName,
    required this.tipo,
    required this.titulo,
    required this.fechaHora,
    this.lugar,
    required this.estado,
    required this.citedPlayersCount,
    required this.unavailablePlayersCount,
    required this.requiresAttention,
    this.acknowledgedAt,
  });
}
