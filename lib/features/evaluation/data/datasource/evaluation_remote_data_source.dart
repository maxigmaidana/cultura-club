import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/evaluation_model.dart';

abstract class EvaluationRemoteDataSource {
  Future<void> insertEvaluation(EvaluationModel evaluation);
}

class EvaluationRemoteDataSourceImpl implements EvaluationRemoteDataSource {
  final SupabaseClient supabaseClient;

  EvaluationRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<void> insertEvaluation(EvaluationModel evaluation) async {
    final payload = evaluation.toJson();

    try {
      log(
        '📡 REQUEST | table: evolucion_jugador | action: insert | '
        'parameters: $payload',
        name: 'Supabase',
      );

      await supabaseClient.from('evolucion_jugador').insert(payload);

      log(
        '✅ RESPONSE | table: evolucion_jugador | action: insert | completed',
        name: 'Supabase',
      );
    } catch (error, stackTrace) {
      log(
        '❌ ERROR | table: evolucion_jugador | action: insert | error: $error',
        name: 'Supabase',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
