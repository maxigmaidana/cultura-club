import 'app_color_palette.dart';
import 'app_radius_tokens.dart';
import 'app_spacing_tokens.dart';
import 'app_typography_tokens.dart';

/// Aggregate design-system theme, delivered today by a hardcoded datasource and
/// destined to come from the club's remote configuration API later.
class AppTheme {
  final String name;
  final AppColorPalette colors;
  final AppTypographyTokens typography;
  final AppRadiusTokens radius;
  final AppSpacingTokens spacing;

  const AppTheme({
    required this.name,
    required this.colors,
    required this.typography,
    required this.radius,
    required this.spacing,
  });
}
