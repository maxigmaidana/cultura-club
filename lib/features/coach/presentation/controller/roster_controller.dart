// Este provider trae la lista de jugadores de forma asíncrona
import 'package:cultura_club/features/coach/domain/entities/player_profile_entity.dart';
import 'package:cultura_club/features/coach/presentation/providers/coach_provider.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'roster_controller.g.dart';

@riverpod
class RosterController extends _$RosterController {
  @override
  FutureOr<List<PlayerProfileEntity>> build() async {
    // 1. Obtenemos el ID del DT logueado desde el core
    final currentUser = ref.watch(userSessionProvider).value;
    if (currentUser == null) throw Exception('Usuario no autenticado');

    // 2. Ejecutamos el caso de uso
    final useCase = ref.watch(getRosterUseCaseProvider);
    final result = await useCase(currentUser.id);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (roster) => roster,
    );
  }
}