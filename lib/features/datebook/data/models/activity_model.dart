import '../../domain/entities/activity_entity.dart';
import 'citation_model.dart';

class ActivityModel extends ActivityEntity {
  ActivityModel({
    required super.id,
    required super.categoriaId,
    required super.creadorId,
    required super.tipo,
    required super.titulo,
    required super.fechaHora,
    super.lugar,
    super.indicaciones,
    required super.estado,
    super.citaciones,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    var citacionesList = json['citaciones'] as List?;
    return ActivityModel(
      id: json['id'],
      categoriaId: json['categoria_id'],
      creadorId: json['creador_id'],
      tipo: json['tipo'],
      titulo: json['titulo'],
      fechaHora: DateTime.parse(json['fecha_hora']),
      lugar: json['lugar'],
      indicaciones: json['indicaciones'],
      estado: json['estado'],
      citaciones: citacionesList != null
          ? citacionesList.map((e) => CitationModel.fromJson(e)).toList()
          : [],
    );
  }
}
