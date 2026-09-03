import 'package:cultura_club/core/enums/activity_enums.dart';
import 'package:cultura_club/core/theme/widgets/app_button.dart';
import 'package:cultura_club/core/theme/widgets/app_card.dart';
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
      appBar: AppBar(title: const Text('Detalle')),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              _ActivityHeroImage(activity: activity),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.titulo,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppCard(
                      child: Column(
                        children: [
                          _InfoRow(
                            icon: Icons.calendar_today,
                            label: formatActivityDate(activity.fechaHora),
                          ),
                          if (activity.lugar != null &&
                              activity.lugar!.isNotEmpty) ...[
                            const Divider(height: 20),
                            _InfoRow(icon: Icons.place, label: activity.lugar!),
                          ],
                        ],
                      ),
                    ),
                    if (activity.indicaciones != null &&
                        activity.indicaciones!.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Indicaciones',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        activity.indicaciones!,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        variant: AppButtonVariant.success,
                        icon: Icons.check,
                        label: 'Confirmar Asistencia',
                        isLoading: isSubmitting,
                        onPressed: () => _respond(context, ref, 'confirma'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        variant: AppButtonVariant.danger,
                        icon: Icons.close,
                        label: 'No Asistir',
                        isLoading: isSubmitting,
                        onPressed: () => _respond(context, ref, 'no_asiste'),
                      ),
                    ),
                  ],
                ),
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

class _ActivityHeroImage extends StatelessWidget {
  final ActivityEntity activity;

  const _ActivityHeroImage({required this.activity});

  IconData get _placeholderIcon {
    switch (ActivityTipo.fromString(activity.tipo)) {
      case ActivityTipo.partido:
        return Icons.sports_soccer;
      case ActivityTipo.evento:
        return Icons.event;
      case ActivityTipo.entrenamiento:
        return Icons.fitness_center;
    }
  }

  Widget _placeholder(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.primaryContainer,
      alignment: Alignment.center,
      child: Icon(_placeholderIcon, size: 56, color: scheme.onPrimaryContainer),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagenUrl = activity.imagenUrl;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            imagenUrl == null || imagenUrl.isEmpty
                ? _placeholder(context)
                : Image.network(
                    imagenUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _placeholder(context),
                  ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  ActivityTipo.fromString(activity.tipo).label,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
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
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
      ],
    );
  }
}
