import 'package:cultura_club/features/datebook/domain/entities/activity_entity.dart';
import 'package:cultura_club/features/datebook/presentation/providers/datebook_providers.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_agenda_controller.g.dart';

@riverpod
class MyAgendaController extends _$MyAgendaController {
  @override
  FutureOr<List<ActivityEntity>> build() async {
    return _fetchAgenda();
  }

  Future<List<ActivityEntity>> _fetchAgenda() async {
    final currentUser = ref.read(userSessionProvider).value;
    if (currentUser == null) throw Exception('Usuario no autenticado');

    final useCase = ref.read(getActivitiesForPlayerUseCaseProvider);
    final result = await useCase(currentUser.id);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (activities) => activities,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchAgenda);
  }
}
