import 'package:cultura_club/features/evaluation/presentation/providers/evaluation_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/evaluation_entity.dart';
import '../../domain/entities/player_stats_entity.dart';

part 'evaluation_controller.g.dart';

// AsyncNotifier con <void> es ideal para disparar acciones (side effects) como un INSERT
@riverpod
class EvaluationController extends _$EvaluationController {
  @override
  FutureOr<void> build() {
    // Estado inicial: no hace nada
  }

  Future<void> submitEvaluation(
    EvaluationEntity delta,
    PlayerStatsEntity newStats,
  ) async {
    // Ponemos la UI en estado de carga
    state = const AsyncValue.loading();

    final useCase = ref.read(saveEvaluationUseCaseProvider);
    final result = await useCase(delta, newStats);

    // Actualizamos el estado dependiendo de si falló o fue exitoso
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) => state = const AsyncValue.data(null),
    );
  }
}
