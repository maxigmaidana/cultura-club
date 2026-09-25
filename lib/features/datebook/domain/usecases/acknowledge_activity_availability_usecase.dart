import 'package:cultura_club/core/errors/failures.dart';
import 'package:cultura_club/features/datebook/domain/repository/datebook_repository.dart';
import 'package:fpdart/fpdart.dart';

class AcknowledgeActivityAvailabilityUseCase {
  final DatebookRepository repository;

  AcknowledgeActivityAvailabilityUseCase(this.repository);

  Future<Either<Failure, DateTime>> call(String activityId) {
    return repository.acknowledgeActivityAvailability(activityId);
  }
}
