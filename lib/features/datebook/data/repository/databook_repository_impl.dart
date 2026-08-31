import 'package:cultura_club/core/errors/failures.dart';
import 'package:cultura_club/features/datebook/domain/repository/datebook_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/activity_entity.dart';
import '../datasource/datebook_remote_data_source.dart';

class DatebookRepositoryImpl implements DatebookRepository {
  final DatebookRemoteDataSource remoteDataSource;

  DatebookRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesByCategory(
    String categoriaId,
  ) async {
    try {
      final activities = await remoteDataSource.getActivitiesByCategory(
        categoriaId,
      );
      return Right(activities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> respondToCitation(
    String actividadId,
    String jugadorId,
    String estadoRespuesta,
  ) async {
    try {
      await remoteDataSource.respondToCitation(
        actividadId,
        jugadorId,
        estadoRespuesta,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
