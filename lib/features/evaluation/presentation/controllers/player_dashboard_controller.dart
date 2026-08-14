import 'package:cultura_club/features/evaluation/domain/entities/player_stats_entity.dart';
import 'package:cultura_club/features/evaluation/presentation/providers/evaluation_provider.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_dashboard_controller.g.dart';

@riverpod
class PlayerDashboardController extends _$PlayerDashboardController {
  @override
  FutureOr<List<PlayerStatsEntity>> build() async {
    // Obtenemos el ID del jugador logueado
    final currentUser = ref.watch(userSessionProvider).value;
    if (currentUser == null) throw Exception('Usuario no autenticado');

    // Ejecutamos el caso de uso para obtener todas las stats del jugador
    final useCase = ref.watch(getAllPlayerStatsUseCaseProvider);
    final result = await useCase(currentUser.id);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (statsList) => statsList,
    );
  }
}
