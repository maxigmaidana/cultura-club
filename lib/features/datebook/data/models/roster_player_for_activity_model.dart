import 'package:cultura_club/core/enums/player_enums.dart';
import 'package:cultura_club/features/datebook/domain/entities/roster_player_for_activity_entity.dart';

class RosterPlayerForActivityModel extends RosterPlayerForActivityEntity {
  RosterPlayerForActivityModel({
    required super.userId,
    required super.fullName,
    required super.posiciones,
    required super.piernaHabil,
    required super.sectorCancha,
    super.alturaCm,
    super.pesoKg,
    required super.canTrain,
    required super.canPlay,
    required super.activeInjuriesCount,
    required super.hasRecoveringInjury,
  });

  factory RosterPlayerForActivityModel.fromJson(Map<String, dynamic> json) {
    final posicionesRaw = json['posiciones'] as List<dynamic>? ?? <dynamic>[];

    return RosterPlayerForActivityModel(
      userId: json['player_id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? 'Jugador sin nombre',
      posiciones: posicionesRaw
          .map((value) => Posicion.fromString(value.toString()))
          .toList(),
      piernaHabil: PiernaHabil.fromString(json['pierna_habil'] as String?),
      sectorCancha: SectorCancha.fromString(json['sector_cancha'] as String?),
      alturaCm: (json['altura_cm'] as num?)?.toDouble(),
      pesoKg: (json['peso_kg'] as num?)?.toDouble(),
      canTrain: json['can_train'] as bool? ?? false,
      canPlay: json['can_play'] as bool? ?? false,
      activeInjuriesCount:
          (json['active_injuries_count'] as num?)?.toInt() ?? 0,
      hasRecoveringInjury: json['has_recovering_injury'] as bool? ?? false,
    );
  }
}
