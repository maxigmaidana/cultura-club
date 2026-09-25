import 'package:cultura_club/core/errors/failures.dart';
import 'package:cultura_club/features/datebook/domain/entities/activity_citation_availability_entity.dart';
import 'package:cultura_club/features/datebook/domain/repository/datebook_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetActivityCitationsWithAvailabilityUseCase {
  final DatebookRepository repository;

  GetActivityCitationsWithAvailabilityUseCase(this.repository);

  Future<Either<Failure, List<ActivityCitationAvailabilityEntity>>> call(
    String activityId,
  ) {
    return repository.getActivityCitationsWithAvailability(activityId);
  }
}
