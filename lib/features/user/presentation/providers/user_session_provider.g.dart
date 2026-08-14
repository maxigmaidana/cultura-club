// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserSession)
final userSessionProvider = UserSessionProvider._();

final class UserSessionProvider
    extends $AsyncNotifierProvider<UserSession, UserEntity?> {
  UserSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSessionHash();

  @$internal
  @override
  UserSession create() => UserSession();
}

String _$userSessionHash() => r'8883f3336104e59fd55a3c557a53722c27b0d837';

abstract class _$UserSession extends $AsyncNotifier<UserEntity?> {
  FutureOr<UserEntity?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserEntity?>, UserEntity?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserEntity?>, UserEntity?>,
              AsyncValue<UserEntity?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
