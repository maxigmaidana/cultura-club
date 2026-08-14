import 'package:cultura_club/features/coach/data/datasource/coach_rempote_data_source.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/player_profile_entity.dart';
import '../../domain/repositories/coach_repository.dart';

class CoachRepositoryImpl implements CoachRepository {
  final CoachRemoteDataSource remoteDataSource;

  CoachRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PlayerProfileEntity>>> getRoster(String coachId) async {
    try {
      final roster = await remoteDataSource.getRoster(coachId);
      return Right(roster);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}