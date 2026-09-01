import 'package:cultura_club/core/enums/activity_enums.dart';
import 'package:cultura_club/features/datebook/domain/entities/activity_entity.dart';
import 'package:cultura_club/features/datebook/presentation/controllers/citation_controller.dart';
import 'package:cultura_club/features/datebook/presentation/utils/date_formatter.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ActivityDetailScreen extends ConsumerWidget {
  final String categoriaId;
  final ActivityEntity activity;

  const ActivityDetailScreen({
    super.key,
    required this.categoriaId,
    required this.activity,
  });

  static String buildPath(String categoriaId, String activityId) =>
      '/datebook/$categoriaId/activity/$activityId';

  Future<void> _respond(
    BuildContext context,
    WidgetRef ref,
    String estadoRespuesta,
  ) async {
    final userId = ref.read(userSessionProvider).value?.id;
    if (userId == null) return;

    await ref
        .read(citationControllerProvider.notifier)
        .respondToCitation(
          actividadId: activity.id,
          jugadorId: userId,
          estadoRespuesta: estadoRespuesta,
          categoriaId: categoriaId,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citationState = ref.watch(citationControllerProvider);
    final isSubmitting = citationState.isLoading;

    ref.listen(citationControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al responder: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
        data: (_) {
          if (previous?.isLoading == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Respuesta guardada!'),
                backgroundColor: Colors.green,
              ),
            );
            // Volvemos a la lista para que se vea el estado actualizado
            GoRouter.of(context).pop();
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Actividad'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              Text(
                ActivityTipo.fromString(activity.tipo).label,
                style: TextStyle(
                  color: Colors.red[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                activity.titulo,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _InfoRow(
                icon: Icons.calendar_today,
                label: formatActivityDate(activity.fechaHora),
              ),
              if (activity.lugar != null && activity.lugar!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _InfoRow(icon: Icons.place, label: activity.lugar!),
              ],
              if (activity.indicaciones != null &&
                  activity.indicaciones!.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text(
                  'Indicaciones',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  activity.indicaciones!,
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isSubmitting
                          ? null
                          : () => _respond(context, ref, 'confirma'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text('Confirmar Asistencia'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isSubmitting
                          ? null
                          : () => _respond(context, ref, 'no_asiste'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[900],
                        side: BorderSide(color: Colors.red[900]!),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.close),
                      label: const Text('No Asistir'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isSubmitting)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.red[900], size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
      ],
    );
  }
}
