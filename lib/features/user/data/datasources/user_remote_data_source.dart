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

      // Mapear a UserModel (incluye playerProfile si es jugador)
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
