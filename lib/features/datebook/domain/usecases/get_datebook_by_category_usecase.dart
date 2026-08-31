import 'package:cultura_club/core/errors/failures.dart';
import 'package:cultura_club/features/datebook/domain/repository/datebook_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../entities/activity_entity.dart';

class GetDatebookByCategoryUseCase {
  final DatebookRepository repository;

  GetDatebookByCategoryUseCase(this.repository);

  Future<Either<Failure, List<ActivityEntity>>> call(String categoriaId) {
    return repository.getActivitiesByCategory(categoriaId);
  }
}
