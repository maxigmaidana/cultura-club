import 'package:cultura_club/features/coach/data/datasource/coach_rempote_data_source.dart';
import 'package:cultura_club/features/coach/data/repositories/coach_repository_imp.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../domain/repositories/coach_repository.dart';
import '../../domain/usecases/get_roster_usecase.dart';

part 'coach_provider.g.dart';

@riverpod
CoachRemoteDataSource coachRemoteDataSource(Ref ref) {
  return CoachRemoteDataSourceImpl(ref.watch(supabaseProvider));
}

@riverpod
CoachRepository coachRepository(Ref ref) {
  return CoachRepositoryImpl(ref.watch(coachRemoteDataSourceProvider));
}

@riverpod
GetRosterUseCase getRosterUseCase(Ref ref) {
  return GetRosterUseCase(ref.watch(coachRepositoryProvider));
}
