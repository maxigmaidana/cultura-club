import 'package:cultura_club/features/auth/presentation/screens/login_screen.dart';
import 'package:cultura_club/features/home/presentation/screens/home_screen.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const String clubName = String.fromEnvironment(
  'CLUB_NAME',
  defaultValue: 'Cultura Club',
);
const String primaryColorHex = String.fromEnvironment(
  'PRIMARY_COLOR',
  defaultValue: '0xFFE2001A',
);

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  static const String pathName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current state (handles both initial resolved state and changes)
    final userSessionAsync = ref.watch(userSessionProvider);

    // Navigate when session state is resolved
    userSessionAsync.when(
      data: (user) {
        // State is resolved - navigate immediately
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (user != null) {
            GoRouter.of(
              context,
            ).go(HomeScreen.pathName); // Valid session -> Home
          } else {
            GoRouter.of(
              context,
            ).go(LoginScreen.pathName); // No session -> Login
          }
        });
      },
      loading: () {
        // Still loading - show splash screen
      },
      error: (error, stackTrace) {
        // Error during session restore - navigate to login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          GoRouter.of(context).go(LoginScreen.pathName);
        });
      },
    );

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
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
