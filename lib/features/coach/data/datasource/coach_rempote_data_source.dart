import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/player_profile_model.dart';
import '../../domain/entities/player_profile_entity.dart';

// 1. El Contrato (La abstracción)
abstract class CoachRemoteDataSource {
  Future<List<PlayerProfileEntity>> getRoster(String coachId);
}

// 2. La Implementación concreta
class CoachRemoteDataSourceImpl implements CoachRemoteDataSource {
  final SupabaseClient supabaseClient;

  CoachRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<PlayerProfileEntity>> getRoster(String coachId) async {
    final response = await supabaseClient
        .from('jugadores_perfil')
        .select('''
          usuario_id,
          posiciones,
          pierna_habil,
          altura_cm,
          peso_kg,
          usuarios ( nombre_completo ),
          categorias!inner ( entrenador_id )
        ''')
        .eq('categorias.entrenador_id', coachId);

    return (response as List<dynamic>)
        .map((json) => PlayerProfileModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}