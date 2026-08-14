// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EvaluationController)
final evaluationControllerProvider = EvaluationControllerProvider._();

final class EvaluationControllerProvider
    extends $AsyncNotifierProvider<EvaluationController, void> {
  EvaluationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'evaluationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$evaluationControllerHash();

  @$internal
  @override
  EvaluationController create() => EvaluationController();
}

String _$evaluationControllerHash() =>
    r'079f34431f69b3a68b61f3cde1728d11cd3a0f85';

abstract class _$EvaluationController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
