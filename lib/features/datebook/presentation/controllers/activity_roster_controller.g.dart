// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_roster_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActivityRosterController)
final activityRosterControllerProvider = ActivityRosterControllerFamily._();

final class ActivityRosterControllerProvider
    extends
        $AsyncNotifierProvider<
          ActivityRosterController,
          List<RosterPlayerForActivityEntity>
        > {
  ActivityRosterControllerProvider._({
    required ActivityRosterControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activityRosterControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activityRosterControllerHash();

  @override
  String toString() {
    return r'activityRosterControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ActivityRosterController create() => ActivityRosterController();

  @override
  bool operator ==(Object other) {
    return other is ActivityRosterControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityRosterControllerHash() =>
    r'a536d8188317ee1b68d1b12e9bc250058c1013e1';

final class ActivityRosterControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ActivityRosterController,
          AsyncValue<List<RosterPlayerForActivityEntity>>,
          List<RosterPlayerForActivityEntity>,
          FutureOr<List<RosterPlayerForActivityEntity>>,
          String
        > {
  ActivityRosterControllerFamily._()
    : super(
        retry: null,
        name: r'activityRosterControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActivityRosterControllerProvider call(String categoriaId) =>
      ActivityRosterControllerProvider._(argument: categoriaId, from: this);

  @override
  String toString() => r'activityRosterControllerProvider';
}

abstract class _$ActivityRosterController
    extends $AsyncNotifier<List<RosterPlayerForActivityEntity>> {
  late final _$args = ref.$arg as String;
  String get categoriaId => _$args;

  FutureOr<List<RosterPlayerForActivityEntity>> build(String categoriaId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<RosterPlayerForActivityEntity>>,
              List<RosterPlayerForActivityEntity>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<RosterPlayerForActivityEntity>>,
                List<RosterPlayerForActivityEntity>
              >,
              AsyncValue<List<RosterPlayerForActivityEntity>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
