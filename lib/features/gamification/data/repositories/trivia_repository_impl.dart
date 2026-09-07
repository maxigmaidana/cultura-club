import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/trivia_entity.dart';
import '../../domain/repositories/trivia_repository.dart';
import '../datasources/trivia_remote_data_source.dart';

class TriviaRepositoryImpl implements ITriviaRepository {
  final TriviaRemoteDataSource remoteDataSource;

  TriviaRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<TriviaEntity>>> getPendingTrivias(
    String jugadorId,
  ) async {
    try {
      final trivias = await remoteDataSource.getPendingTrivias(jugadorId);
      return Right(trivias);
    } catch (error) {
      return Left(
        ServerFailure(
          'Error al obtener trivias pendientes: $error',
          code: 'FETCH_PENDING_TRIVIAS_ERROR',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<CompletedTriviaInfo>>> getCompletedTrivias(
    String jugadorId,
  ) async {
    try {
      final completed = await remoteDataSource.getCompletedTrivias(jugadorId);
      return Right(completed);
    } catch (error) {
      return Left(
        ServerFailure(
          'Error al obtener trivias completadas: $error',
          code: 'FETCH_COMPLETED_TRIVIAS_ERROR',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> submitTriviaAnswers(
    String triviaId,
    String jugadorId,
    List<RespuestaEntity> respuestas,
  ) async {
    try {
      final respuestasMap = respuestas
          .map(
            (r) => {
              'pregunta_id': r.preguntaId,
              'opcion_elegida_id': r.opcionElegidaId,
            },
          )
          .toList();

      await remoteDataSource.submitTriviaAnswers(
        triviaId,
        jugadorId,
        respuestasMap,
      );

      return const Right(null);
    } catch (error) {
      return Left(
        ServerFailure(
          'Error al enviar respuestas: $error',
          code: 'SUBMIT_ANSWERS_ERROR',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, int>> getTotalGameificationPoints(
    String jugadorId,
  ) async {
    try {
      final points = await remoteDataSource.getTotalGameificationPoints(
        jugadorId,
      );
      return Right(points);
    } catch (error) {
      return Left(
        ServerFailure(
          'Error al obtener puntos totales: $error',
          code: 'FETCH_POINTS_ERROR',
        ),
      );
    }
  }
}
