import 'package:cultura_club/features/evaluation/domain/entities/player_stats_entity.dart';
import 'package:cultura_club/features/evaluation/presentation/providers/evaluation_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_stats_controller.g.dart';

@riverpod
class PlayerStatsController extends _$PlayerStatsController {
  @override
  FutureOr<PlayerStatsEntity> build(String playerId, String categoryId) async {
    // Forzamos siempre un fetch fresco de datos desde el datasource
    final useCase = ref.watch(getPlayerStatsUseCaseProvider);
    final result = await useCase(playerId, categoryId);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (stats) => stats,
    );
  }
}
