// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datebook_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DatebookNotifier)
final datebookProvider = DatebookNotifierFamily._();

final class DatebookNotifierProvider
    extends $AsyncNotifierProvider<DatebookNotifier, List<ActivityEntity>> {
  DatebookNotifierProvider._({
    required DatebookNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'datebookProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$datebookNotifierHash();

  @override
  String toString() {
    return r'datebookProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DatebookNotifier create() => DatebookNotifier();

  @override
  bool operator ==(Object other) {
    return other is DatebookNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$datebookNotifierHash() => r'b2aa650ff1cf47b7f3056f889a688f79c91df833';

final class DatebookNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          DatebookNotifier,
          AsyncValue<List<ActivityEntity>>,
          List<ActivityEntity>,
          FutureOr<List<ActivityEntity>>,
          String
        > {
  DatebookNotifierFamily._()
    : super(
        retry: null,
        name: r'datebookProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DatebookNotifierProvider call(String categoriaId) =>
      DatebookNotifierProvider._(argument: categoriaId, from: this);

  @override
  String toString() => r'datebookProvider';
}

abstract class _$DatebookNotifier extends $AsyncNotifier<List<ActivityEntity>> {
  late final _$args = ref.$arg as String;
  String get categoriaId => _$args;

  FutureOr<List<ActivityEntity>> build(String categoriaId);
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
    return element.handleCreate(ref, () => build(_$args));
  }
}
