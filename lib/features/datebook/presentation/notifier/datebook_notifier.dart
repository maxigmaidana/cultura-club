import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/activity_entity.dart';
import '../providers/datebook_providers.dart';

part 'datebook_notifier.g.dart';

@riverpod
class DatebookNotifier extends _$DatebookNotifier {
  @override
  FutureOr<List<ActivityEntity>> build(String categoriaId) async {
    return _fetchActivities();
  }

  Future<List<ActivityEntity>> _fetchActivities() async {
    final useCase = ref.read(getActivitiesByCategoryUseCaseProvider);
    final result = await useCase(categoriaId);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (activities) => activities,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchActivities());
  }
}
