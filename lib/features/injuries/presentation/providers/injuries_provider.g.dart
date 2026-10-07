// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'injuries_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(injuriesRemoteDataSource)
final injuriesRemoteDataSourceProvider = InjuriesRemoteDataSourceProvider._();

final class InjuriesRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          InjuriesRemoteDataSource,
          InjuriesRemoteDataSource,
          InjuriesRemoteDataSource
        >
    with $Provider<InjuriesRemoteDataSource> {
  InjuriesRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'injuriesRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$injuriesRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<InjuriesRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InjuriesRemoteDataSource create(Ref ref) {
    return injuriesRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InjuriesRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InjuriesRemoteDataSource>(value),
    );
  }
}

String _$injuriesRemoteDataSourceHash() =>
    r'b3bd18e18b0763c845b9e6ea77b6dacc45d6b380';

@ProviderFor(injuriesRepository)
final injuriesRepositoryProvider = InjuriesRepositoryProvider._();

final class InjuriesRepositoryProvider
    extends
        $FunctionalProvider<
          InjuriesRepository,
          InjuriesRepository,
          InjuriesRepository
        >
    with $Provider<InjuriesRepository> {
  InjuriesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'injuriesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$injuriesRepositoryHash();

  @$internal
  @override
  $ProviderElement<InjuriesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InjuriesRepository create(Ref ref) {
    return injuriesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InjuriesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InjuriesRepository>(value),
    );
  }
}

String _$injuriesRepositoryHash() =>
    r'75d9189ce73818c8574fa2d7e54f0d38a171f39a';

@ProviderFor(getPlayerUnavailabilitiesUseCase)
final getPlayerUnavailabilitiesUseCaseProvider =
    GetPlayerUnavailabilitiesUseCaseProvider._();

final class GetPlayerUnavailabilitiesUseCaseProvider
    extends
        $FunctionalProvider<
          GetPlayerUnavailabilitiesUseCase,
          GetPlayerUnavailabilitiesUseCase,
          GetPlayerUnavailabilitiesUseCase
        >
    with $Provider<GetPlayerUnavailabilitiesUseCase> {
  GetPlayerUnavailabilitiesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPlayerUnavailabilitiesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPlayerUnavailabilitiesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPlayerUnavailabilitiesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetPlayerUnavailabilitiesUseCase create(Ref ref) {
    return getPlayerUnavailabilitiesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPlayerUnavailabilitiesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPlayerUnavailabilitiesUseCase>(
        value,
      ),
    );
  }
}

String _$getPlayerUnavailabilitiesUseCaseHash() =>
    r'14388047360d4abd7d0f2e1b4b52747127b4931e';

@ProviderFor(playerUnavailabilities)
final playerUnavailabilitiesProvider = PlayerUnavailabilitiesFamily._();

final class PlayerUnavailabilitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PlayerUnavailabilityEntity>>,
          List<PlayerUnavailabilityEntity>,
          FutureOr<List<PlayerUnavailabilityEntity>>
        >
    with
        $FutureModifier<List<PlayerUnavailabilityEntity>>,
        $FutureProvider<List<PlayerUnavailabilityEntity>> {
  PlayerUnavailabilitiesProvider._({
    required PlayerUnavailabilitiesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'playerUnavailabilitiesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playerUnavailabilitiesHash();

  @override
  String toString() {
    return r'playerUnavailabilitiesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<PlayerUnavailabilityEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PlayerUnavailabilityEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return playerUnavailabilities(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerUnavailabilitiesProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playerUnavailabilitiesHash() =>
    r'6514397bbef2baf377d8d3fd01d9df83eebc762b';

final class PlayerUnavailabilitiesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<PlayerUnavailabilityEntity>>,
          String
        > {
  PlayerUnavailabilitiesFamily._()
    : super(
        retry: null,
        name: r'playerUnavailabilitiesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlayerUnavailabilitiesProvider call(String playerId) =>
      PlayerUnavailabilitiesProvider._(argument: playerId, from: this);

  @override
  String toString() => r'playerUnavailabilitiesProvider';
}
