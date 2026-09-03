import 'dart:developer';

import '../models/app_theme_model.dart';

abstract class ThemeLocalDataSource {
  /// Hardcoded stand-in for the future "GET /clubs/{id}/theme" API call.
  Future<AppThemeModel> getAppTheme();
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  @override
  Future<AppThemeModel> getAppTheme() async {
    log(
      '📡 REQUEST | service: theme | action: getAppTheme | source: local (hardcoded)',
      name: 'Theme',
    );

    final model = AppThemeModel.fromJson(_apexAthleticsPayload);

    log(
      '✅ RESPONSE | service: theme | action: getAppTheme | name: ${_apexAthleticsPayload['name']}',
      name: 'Theme',
    );

    return model;
  }
}

/// Mirrors the "Apex Athletics" design-system brief. Will be replaced by the
/// club's remote configuration payload without changing the datasource contract.
final Map<String, dynamic> _apexAthleticsPayload = {
  'name': 'Apex Athletics',
  'colors': {
    'surface': '#f8f9fa',
    'surface-dim': '#d9dadb',
    'surface-bright': '#f8f9fa',
    'surface-container-lowest': '#ffffff',
    'surface-container-low': '#f3f4f5',
    'surface-container': '#edeeef',
    'surface-container-high': '#e7e8e9',
    'surface-container-highest': '#e1e3e4',
    'on-surface': '#191c1d',
    'on-surface-variant': '#5e3f3b',
    'inverse-surface': '#2e3132',
    'inverse-on-surface': '#f0f1f2',
    'outline': '#936e6a',
    'outline-variant': '#e8bcb7',
    'surface-tint': '#c00015',
    'primary': '#b50013',
    'on-primary': '#ffffff',
    'primary-container': '#e3001b',
    'on-primary-container': '#fff4f2',
    'inverse-primary': '#ffb4ac',
    'secondary': '#575e70',
    'on-secondary': '#ffffff',
    'secondary-container': '#d9dff5',
    'on-secondary-container': '#5c6274',
    'tertiary': '#525966',
    'on-tertiary': '#ffffff',
    'tertiary-container': '#6a717f',
    'on-tertiary-container': '#f4f6ff',
    'error': '#ba1a1a',
    'on-error': '#ffffff',
    'error-container': '#ffdad6',
    'on-error-container': '#93000a',
    'primary-fixed': '#ffdad6',
    'primary-fixed-dim': '#ffb4ac',
    'on-primary-fixed': '#410002',
    'on-primary-fixed-variant': '#93000d',
    'secondary-fixed': '#dce2f7',
    'secondary-fixed-dim': '#c0c6db',
    'on-secondary-fixed': '#141b2b',
    'on-secondary-fixed-variant': '#404758',
    'tertiary-fixed': '#dce2f3',
    'tertiary-fixed-dim': '#c0c7d6',
    'on-tertiary-fixed': '#151c27',
    'on-tertiary-fixed-variant': '#404754',
    'background': '#f8f9fa',
    'on-background': '#191c1d',
    'surface-variant': '#e1e3e4',
  },
  'typography': {
    'display': {
      'fontFamily': 'Inter',
      'fontSize': '36px',
      'fontWeight': '700',
      'lineHeight': '44px',
      'letterSpacing': '-0.02em',
    },
    'headline-lg': {
      'fontFamily': 'Inter',
      'fontSize': '28px',
      'fontWeight': '600',
      'lineHeight': '34px',
      'letterSpacing': '-0.01em',
    },
    'headline-md': {
      'fontFamily': 'Inter',
      'fontSize': '20px',
      'fontWeight': '600',
      'lineHeight': '28px',
    },
    'body-lg': {
      'fontFamily': 'Inter',
      'fontSize': '16px',
      'fontWeight': '400',
      'lineHeight': '24px',
    },
    'body-md': {
      'fontFamily': 'Inter',
      'fontSize': '14px',
      'fontWeight': '400',
      'lineHeight': '20px',
    },
    'label-sm': {
      'fontFamily': 'Inter',
      'fontSize': '12px',
      'fontWeight': '500',
      'lineHeight': '16px',
      'letterSpacing': '0.02em',
    },
    'headline-lg-mobile': {
      'fontFamily': 'Inter',
      'fontSize': '24px',
      'fontWeight': '600',
      'lineHeight': '32px',
    },
  },
  'rounded': {
    'sm': '0.25rem',
    'DEFAULT': '0.5rem',
    'md': '0.75rem',
    'lg': '1rem',
    'xl': '1.5rem',
    'full': '9999px',
  },
  'spacing': {
    'container-margin': '1rem',
    'stack-gap': '0.75rem',
    'section-gap': '1.5rem',
    'gutter': '1rem',
  },
};
