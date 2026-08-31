import 'package:cultura_club/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';
import '../entities/activity_entity.dart';

abstract class DatebookRepository {
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesByCategory(
    String categoriaId,
  );
  Future<Either<Failure, void>> respondToCitation(
    String actividadId,
    String jugadorId,
    String estadoRespuesta,
  );
}
