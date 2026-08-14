
import 'package:cultura_club/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:cultura_club/features/auth/presentation/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'restore_session_usecase_provider.g.dart';


@riverpod
RestoreSessionUseCase restoreSessionUseCase(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RestoreSessionUseCase(repository);
}