// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_citations_availability_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActivityCitationsAvailabilityController)
final activityCitationsAvailabilityControllerProvider =
    ActivityCitationsAvailabilityControllerFamily._();

final class ActivityCitationsAvailabilityControllerProvider
    extends
        $AsyncNotifierProvider<
          ActivityCitationsAvailabilityController,
          List<ActivityCitationAvailabilityEntity>
        > {
  ActivityCitationsAvailabilityControllerProvider._({
    required ActivityCitationsAvailabilityControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activityCitationsAvailabilityControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$activityCitationsAvailabilityControllerHash();

  @override
  String toString() {
    return r'activityCitationsAvailabilityControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ActivityCitationsAvailabilityController create() =>
      ActivityCitationsAvailabilityController();

  @override
  bool operator ==(Object other) {
    return other is ActivityCitationsAvailabilityControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityCitationsAvailabilityControllerHash() =>
    r'b79cc023151b27c3954710c9f605a8639d5a2e16';

final class ActivityCitationsAvailabilityControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ActivityCitationsAvailabilityController,
          AsyncValue<List<ActivityCitationAvailabilityEntity>>,
          List<ActivityCitationAvailabilityEntity>,
          FutureOr<List<ActivityCitationAvailabilityEntity>>,
          String
        > {
  ActivityCitationsAvailabilityControllerFamily._()
    : super(
        retry: null,
        name: r'activityCitationsAvailabilityControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActivityCitationsAvailabilityControllerProvider call(String activityId) =>
      ActivityCitationsAvailabilityControllerProvider._(
        argument: activityId,
        from: this,
      );

  @override
  String toString() => r'activityCitationsAvailabilityControllerProvider';
}

abstract class _$ActivityCitationsAvailabilityController
    extends $AsyncNotifier<List<ActivityCitationAvailabilityEntity>> {
  late final _$args = ref.$arg as String;
  String get activityId => _$args;

  FutureOr<List<ActivityCitationAvailabilityEntity>> build(String activityId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ActivityCitationAvailabilityEntity>>,
              List<ActivityCitationAvailabilityEntity>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ActivityCitationAvailabilityEntity>>,
                List<ActivityCitationAvailabilityEntity>
              >,
              AsyncValue<List<ActivityCitationAvailabilityEntity>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
