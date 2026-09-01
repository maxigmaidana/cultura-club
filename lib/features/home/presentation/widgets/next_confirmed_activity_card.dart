import 'package:cultura_club/core/enums/activity_enums.dart';
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

        return Card(
          color: Colors.green[50],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.green.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.event_available, color: Colors.green[800], size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tu próxima actividad confirmada',
                        style: TextStyle(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
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
                      if (next.lugar != null && next.lugar!.isNotEmpty)
                        Text(
                          next.lugar!,
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
