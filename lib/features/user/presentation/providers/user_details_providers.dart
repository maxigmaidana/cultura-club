import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/supabase_provider.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_user_details_usecase.dart';

part 'user_details_providers.g.dart';

/// Datasource Provider
@riverpod
IUserRemoteDataSource userRemoteDataSource(Ref ref) {
  final supabaseClient = ref.watch(supabaseProvider);
  return UserRemoteDataSourceImpl(supabaseClient);
}

/// Repository Provider
@riverpod
IUserRepository userRepository(Ref ref) {
  final dataSource = ref.watch(userRemoteDataSourceProvider);
  return UserRepositoryImpl(dataSource);
}

/// Use Case Provider
@riverpod
GetUserDetailsUseCase getUserDetailsUseCase(Ref ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUserDetailsUseCase(repository);
}

/// Async Provider (Family para múltiples usuarios)
@riverpod
Future<UserEntity> userDetails(Ref ref, String userId) async {
  final useCase = ref.watch(getUserDetailsUseCaseProvider);
  final result = await useCase(userId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (user) => user,
  );
}
