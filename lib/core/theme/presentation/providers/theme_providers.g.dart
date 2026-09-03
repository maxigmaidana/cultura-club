// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(themeLocalDataSource)
final themeLocalDataSourceProvider = ThemeLocalDataSourceProvider._();

final class ThemeLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ThemeLocalDataSource,
          ThemeLocalDataSource,
          ThemeLocalDataSource
        >
    with $Provider<ThemeLocalDataSource> {
  ThemeLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ThemeLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ThemeLocalDataSource create(Ref ref) {
    return themeLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeLocalDataSource>(value),
    );
  }
}

String _$themeLocalDataSourceHash() =>
    r'4cfb227ad60f2cea34e8aab7356a52af9f28030c';

@ProviderFor(themeRepository)
final themeRepositoryProvider = ThemeRepositoryProvider._();

final class ThemeRepositoryProvider
    extends
        $FunctionalProvider<ThemeRepository, ThemeRepository, ThemeRepository>
    with $Provider<ThemeRepository> {
  ThemeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeRepositoryHash();

  @$internal
  @override
  $ProviderElement<ThemeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeRepository create(Ref ref) {
    return themeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeRepository>(value),
    );
  }
}

String _$themeRepositoryHash() => r'83feb5faac0722068e59c4e341938f62c6b17650';

@ProviderFor(getAppThemeUseCase)
final getAppThemeUseCaseProvider = GetAppThemeUseCaseProvider._();

final class GetAppThemeUseCaseProvider
    extends
        $FunctionalProvider<
          GetAppThemeUseCase,
          GetAppThemeUseCase,
          GetAppThemeUseCase
        >
    with $Provider<GetAppThemeUseCase> {
  GetAppThemeUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAppThemeUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAppThemeUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetAppThemeUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetAppThemeUseCase create(Ref ref) {
    return getAppThemeUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetAppThemeUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetAppThemeUseCase>(value),
    );
  }
}

String _$getAppThemeUseCaseHash() =>
    r'362d273c711ed2c5de051ed2a30c7fc6bd544b1b';
