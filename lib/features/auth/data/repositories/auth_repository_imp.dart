import 'package:cultura_club/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/errors/failures.dart';
import '../../../user/domain/entity/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  // Ahora inyectamos el Data Source, no el cliente de Supabase
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      // 1. Pedimos los datos al Data Source
      final userModel = await remoteDataSource.login(email, password);

      if (userModel == null) {
        return Left(AuthFailure('No se pudo iniciar sesión. Usuario no encontrado.'));
      }
      
      // 2. Si todo sale bien, retornamos la Entidad pura al Caso de Uso
      return Right(userModel.toEntity());

    } on supabase.AuthException catch (e) {
      // 3. Atrapamos errores conocidos del Data Source actual (Supabase)
      return Left(AuthFailure(e.message, code: e.statusCode));
    } catch (e) {
      // 4. Atrapamos cualquier otro error inesperado
      return Left(ServerFailure(e.toString()));
    }
  }

  // Agregamos la implementación al repositorio
  @override
  Future<Either<Failure, UserEntity?>> restoreSession() async {
    try {
      final userModel = await remoteDataSource.restoreSession();
      return Right(userModel?.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}