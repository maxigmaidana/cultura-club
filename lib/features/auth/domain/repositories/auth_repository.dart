import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../user/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity?>> restoreSession();
  Future<Either<Failure, void>> signOut();
}