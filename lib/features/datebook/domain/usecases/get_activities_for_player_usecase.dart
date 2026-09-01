import 'package:cultura_club/core/errors/failures.dart';
import 'package:cultura_club/features/datebook/domain/repository/datebook_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../entities/activity_entity.dart';

class GetActivitiesForPlayerUseCase {
  final DatebookRepository repository;

  GetActivitiesForPlayerUseCase(this.repository);

  Future<Either<Failure, List<ActivityEntity>>> call(String jugadorId) {
    return repository.getActivitiesForPlayer(jugadorId);
  }
}
