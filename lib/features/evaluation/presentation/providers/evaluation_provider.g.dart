// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(evaluationRemoteDataSource)
final evaluationRemoteDataSourceProvider =
    EvaluationRemoteDataSourceProvider._();

final class EvaluationRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          EvaluationRemoteDataSource,
          EvaluationRemoteDataSource,
          EvaluationRemoteDataSource
        >
    with $Provider<EvaluationRemoteDataSource> {
  EvaluationRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'evaluationRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$evaluationRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<EvaluationRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EvaluationRemoteDataSource create(Ref ref) {
    return evaluationRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EvaluationRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EvaluationRemoteDataSource>(value),
    );
  }
}

String _$evaluationRemoteDataSourceHash() =>
    r'dff2a2945d4f909dc925e331aa9228a263636c83';

@ProviderFor(evaluationRepository)
final evaluationRepositoryProvider = EvaluationRepositoryProvider._();

final class EvaluationRepositoryProvider
    extends
        $FunctionalProvider<
          EvaluationRepository,
          EvaluationRepository,
          EvaluationRepository
        >
    with $Provider<EvaluationRepository> {
  EvaluationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'evaluationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$evaluationRepositoryHash();

  @$internal
  @override
  $ProviderElement<EvaluationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EvaluationRepository create(Ref ref) {
    return evaluationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EvaluationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EvaluationRepository>(value),
    );
  }
}

String _$evaluationRepositoryHash() =>
    r'786bec38f71adf524725165cee7483ad0e24642b';

@ProviderFor(saveEvaluationUseCase)
final saveEvaluationUseCaseProvider = SaveEvaluationUseCaseProvider._();

final class SaveEvaluationUseCaseProvider
    extends
        $FunctionalProvider<
          SaveEvaluationUseCase,
          SaveEvaluationUseCase,
          SaveEvaluationUseCase
        >
    with $Provider<SaveEvaluationUseCase> {
  SaveEvaluationUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saveEvaluationUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saveEvaluationUseCaseHash();

  @$internal
  @override
  $ProviderElement<SaveEvaluationUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SaveEvaluationUseCase create(Ref ref) {
    return saveEvaluationUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SaveEvaluationUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SaveEvaluationUseCase>(value),
    );
  }
}

String _$saveEvaluationUseCaseHash() =>
    r'17ac5dd38e3b782d620c14649e18b04d7fcf3643';
