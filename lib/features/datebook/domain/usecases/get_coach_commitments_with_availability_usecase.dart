import 'package:cultura_club/core/errors/failures.dart';
import 'package:cultura_club/features/datebook/domain/entities/coach_commitment_entity.dart';
import 'package:cultura_club/features/datebook/domain/repository/datebook_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCoachCommitmentsWithAvailabilityUseCase {
  final DatebookRepository repository;

  GetCoachCommitmentsWithAvailabilityUseCase(this.repository);

  Future<Either<Failure, List<CoachCommitmentEntity>>> call({
    required DateTime from,
    required int limit,
  }) {
    return repository.getCoachCommitmentsWithAvailability(
      from: from,
      limit: limit,
    );
  }
}
