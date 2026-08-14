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
    // Inserta directo en la tabla usando el toJson que armamos
    await supabaseClient
        .from('evolucion_jugador')
        .insert(evaluation.toJson());
  }
}