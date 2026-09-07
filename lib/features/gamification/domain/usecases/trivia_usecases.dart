import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/trivia_entity.dart';
import '../repositories/trivia_repository.dart';

class GetPendingTriviasUseCase {
  final ITriviaRepository repository;

  GetPendingTriviasUseCase(this.repository);

  Future<Either<Failure, List<TriviaEntity>>> call(String jugadorId) async {
    return repository.getPendingTrivias(jugadorId);
  }
}

class GetCompletedTriviasUseCase {
  final ITriviaRepository repository;

  GetCompletedTriviasUseCase(this.repository);

  Future<Either<Failure, List<CompletedTriviaInfo>>> call(
    String jugadorId,
  ) async {
    return repository.getCompletedTrivias(jugadorId);
  }
}

class SubmitTriviaAnswersUseCase {
  final ITriviaRepository repository;

  SubmitTriviaAnswersUseCase(this.repository);

  Future<Either<Failure, void>> call(
    String triviaId,
    String jugadorId,
    List<RespuestaEntity> respuestas,
  ) async {
    return repository.submitTriviaAnswers(triviaId, jugadorId, respuestas);
  }
}

class GetTotalGameificationPointsUseCase {
  final ITriviaRepository repository;

  GetTotalGameificationPointsUseCase(this.repository);

  Future<Either<Failure, int>> call(String jugadorId) async {
    return repository.getTotalGameificationPoints(jugadorId);
  }
}
