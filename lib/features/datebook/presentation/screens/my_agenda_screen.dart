import 'package:cultura_club/core/enums/activity_enums.dart';
import 'package:cultura_club/features/datebook/domain/entities/activity_entity.dart';
import 'package:cultura_club/features/datebook/presentation/controllers/my_agenda_controller.dart';
import 'package:cultura_club/features/datebook/presentation/screens/activity_detail_screen.dart';
import 'package:cultura_club/features/datebook/presentation/utils/date_formatter.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyAgendaScreen extends ConsumerWidget {
  const MyAgendaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agendaState = ref.watch(myAgendaControllerProvider);
    final currentUserId = ref.watch(userSessionProvider).value?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Agenda'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        color: Colors.red[900],
        onRefresh: () =>
            ref.read(myAgendaControllerProvider.notifier).refresh(),
        child: agendaState.when(
          loading: () =>
              const Center(child: CircularProgressIndicator(color: Colors.red)),
          error: (error, stack) => ListView(
            children: [
              const SizedBox(height: 120),
              Center(
                child: Text(
                  'Error al cargar tu agenda: $error',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          data: (activities) {
            if (activities.isEmpty || currentUserId == null) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(
                    child: Text(
                      'No tenés actividades asignadas.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                final myCitations = activity.citaciones.where(
                  (c) => c.jugadorId == currentUserId,
                );
                final myCitation = myCitations.isEmpty
                    ? null
                    : myCitations.first;
                final estado = CitacionEstado.fromString(
                  myCitation?.estadoRespuesta,
                );

                return _AgendaCard(
                  activity: activity,
                  estado: estado,
                  onTap: () => GoRouter.of(context).push(
                    ActivityDetailScreen.buildPath(
                      activity.categoriaId,
                      activity.id,
                    ),
                    extra: activity,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _AgendaCard extends StatelessWidget {
  final ActivityEntity activity;
  final CitacionEstado estado;
  final VoidCallback onTap;

  const _AgendaCard({
    required this.activity,
    required this.estado,
    required this.onTap,
  });

  Color get _estadoColor {
    switch (estado) {
      case CitacionEstado.confirma:
        return Colors.green[700]!;
      case CitacionEstado.noAsiste:
        return Colors.red[900]!;
      case CitacionEstado.pendiente:
        return Colors.orange[800]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tipoIcon = _getTipoIcon(activity.tipo);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(tipoIcon, color: Colors.blue[900], size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.titulo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activity.tipo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _estadoColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _estadoColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      estado.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _estadoColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                Icons.calendar_today,
                formatActivityDate(activity.fechaHora),
              ),
              if (activity.lugar != null && activity.lugar!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildInfoRow(Icons.place, activity.lugar!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  IconData _getTipoIcon(String tipo) {
    final tipoUpper = tipo.toUpperCase();
    if (tipoUpper.contains('PARTIDO')) return Icons.sports_soccer;
    if (tipoUpper.contains('ENTRENAMIENTO')) return Icons.fitness_center;
    if (tipoUpper.contains('EVENTO')) return Icons.event;
    return Icons.calendar_today;
  }
}
