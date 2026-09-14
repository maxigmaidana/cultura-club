// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider que centraliza el color primario del club (white-label compatible)
///
/// Lee desde env var `PRIMARY_COLOR` en launch.json.
/// Un único punto de verdad para el color de la marca.

@ProviderFor(primaryColor)
final primaryColorProvider = PrimaryColorProvider._();

/// Provider que centraliza el color primario del club (white-label compatible)
///
/// Lee desde env var `PRIMARY_COLOR` en launch.json.
/// Un único punto de verdad para el color de la marca.

final class PrimaryColorProvider
    extends $FunctionalProvider<Color, Color, Color>
    with $Provider<Color> {
  /// Provider que centraliza el color primario del club (white-label compatible)
  ///
  /// Lee desde env var `PRIMARY_COLOR` en launch.json.
  /// Un único punto de verdad para el color de la marca.
  PrimaryColorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'primaryColorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$primaryColorHash();

  @$internal
  @override
  $ProviderElement<Color> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Color create(Ref ref) {
    return primaryColor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Color value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Color>(value),
    );
  }
}

String _$primaryColorHash() => r'a91b076de6bab49e9ea7cc5df499db277f1b345c';
