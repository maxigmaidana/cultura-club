import 'package:cultura_club/features/auth/presentation/providers/auth_provider.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<bool> login(String email, String password) async {
    // Ponemos el estado en "Cargando" (AsyncLoading)
    state = const AsyncLoading();

    // Inyectamos el Caso de Uso que armamos antes
    final loginUseCase = ref.read(loginUseCaseProvider);

    // Ejecutamos el login
    final result = await loginUseCase(email, password);

    // Usamos el fold de fpdart para manejar el Left (Error) y el Right (Éxito)
    return result.fold(
      (failure) {
        // Si falla, guardamos el error en el estado
        state = AsyncError(failure.message, StackTrace.current);
        return false;
      },
      (user) {
        // Si es exitoso, volvemos a estado normal (data)
        ref.read(userSessionProvider.notifier).setUser(user);
        state = const AsyncData(null);
        return true;
      },
    );
  }
}