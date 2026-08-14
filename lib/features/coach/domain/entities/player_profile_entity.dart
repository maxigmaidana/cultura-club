import '../../../../core/enums/player_enums.dart';

class PlayerProfileEntity {
  final String userId;
  final String fullName;
  final List<Posicion> posiciones;
  final PiernaHabil piernaHabil;
  final double? alturaCm;
  final double? pesoKg;

  PlayerProfileEntity({
    required this.userId,
    required this.fullName,
    required this.posiciones,
    required this.piernaHabil,
    this.alturaCm,
    this.pesoKg,
  });
} 