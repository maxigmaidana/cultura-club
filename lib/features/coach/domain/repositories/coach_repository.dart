import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category_entity.dart';
import '../entities/player_profile_entity.dart';

abstract class CoachRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategoriesByCoach(
    String coachId,
  );
  Future<Either<Failure, List<PlayerProfileEntity>>> getRosterByCategory(
    String categoryId,
  );
}
