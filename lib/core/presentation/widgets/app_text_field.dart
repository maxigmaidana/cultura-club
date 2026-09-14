import 'package:cultura_club/core/presentation/theme/app_theme.dart';
import 'package:cultura_club/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tipos de campo de texto soportados
enum AppTextFieldType { email, password, text }

/// Widget de TextField reutilizable y tipado
/// Lee el color primario del provider centralizado (no requiere pasarlo)
class AppTextField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final AppTextFieldType type;
  final String? label; // Opcional: usa default según type si no se proporciona
  final String? hintText;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputAction textInputAction;

  const AppTextField({
    super.key,
    required this.controller,
    required this.type,
    this.label,
    this.hintText,
    this.focusNode,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.textInputAction = TextInputAction.done,
  });

  @override
  ConsumerState<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends ConsumerState<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.type == AppTextFieldType.password;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = ref.watch(primaryColorProvider);
    final effectiveLabel = widget.label ?? _getDefaultLabel();

    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      obscureText: _obscureText,
      keyboardType: _getKeyboardType(),
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted != null
          ? (_) => widget.onSubmitted!()
          : null,
      decoration:
          AppTheme.buildInputDecoration(
            label: effectiveLabel,
            hintText: widget.hintText,
            primaryColor: primaryColor,
            prefixIcon: _getPrefixIcon(),
            obscureText: _obscureText,
          ).copyWith(
            suffixIcon: widget.type == AppTextFieldType.password
                ? _buildPasswordToggle(primaryColor)
                : null,
          ),
    );
  }

  /// Retorna el label default según el tipo de campo
  String _getDefaultLabel() {
    return switch (widget.type) {
      AppTextFieldType.email => 'Correo electrónico',
      AppTextFieldType.password => 'Contraseña',
      AppTextFieldType.text => '',
    };
  }

  /// Retorna el tipo de teclado según el tipo de campo
  TextInputType _getKeyboardType() {
    return switch (widget.type) {
      AppTextFieldType.email => TextInputType.emailAddress,
      AppTextFieldType.password => TextInputType.visiblePassword,
      AppTextFieldType.text => TextInputType.text,
    };
  }

  /// Retorna el icono prefijo según el tipo de campo
  IconData? _getPrefixIcon() {
    return switch (widget.type) {
      AppTextFieldType.email => Icons.email_outlined,
      AppTextFieldType.password => Icons.lock_outline,
      AppTextFieldType.text => null,
    };
  }

  /// Construye el botón toggle para mostrar/ocultar contraseña
  Widget? _buildPasswordToggle(Color primaryColor) {
    if (widget.type != AppTextFieldType.password) return null;

    return IconButton(
      icon: Icon(
        _obscureText
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        color: primaryColor,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }
}
