// Este provider trae la lista de jugadores de una categoría específica
import 'package:cultura_club/features/coach/domain/entities/player_profile_entity.dart';
import 'package:cultura_club/features/coach/presentation/providers/coach_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'roster_controller.g.dart';

@riverpod
class RosterController extends _$RosterController {
  @override
  FutureOr<List<PlayerProfileEntity>> build(String categoryId) async {
    // Ejecutamos el caso de uso con el categoryId recibido
    final useCase = ref.watch(getRosterUseCaseProvider);
    final result = await useCase(categoryId);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (roster) => roster,
    );
  }
}
