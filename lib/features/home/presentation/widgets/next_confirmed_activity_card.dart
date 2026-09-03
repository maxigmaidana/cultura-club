import 'package:cultura_club/core/enums/activity_enums.dart';
import 'package:cultura_club/core/theme/widgets/app_alert_card.dart';
import 'package:cultura_club/core/theme/widgets/app_button.dart';
import 'package:cultura_club/core/theme/widgets/app_semantic_colors.dart';
import 'package:cultura_club/core/theme/widgets/app_status_badge.dart';
import 'package:cultura_club/features/datebook/domain/entities/activity_entity.dart';
import 'package:cultura_club/features/datebook/presentation/controllers/citation_controller.dart';
import 'package:cultura_club/features/datebook/presentation/controllers/my_agenda_controller.dart';
import 'package:cultura_club/features/datebook/presentation/screens/activity_detail_screen.dart';
import 'package:cultura_club/features/datebook/presentation/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

        return AppAlertCard(
          status: AppAlertStatus.success,
          iconSize: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Tu próxima actividad confirmada',
                      style: TextStyle(
                        color: AppSemanticColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const AppStatusBadge(
                    label: 'Confirmado',
                    color: AppSemanticColors.success,
                  ),
                ],
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
                Text(next.lugar!, style: const TextStyle(color: Colors.black87)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      variant: AppButtonVariant.secondary,
                      label: 'Cancelar',
                      onPressed: () => _respond(context, ref, next, 'no_asiste'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      variant: AppButtonVariant.primary,
                      label: 'Ver Detalles',
                      onPressed: () => GoRouter.of(context).push(
                        ActivityDetailScreen.buildPath(next.categoriaId, next.id),
                        extra: next,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _respond(
    BuildContext context,
    WidgetRef ref,
    ActivityEntity activity,
    String estadoRespuesta,
  ) async {
    await ref
        .read(citationControllerProvider.notifier)
        .respondToCitation(
          actividadId: activity.id,
          jugadorId: userId,
          estadoRespuesta: estadoRespuesta,
          categoriaId: activity.categoriaId,
        );
  }
}
