import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.clubId,
    required super.nombre,
    required super.entrenadorId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      clubId: json['club_id'] as String,
      nombre: json['nombre'] as String,
      entrenadorId: json['entrenador_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'club_id': clubId,
      'nombre': nombre,
      'entrenador_id': entrenadorId,
    };
  }
}
