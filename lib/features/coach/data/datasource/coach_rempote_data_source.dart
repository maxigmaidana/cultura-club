import 'dart:developer';

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
    try {
      log(
        '📡 REQUEST | table: jugadores_perfil | action: select | '
        'filters: categorias.entrenador_id = $coachId',
        name: 'Supabase',
      );

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

      log(
        '✅ RESPONSE | table: jugadores_perfil | action: select | '
        'records: ${(response as List<dynamic>).length}',
        name: 'Supabase',
      );

      return (response as List<dynamic>)
          .map(
            (json) => PlayerProfileModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (error, stackTrace) {
      log(
        '❌ ERROR | table: jugadores_perfil | action: select | error: $error',
        name: 'Supabase',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
