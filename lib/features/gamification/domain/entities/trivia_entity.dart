class TriviaEntity {
  final String id;
  final String titulo;
  final String categoriaId;
  final String creadorId;
  final String estado;
  final DateTime createdAt;
  final List<PreguntaEntity> preguntas;

  TriviaEntity({
    required this.id,
    required this.titulo,
    required this.categoriaId,
    required this.creadorId,
    required this.estado,
    required this.preguntas,
    required this.createdAt,
  });
}

class PreguntaEntity {
  final String id;
  final String triviaId;
  final String pregunta;
  final String respuestaCorrecta;
  final List<String> opciones;
  final int puntos;

  PreguntaEntity({
    required this.id,
    required this.triviaId,
    required this.pregunta,
    required this.respuestaCorrecta,
    required this.puntos,
    required this.opciones,
  });
}

// class OpcionEntity {
//   final String id;
//   final String preguntaId;
//   final String texto;
//   final bool esCorrecta;
//   final int orden;

//   OpcionEntity({
//     required this.id,
//     required this.preguntaId,
//     required this.texto,
//     required this.esCorrecta,
//     required this.orden,
//   });
// }

class TriviaRespuestaEntity {
  final String id;
  final String triviaId;
  final String jugadorId;
  final List<RespuestaEntity> respuestas;
  final int puntosObtenidog;
  final DateTime respondidoAt;

  TriviaRespuestaEntity({
    required this.id,
    required this.triviaId,
    required this.jugadorId,
    required this.respuestas,
    required this.puntosObtenidog,
    required this.respondidoAt,
  });
}

class RespuestaEntity {
  final String preguntaId;
  final String opcionElegidaId;

  RespuestaEntity({required this.preguntaId, required this.opcionElegidaId});
}
