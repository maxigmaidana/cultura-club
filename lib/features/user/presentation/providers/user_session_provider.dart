import 'package:cultura_club/features/auth/presentation/providers/restore_session_usecase_provider.dart';
import 'package:cultura_club/features/user/domain/entity/user_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_session_provider.g.dart';

@Riverpod(keepAlive: true)
class UserSession extends _$UserSession {
  @override
  FutureOr<UserEntity?> build() async {
    // Al inicializarse, busca si hay una sesión guardada
    final restoreSession = ref.watch(restoreSessionUseCaseProvider);
    final result = await restoreSession();
    
    return result.fold(
      (failure) => null, // Si falla, no hay usuario
      (user) => user,    // Si hay token válido, devuelve el usuario
    );
  }

  void setUser(UserEntity user) {
    state = AsyncData(user);
  }

  void clearUser() {
    state = const AsyncData(null);
  }
}