import 'package:cultura_club/features/datebook/data/datasource/datebook_remote_data_source.dart';
import 'package:cultura_club/features/datebook/data/repository/databook_repository_impl.dart';
import 'package:cultura_club/features/datebook/domain/repository/datebook_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../domain/usecases/get_datebook_by_category_usecase.dart';
import '../../domain/usecases/respond_to_citation_usecase.dart';
import '../../domain/usecases/create_activity_usecase.dart';
import '../../domain/usecases/update_activity_usecase.dart';
import '../../domain/usecases/get_activities_for_player_usecase.dart';

part 'datebook_providers.g.dart';

@riverpod
DatebookRemoteDataSource datebookRemoteDataSource(Ref ref) {
  final supabase = ref.watch(supabaseProvider);
  return DatebookRemoteDataSourceImpl(supabase);
}

@riverpod
DatebookRepository datebookRepository(Ref ref) {
  final remoteDataSource = ref.watch(datebookRemoteDataSourceProvider);
  return DatebookRepositoryImpl(remoteDataSource);
}

@riverpod
GetDatebookByCategoryUseCase getActivitiesByCategoryUseCase(Ref ref) {
  final repository = ref.watch(datebookRepositoryProvider);
  return GetDatebookByCategoryUseCase(repository);
}

@riverpod
RespondToCitationUseCase respondToCitationUseCase(Ref ref) {
  final repository = ref.watch(datebookRepositoryProvider);
  return RespondToCitationUseCase(repository);
}

@riverpod
CreateActivityUseCase createActivityUseCase(Ref ref) {
  final repository = ref.watch(datebookRepositoryProvider);
  return CreateActivityUseCase(repository);
}

@riverpod
UpdateActivityUseCase updateActivityUseCase(Ref ref) {
  final repository = ref.watch(datebookRepositoryProvider);
  return UpdateActivityUseCase(repository);
}

@riverpod
GetActivitiesForPlayerUseCase getActivitiesForPlayerUseCase(Ref ref) {
  final repository = ref.watch(datebookRepositoryProvider);
  return GetActivitiesForPlayerUseCase(repository);
}
