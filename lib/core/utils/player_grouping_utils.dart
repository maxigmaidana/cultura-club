import 'package:cultura_club/core/enums/player_enums.dart';
import 'package:cultura_club/features/coach/domain/entities/player_profile_entity.dart';

/// Utilidades para agrupar jugadores por atributos
abstract class PlayerGroupingUtils {
  /// Agrupa una lista de jugadores por su sector de cancha
  ///
  /// Retorna un Map donde la clave es el SectorCancha y el valor es la lista de jugadores en ese sector.
  /// Inicializa todos los sectores (incluso los vacíos) para garantizar orden consistente.
  ///
  /// Ejemplo:
  /// ```dart
  /// final grouped = groupPlayersBySector(roster);
  /// // {arquero: [...], defensa: [...], medio: [...], delantero: [...]}
  /// ```
  static Map<SectorCancha, List<PlayerProfileEntity>> groupPlayersBySector(
    List<PlayerProfileEntity> roster,
  ) {
    final grouped = <SectorCancha, List<PlayerProfileEntity>>{};

    // Inicializar todos los sectores (incluso los vacíos) para orden consistente
    for (final sector in SectorCancha.values) {
      grouped[sector] = [];
    }

    // Agrupar jugadores por su sector
    for (final player in roster) {
      grouped[player.sectorCancha]?.add(player);
    }

    return grouped;
  }
}
