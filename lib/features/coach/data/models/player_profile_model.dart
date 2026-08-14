import '../../../../core/enums/player_enums.dart';
import '../../domain/entities/player_profile_entity.dart';

class PlayerProfileModel {
  // Parseamos el JSON relacional de Supabase
  static PlayerProfileEntity fromJson(Map<String, dynamic> json) {
    // 1. Extraemos el nombre del join con la tabla usuarios
    final usuarioData = json['usuarios'] as Map<String, dynamic>?;
    final fullName = usuarioData?['nombre_completo'] ?? 'Jugador sin nombre';

    // 2. Parseamos el arreglo de posiciones
    final posicionesRaw = json['posiciones'] as List<dynamic>? ?? [];
    final posiciones = posicionesRaw.map((p) => Posicion.fromString(p.toString())).toList();

    return PlayerProfileEntity(
      userId: json['usuario_id'] ?? '',
      fullName: fullName,
      posiciones: posiciones,
      piernaHabil: PiernaHabil.fromString(json['pierna_habil']),
      alturaCm: json['altura_cm']?.toDouble(),
      pesoKg: json['peso_kg']?.toDouble(),
    );
  }
}