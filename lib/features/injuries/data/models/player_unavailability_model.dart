import '../../domain/entities/player_unavailability_entity.dart';

class PlayerUnavailabilityModel extends PlayerUnavailabilityEntity {
  const PlayerUnavailabilityModel({
    required super.id,
    required super.playerId,
    required super.title,
    super.description,
    required super.status,
    super.bodyArea,
    super.bodySide,
    super.severity,
    required super.startDate,
    super.estimatedReturnDate,
    required super.canTrain,
    required super.canPlay,
    super.playerNotes,
    super.closedAt,
    required super.createdAt,
  });

  factory PlayerUnavailabilityModel.fromJson(Map<String, dynamic> json) {
    return PlayerUnavailabilityModel(
      id: json['id'] as String,
      playerId: json['player_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      bodyArea: json['body_area'] as String?,
      bodySide: json['body_side'] as String?,
      severity: json['severity'] as String?,
      startDate: DateTime.parse(json['start_date'] as String),
      estimatedReturnDate: json['estimated_return_date'] != null
          ? DateTime.parse(json['estimated_return_date'] as String)
          : null,
      canTrain: json['can_train'] as bool,
      canPlay: json['can_play'] as bool,
      playerNotes: json['player_notes'] as String?,
      closedAt: json['closed_at'] != null
          ? DateTime.parse(json['closed_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player_id': playerId,
      'title': title,
      'description': description,
      'status': status,
      'body_area': bodyArea,
      'body_side': bodySide,
      'severity': severity,
      'start_date': startDate.toIso8601String(),
      'estimated_return_date': estimatedReturnDate?.toIso8601String(),
      'can_train': canTrain,
      'can_play': canPlay,
      'player_notes': playerNotes,
      'closed_at': closedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
