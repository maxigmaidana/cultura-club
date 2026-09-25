// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_commitments_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CoachCommitmentsController)
final coachCommitmentsControllerProvider =
    CoachCommitmentsControllerProvider._();

final class CoachCommitmentsControllerProvider
    extends
        $AsyncNotifierProvider<
          CoachCommitmentsController,
          List<CoachCommitmentEntity>
        > {
  CoachCommitmentsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coachCommitmentsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coachCommitmentsControllerHash();

  @$internal
  @override
  CoachCommitmentsController create() => CoachCommitmentsController();
}

String _$coachCommitmentsControllerHash() =>
    r'3ac4dcae9839104c96f2e3d3fa7655dba4aacd9d';

abstract class _$CoachCommitmentsController
    extends $AsyncNotifier<List<CoachCommitmentEntity>> {
  FutureOr<List<CoachCommitmentEntity>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<CoachCommitmentEntity>>,
              List<CoachCommitmentEntity>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<CoachCommitmentEntity>>,
                List<CoachCommitmentEntity>
              >,
              AsyncValue<List<CoachCommitmentEntity>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
