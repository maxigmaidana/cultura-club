import 'package:cultura_club/core/presentation/widgets/exports.dart';
import 'package:cultura_club/features/coach/presentation/controller/coach_categories_controller.dart';
import 'package:cultura_club/features/datebook/domain/entities/activity_entity.dart';
import 'package:cultura_club/features/datebook/domain/entities/coach_commitment_entity.dart';
import 'package:cultura_club/features/datebook/presentation/controllers/coach_commitments_controller.dart';
import 'package:cultura_club/features/datebook/presentation/notifier/datebook_notifier.dart';
import 'package:cultura_club/features/datebook/presentation/screens/activity_dashboard_screen.dart';
import 'package:cultura_club/features/datebook/presentation/utils/date_formatter.dart';
import 'package:cultura_club/features/gamification/presentation/widgets/pending_trivias_section.dart';
import 'package:cultura_club/features/home/presentation/widgets/next_confirmed_activity_card.dart';
import 'package:cultura_club/features/user/domain/entity/user_entity.dart';
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            '¡Hola, ${user.fullName}!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          AppInfoCard(
            icon: Icons.campaign,
            title: 'Aviso Importante',
            colorScheme: AppCardColorScheme.red,
            content: const Text(
              'Los entrenamientos de esta semana se pasan al predio techado por pronóstico de lluvias.',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          if (user.role.isCoach) ...[
            const SizedBox(height: 20),
            const CoachAttentionCommitmentCard(),
            const SizedBox(height: 16),
            const NextCoachCommitmentCard(),
          ] else ...[
            const SizedBox(height: 20),
            NextConfirmedActivityCard(userId: user.id),
            PendingTriviasSection(jugadorId: user.id),
          ],
        ],
      ),
    );
  }
}

class CoachAttentionCommitmentCard extends ConsumerWidget {
  const CoachAttentionCommitmentCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commitmentsState = ref.watch(coachCommitmentsControllerProvider);

    return commitmentsState.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
      data: (commitments) {
        final nextNeedingAttention = commitments
            .where((commitment) => commitment.requiresAttention)
            .fold<CoachCommitmentEntity?>(null, (current, candidate) {
              if (current == null) return candidate;
              return candidate.fechaHora.isBefore(current.fechaHora)
                  ? candidate
                  : current;
            });

        if (nextNeedingAttention == null) {
          return const SizedBox.shrink();
        }

        final unavailableCount = nextNeedingAttention.unavailablePlayersCount;

        return AppInfoCard(
          icon: Icons.warning_amber_rounded,
          title: 'Convocatoria para revisar',
          colorScheme: AppCardColorScheme.orange,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${nextNeedingAttention.categoryName} · ${nextNeedingAttention.tipo.toUpperCase()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(formatActivityDate(nextNeedingAttention.fechaHora)),
              const SizedBox(height: 6),
              Text(
                '$unavailableCount ${unavailableCount == 1 ? 'jugador no disponible' : 'jugadores no disponibles'}',
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  GoRouter.of(context).push(
                    ActivityDashboardScreen.buildPath(
                      nextNeedingAttention.categoryId,
                      nextNeedingAttention.activityId,
                    ),
                  );
                },
                child: const Text('Revisar compromiso'),
              ),
            ],
          ),
        );
      },
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
          final activities =
              activitiesState.asData?.value ?? const <ActivityEntity>[];

          for (final activity in activities) {
            if (!activity.fechaHora.isAfter(now)) continue;
            if (next == null || activity.fechaHora.isBefore(next.fechaHora)) {
              next = activity;
            }
          }
        }

        if (next == null) return const SizedBox.shrink();

        final activity = next;

        return AppInfoCard(
          icon: Icons.event,
          title: 'Tu próximo compromiso',
          colorScheme: AppCardColorScheme.orange,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              if (activity.lugar != null && activity.lugar!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  activity.lugar!,
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
