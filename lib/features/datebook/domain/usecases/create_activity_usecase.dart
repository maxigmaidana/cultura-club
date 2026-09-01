import 'package:cultura_club/core/errors/failures.dart';
import 'package:cultura_club/features/datebook/domain/repository/datebook_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateActivityUseCase {
  final DatebookRepository repository;

  CreateActivityUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String categoriaId,
    required String creadorId,
    required String tipo,
    required String titulo,
    required DateTime fechaHora,
    String? lugar,
    String? indicaciones,
    List<String> jugadorIds = const [],
  }) {
    return repository.createActivity(
      categoriaId: categoriaId,
      creadorId: creadorId,
      tipo: tipo,
      titulo: titulo,
      fechaHora: fechaHora,
      lugar: lugar,
      indicaciones: indicaciones,
      jugadorIds: jugadorIds,
    );
  }
}
