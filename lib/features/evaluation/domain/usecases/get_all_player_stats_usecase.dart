import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/player_stats_entity.dart';
import '../repositories/evaluation_repository.dart';

class GetAllPlayerStatsUseCase {
  final EvaluationRepository repository;

  GetAllPlayerStatsUseCase(this.repository);

  Future<Either<Failure, List<PlayerStatsEntity>>> call(String playerId) {
    return repository.getAllStatsForPlayer(playerId);
  }
}
