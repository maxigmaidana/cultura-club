import 'package:cultura_club/core/errors/failures.dart';
import 'package:cultura_club/features/datebook/domain/repository/datebook_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateActivityUseCase {
  final DatebookRepository repository;

  UpdateActivityUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String actividadId,
    required String tipo,
    required String titulo,
    required DateTime fechaHora,
    String? lugar,
    String? indicaciones,
    String? imagenUrl,
  }) {
    return repository.updateActivity(
      actividadId: actividadId,
      tipo: tipo,
      titulo: titulo,
      fechaHora: fechaHora,
      lugar: lugar,
      indicaciones: indicaciones,
      imagenUrl: imagenUrl,
    );
  }
}
