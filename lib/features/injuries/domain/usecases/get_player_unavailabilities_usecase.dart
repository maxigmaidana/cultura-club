import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/player_unavailability_entity.dart';
import '../repositories/injuries_repository.dart';

class GetPlayerUnavailabilitiesUseCase {
  final InjuriesRepository repository;

  GetPlayerUnavailabilitiesUseCase(this.repository);

  Future<Either<Failure, List<PlayerUnavailabilityEntity>>> call(
    String playerId,
  ) {
    return repository.getPlayerUnavailabilities(playerId);
  }
}
