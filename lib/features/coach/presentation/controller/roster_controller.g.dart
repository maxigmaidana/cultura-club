// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roster_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RosterController)
final rosterControllerProvider = RosterControllerProvider._();

final class RosterControllerProvider
    extends
        $AsyncNotifierProvider<RosterController, List<PlayerProfileEntity>> {
  RosterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rosterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rosterControllerHash();

  @$internal
  @override
  RosterController create() => RosterController();
}

String _$rosterControllerHash() => r'76eb6a3735d638447ce157cee4ca83073f5402dc';

abstract class _$RosterController
    extends $AsyncNotifier<List<PlayerProfileEntity>> {
  FutureOr<List<PlayerProfileEntity>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<PlayerProfileEntity>>,
              List<PlayerProfileEntity>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<PlayerProfileEntity>>,
                List<PlayerProfileEntity>
              >,
              AsyncValue<List<PlayerProfileEntity>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
