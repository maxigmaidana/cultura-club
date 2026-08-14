// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(coachRemoteDataSource)
final coachRemoteDataSourceProvider = CoachRemoteDataSourceProvider._();

final class CoachRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          CoachRemoteDataSource,
          CoachRemoteDataSource,
          CoachRemoteDataSource
        >
    with $Provider<CoachRemoteDataSource> {
  CoachRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coachRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coachRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<CoachRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CoachRemoteDataSource create(Ref ref) {
    return coachRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoachRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoachRemoteDataSource>(value),
    );
  }
}

String _$coachRemoteDataSourceHash() =>
    r'7a6b1df9dc9f4c26efa8eef9d737068605f3403e';

@ProviderFor(coachRepository)
final coachRepositoryProvider = CoachRepositoryProvider._();

final class CoachRepositoryProvider
    extends
        $FunctionalProvider<CoachRepository, CoachRepository, CoachRepository>
    with $Provider<CoachRepository> {
  CoachRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coachRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coachRepositoryHash();

  @$internal
  @override
  $ProviderElement<CoachRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CoachRepository create(Ref ref) {
    return coachRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoachRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoachRepository>(value),
    );
  }
}

String _$coachRepositoryHash() => r'cfbe2aa52f136a37e0b491e4f2fbdfdfed78adda';

@ProviderFor(getCoachCategoriesUseCase)
final getCoachCategoriesUseCaseProvider = GetCoachCategoriesUseCaseProvider._();

final class GetCoachCategoriesUseCaseProvider
    extends
        $FunctionalProvider<
          GetCoachCategoriesUseCase,
          GetCoachCategoriesUseCase,
          GetCoachCategoriesUseCase
        >
    with $Provider<GetCoachCategoriesUseCase> {
  GetCoachCategoriesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCoachCategoriesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCoachCategoriesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCoachCategoriesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetCoachCategoriesUseCase create(Ref ref) {
    return getCoachCategoriesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCoachCategoriesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCoachCategoriesUseCase>(value),
    );
  }
}

String _$getCoachCategoriesUseCaseHash() =>
    r'a07ce2bc1ea48fcfd323f4aa264ef1c9520fa8f2';

@ProviderFor(getRosterUseCase)
final getRosterUseCaseProvider = GetRosterUseCaseProvider._();

final class GetRosterUseCaseProvider
    extends
        $FunctionalProvider<
          GetRosterUseCase,
          GetRosterUseCase,
          GetRosterUseCase
        >
    with $Provider<GetRosterUseCase> {
  GetRosterUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getRosterUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getRosterUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetRosterUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetRosterUseCase create(Ref ref) {
    return getRosterUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetRosterUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetRosterUseCase>(value),
    );
  }
}

String _$getRosterUseCaseHash() => r'a20b8a861382374a9c51a8179b198ba876bdb63c';
