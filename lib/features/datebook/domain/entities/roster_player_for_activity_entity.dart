import 'package:cultura_club/features/coach/domain/entities/player_profile_entity.dart';

class RosterPlayerForActivityEntity extends PlayerProfileEntity {
  final bool canTrain;
  final bool canPlay;
  final int activeInjuriesCount;
  final bool hasRecoveringInjury;

  RosterPlayerForActivityEntity({
    required super.userId,
    required super.fullName,
    required super.posiciones,
    required super.piernaHabil,
    required super.sectorCancha,
    super.alturaCm,
    super.pesoKg,
    required this.canTrain,
    required this.canPlay,
    required this.activeInjuriesCount,
    required this.hasRecoveringInjury,
  });
}
