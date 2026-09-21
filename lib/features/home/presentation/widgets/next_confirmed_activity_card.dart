import 'package:cultura_club/core/enums/activity_enums.dart';
import 'package:cultura_club/core/presentation/widgets/exports.dart';
import 'package:cultura_club/features/datebook/domain/entities/activity_entity.dart';
import 'package:cultura_club/features/datebook/presentation/controllers/my_agenda_controller.dart';
import 'package:cultura_club/features/datebook/presentation/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

ActivityEntity? findClosestConfirmedActivity(
  List<ActivityEntity> activities,
  String userId, {
  DateTime? now,
}) {
  final referenceTime = now ?? DateTime.now();
  ActivityEntity? closest;

  for (final activity in activities) {
    if (activity.fechaHora.isBefore(referenceTime)) continue;

    final myCitations = activity.citaciones.where(
      (citation) => citation.jugadorId == userId,
    );

    if (myCitations.isEmpty) continue;

    final myCitation = myCitations.first;
    if (CitacionEstado.fromString(myCitation.estadoRespuesta) !=
        CitacionEstado.confirma) {
      continue;
    }

    if (closest == null || activity.fechaHora.isBefore(closest.fechaHora)) {
      closest = activity;
    }
  }

  return closest;
}

class NextConfirmedActivityCard extends ConsumerWidget {
  final String userId;

  const NextConfirmedActivityCard({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agendaState = ref.watch(myAgendaControllerProvider);

    return agendaState.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
      data: (activities) {
        final next = findClosestConfirmedActivity(activities, userId);

        if (next == null) return const SizedBox.shrink();

        return AppInfoCard(
          icon: Icons.event_available,
          title: 'Tu próxima actividad confirmada',
          colorScheme: AppCardColorScheme.green,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                next.titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formatActivityDate(next.fechaHora),
                style: const TextStyle(color: Colors.black87),
              ),
              if (next.lugar != null && next.lugar!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  next.lugar!,
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
