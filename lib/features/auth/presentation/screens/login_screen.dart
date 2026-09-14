import 'package:cultura_club/core/presentation/widgets/exports.dart';
import 'package:cultura_club/core/providers/theme_provider.dart';
import 'package:cultura_club/features/auth/presentation/controller/login_controller.dart';
import 'package:cultura_club/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Leemos las variables inyectadas desde el launch.json
const String clubName = String.fromEnvironment(
  'CLUB_NAME',
  defaultValue: 'Cultura Club',
);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static String pathName = '/login';
  static String routeName = 'login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onLoginPressed() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppSnackBar.show(
        context,
        AppSnackBarType.error,
        'Por favor, completa todos los campos',
      );
      return;
    }

    final success = await ref
        .read(loginControllerProvider.notifier)
        .login(email, password);

    if (success && mounted) {
      GoRouter.of(context).go(HomeScreen.pathName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = ref.watch(primaryColorProvider);
    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState is AsyncLoading;

    ref.listen(loginControllerProvider, (_, next) {
      if (next is AsyncError) {
        AppSnackBar.show(context, AppSnackBarType.error, next.error.toString());
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              const SizedBox(height: 60),
              // Header
              Column(
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(16),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.black.withOpacity(0.2),
                    //       blurRadius: 8,
                    //       offset: const Offset(0, 4),
                    //     ),
                    //   ],
                    // ),
                    // child: SvgPicture.asset(
                    //   'assets/independiente/independiente_logo.svg',
                    //   fit: BoxFit.contain,
                    // ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    clubName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Rey de copas',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 60),

              // Formulario
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Email Field
                    AppTextField(
                      controller: _emailController,
                      type: AppTextFieldType.email,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      focusNode: null,
                      onSubmitted: () {
                        _passwordFocusNode.requestFocus();
                      },
                    ),
                    const SizedBox(height: 16),
                    // Password Field
                    AppTextField(
                      controller: _passwordController,
                      type: AppTextFieldType.password,
                      enabled: !isLoading,
                      focusNode: _passwordFocusNode,
                      textInputAction: TextInputAction.done,
                      onSubmitted: () {
                        if (_emailController.text.trim().isNotEmpty &&
                            _passwordController.text.trim().isNotEmpty) {
                          _onLoginPressed();
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    // Login Button
                    AppButton(
                      onPressed: _onLoginPressed,
                      label: 'Ingresar',
                      type: AppButtonType.primary,
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
