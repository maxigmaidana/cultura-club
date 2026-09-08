import 'package:fpdart/fpdart.dart';
import 'package:cultura_club/core/errors/failures.dart';
import '../entity/user_entity.dart';

abstract class IUserRepository {
  Future<Either<Failure, UserEntity>> getUserDetails(String userId);
}
