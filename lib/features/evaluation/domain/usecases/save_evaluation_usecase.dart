import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/evaluation_entity.dart';
import '../entities/player_stats_entity.dart';
import '../repositories/evaluation_repository.dart';

class SaveEvaluationUseCase {
  final EvaluationRepository repository;

  SaveEvaluationUseCase(this.repository);

  Future<Either<Failure, void>> call(
    EvaluationEntity delta,
    PlayerStatsEntity newStats,
  ) {
    return repository.saveEvaluation(delta, newStats);
  }
}
