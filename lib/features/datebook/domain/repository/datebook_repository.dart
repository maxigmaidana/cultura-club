import 'package:cultura_club/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';
import '../entities/activity_entity.dart';
import '../entities/activity_citation_availability_entity.dart';
import '../entities/coach_commitment_entity.dart';
import '../entities/roster_player_for_activity_entity.dart';

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
    List<String> jugadorIds = const [],
  });
  Future<Either<Failure, void>> updateActivity({
    required String actividadId,
    required String tipo,
    required String titulo,
    required DateTime fechaHora,
    String? lugar,
    String? indicaciones,
  });
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesForPlayer(
    String jugadorId,
  );
  Future<Either<Failure, List<RosterPlayerForActivityEntity>>>
  getRosterWithAvailability(String categoryId);
  Future<Either<Failure, List<CoachCommitmentEntity>>>
  getCoachCommitmentsWithAvailability({
    required DateTime from,
    required int limit,
  });
  Future<Either<Failure, List<ActivityCitationAvailabilityEntity>>>
  getActivityCitationsWithAvailability(String activityId);
  Future<Either<Failure, DateTime>> acknowledgeActivityAvailability(
    String activityId,
  );
}
