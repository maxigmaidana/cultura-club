import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../user/domain/entity/user_entity.dart';
import '../repositories/auth_repository.dart';

class RestoreSessionUseCase {
  final AuthRepository repository;

  RestoreSessionUseCase(this.repository);

  Future<Either<Failure, UserEntity?>> call() async {
    return await repository.restoreSession();
  }
}