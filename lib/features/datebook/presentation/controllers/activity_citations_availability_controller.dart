import 'package:cultura_club/features/datebook/domain/entities/activity_citation_availability_entity.dart';
import 'package:cultura_club/features/datebook/presentation/controllers/coach_commitments_controller.dart';
import 'package:cultura_club/features/datebook/presentation/notifier/datebook_notifier.dart';
import 'package:cultura_club/features/datebook/presentation/providers/datebook_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_citations_availability_controller.g.dart';

@riverpod
class ActivityCitationsAvailabilityController
    extends _$ActivityCitationsAvailabilityController {
  Future<List<ActivityCitationAvailabilityEntity>> _fetch() async {
    final useCase = ref.read(
      getActivityCitationsWithAvailabilityUseCaseProvider,
    );
    final result = await useCase(activityId);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (citations) => citations,
    );
  }

  @override
  FutureOr<List<ActivityCitationAvailabilityEntity>> build(
    String activityId,
  ) async {
    return _fetch();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> acknowledgeAvailability({String? categoriaId}) async {
    final useCase = ref.read(acknowledgeActivityAvailabilityUseCaseProvider);
    final result = await useCase(activityId);

    result.fold((failure) => throw Exception(failure.message), (_) {
      if (categoriaId != null) {
        ref.invalidate(datebookProvider(categoriaId));
      }
      ref.invalidate(coachCommitmentsControllerProvider);
      ref.invalidateSelf();
    });
  }
}
