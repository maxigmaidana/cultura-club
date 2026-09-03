// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppThemeNotifier)
final appThemeProvider = AppThemeNotifierProvider._();

final class AppThemeNotifierProvider
    extends $AsyncNotifierProvider<AppThemeNotifier, AppTheme> {
  AppThemeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeNotifierHash();

  @$internal
  @override
  AppThemeNotifier create() => AppThemeNotifier();
}

String _$appThemeNotifierHash() => r'f40dfd80682858fb925bc349d0f8ce28845d5232';

abstract class _$AppThemeNotifier extends $AsyncNotifier<AppTheme> {
  FutureOr<AppTheme> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppTheme>, AppTheme>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppTheme>, AppTheme>,
              AsyncValue<AppTheme>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
