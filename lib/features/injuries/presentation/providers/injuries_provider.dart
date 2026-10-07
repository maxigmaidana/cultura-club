import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../data/datasources/injuries_remote_datasource.dart';
import '../../data/repositories/injuries_repository_impl.dart';
import '../../domain/repositories/injuries_repository.dart';
import '../../domain/usecases/get_player_unavailabilities_usecase.dart';
import '../../domain/entities/player_unavailability_entity.dart';

part 'injuries_provider.g.dart';

@riverpod
InjuriesRemoteDataSource injuriesRemoteDataSource(Ref ref) {
  return InjuriesRemoteDataSourceImpl(ref.watch(supabaseProvider));
}

@riverpod
InjuriesRepository injuriesRepository(Ref ref) {
  return InjuriesRepositoryImpl(
    ref.watch(injuriesRemoteDataSourceProvider),
  );
}

@riverpod
GetPlayerUnavailabilitiesUseCase getPlayerUnavailabilitiesUseCase(Ref ref) {
  return GetPlayerUnavailabilitiesUseCase(ref.watch(injuriesRepositoryProvider));
}

@riverpod
Future<List<PlayerUnavailabilityEntity>> playerUnavailabilities(
  Ref ref,
  String playerId,
) async {
  final useCase = ref.watch(getPlayerUnavailabilitiesUseCaseProvider);
  final result = await useCase(playerId);
  return result.fold(
    (failure) => throw failure,
    (unavailabilities) => unavailabilities,
  );
}
