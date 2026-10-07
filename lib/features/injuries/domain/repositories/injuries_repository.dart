import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/player_unavailability_entity.dart';

abstract class InjuriesRepository {
  Future<Either<Failure, List<PlayerUnavailabilityEntity>>> getPlayerUnavailabilities(
    String playerId,
  );
}
