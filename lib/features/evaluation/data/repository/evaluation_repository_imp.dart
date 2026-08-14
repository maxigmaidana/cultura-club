import 'package:cultura_club/features/evaluation/data/datasource/evaluation_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/evaluation_entity.dart';
import '../../domain/entities/player_stats_entity.dart';
import '../../domain/repositories/evaluation_repository.dart';
import '../models/evaluation_model.dart';
import '../models/player_stats_model.dart';

class EvaluationRepositoryImpl implements EvaluationRepository {
  final EvaluationRemoteDataSource remoteDataSource;

  EvaluationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, PlayerStatsEntity>> getPlayerStats(
    String playerId,
    String categoryId,
  ) async {
    try {
      final stats = await remoteDataSource.getPlayerStats(playerId, categoryId);
      return Right(stats);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlayerStatsEntity>>> getAllStatsForPlayer(
    String playerId,
  ) async {
    try {
      final statsList = await remoteDataSource.getAllStatsForPlayer(playerId);
      return Right(statsList);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveEvaluation(
    EvaluationEntity delta,
    PlayerStatsEntity newStats,
  ) async {
    try {
      // Convertimos las Entidades a Modelos para poder usar toJson()
      final deltaModel = EvaluationModel(
        jugadorId: delta.jugadorId,
        categoriaId: delta.categoriaId,
        evaluadorId: delta.evaluadorId,
        fechaEvaluacion: delta.fechaEvaluacion,
        velocidad: delta.velocidad,
        resistencia: delta.resistencia,
        tecnica: delta.tecnica,
        tactica: delta.tactica,
        actitud: delta.actitud,
        asistencia: delta.asistencia,
        comentariosDt: delta.comentariosDt,
      );

      final statsModel = PlayerStatsModel(
        jugadorId: newStats.jugadorId,
        categoriaId: newStats.categoriaId,
        categoriaNombre: newStats.categoriaNombre,
        velocidad: newStats.velocidad,
        resistencia: newStats.resistencia,
        tecnica: newStats.tecnica,
        tactica: newStats.tactica,
        actitud: newStats.actitud,
        asistencia: newStats.asistencia,
      );

      await remoteDataSource.insertEvaluation(deltaModel, statsModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
