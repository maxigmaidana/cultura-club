import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/player_unavailability_entity.dart';
import '../../domain/repositories/injuries_repository.dart';
import '../datasources/injuries_remote_datasource.dart';

class InjuriesRepositoryImpl implements InjuriesRepository {
  final InjuriesRemoteDataSource remoteDataSource;

  InjuriesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PlayerUnavailabilityEntity>>>
  getPlayerUnavailabilities(String playerId) async {
    try {
      final unavailabilities = await remoteDataSource.getPlayerUnavailabilities(
        playerId,
      );
      return Right(unavailabilities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
