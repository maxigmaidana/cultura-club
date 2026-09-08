import 'package:cultura_club/core/enums/player_enums.dart';
import '../../domain/entity/player_profile_entity.dart';

class PlayerProfileModel extends PlayerProfileEntity {
  const PlayerProfileModel({
    required super.categoriaId,
    required super.categoriaNombre,
    super.fotoUrl,
    super.fechaNacimiento,
    required super.piernaHabil,
    required super.posiciones,
    required super.alturaCm,
    required super.pesoCm,
  });

  factory PlayerProfileModel.fromJson(Map<String, dynamic> json) {
    // Datos desde jugadores_perfil table
    final posicionesRaw =
        (json['posiciones'] as List<dynamic>?)?.cast<String>() ?? [];
    final posiciones = posicionesRaw
        .map((p) => Posicion.fromString(p))
        .toList();

    // Categoría viene desde el JOIN con categorias
    final categoriaData = json['categorias'] as Map<String, dynamic>?;

    return PlayerProfileModel(
      categoriaId: categoriaData?['id'] ?? json['categoria_id'] ?? '',
      categoriaNombre: categoriaData?['nombre'] ?? '',
      fotoUrl: json['foto_url'] as String?,
      fechaNacimiento: json['fecha_nacimiento'] is String
          ? DateTime.tryParse(json['fecha_nacimiento'])
          : (json['fecha_nacimiento'] as DateTime?),
      piernaHabil: PiernaHabil.fromString(json['pierna_habil'] ?? 'DERECHA'),
      posiciones: posiciones,
      alturaCm: (json['altura_cm'] as num?)?.toDouble() ?? 0.0,
      pesoCm: (json['peso_kg'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
