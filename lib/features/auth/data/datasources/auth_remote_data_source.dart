import 'dart:developer';

import 'package:cultura_club/core/enums/user_rol_enums.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../user/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Llama al endpoint de login
  /// Lanza una [AuthException] o [Exception] genérica en caso de error.
  Future<UserModel?> login(String email, String password);
  Future<UserModel?> restoreSession();
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final supabase.SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel?> login(String email, String password) async {
    try {
      log(
        '📡 REQUEST | service: auth | action: signInWithPassword | '
        'parameters: email = $email',
        name: 'Supabase',
      );

      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      log(
        '✅ RESPONSE | service: auth | action: signInWithPassword | '
        'userId: ${response.user?.id}',
        name: 'Supabase',
      );

      final user = response.user;
      if (user == null) {
        throw const supabase.AuthException(
          'Error desconocido: el usuario es nulo.',
        );
      }

      try {
        log(
          '📡 REQUEST | table: usuarios | action: select | filters: id = ${user.id}',
          name: 'Supabase',
        );

        final userData = await supabaseClient
            .from('usuarios')
            .select('club_id, rol, nombre_completo')
            .eq('id', user.id)
            .maybeSingle();

        log(
          '✅ RESPONSE | table: usuarios | action: select | '
          'records: ${userData == null ? 0 : 1}',
          name: 'Supabase',
        );

        if (userData == null) {
          return null;
        }

        return UserModel(
          id: user.id,
          email: user.email ?? '',
          clubId: userData['club_id'] ?? '',
          role: UserRole.fromString(userData['rol'] ?? 'JUGADOR'),
          fullName: userData['nombre_completo'] ?? 'Usuario',
        );
      } catch (error, stackTrace) {
        log(
          '❌ ERROR | table: usuarios | action: select | error: $error',
          name: 'Supabase',
          error: error,
          stackTrace: stackTrace,
        );
        return null;
      }
    } catch (error, stackTrace) {
      log(
        '❌ ERROR | service: auth | action: signInWithPassword | error: $error',
        name: 'Supabase',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<UserModel?> restoreSession() async {
    final session = supabaseClient.auth.currentSession;
    if (session == null) return null;

    final user = session.user;
    try {
      log(
        '📡 REQUEST | table: usuarios | action: select | filters: id = ${user.id}',
        name: 'Supabase',
      );

      final userData = await supabaseClient
          .from('usuarios')
          .select('club_id, rol, nombre_completo')
          .eq('id', user.id)
          .maybeSingle();

      log(
        '✅ RESPONSE | table: usuarios | action: select | '
        'records: ${userData == null ? 0 : 1}',
        name: 'Supabase',
      );

      if (userData == null) {
        return null;
      }

      return UserModel(
        id: user.id,
        email: user.email ?? '',
        clubId: userData['club_id'] ?? '',
        role: UserRole.fromString(userData['rol'] ?? 'JUGADOR'),
        fullName: userData['nombre_completo'] ?? 'Usuario',
      );
    } catch (error, stackTrace) {
      log(
        '❌ ERROR | table: usuarios | action: select | error: $error',
        name: 'Supabase',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      log(
        '📡 REQUEST | service: auth | action: signOut | parameters: none',
        name: 'Supabase',
      );

      await supabaseClient.auth.signOut();

      log(
        '✅ RESPONSE | service: auth | action: signOut | completed',
        name: 'Supabase',
      );
    } catch (error, stackTrace) {
      log(
        '❌ ERROR | service: auth | action: signOut | error: $error',
        name: 'Supabase',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
