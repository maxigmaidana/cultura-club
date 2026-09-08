import 'package:cultura_club/core/enums/player_enums.dart';

class PlayerProfileEntity {
  final String categoriaId;
  final String categoriaNombre;
  final String? fotoUrl;
  final DateTime? fechaNacimiento;
  final PiernaHabil piernaHabil;
  final List<Posicion> posiciones;
  final double alturaCm;
  final double pesoCm;

  const PlayerProfileEntity({
    required this.categoriaId,
    required this.categoriaNombre,
    this.fotoUrl,
    this.fechaNacimiento,
    required this.piernaHabil,
    required this.posiciones,
    required this.alturaCm,
    required this.pesoCm,
  });
}
