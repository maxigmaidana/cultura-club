// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_agenda_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyAgendaController)
final myAgendaControllerProvider = MyAgendaControllerProvider._();

final class MyAgendaControllerProvider
    extends $AsyncNotifierProvider<MyAgendaController, List<ActivityEntity>> {
  MyAgendaControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myAgendaControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myAgendaControllerHash();

  @$internal
  @override
  MyAgendaController create() => MyAgendaController();
}

String _$myAgendaControllerHash() =>
    r'df0a5e37a6aa973f1c1297dfb06bff96c914636e';

abstract class _$MyAgendaController
    extends $AsyncNotifier<List<ActivityEntity>> {
  FutureOr<List<ActivityEntity>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ActivityEntity>>, List<ActivityEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ActivityEntity>>,
                List<ActivityEntity>
              >,
              AsyncValue<List<ActivityEntity>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
