import 'package:cultura_club/features/datebook/domain/entities/citation_entity.dart';

class ActivityEntity {
  final String id;
  final String categoriaId;
  final String creadorId;
  final String tipo;
  final String titulo;
  final DateTime fechaHora;
  final String? lugar;
  final String? indicaciones;
  final String estado;
  final List<CitationEntity> citaciones;

  ActivityEntity({
    required this.id,
    required this.categoriaId,
    required this.creadorId,
    required this.tipo,
    required this.titulo,
    required this.fechaHora,
    this.lugar,
    this.indicaciones,
    required this.estado,
    this.citaciones = const [],
  });
}
