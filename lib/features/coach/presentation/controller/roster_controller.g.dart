// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roster_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RosterController)
final rosterControllerProvider = RosterControllerFamily._();

final class RosterControllerProvider
    extends
        $AsyncNotifierProvider<RosterController, List<PlayerProfileEntity>> {
  RosterControllerProvider._({
    required RosterControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'rosterControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rosterControllerHash();

  @override
  String toString() {
    return r'rosterControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RosterController create() => RosterController();

  @override
  bool operator ==(Object other) {
    return other is RosterControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rosterControllerHash() => r'af2191a5a9eda38273045fe017e7558463154ce0';

final class RosterControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          RosterController,
          AsyncValue<List<PlayerProfileEntity>>,
          List<PlayerProfileEntity>,
          FutureOr<List<PlayerProfileEntity>>,
          String
        > {
  RosterControllerFamily._()
    : super(
        retry: null,
        name: r'rosterControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RosterControllerProvider call(String categoryId) =>
      RosterControllerProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'rosterControllerProvider';
}

abstract class _$RosterController
    extends $AsyncNotifier<List<PlayerProfileEntity>> {
  late final _$args = ref.$arg as String;
  String get categoryId => _$args;

  FutureOr<List<PlayerProfileEntity>> build(String categoryId);
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
    return element.handleCreate(ref, () => build(_$args));
  }
}
