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
    final response = await supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw const supabase.AuthException('Error desconocido: el usuario es nulo.');
    }

    try {
      final userData = await supabaseClient
          .from('usuarios')
          .select('club_id, rol, nombre_completo')
          .eq('id', user.id)
          .maybeSingle();

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
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserModel?> restoreSession() async {
    final session = supabaseClient.auth.currentSession;
    if (session == null) return null;

    final user = session.user;
    try {
      final userData = await supabaseClient
          .from('usuarios')
          .select('club_id, rol, nombre_completo')
          .eq('id', user.id)
          .maybeSingle();

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
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
}