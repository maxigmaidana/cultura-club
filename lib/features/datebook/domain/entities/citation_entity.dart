class CitationEntity {
  final String id;
  final String actividadId;
  final String jugadorId;
  final String estadoRespuesta;
  final DateTime? fechaRespuesta;

  CitationEntity({
    required this.id,
    required this.actividadId,
    required this.jugadorId,
    required this.estadoRespuesta,
    this.fechaRespuesta,
  });
}
