import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category_entity.dart';
import '../repositories/coach_repository.dart';

class GetCoachCategoriesUseCase {
  final CoachRepository repository;
  GetCoachCategoriesUseCase(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call(String coachId) {
    return repository.getCategoriesByCoach(coachId);
  }
}
