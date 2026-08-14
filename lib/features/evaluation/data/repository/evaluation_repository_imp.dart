import 'package:cultura_club/features/evaluation/data/datasource/evaluation_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/evaluation_entity.dart';
import '../../domain/repositories/evaluation_repository.dart';
import '../models/evaluation_model.dart';

class EvaluationRepositoryImpl implements EvaluationRepository {
  final EvaluationRemoteDataSource remoteDataSource;

  EvaluationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> saveEvaluation(EvaluationEntity evaluation) async {
    try {
      // Convertimos la Entidad a Modelo para poder usar toJson()
      final model = EvaluationModel(
        jugadorId: evaluation.jugadorId,
        evaluadorId: evaluation.evaluadorId,
        fechaEvaluacion: evaluation.fechaEvaluacion,
        velocidad: evaluation.velocidad,
        resistencia: evaluation.resistencia,
        tecnica: evaluation.tecnica,
        tactica: evaluation.tactica,
        actitud: evaluation.actitud,
        asistencia: evaluation.asistencia,
        comentariosDt: evaluation.comentariosDt,
      );

      await remoteDataSource.insertEvaluation(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}