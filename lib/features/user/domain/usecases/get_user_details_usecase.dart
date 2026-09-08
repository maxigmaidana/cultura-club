import 'package:fpdart/fpdart.dart';
import 'package:cultura_club/core/errors/failures.dart';
import '../entity/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUserDetailsUseCase {
  final IUserRepository _repository;

  GetUserDetailsUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(String userId) {
    return _repository.getUserDetails(userId);
  }
}
