import 'package:cultura_club/core/errors/failures.dart';
import 'package:cultura_club/features/datebook/domain/entities/roster_player_for_activity_entity.dart';
import 'package:cultura_club/features/datebook/domain/repository/datebook_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetRosterWithAvailabilityUseCase {
  final DatebookRepository repository;

  GetRosterWithAvailabilityUseCase(this.repository);

  Future<Either<Failure, List<RosterPlayerForActivityEntity>>> call(
    String categoryId,
  ) {
    return repository.getRosterWithAvailability(categoryId);
  }
}
