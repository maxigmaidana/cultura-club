import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../models/trivia_model.dart';

abstract class TriviaRemoteDataSource {
  Future<List<TriviaModel>> getPendingTrivias(String jugadorId);
  Future<List<CompletedTriviaInfoModel>> getCompletedTrivias(String jugadorId);
  Future<void> submitTriviaAnswers(
    String triviaId,
    String jugadorId,
    List<Map<String, dynamic>> respuestas,
  );
  Future<int> getTotalGameificationPoints(String jugadorId);
}

class TriviaRemoteDataSourceImpl implements TriviaRemoteDataSource {
  final supabase.SupabaseClient supabaseClient;

  TriviaRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<TriviaModel>> getPendingTrivias(String jugadorId) async {
    try {
      log(
        '📡 REQUEST | table: trivias | action: select | filters: pending for jugador_id = $jugadorId',
        name: 'Supabase',
      );

      final perfilResponse = await supabaseClient
          .from('jugadores_perfil')
          .select('categoria_id')
          .eq('usuario_id', jugadorId)
          .maybeSingle();

      final String? categoriaId = perfilResponse?['categoria_id'];

      final respuestasData = await supabaseClient
          .from('trivia_respuestas')
          .select('pregunta_id')
          .eq('jugador_id', jugadorId);

      final List<String> preguntaIdsRespondidas =
          (respuestasData as List<dynamic>)
              .map((item) => item['pregunta_id'] as String)
              .toList();

      List<String> respondedTriviaIds = [];

      if (preguntaIdsRespondidas.isNotEmpty) {
        final preguntasData = await supabaseClient
            .from('trivia_preguntas')
            .select('trivia_id')
            .inFilter('id', preguntaIdsRespondidas);

        respondedTriviaIds = (preguntasData as List<dynamic>)
            .map((item) => item['trivia_id'] as String)
            .toSet()
            .toList();
      }

      var query = supabaseClient.from('trivias').select('''
          id,
          titulo,
          categoria_id,
          creador_id,
          estado,
          created_at,
          trivia_preguntas (
            id,
            trivia_id,
            pregunta,
            opciones,
            respuesta_correcta,
            puntos
          )
        ''');

      if (categoriaId != null) {
        query = query.eq('categoria_id', categoriaId);
      }

      if (respondedTriviaIds.isNotEmpty) {
        final idsString = '(${respondedTriviaIds.join(',')})';
        query = query.not('id', 'in', idsString);
      }

      final response = await query;

      final List<TriviaModel> trivias = (response as List<dynamic>)
          .map((json) => TriviaModel.fromJson(json))
          .toList();

      return trivias;
    } catch (error, stackTrace) {
      log(
        '❌ ERROR | table: trivias | action: select | error: $error',
        name: 'Supabase',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<CompletedTriviaInfoModel>> getCompletedTrivias(
    String jugadorId,
  ) async {
    try {
      log(
        '📡 REQUEST | table: trivia_respuestas | action: select | filters: jugador_id = $jugadorId (completadas)',
        name: 'Supabase',
      );

      final response = await supabaseClient
          .from('trivia_respuestas')
          .select('''
          id,
          pregunta_id,
          jugador_id,
          puntos_ganados,
          trivia_preguntas (
            trivia_id,
            trivias (
              id,
              titulo
            )
          )
        ''')
          .eq('jugador_id', jugadorId)
          .order('id', ascending: false);

      log(
        '✅ RESPONSE | table: trivia_respuestas | action: select | records: ${response.length}',
        name: 'Supabase',
      );

      final Map<String, Map<String, dynamic>> triviaMap = {};
      final Map<String, int> preguntasCountByTrivia = {};

      // Agrupar respuestas por trivia y contar preguntas por trivia
      for (final item in (response as List<dynamic>)) {
        final pregunta = item['trivia_preguntas'] as Map<String, dynamic>?;
        if (pregunta == null) continue;

        final trivia = pregunta['trivias'] as Map<String, dynamic>?;
        if (trivia == null) continue;

        final triviaId = trivia['id'] as String;
        final titulo = trivia['titulo'] as String;
        final puntos = (item['puntos_ganados'] as int?) ?? 0;

        // Contar preguntas por trivia
        preguntasCountByTrivia[triviaId] =
            (preguntasCountByTrivia[triviaId] ?? 0) + 1;

        if (!triviaMap.containsKey(triviaId)) {
          triviaMap[triviaId] = {
            'trivia_id': triviaId,
            'titulo': titulo,
            'puntos_obtenidos': 0,
            'respondido_at': DateTime.now(),
          };
        }

        triviaMap[triviaId]!['puntos_obtenidos'] =
            (triviaMap[triviaId]!['puntos_obtenidos'] as int) + puntos;
      }

      // Validar que cada trivia fue completada (respondió todas las preguntas)
      final List<CompletedTriviaInfoModel> result = [];
      for (final entry in triviaMap.entries) {
        final triviaId = entry.key;
        final data = entry.value;
        final respondidas = preguntasCountByTrivia[triviaId] ?? 0;

        // Obtener el número total de preguntas en la trivia
        final preguntasTotal = await supabaseClient
            .from('trivia_preguntas')
            .select('id')
            .eq('trivia_id', triviaId)
            .then((response) => (response as List<dynamic>).length);

        // Solo agregar si respondió todas las preguntas
        if (respondidas == preguntasTotal) {
          result.add(CompletedTriviaInfoModel.fromJson(data));
        }
      }

      return result;
    } catch (error, stackTrace) {
      log(
        '❌ ERROR | table: trivia_respuestas | action: select | error: $error',
        name: 'Supabase',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> submitTriviaAnswers(
    String triviaId,
    String jugadorId,
    List<Map<String, dynamic>> respuestas,
  ) async {
    try {
      log(
        '📡 REQUEST | table: trivia_respuestas | action: insert | trivia_id: $triviaId, jugador_id: $jugadorId, respuestas: ${respuestas.length}',
        name: 'Supabase',
      );

      for (final respuesta in respuestas) {
        final preguntaId = respuesta['pregunta_id'] as String;
        final opcionElegidaId = respuesta['opcion_elegida_id'] as String;

        final opcionData = await supabaseClient
            .from('trivia_preguntas')
            .select('respuesta_correcta')
            .eq('id', preguntaId)
            .single();

        final respuestaCorrecta =
            opcionData['respuesta_correcta'] as String? ?? '';
        final esCorrecta = respuestaCorrecta == opcionElegidaId;
        final puntosGanados = esCorrecta ? 1 : 0;

        await supabaseClient.from('trivia_respuestas').insert({
          'pregunta_id': preguntaId,
          'jugador_id': jugadorId,
          'respuesta_elegida': opcionElegidaId,
          'es_correcta': esCorrecta,
          'puntos_ganados': puntosGanados,
        });
      }

      log(
        '✅ RESPONSE | table: trivia_respuestas | action: insert | respuestas_insertadas: ${respuestas.length}',
        name: 'Supabase',
      );
    } catch (error, stackTrace) {
      log(
        '❌ ERROR | table: trivia_respuestas | action: insert | error: $error',
        name: 'Supabase',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<int> getTotalGameificationPoints(String jugadorId) async {
    try {
      log(
        '📡 REQUEST | table: trivia_respuestas | action: sum | jugador_id: $jugadorId',
        name: 'Supabase',
      );

      final response = await supabaseClient
          .rpc(
            'obtener_puntos_totales_gamification',
            params: {'p_jugador_id': jugadorId},
          )
          .then((value) => value as int? ?? 0);

      log(
        '✅ RESPONSE | table: trivia_respuestas | action: sum | total_points: $response',
        name: 'Supabase',
      );

      return response;
    } catch (error, stackTrace) {
      log(
        '❌ ERROR | table: trivia_respuestas | action: sum | error: $error',
        name: 'Supabase',
        error: error,
        stackTrace: stackTrace,
      );
      return 0;
    }
  }
}
