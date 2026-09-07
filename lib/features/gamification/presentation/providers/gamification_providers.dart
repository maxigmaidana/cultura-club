import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/supabase_provider.dart';
import '../../data/datasources/trivia_remote_data_source.dart';
import '../../data/repositories/trivia_repository_impl.dart';
import '../../domain/entities/trivia_entity.dart';
import '../../domain/repositories/trivia_repository.dart';
import '../../domain/usecases/trivia_usecases.dart';

part 'gamification_providers.g.dart';

/// Datasource Provider
@riverpod
TriviaRemoteDataSource triviaRemoteDataSource(Ref ref) {
  final supabaseClient = ref.watch(supabaseProvider);
  return TriviaRemoteDataSourceImpl(supabaseClient);
}

/// Repository Provider
@riverpod
ITriviaRepository triviaRepository(Ref ref) {
  final dataSource = ref.watch(triviaRemoteDataSourceProvider);
  return TriviaRepositoryImpl(dataSource);
}

/// Use Cases Providers
@riverpod
GetPendingTriviasUseCase getPendingTriviasUseCase(Ref ref) {
  final repository = ref.watch(triviaRepositoryProvider);
  return GetPendingTriviasUseCase(repository);
}

@riverpod
GetCompletedTriviasUseCase getCompletedTriviasUseCase(Ref ref) {
  final repository = ref.watch(triviaRepositoryProvider);
  return GetCompletedTriviasUseCase(repository);
}

@riverpod
SubmitTriviaAnswersUseCase submitTriviaAnswersUseCase(Ref ref) {
  final repository = ref.watch(triviaRepositoryProvider);
  return SubmitTriviaAnswersUseCase(repository);
}

@riverpod
GetTotalGameificationPointsUseCase getTotalGameificationPointsUseCase(Ref ref) {
  final repository = ref.watch(triviaRepositoryProvider);
  return GetTotalGameificationPointsUseCase(repository);
}

/// Async Providers (Family para múltiples jugadores)
@riverpod
Future<List<TriviaEntity>> pendingTrivias(Ref ref, String jugadorId) async {
  final useCase = ref.watch(getPendingTriviasUseCaseProvider);
  final result = await useCase(jugadorId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (trivias) => trivias,
  );
}

@riverpod
Future<List<CompletedTriviaInfo>> completedTrivias(
  Ref ref,
  String jugadorId,
) async {
  final useCase = ref.watch(getCompletedTriviasUseCaseProvider);
  final result = await useCase(jugadorId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (trivias) => trivias,
  );
}

@riverpod
Future<int> totalGameificationPoints(Ref ref, String jugadorId) async {
  final useCase = ref.watch(getTotalGameificationPointsUseCaseProvider);
  final result = await useCase(jugadorId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (points) => points,
  );
}
