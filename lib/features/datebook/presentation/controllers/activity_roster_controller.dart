import 'package:cultura_club/features/datebook/domain/entities/roster_player_for_activity_entity.dart';
import 'package:cultura_club/features/datebook/presentation/providers/datebook_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_roster_controller.g.dart';

@riverpod
class ActivityRosterController extends _$ActivityRosterController {
  Future<List<RosterPlayerForActivityEntity>> _fetchRoster() async {
    final useCase = ref.read(getRosterWithAvailabilityUseCaseProvider);
    final result = await useCase(categoriaId);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (roster) => roster,
    );
  }

  @override
  FutureOr<List<RosterPlayerForActivityEntity>> build(
    String categoriaId,
  ) async {
    return _fetchRoster();
  }

  Future<void> retry() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchRoster);
  }
}
