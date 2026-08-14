import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/evaluation_entity.dart';
import '../entities/player_stats_entity.dart';

abstract class EvaluationRepository {
  Future<Either<Failure, PlayerStatsEntity>> getPlayerStats(
    String playerId,
    String categoryId,
  );
  Future<Either<Failure, List<PlayerStatsEntity>>> getAllStatsForPlayer(
    String playerId,
  );
  Future<Either<Failure, void>> saveEvaluation(
    EvaluationEntity delta,
    PlayerStatsEntity newStats,
  );
}
