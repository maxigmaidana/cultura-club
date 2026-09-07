// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Datasource Provider

@ProviderFor(triviaRemoteDataSource)
final triviaRemoteDataSourceProvider = TriviaRemoteDataSourceProvider._();

/// Datasource Provider

final class TriviaRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          TriviaRemoteDataSource,
          TriviaRemoteDataSource,
          TriviaRemoteDataSource
        >
    with $Provider<TriviaRemoteDataSource> {
  /// Datasource Provider
  TriviaRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'triviaRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$triviaRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<TriviaRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TriviaRemoteDataSource create(Ref ref) {
    return triviaRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TriviaRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TriviaRemoteDataSource>(value),
    );
  }
}

String _$triviaRemoteDataSourceHash() =>
    r'2cdc7e7b5a15ffd67b019682f6b988dd49a62a32';

/// Repository Provider

@ProviderFor(triviaRepository)
final triviaRepositoryProvider = TriviaRepositoryProvider._();

/// Repository Provider

final class TriviaRepositoryProvider
    extends
        $FunctionalProvider<
          ITriviaRepository,
          ITriviaRepository,
          ITriviaRepository
        >
    with $Provider<ITriviaRepository> {
  /// Repository Provider
  TriviaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'triviaRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$triviaRepositoryHash();

  @$internal
  @override
  $ProviderElement<ITriviaRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ITriviaRepository create(Ref ref) {
    return triviaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ITriviaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ITriviaRepository>(value),
    );
  }
}

String _$triviaRepositoryHash() => r'3c3b9a5cb281873a1bdd0ad8da893880e5a333e3';

/// Use Cases Providers

@ProviderFor(getPendingTriviasUseCase)
final getPendingTriviasUseCaseProvider = GetPendingTriviasUseCaseProvider._();

/// Use Cases Providers

final class GetPendingTriviasUseCaseProvider
    extends
        $FunctionalProvider<
          GetPendingTriviasUseCase,
          GetPendingTriviasUseCase,
          GetPendingTriviasUseCase
        >
    with $Provider<GetPendingTriviasUseCase> {
  /// Use Cases Providers
  GetPendingTriviasUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPendingTriviasUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPendingTriviasUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPendingTriviasUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetPendingTriviasUseCase create(Ref ref) {
    return getPendingTriviasUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPendingTriviasUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPendingTriviasUseCase>(value),
    );
  }
}

String _$getPendingTriviasUseCaseHash() =>
    r'cbddce130d60840b626c71d321400c5833fbf2c1';

@ProviderFor(getCompletedTriviasUseCase)
final getCompletedTriviasUseCaseProvider =
    GetCompletedTriviasUseCaseProvider._();

final class GetCompletedTriviasUseCaseProvider
    extends
        $FunctionalProvider<
          GetCompletedTriviasUseCase,
          GetCompletedTriviasUseCase,
          GetCompletedTriviasUseCase
        >
    with $Provider<GetCompletedTriviasUseCase> {
  GetCompletedTriviasUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCompletedTriviasUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCompletedTriviasUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCompletedTriviasUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetCompletedTriviasUseCase create(Ref ref) {
    return getCompletedTriviasUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCompletedTriviasUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCompletedTriviasUseCase>(value),
    );
  }
}

String _$getCompletedTriviasUseCaseHash() =>
    r'5532fc48e1c1e36e0e86509a394a5f39d791ceef';

@ProviderFor(submitTriviaAnswersUseCase)
final submitTriviaAnswersUseCaseProvider =
    SubmitTriviaAnswersUseCaseProvider._();

final class SubmitTriviaAnswersUseCaseProvider
    extends
        $FunctionalProvider<
          SubmitTriviaAnswersUseCase,
          SubmitTriviaAnswersUseCase,
          SubmitTriviaAnswersUseCase
        >
    with $Provider<SubmitTriviaAnswersUseCase> {
  SubmitTriviaAnswersUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submitTriviaAnswersUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submitTriviaAnswersUseCaseHash();

  @$internal
  @override
  $ProviderElement<SubmitTriviaAnswersUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubmitTriviaAnswersUseCase create(Ref ref) {
    return submitTriviaAnswersUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubmitTriviaAnswersUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubmitTriviaAnswersUseCase>(value),
    );
  }
}

String _$submitTriviaAnswersUseCaseHash() =>
    r'4b1632e92e97d87539b2d38cc498d267bf67849f';

