import '../../domain/entities/citation_entity.dart';

class CitationModel extends CitationEntity {
  CitationModel({
    required super.id,
    required super.actividadId,
    required super.jugadorId,
    required super.estadoRespuesta,
    super.fechaRespuesta,
  });

  factory CitationModel.fromJson(Map<String, dynamic> json) {
    return CitationModel(
      id: json['id'],
      actividadId: json['actividad_id'],
      jugadorId: json['jugador_id'],
      estadoRespuesta: json['estado_respuesta'],
      fechaRespuesta: json['fecha_respuesta'] != null
          ? DateTime.parse(json['fecha_respuesta'])
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'actividad_id': actividadId,
      'jugador_id': jugadorId,
      'estado_respuesta': estadoRespuesta,
      'fecha_respuesta': fechaRespuesta?.toIso8601String(),
    };
  }
}
