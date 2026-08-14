import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/evaluation_model.dart';
import '../models/player_stats_model.dart';

abstract class EvaluationRemoteDataSource {
  Future<PlayerStatsModel> getPlayerStats(String playerId, String categoryId);
  Future<List<PlayerStatsModel>> getAllStatsForPlayer(String playerId);
  Future<void> insertEvaluation(
    EvaluationModel delta,
    PlayerStatsModel newStats,
  );
}

class EvaluationRemoteDataSourceImpl implements EvaluationRemoteDataSource {
  final SupabaseClient supabaseClient;

  EvaluationRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<PlayerStatsModel> getPlayerStats(
    String playerId,
    String categoryId,
  ) async {
    try {
      log(
        '📡 REQUEST | table: jugador_categoria_stats | action: select | '
        'filters: jugador_id = $playerId, categoria_id = $categoryId',
        name: 'Supabase',
      );

      final response = await supabaseClient
          .from('jugador_categoria_stats')
          .select('*, categorias(nombre)')
          .eq('jugador_id', playerId)
          .eq('categoria_id', categoryId)
          .maybeSingle();

      log(
        '✅ RESPONSE | table: jugador_categoria_stats | action: select | '
        'records: ${response == null ? 0 : 1}',
        name: 'Supabase',
      );

      // Si no existe registro, retornamos stats por defecto (50)
      if (response == null) {
        return PlayerStatsModel.defaultStats(
          jugadorId: playerId,
          categoriaId: categoryId,
        );
      }

      return PlayerStatsModel.fromJson(response);
    } catch (error, stackTrace) {
      log(
        '❌ ERROR | table: jugador_categoria_stats | action: select | error: $error',
        name: 'Supabase',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<PlayerStatsModel>> getAllStatsForPlayer(String playerId) async {
    try {
      log(
        '📡 REQUEST | table: jugador_categoria_stats | action: select | '
        'filters: jugador_id = $playerId | join: categorias',
        name: 'Supabase',
      );

      final response = await supabaseClient
          .from('jugador_categoria_stats')
          .select('*, categorias(nombre)')
          .eq('jugador_id', playerId);

      log(
        '✅ RESPONSE | table: jugador_categoria_stats | action: select | '
        'records: ${(response as List<dynamic>).length}',
        name: 'Supabase',
      );

      return (response as List<dynamic>)
          .map(
            (json) => PlayerStatsModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (error, stackTrace) {
      log(
        '❌ ERROR | table: jugador_categoria_stats | action: select | error: $error',
        name: 'Supabase',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> insertEvaluation(
    EvaluationModel delta,
    PlayerStatsModel newStats,
  ) async {
    final deltaPayload = delta.toJson();
    final statsPayload = newStats.toJson();

    try {
      // 1. Upsert los stats absolutos en jugador_categoria_stats
      log(
        '📡 REQUEST | table: jugador_categoria_stats | action: upsert | '
        'parameters: $statsPayload',
        name: 'Supabase',
      );

      await supabaseClient
          .from('jugador_categoria_stats')
          .upsert(statsPayload, onConflict: 'jugador_id,categoria_id');

      log(
        '✅ RESPONSE | table: jugador_categoria_stats | action: upsert | completed',
        name: 'Supabase',
      );

      // 2. Insert el delta en evolucion_jugador
      log(
        '📡 REQUEST | table: evolucion_jugador | action: insert | '
        'parameters: $deltaPayload',
        name: 'Supabase',
      );

      await supabaseClient.from('evolucion_jugador').insert(deltaPayload);

      log(
        '✅ RESPONSE | table: evolucion_jugador | action: insert | completed',
        name: 'Supabase',
      );
    } catch (error, stackTrace) {
      log(
        '❌ ERROR | table: evolucion_jugador/jugador_categoria_stats | error: $error',
        name: 'Supabase',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
