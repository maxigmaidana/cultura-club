// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'citation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CitationController)
final citationControllerProvider = CitationControllerProvider._();

final class CitationControllerProvider
    extends $AsyncNotifierProvider<CitationController, void> {
  CitationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'citationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$citationControllerHash();

  @$internal
  @override
  CitationController create() => CitationController();
}

String _$citationControllerHash() =>
    r'af4f67e768cfcbbd8494eb4adef42e4a9003c441';

abstract class _$CitationController extends $AsyncNotifier<void> {
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
