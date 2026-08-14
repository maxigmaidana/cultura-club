import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/evaluation_entity.dart';

abstract class EvaluationRepository {
  Future<Either<Failure, void>> saveEvaluation(EvaluationEntity evaluation);
}