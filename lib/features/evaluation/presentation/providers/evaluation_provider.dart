import 'package:cultura_club/features/evaluation/data/datasource/evaluation_remote_data_source.dart';
import 'package:cultura_club/features/evaluation/data/repository/evaluation_repository_imp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../domain/repositories/evaluation_repository.dart';
import '../../domain/usecases/save_evaluation_usecase.dart';

part 'evaluation_provider.g.dart';

@riverpod
EvaluationRemoteDataSource evaluationRemoteDataSource(Ref ref) {
  return EvaluationRemoteDataSourceImpl(ref.watch(supabaseProvider));
}

@riverpod
EvaluationRepository evaluationRepository(Ref ref) {
  return EvaluationRepositoryImpl(ref.watch(evaluationRemoteDataSourceProvider));
}

@riverpod
SaveEvaluationUseCase saveEvaluationUseCase(Ref ref) {
  return SaveEvaluationUseCase(ref.watch(evaluationRepositoryProvider));
}