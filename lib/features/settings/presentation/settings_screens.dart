import 'package:cultura_club/core/theme/widgets/app_card.dart';
import 'package:cultura_club/core/theme/widgets/app_header_bar.dart';
import 'package:cultura_club/features/auth/presentation/providers/auth_provider.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreens extends ConsumerWidget {
  const SettingsScreens({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider).value;

    return Scaffold(
      appBar: AppHeaderBar(
        title: 'Configuración',
        avatarInitial: (user == null || user.fullName.isEmpty)
            ? '?'
            : user.fullName[0].toUpperCase(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                // 1. Ejecutamos el caso de uso limpio
                final signOutUseCase = ref.read(signOutUseCaseProvider);
                final result = await signOutUseCase();

                result.fold(
                  (failure) {
                    // Manejo de error si falla el deslogueo
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error al cerrar sesión: ${failure.message}',
                        ),
                      ),
                    );
                  },
                  (_) {
                    // 2. Limpiamos el estado global
                    ref.read(userSessionProvider.notifier).clearUser();

                    // 3. Redirigimos
                    if (context.mounted) {
                      GoRouter.of(context).go('/login');
                    }
                  },
                );
              },
              child: const AppCard(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Cerrar Sesion'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
