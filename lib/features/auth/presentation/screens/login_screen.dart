import 'package:cultura_club/core/theme/widgets/app_button.dart';
import 'package:cultura_club/core/theme/widgets/app_input_field.dart';
import 'package:cultura_club/features/auth/presentation/controller/login_controller.dart';
import 'package:cultura_club/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Leemos las variables inyectadas desde el launch.json
const String clubName = String.fromEnvironment('CLUB_NAME', defaultValue: 'Cultura Club');
const String primaryColorHex = String.fromEnvironment('PRIMARY_COLOR', defaultValue: '0xFFE2001A');

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    // Llamamos al controlador de Riverpod
    final success = await ref.read(loginControllerProvider.notifier).login(email, password);

    if (success && mounted) {
      // Navegamos al Home limpiando el historial de rutas
      GoRouter.of(context).go(HomeScreen.pathName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(int.parse(primaryColorHex));
    final loginState = ref.watch(loginControllerProvider);

    final isLoading = loginState is AsyncLoading;

    // Escuchamos si hay errores para mostrarlos en un SnackBar
    ref.listen(loginControllerProvider, (_, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString()), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(clubName, style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                AppInputField(
                  controller: _emailController,
                  label: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                AppInputField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: AppButton(
                    label: 'Ingresar',
                    isLoading: isLoading,
                    onPressed: _onLoginPressed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}