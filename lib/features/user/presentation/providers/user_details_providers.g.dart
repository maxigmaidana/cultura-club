// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Datasource Provider

@ProviderFor(userRemoteDataSource)
final userRemoteDataSourceProvider = UserRemoteDataSourceProvider._();

/// Datasource Provider

final class UserRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          IUserRemoteDataSource,
          IUserRemoteDataSource,
          IUserRemoteDataSource
        >
    with $Provider<IUserRemoteDataSource> {
  /// Datasource Provider
  UserRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<IUserRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IUserRemoteDataSource create(Ref ref) {
    return userRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IUserRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IUserRemoteDataSource>(value),
    );
  }
}

String _$userRemoteDataSourceHash() =>
    r'14e14c6d9c04672284f0385a31a095f7ac2be9cf';

/// Repository Provider

@ProviderFor(userRepository)
final userRepositoryProvider = UserRepositoryProvider._();

/// Repository Provider

final class UserRepositoryProvider
    extends
        $FunctionalProvider<IUserRepository, IUserRepository, IUserRepository>
    with $Provider<IUserRepository> {
  /// Repository Provider
  UserRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRepositoryHash();

  @$internal
  @override
  $ProviderElement<IUserRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IUserRepository create(Ref ref) {
    return userRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IUserRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IUserRepository>(value),
    );
  }
}

String _$userRepositoryHash() => r'a27cf727d4f3c5d1d007407fb6a624ad2b95385b';

/// Use Case Provider

@ProviderFor(getUserDetailsUseCase)
final getUserDetailsUseCaseProvider = GetUserDetailsUseCaseProvider._();

/// Use Case Provider

final class GetUserDetailsUseCaseProvider
    extends
        $FunctionalProvider<
          GetUserDetailsUseCase,
          GetUserDetailsUseCase,
          GetUserDetailsUseCase
        >
    with $Provider<GetUserDetailsUseCase> {
  /// Use Case Provider
  GetUserDetailsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getUserDetailsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getUserDetailsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetUserDetailsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetUserDetailsUseCase create(Ref ref) {
    return getUserDetailsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetUserDetailsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetUserDetailsUseCase>(value),
    );
  }
}

String _$getUserDetailsUseCaseHash() =>
    r'6f319ace75fc4a0f24cfcfd2a2f594d1f13d50a8';

/// Async Provider (Family para múltiples usuarios)

@ProviderFor(userDetails)
final userDetailsProvider = UserDetailsFamily._();

/// Async Provider (Family para múltiples usuarios)

final class UserDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserEntity>,
          UserEntity,
          FutureOr<UserEntity>
        >
    with $FutureModifier<UserEntity>, $FutureProvider<UserEntity> {
  /// Async Provider (Family para múltiples usuarios)
  UserDetailsProvider._({
    required UserDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userDetailsHash();

  @override
  String toString() {
    return r'userDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UserEntity> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserEntity> create(Ref ref) {
    final argument = this.argument as String;
    return userDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userDetailsHash() => r'ba4f248b13158dc0d87ca707922e423fd47c8155';

/// Async Provider (Family para múltiples usuarios)

final class UserDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UserEntity>, String> {
  UserDetailsFamily._()
    : super(
        retry: null,
        name: r'userDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Async Provider (Family para múltiples usuarios)

  UserDetailsProvider call(String userId) =>
      UserDetailsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userDetailsProvider';
}
