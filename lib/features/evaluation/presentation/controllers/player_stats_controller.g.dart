// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_stats_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayerStatsController)
final playerStatsControllerProvider = PlayerStatsControllerFamily._();

final class PlayerStatsControllerProvider
    extends $AsyncNotifierProvider<PlayerStatsController, PlayerStatsEntity> {
  PlayerStatsControllerProvider._({
    required PlayerStatsControllerFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'playerStatsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playerStatsControllerHash();

  @override
  String toString() {
    return r'playerStatsControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  PlayerStatsController create() => PlayerStatsController();

  @override
  bool operator ==(Object other) {
    return other is PlayerStatsControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playerStatsControllerHash() =>
    r'5db7646d74ef6389b902a63370dc3f95f52c8c94';

final class PlayerStatsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PlayerStatsController,
          AsyncValue<PlayerStatsEntity>,
          PlayerStatsEntity,
          FutureOr<PlayerStatsEntity>,
          (String, String)
        > {
  PlayerStatsControllerFamily._()
    : super(
        retry: null,
        name: r'playerStatsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlayerStatsControllerProvider call(String playerId, String categoryId) =>
      PlayerStatsControllerProvider._(
        argument: (playerId, categoryId),
        from: this,
      );

  @override
  String toString() => r'playerStatsControllerProvider';
}

abstract class _$PlayerStatsController
    extends $AsyncNotifier<PlayerStatsEntity> {
  late final _$args = ref.$arg as (String, String);
  String get playerId => _$args.$1;
  String get categoryId => _$args.$2;

  FutureOr<PlayerStatsEntity> build(String playerId, String categoryId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<PlayerStatsEntity>, PlayerStatsEntity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlayerStatsEntity>, PlayerStatsEntity>,
              AsyncValue<PlayerStatsEntity>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
