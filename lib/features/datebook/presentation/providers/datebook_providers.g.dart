// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datebook_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(datebookRemoteDataSource)
final datebookRemoteDataSourceProvider = DatebookRemoteDataSourceProvider._();

final class DatebookRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          DatebookRemoteDataSource,
          DatebookRemoteDataSource,
          DatebookRemoteDataSource
        >
    with $Provider<DatebookRemoteDataSource> {
  DatebookRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'datebookRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$datebookRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<DatebookRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DatebookRemoteDataSource create(Ref ref) {
    return datebookRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DatebookRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DatebookRemoteDataSource>(value),
    );
  }
}

String _$datebookRemoteDataSourceHash() =>
    r'd50a47ef0a0c06d675cc6c9a26ac38f8a0ccb97a';

@ProviderFor(datebookRepository)
final datebookRepositoryProvider = DatebookRepositoryProvider._();

final class DatebookRepositoryProvider
    extends
        $FunctionalProvider<
          DatebookRepository,
          DatebookRepository,
          DatebookRepository
        >
    with $Provider<DatebookRepository> {
  DatebookRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'datebookRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$datebookRepositoryHash();

  @$internal
  @override
  $ProviderElement<DatebookRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DatebookRepository create(Ref ref) {
    return datebookRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DatebookRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DatebookRepository>(value),
    );
  }
}

String _$datebookRepositoryHash() =>
    r'bb380ab6350ecc315aeed50870d84492668a7762';

@ProviderFor(getActivitiesByCategoryUseCase)
final getActivitiesByCategoryUseCaseProvider =
    GetActivitiesByCategoryUseCaseProvider._();

final class GetActivitiesByCategoryUseCaseProvider
    extends
        $FunctionalProvider<
          GetDatebookByCategoryUseCase,
          GetDatebookByCategoryUseCase,
          GetDatebookByCategoryUseCase
        >
    with $Provider<GetDatebookByCategoryUseCase> {
  GetActivitiesByCategoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getActivitiesByCategoryUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getActivitiesByCategoryUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetDatebookByCategoryUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetDatebookByCategoryUseCase create(Ref ref) {
    return getActivitiesByCategoryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetDatebookByCategoryUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetDatebookByCategoryUseCase>(value),
    );
  }
}

String _$getActivitiesByCategoryUseCaseHash() =>
    r'02ee4dbcbe1e30036655690dc08ac0f30514ce25';

@ProviderFor(respondToCitationUseCase)
final respondToCitationUseCaseProvider = RespondToCitationUseCaseProvider._();

final class RespondToCitationUseCaseProvider
    extends
        $FunctionalProvider<
          RespondToCitationUseCase,
          RespondToCitationUseCase,
          RespondToCitationUseCase
        >
    with $Provider<RespondToCitationUseCase> {
  RespondToCitationUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'respondToCitationUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$respondToCitationUseCaseHash();

  @$internal
  @override
  $ProviderElement<RespondToCitationUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RespondToCitationUseCase create(Ref ref) {
    return respondToCitationUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RespondToCitationUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RespondToCitationUseCase>(value),
    );
  }
}

String _$respondToCitationUseCaseHash() =>
    r'1906ddf30624478402dbc44542f93368992077c2';
