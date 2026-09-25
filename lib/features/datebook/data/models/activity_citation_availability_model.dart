import 'package:cultura_club/features/datebook/domain/entities/activity_citation_availability_entity.dart';

class ActivityCitationAvailabilityModel
    extends ActivityCitationAvailabilityEntity {
  const ActivityCitationAvailabilityModel({
    required super.citationId,
    required super.playerId,
    required super.playerName,
    super.playerCategoryId,
    super.playerCategoryName,
    required super.responseStatus,
    super.responseDate,
    required super.canTrain,
    required super.canPlay,
    required super.activeInjuriesCount,
    required super.hasRecoveringInjury,
    required super.currentlyAvailableForActivity,
    required super.blockingTitles,
  });

  factory ActivityCitationAvailabilityModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawBlockingTitles =
        json['blocking_titles'] as List<dynamic>? ?? const <dynamic>[];

    return ActivityCitationAvailabilityModel(
      citationId: json['citation_id'] as String? ?? '',
      playerId: json['player_id'] as String? ?? '',
      playerName: json['player_name'] as String? ?? 'Jugador sin nombre',
      playerCategoryId: json['player_category_id'] as String?,
      playerCategoryName: json['player_category_name'] as String?,
      responseStatus: json['estado_respuesta'] as String? ?? 'pendiente',
      responseDate: json['fecha_respuesta'] != null
          ? DateTime.parse(json['fecha_respuesta'] as String)
          : null,
      canTrain: json['can_train'] as bool? ?? true,
      canPlay: json['can_play'] as bool? ?? true,
      activeInjuriesCount:
          (json['active_injuries_count'] as num?)?.toInt() ?? 0,
      hasRecoveringInjury: json['has_recovering_injury'] as bool? ?? false,
      currentlyAvailableForActivity:
          json['currently_available_for_activity'] as bool? ?? true,
      blockingTitles: rawBlockingTitles.map((e) => e.toString()).toList(),
    );
  }
}