@ProviderFor(getTotalGameificationPointsUseCase)
final getTotalGameificationPointsUseCaseProvider =
    GetTotalGameificationPointsUseCaseProvider._();

final class GetTotalGameificationPointsUseCaseProvider
    extends
        $FunctionalProvider<
          GetTotalGameificationPointsUseCase,
          GetTotalGameificationPointsUseCase,
          GetTotalGameificationPointsUseCase
        >
    with $Provider<GetTotalGameificationPointsUseCase> {
  GetTotalGameificationPointsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getTotalGameificationPointsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$getTotalGameificationPointsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetTotalGameificationPointsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetTotalGameificationPointsUseCase create(Ref ref) {
    return getTotalGameificationPointsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetTotalGameificationPointsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetTotalGameificationPointsUseCase>(
        value,
      ),
    );
  }
}

String _$getTotalGameificationPointsUseCaseHash() =>
    r'68e092f602bf1700f334b5cac99b1ab8691e1ee9';

/// Async Providers (Family para múltiples jugadores)

@ProviderFor(pendingTrivias)
final pendingTriviasProvider = PendingTriviasFamily._();

/// Async Providers (Family para múltiples jugadores)

final class PendingTriviasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TriviaEntity>>,
          List<TriviaEntity>,
          FutureOr<List<TriviaEntity>>
        >
    with
        $FutureModifier<List<TriviaEntity>>,
        $FutureProvider<List<TriviaEntity>> {
  /// Async Providers (Family para múltiples jugadores)
  PendingTriviasProvider._({
    required PendingTriviasFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'pendingTriviasProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pendingTriviasHash();

  @override
  String toString() {
    return r'pendingTriviasProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<TriviaEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TriviaEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return pendingTrivias(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PendingTriviasProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pendingTriviasHash() => r'485fcbcb4309dcbaf4e5b5ea9afa51bc3e04fe23';

/// Async Providers (Family para múltiples jugadores)

final class PendingTriviasFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<TriviaEntity>>, String> {
  PendingTriviasFamily._()
    : super(
        retry: null,
        name: r'pendingTriviasProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Async Providers (Family para múltiples jugadores)

  PendingTriviasProvider call(String jugadorId) =>
      PendingTriviasProvider._(argument: jugadorId, from: this);

  @override
  String toString() => r'pendingTriviasProvider';
}

@ProviderFor(completedTrivias)
final completedTriviasProvider = CompletedTriviasFamily._();

final class CompletedTriviasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CompletedTriviaInfo>>,
          List<CompletedTriviaInfo>,
          FutureOr<List<CompletedTriviaInfo>>
        >
    with
        $FutureModifier<List<CompletedTriviaInfo>>,
        $FutureProvider<List<CompletedTriviaInfo>> {
  CompletedTriviasProvider._({
    required CompletedTriviasFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'completedTriviasProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$completedTriviasHash();

  @override
  String toString() {
    return r'completedTriviasProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CompletedTriviaInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CompletedTriviaInfo>> create(Ref ref) {
    final argument = this.argument as String;
    return completedTrivias(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CompletedTriviasProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$completedTriviasHash() => r'c1f4bf5cd8fc924cc78072cfb4ef37c5d6379f6d';

final class CompletedTriviasFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<CompletedTriviaInfo>>, String> {
  CompletedTriviasFamily._()
    : super(
        retry: null,
        name: r'completedTriviasProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CompletedTriviasProvider call(String jugadorId) =>
      CompletedTriviasProvider._(argument: jugadorId, from: this);

  @override
  String toString() => r'completedTriviasProvider';
}

@ProviderFor(totalGameificationPoints)
final totalGameificationPointsProvider = TotalGameificationPointsFamily._();

final class TotalGameificationPointsProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  TotalGameificationPointsProvider._({
    required TotalGameificationPointsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'totalGameificationPointsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$totalGameificationPointsHash();

  @override
  String toString() {
    return r'totalGameificationPointsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as String;
    return totalGameificationPoints(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TotalGameificationPointsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$totalGameificationPointsHash() =>
    r'153e23b950d8e535014a9d81e53ae1711463eecb';

final class TotalGameificationPointsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, String> {
  TotalGameificationPointsFamily._()
    : super(
        retry: null,
        name: r'totalGameificationPointsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TotalGameificationPointsProvider call(String jugadorId) =>
      TotalGameificationPointsProvider._(argument: jugadorId, from: this);

  @override
  String toString() => r'totalGameificationPointsProvider';
}
