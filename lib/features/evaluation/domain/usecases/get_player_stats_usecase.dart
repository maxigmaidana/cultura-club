import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/player_stats_entity.dart';
import '../repositories/evaluation_repository.dart';

class GetPlayerStatsUseCase {
  final EvaluationRepository repository;

  GetPlayerStatsUseCase(this.repository);

  Future<Either<Failure, PlayerStatsEntity>> call(
    String playerId,
    String categoryId,
  ) {
    return repository.getPlayerStats(playerId, categoryId);
  }
}
