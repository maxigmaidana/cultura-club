import 'package:cultura_club/features/coach/domain/entities/category_entity.dart';
import 'package:cultura_club/features/coach/presentation/providers/coach_provider.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coach_categories_controller.g.dart';

@riverpod
class CoachCategoriesController extends _$CoachCategoriesController {
  @override
  FutureOr<List<CategoryEntity>> build() async {
    // 1. Obtenemos el ID del DT logueado desde el core
    final currentUser = ref.watch(userSessionProvider).value;
    if (currentUser == null) throw Exception('Usuario no autenticado');

    // 2. Ejecutamos el caso de uso
    final useCase = ref.watch(getCoachCategoriesUseCaseProvider);
    final result = await useCase(currentUser.id);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (categories) => categories,
    );
  }
}
