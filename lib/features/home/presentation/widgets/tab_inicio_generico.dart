import 'package:cultura_club/features/auth/presentation/providers/auth_provider.dart';
import 'package:cultura_club/features/coach/presentation/controller/coach_categories_controller.dart';
import 'package:cultura_club/features/datebook/domain/entities/activity_entity.dart';
import 'package:cultura_club/features/datebook/presentation/notifier/datebook_notifier.dart';
import 'package:cultura_club/features/datebook/presentation/utils/date_formatter.dart';
import 'package:cultura_club/features/home/presentation/widgets/next_confirmed_activity_card.dart';
import 'package:cultura_club/features/user/domain/entity/user_entity.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TabInicioGenerico extends ConsumerWidget {
  final UserEntity user;
  const TabInicioGenerico({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () async {
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
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            '¡Hola, ${user.fullName}!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Card(
            color: Colors.red[50],
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.red.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.campaign, color: Colors.red[900], size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aviso Importante',
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Los entrenamientos de esta semana se pasan al predio techado por pronóstico de lluvias.',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (user.role.isCoach) ...[
            const SizedBox(height: 20),
            const NextCoachCommitmentCard(),
          ] else ...[
            const SizedBox(height: 20),
            NextConfirmedActivityCard(userId: user.id),
          ],
        ],
      ),
    );
  }
}

class NextCoachCommitmentCard extends ConsumerWidget {
  const NextCoachCommitmentCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(coachCategoriesControllerProvider);

    return categoriesState.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (categories) {
        if (categories.isEmpty) return const SizedBox.shrink();

        final now = DateTime.now();
        ActivityEntity? next;

        for (final category in categories) {
          final activitiesState = ref.watch(datebookProvider(category.id));
          final activities = activitiesState.asData?.value ?? const <ActivityEntity>[];

          for (final activity in activities) {
            if (!activity.fechaHora.isAfter(now)) continue;
            if (next == null || activity.fechaHora.isBefore(next.fechaHora)) {
              next = activity;
            }
          }
        }

        if (next == null) return const SizedBox.shrink();

        final activity = next;

        return Card(
          color: Colors.orange[50],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.orange.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.event, color: Colors.orange[800], size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tu próximo compromiso',
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activity.titulo,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatActivityDate(activity.fechaHora),
                        style: const TextStyle(color: Colors.black87),
                      ),
                      if (activity.lugar != null && activity.lugar!.isNotEmpty)
                        Text(
                          activity.lugar!,
                          style: const TextStyle(color: Colors.black87),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
