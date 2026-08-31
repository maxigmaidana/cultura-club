import 'package:cultura_club/core/errors/failures.dart';
import 'package:cultura_club/features/datebook/domain/repository/datebook_repository.dart';
import 'package:fpdart/fpdart.dart';

class RespondToCitationUseCase {
  final DatebookRepository repository;

  RespondToCitationUseCase(this.repository);

  Future<Either<Failure, void>> call(
    String actividadId,
    String jugadorId,
    String estadoRespuesta,
  ) {
    return repository.respondToCitation(
      actividadId,
      jugadorId,
      estadoRespuesta,
    );
  }
}
