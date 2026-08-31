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
}
