import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/trivia_entity.dart';

abstract class ITriviaRepository {
  /// Obtiene las trivias pendientes para un jugador (que aún no ha respondido)
  Future<Either<Failure, List<TriviaEntity>>> getPendingTrivias(
    String jugadorId,
  );

  /// Obtiene las trivias completadas por el jugador con sus puntos
  Future<Either<Failure, List<CompletedTriviaInfo>>> getCompletedTrivias(
    String jugadorId,
  );

  /// Envía las respuestas de una trivia
  Future<Either<Failure, void>> submitTriviaAnswers(
    String triviaId,
    String jugadorId,
    List<RespuestaEntity> respuestas,
  );

  /// Obtiene los puntos totales del jugador en trivias
  Future<Either<Failure, int>> getTotalGameificationPoints(String jugadorId);
}

class CompletedTriviaInfo {
  final String triviaId;
  final String titulo;
  final int puntosObtenidos;
  final DateTime respondidoAt;

  CompletedTriviaInfo({
    required this.triviaId,
    required this.titulo,
    required this.puntosObtenidos,
    required this.respondidoAt,
  });
}
