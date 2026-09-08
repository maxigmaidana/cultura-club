import 'package:fpdart/fpdart.dart';
import 'package:cultura_club/core/errors/failures.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements IUserRepository {
  final IUserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> getUserDetails(String userId) async {
    try {
      final userModel = await _remoteDataSource.getUserDetails(userId);
      return Right(userModel.toEntity());
    } catch (error) {
      return Left(
        ServerFailure('Error al obtener detalles del usuario: $error'),
      );
    }
  }
}
