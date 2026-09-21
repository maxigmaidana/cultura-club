import 'package:cultura_club/core/providers/theme_provider.dart';
import 'package:cultura_club/core/presentation/widgets/exports.dart';
import 'package:cultura_club/features/auth/presentation/providers/auth_provider.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider).value;
    final primaryColor = ref.watch(primaryColorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Sección: Perfil y Cuenta
          AppSectionHeader(title: 'Cuenta'),
          const SizedBox(height: 12),
          AppSettingItem(
            icon: Icons.person,
            title: 'Perfil',
            onTap: () {
              if (user != null) {
                GoRouter.of(context).push('/profile/${user.id}');
              }
            },
          ),
          AppSettingItem(
            icon: Icons.notifications,
            title: 'Notificaciones',
            onTap: () {
              // Acción al tocar 'Notificaciones'
            },
          ),
          const SizedBox(height: 24),

          // Sección: Gamificación y Disciplina (solo para jugadores)
          if (!user!.role.isCoach) ...[
            AppSectionHeader(title: 'Rendimiento'),
            const SizedBox(height: 12),
            AppSettingItem(
              icon: Icons.health_and_safety,
              title: 'Mi evolución',
              onTap: () {
                GoRouter.of(context).push('/health');
              },
            ),
            AppSettingItem(
              icon: Icons.sports_soccer,
              title: 'Gamificación',
              onTap: () {
                GoRouter.of(context).push('/gamification/${user.id}');
              },
            ),
            AppSettingItem(
              icon: Icons.warning,
              title: 'Sanciones',
              onTap: () {
                // Acción al tocar 'Sanciones'
              },
            ),
            const SizedBox(height: 24),
          ],

          // Sección: Sesión
          AppSectionHeader(title: 'Sesión'),
          const SizedBox(height: 12),
          AppSettingItem(
            icon: Icons.logout,
            title: 'Cerrar sesión',
            isDestructive: true,
            onTap: () async {
              final signOutUseCase = ref.read(signOutUseCaseProvider);
              final result = await signOutUseCase();

              result.fold(
                (failure) {
                  AppSnackBar.show(
                    context,
                    AppSnackBarType.error,
                    'Error al cerrar sesión: ${failure.message}',
                  );
                },
                (_) {
                  ref.read(userSessionProvider.notifier).clearUser();
                  if (context.mounted) {
                    GoRouter.of(context).go('/login');
                  }
                },
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
