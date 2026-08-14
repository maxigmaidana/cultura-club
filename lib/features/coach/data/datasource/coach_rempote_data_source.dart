import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';
import '../models/player_profile_model.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/player_profile_entity.dart';

// 1. El Contrato (La abstracción)
abstract class CoachRemoteDataSource {
  Future<List<CategoryEntity>> getCategoriesByCoach(String coachId);
  Future<List<PlayerProfileEntity>> getRosterByCategory(String categoryId);
}

// 2. La Implementación concreta
class CoachRemoteDataSourceImpl implements CoachRemoteDataSource {
  final SupabaseClient supabaseClient;

  CoachRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<CategoryEntity>> getCategoriesByCoach(String coachId) async {
    try {
      log(
        '📡 REQUEST | table: categorias | action: select | '
        'filters: entrenador_id = $coachId',
        name: 'Supabase',
      );

      final response = await supabaseClient
          .from('categorias')
          .select('id, club_id, nombre, entrenador_id')
          .eq('entrenador_id', coachId);

      log(
        '✅ RESPONSE | table: categorias | action: select | '
        'records: ${(response as List<dynamic>).length}',
        name: 'Supabase',
      );

      return (response as List<dynamic>)
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (error, stackTrace) {
      log(
        '❌ ERROR | table: categorias | action: select | error: $error',
        name: 'Supabase',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<PlayerProfileEntity>> getRosterByCategory(
    String categoryId,
  ) async {
    try {
      log(
        '📡 REQUEST | table: jugadores_perfil | action: select | '
        'filters: categoria_id = $categoryId',
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
          usuarios ( nombre_completo )
        ''')
          .eq('categoria_id', categoryId);

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
