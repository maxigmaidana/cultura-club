import '../../domain/entities/trivia_entity.dart';
import '../../domain/repositories/trivia_repository.dart';

class TriviaModel extends TriviaEntity {
  TriviaModel({
    required super.id,
    required super.categoriaId,
    required super.titulo,
    required super.creadorId,
    required super.preguntas,
    required super.estado,
    required super.createdAt,
  });

  factory TriviaModel.fromJson(Map<String, dynamic> json) {
    return TriviaModel(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      categoriaId: json['categoria_id'] as String,
      creadorId: json['creador_id'] as String,
      preguntas:
          (json['trivia_preguntas'] as List<dynamic>?)
              ?.map((p) => PreguntaModel.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      estado: json['estado'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoria_id': categoriaId,
      'titulo': titulo,
      'creador_id': creadorId,
      'preguntas': preguntas.map((p) => (p as PreguntaModel).toJson()).toList(),
      'estado': estado,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class PreguntaModel extends PreguntaEntity {
  PreguntaModel({
    required super.id,
    required super.triviaId,
    required super.pregunta,
    required super.respuestaCorrecta,
    required super.puntos,
    required super.opciones,
  });

  factory PreguntaModel.fromJson(Map<String, dynamic> json) {
    return PreguntaModel(
      id: json['id'] as String,
      triviaId: json['trivia_id'] as String,
      pregunta: json['pregunta'] as String,
      respuestaCorrecta: json['respuesta_correcta'] as String,
      puntos: json['puntos'] as int,
      opciones:
          (json['opciones'] as List<dynamic>?)
              ?.map((o) => o as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trivia_id': triviaId,
      'pregunta': pregunta,
      'respuesta_correcta': respuestaCorrecta,
      'puntos': puntos,
      'opciones': opciones,
    };
  }
}

// class OpcionModel extends OpcionEntity {
//   OpcionModel({
//     required super.id,
//     required super.preguntaId,
//     required super.texto,
//     required super.esCorrecta,
//     required super.orden,
//   });

//   factory OpcionModel.fromJson(Map<String, dynamic> json) {
//     return OpcionModel(
//       id: json['id'] as String,
//       preguntaId: json['pregunta_id'] as String,
//       texto: json['texto'] as String,
//       esCorrecta: json['es_correcta'] as bool,
//       orden: json['orden'] as int,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'pregunta_id': preguntaId,
//       'texto': texto,
//       'es_correcta': esCorrecta,
//       'orden': orden,
//     };
//   }
// }

class TriviaRespuestaModel extends TriviaRespuestaEntity {
  TriviaRespuestaModel({
    required super.id,
    required super.triviaId,
    required super.jugadorId,
    required super.respuestas,
    required super.puntosObtenidog,
    required super.respondidoAt,
  });

  factory TriviaRespuestaModel.fromJson(Map<String, dynamic> json) {
    return TriviaRespuestaModel(
      id: json['id'] as String,
      triviaId: json['trivia_id'] as String,
      jugadorId: json['jugador_id'] as String,
      respuestas:
          (json['respuestas'] as List<dynamic>?)
              ?.map((r) => RespuestaModel.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      puntosObtenidog: json['puntos_obtenidos'] as int? ?? 0,
      respondidoAt: DateTime.parse(json['respondido_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trivia_id': triviaId,
      'jugador_id': jugadorId,
      'respuestas': respuestas
          .map((r) => (r as RespuestaModel).toJson())
          .toList(),
      'puntos_obtenidos': puntosObtenidog,
      'respondido_at': respondidoAt.toIso8601String(),
    };
  }
}

class RespuestaModel extends RespuestaEntity {
  RespuestaModel({required super.preguntaId, required super.opcionElegidaId});

  factory RespuestaModel.fromJson(Map<String, dynamic> json) {
    return RespuestaModel(
      preguntaId: json['pregunta_id'] as String,
      opcionElegidaId: json['opcion_elegida_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'pregunta_id': preguntaId, 'opcion_elegida_id': opcionElegidaId};
  }
}

/// Modelo para trivia completada (usado en historial)
class CompletedTriviaInfoModel extends CompletedTriviaInfo {
  CompletedTriviaInfoModel({
    required super.triviaId,
    required super.titulo,
    required super.puntosObtenidos,
    required super.respondidoAt,
  });

  factory CompletedTriviaInfoModel.fromJson(Map<String, dynamic> json) {
    return CompletedTriviaInfoModel(
      triviaId: json['trivia_id'] as String? ?? '',
      titulo: json['titulo'] as String? ?? 'Sin título',
      puntosObtenidos: (json['puntos_obtenidos'] as int?) ?? 0,
      respondidoAt: json['respondido_at'] is String
          ? DateTime.parse(json['respondido_at'] as String)
          : (json['respondido_at'] as DateTime? ?? DateTime.now()),
    );
  }
}
