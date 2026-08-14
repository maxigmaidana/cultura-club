// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayerDashboardController)
final playerDashboardControllerProvider = PlayerDashboardControllerProvider._();

final class PlayerDashboardControllerProvider
    extends
        $AsyncNotifierProvider<
          PlayerDashboardController,
          List<PlayerStatsEntity>
        > {
  PlayerDashboardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerDashboardControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerDashboardControllerHash();

  @$internal
  @override
  PlayerDashboardController create() => PlayerDashboardController();
}

String _$playerDashboardControllerHash() =>
    r'd066bea21bdd3ed3ad1df50da8eafbb5c8dd9e72';

abstract class _$PlayerDashboardController
    extends $AsyncNotifier<List<PlayerStatsEntity>> {
  FutureOr<List<PlayerStatsEntity>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<PlayerStatsEntity>>,
              List<PlayerStatsEntity>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<PlayerStatsEntity>>,
                List<PlayerStatsEntity>
              >,
              AsyncValue<List<PlayerStatsEntity>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
