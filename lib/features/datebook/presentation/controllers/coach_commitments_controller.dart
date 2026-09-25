import 'package:cultura_club/features/datebook/domain/entities/coach_commitment_entity.dart';
import 'package:cultura_club/features/datebook/presentation/providers/datebook_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coach_commitments_controller.g.dart';

@riverpod
class CoachCommitmentsController extends _$CoachCommitmentsController {
  Future<List<CoachCommitmentEntity>> _fetchCommitments() async {
    final useCase = ref.read(
      getCoachCommitmentsWithAvailabilityUseCaseProvider,
    );
    final result = await useCase(from: DateTime.now(), limit: 200);

    return result.fold((failure) => throw Exception(failure.message), (
      commitments,
    ) {
      final sorted = List<CoachCommitmentEntity>.from(commitments)
        ..sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
      return sorted;
    });
  }

  @override
  FutureOr<List<CoachCommitmentEntity>> build() async {
    return _fetchCommitments();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchCommitments);
  }
}
