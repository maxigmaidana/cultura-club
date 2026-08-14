import 'package:cultura_club/features/auth/presentation/screens/login_screen.dart';
import 'package:cultura_club/features/home/presentation/screens/home_screen.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const String clubName = String.fromEnvironment('CLUB_NAME', defaultValue: 'Cultura Club');
const String primaryColorHex = String.fromEnvironment('PRIMARY_COLOR', defaultValue: '0xFFE2001A');

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  static const String pathName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos los cambios en la sesión
    ref.listen(userSessionProvider, (_, next) {
      // Cuando la promesa asíncrona (build) se resuelve:
      if (!next.isLoading) {
        if (next.value != null) {
          context.go(HomeScreen.pathName); // Hay token válido -> Home
        } else {
          context.go(LoginScreen.pathName); // No hay token -> Login
        }
      }
    });

    final Color primaryColor = Color(int.parse(primaryColorHex));

    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_soccer, size: 100, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              clubName,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}