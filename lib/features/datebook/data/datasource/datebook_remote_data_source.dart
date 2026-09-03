import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/activity_model.dart';

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
    String? imagenUrl,
    List<String> jugadorIds = const [],
  });

  Future<void> updateActivity({
    required String actividadId,
    required String tipo,
    required String titulo,
    required DateTime fechaHora,
    String? lugar,
    String? indicaciones,
    String? imagenUrl,
  });

  Future<List<ActivityModel>> getActivitiesForPlayer(String jugadorId);
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
    String? imagenUrl,
    List<String> jugadorIds = const [],
  }) async {
    try {
      log('📡 Creating activity: $titulo for category: $categoriaId');
      final inserted = await supabase
          .from('actividades')
          .insert({
            'categoria_id': categoriaId,
            'creador_id': creadorId,
            'tipo': tipo,
            'titulo': titulo,
            'fecha_hora': fechaHora.toUtc().toIso8601String(),
            'lugar': lugar,
            'indicaciones': indicaciones,
            'imagen_url': imagenUrl,
            'estado': 'publicada',
          })
          .select('id')
          .single();
      log('✅ Activity created.');

      if (jugadorIds.isNotEmpty) {
        final actividadId = inserted['id'] as String;
        log(
          '📡 Creating ${jugadorIds.length} citaciones for activity: $actividadId',
        );
        await supabase
            .from('citaciones')
            .insert(
              jugadorIds
                  .map(
                    (jugadorId) => {
                      'actividad_id': actividadId,
                      'jugador_id': jugadorId,
                      'estado_respuesta': 'pendiente',
                    },
                  )
                  .toList(),
            );
        log('✅ Citaciones created.');
      }
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
    String? imagenUrl,
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
            'imagen_url': imagenUrl,
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
}
