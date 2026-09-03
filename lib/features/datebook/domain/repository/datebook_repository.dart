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
  Future<Either<Failure, void>> createActivity({
    required String categoriaId,
    required String creadorId,
    required String tipo,
    required String titulo,
    required DateTime fechaHora,
    String? lugar,
    String? indicaciones,
    String? imagenUrl,
    List<String> jugadorIds = const [],
  });
  Future<Either<Failure, void>> updateActivity({
    required String actividadId,
    required String tipo,
    required String titulo,
    required DateTime fechaHora,
    String? lugar,
    String? indicaciones,
    String? imagenUrl,
  });
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesForPlayer(
    String jugadorId,
  );
}
