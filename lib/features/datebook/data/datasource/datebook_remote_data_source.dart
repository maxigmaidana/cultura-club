import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/activity_model.dart';
import '../models/roster_player_for_activity_model.dart';

abstract class DatebookRemoteDataSource {
  Future<List<ActivityModel>> getActivitiesByCategory(String categoriaId);
  Future<void> respondToCitation(
    String actividadId,
    String jugadorId,
    String estadoRespuesta,
  );
  Future<void> createActivity({
    required String categoriaId,
    required String creadorId,
    required String tipo,
    required String titulo,
    required DateTime fechaHora,
    String? lugar,
    String? indicaciones,
    List<String> jugadorIds = const [],
  });

  Future<void> updateActivity({
    required String actividadId,
    required String tipo,
    required String titulo,
    required DateTime fechaHora,
    String? lugar,
    String? indicaciones,
  });

  Future<List<ActivityModel>> getActivitiesForPlayer(String jugadorId);
  Future<List<RosterPlayerForActivityModel>> getRosterWithAvailability(
    String categoryId,
  );
}

class DatebookRemoteDataSourceImpl implements DatebookRemoteDataSource {
  final SupabaseClient supabase;

  DatebookRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<ActivityModel>> getActivitiesByCategory(
    String categoriaId,
  ) async {
    try {
      log('📡 Fetching activities for category: $categoriaId');
      final response = await supabase
          .from('actividades')
          .select('*, citaciones(*)')
          .eq('categoria_id', categoriaId)
          .order('fecha_hora', ascending: true);

      log('✅ Fetched ${response.length} activities.');
      return response.map((e) => ActivityModel.fromJson(e)).toList();
    } catch (e) {
      log('❌ Error in getActivitiesByCategory: $e');
      throw Exception('Error al obtener la agenda: $e');
    }
  }

  @override
  Future<void> respondToCitation(
    String actividadId,
    String jugadorId,
    String estadoRespuesta,
  ) async {
    try {
      log(
        '📡 Responding to citation: $actividadId, Jugador: $jugadorId, Estado: $estadoRespuesta',
      );
      await supabase.from('citaciones').upsert({
        'actividad_id': actividadId,
        'jugador_id': jugadorId,
        'estado_respuesta': estadoRespuesta,
        'fecha_respuesta': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'actividad_id,jugador_id');
      log('✅ Citation response saved.');
    } catch (e) {
      log('❌ Error in respondToCitation: $e');
      throw Exception('Error al responder citación: $e');
    }
  }

  @override
  Future<void> createActivity({
    required String categoriaId,
    required String creadorId,
    required String tipo,
    required String titulo,
    required DateTime fechaHora,
    String? lugar,
    String? indicaciones,
    List<String> jugadorIds = const [],
  }) async {
    try {
      log('📡 Creating activity: $titulo for category: $categoriaId');
      await supabase.rpc(
        'create_activity_with_citations',
        params: {
          'p_categoria_id': categoriaId,
          'p_creador_id': creadorId,
          'p_tipo': tipo,
          'p_titulo': titulo,
          'p_fecha_hora': fechaHora.toUtc().toIso8601String(),
          'p_lugar': lugar,
          'p_indicaciones': indicaciones,
          'p_jugador_ids': jugadorIds,
        },
      );
      log('✅ Activity created.');
    } on PostgrestException catch (e) {
      log(
        '❌ Postgrest error in createActivity: ${e.message} (code: ${e.code})',
      );
      rethrow;
    } catch (e) {
      log('❌ Error in createActivity: $e');
      throw Exception('Error al crear la actividad: $e');
    }
  }

  @override
  Future<void> updateActivity({
    required String actividadId,
    required String tipo,
    required String titulo,
    required DateTime fechaHora,
    String? lugar,
    String? indicaciones,
  }) async {
    try {
      log('📡 Updating activity: $actividadId');
      await supabase
          .from('actividades')
          .update({
            'tipo': tipo,
            'titulo': titulo,
            'fecha_hora': fechaHora.toUtc().toIso8601String(),
            'lugar': lugar,
            'indicaciones': indicaciones,
          })
          .eq('id', actividadId);
      log('✅ Activity updated.');
    } catch (e) {
      log('❌ Error in updateActivity: $e');
      throw Exception('Error al actualizar la actividad: $e');
    }
  }

  @override
  Future<List<ActivityModel>> getActivitiesForPlayer(String jugadorId) async {
    try {
      log('📡 Fetching agenda for player: $jugadorId');
      final response = await supabase
          .from('citaciones')
          .select('*, actividades(*, citaciones(*))')
          .eq('jugador_id', jugadorId)
          .order('actividades(fecha_hora)', ascending: true);

      return response
          .map(
            (e) => ActivityModel.fromJson(
              e['actividades'] as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      log('❌ Error in getActivitiesForPlayer: $e');
      throw Exception('Error al obtener la agenda del jugador: $e');
    }
  }

  @override
  Future<List<RosterPlayerForActivityModel>> getRosterWithAvailability(
    String categoryId,
  ) async {
    try {
      log('📡 Fetching roster with availability for category: $categoryId');
      final response = await supabase.rpc(
        'get_roster_with_availability',
        params: {'p_category_id': categoryId},
      );

      if (response is! List) {
        throw Exception('Respuesta inválida para roster con disponibilidad');
      }

      return response
          .map(
            (item) => RosterPlayerForActivityModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
    } on PostgrestException catch (e) {
      log(
        '❌ Postgrest error in getRosterWithAvailability for $categoryId: ${e.message} (code: ${e.code})',
      );
      rethrow;
    } catch (e) {
      log('❌ Error in getRosterWithAvailability for $categoryId: $e');
      throw Exception('Error al obtener plantel con disponibilidad: $e');
    }
  }
}
