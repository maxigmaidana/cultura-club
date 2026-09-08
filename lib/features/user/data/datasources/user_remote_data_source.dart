import 'dart:developer' as dev;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

abstract class IUserRemoteDataSource {
  Future<UserModel> getUserDetails(String userId);
}

class UserRemoteDataSourceImpl implements IUserRemoteDataSource {
  final SupabaseClient _supabaseClient;

  UserRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<UserModel> getUserDetails(String userId) async {
    try {
      dev.log(
        '📡 REQUEST | table: usuarios | action: select with profile join | filters: id = $userId',
        name: 'Supabase',
      );

      final userData = await _supabaseClient
          .from('usuarios')
          .select(
            'id, club_id, rol, nombre_completo, email, jugadores_perfil(usuario_id, categoria_id, foto_url, fecha_nacimiento, pierna_habil, posiciones, altura_cm, peso_kg, categorias(id, nombre))',
          )
          .eq('id', userId)
          .maybeSingle();

      dev.log(
        '✅ RESPONSE | table: usuarios | action: select with profile join | records: ${userData == null ? 0 : 1}',
        name: 'Supabase',
      );

      if (userData == null) {
        throw const PostgrestException(
          message: 'Usuario no encontrado',
          code: '404',
          details: 'No se encontró registro en la tabla usuarios',
        );
      }

      // Si es entrenador, traer también las categorías asignadas
      final String? rol = userData['rol'] as String?;
      if (rol == 'ENTRENADOR') {
        dev.log(
          '📡 REQUEST | table: categorias | action: select | filters: entrenador_id = $userId',
          name: 'Supabase',
        );

        final categories = await _supabaseClient
            .from('categorias')
            .select('id, club_id, nombre, entrenador_id')
            .eq('entrenador_id', userId);

        dev.log(
          '✅ RESPONSE | table: categorias | action: select | records: ${(categories as List<dynamic>).length}',
          name: 'Supabase',
        );

        // Agregar categorías al userData
        userData['categorias'] = categories;
      }

      // Mapear a UserModel (incluye playerProfile si es jugador, o coachCategories si es entrenador)
      return UserModel.fromJson(userData);
    } catch (error, stackTrace) {
      dev.log(
        '❌ ERROR | table: usuarios | action: select with profile join | error: $error',
        name: 'Supabase',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
