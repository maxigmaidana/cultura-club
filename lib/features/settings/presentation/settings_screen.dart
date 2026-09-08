import 'package:cultura_club/features/auth/presentation/providers/auth_provider.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Sección: Perfil y Cuenta
          Text(
            'Cuenta',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.red[900],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            context,
            ref,
            icon: Icons.person,
            title: 'Perfil',
            onTap: () {
              final user = ref.watch(userSessionProvider).value;
              if (user != null) {
                GoRouter.of(context).push('/profile/${user.id}');
              }
            },
          ),
          _buildSettingItem(
            context,
            ref,
            icon: Icons.notifications,
            title: 'Notificaciones',
            onTap: () {
              // Acción al tocar 'Notificaciones'
            },
          ),
          const SizedBox(height: 24),

          // Sección: Gamificación y Disciplina
          Text(
            'Rendimiento',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.red[900],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            context,
            ref,
            icon: Icons.sports_soccer,
            title: 'Gamificación',
            onTap: () {
              final user = ref.watch(userSessionProvider).value;
              if (user != null) {
                GoRouter.of(context).push('/gamification/${user.id}');
              }
            },
          ),
          _buildSettingItem(
            context,
            ref,
            icon: Icons.warning,
            title: 'Sanciones',
            onTap: () {
              // Acción al tocar 'Sanciones'
            },
          ),
          const SizedBox(height: 24),

          // Sección: Sesión
          Text(
            'Sesión',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.red[900],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            context,
            ref,
            icon: Icons.logout,
            title: 'Cerrar sesión',
            isDestructive: true,
            onTap: () async {
              final signOutUseCase = ref.read(signOutUseCaseProvider);
              final result = await signOutUseCase();

              result.fold(
                (failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error al cerrar sesión: ${failure.message}',
                      ),
                      backgroundColor: Colors.red[700],
                    ),
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

  Widget _buildSettingItem(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDestructive ? Colors.red[200]! : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isDestructive ? Colors.red[50] : Colors.grey[50],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDestructive ? Colors.red[100] : Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive ? Colors.red[700] : Colors.red[900],
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? Colors.red[700] : Colors.grey[900],
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDestructive ? Colors.red[400] : Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
