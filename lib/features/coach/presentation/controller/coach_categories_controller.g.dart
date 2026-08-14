// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_categories_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CoachCategoriesController)
final coachCategoriesControllerProvider = CoachCategoriesControllerProvider._();

final class CoachCategoriesControllerProvider
    extends
        $AsyncNotifierProvider<
          CoachCategoriesController,
          List<CategoryEntity>
        > {
  CoachCategoriesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coachCategoriesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coachCategoriesControllerHash();

  @$internal
  @override
  CoachCategoriesController create() => CoachCategoriesController();
}

String _$coachCategoriesControllerHash() =>
    r'8939a45b5565d949ddc42cac7fa0bc5e72ac9713';

abstract class _$CoachCategoriesController
    extends $AsyncNotifier<List<CategoryEntity>> {
  FutureOr<List<CategoryEntity>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<CategoryEntity>>, List<CategoryEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<CategoryEntity>>,
                List<CategoryEntity>
              >,
              AsyncValue<List<CategoryEntity>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
