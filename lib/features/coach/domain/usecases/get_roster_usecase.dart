import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/player_profile_entity.dart';
import '../repositories/coach_repository.dart';

class GetRosterUseCase {
  final CoachRepository repository;
  GetRosterUseCase(this.repository);

  Future<Either<Failure, List<PlayerProfileEntity>>> call(String categoryId) {
    return repository.getRosterByCategory(categoryId);
  }
}