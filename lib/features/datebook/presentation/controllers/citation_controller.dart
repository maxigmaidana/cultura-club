import 'package:cultura_club/features/datebook/presentation/controllers/my_agenda_controller.dart';
import 'package:cultura_club/features/datebook/presentation/notifier/datebook_notifier.dart';
import 'package:cultura_club/features/datebook/presentation/providers/datebook_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'citation_controller.g.dart';

@riverpod
class CitationController extends _$CitationController {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> respondToCitation({
    required String actividadId,
    required String jugadorId,
    required String estadoRespuesta,
    required String categoriaId,
  }) async {
    state = const AsyncLoading();

    final useCase = ref.read(respondToCitationUseCaseProvider);
    final result = await useCase(actividadId, jugadorId, estadoRespuesta);

    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (_) {
        ref.invalidate(datebookProvider(categoriaId));
        ref.invalidate(myAgendaControllerProvider);
        return const AsyncData(null);
      },
    );
  }
}
