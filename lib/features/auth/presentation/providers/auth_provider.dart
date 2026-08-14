import 'package:cultura_club/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:cultura_club/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:cultura_club/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_provider.g.dart';

// 1. Inyectamos el Data Source (depende de Supabase)
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  final supabaseClient = ref.watch(supabaseProvider);
  return AuthRemoteDataSourceImpl(supabaseClient);
}

// 2. Inyectamos el Repositorio (depende del Data Source)
@riverpod
AuthRepository authRepository(Ref ref) {
  final dataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
}

// 3. Inyectamos el Caso de Uso (depende del Repositorio)
@riverpod
LoginUseCase loginUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
}

@riverpod
SignOutUseCase signOutUseCase(Ref ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
}
