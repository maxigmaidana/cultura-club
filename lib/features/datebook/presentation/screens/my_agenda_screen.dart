import 'package:cultura_club/core/enums/activity_enums.dart';
import 'package:cultura_club/core/theme/widgets/app_card.dart';
import 'package:cultura_club/core/theme/widgets/app_header_bar.dart';
import 'package:cultura_club/core/theme/widgets/app_status_badge.dart';
import 'package:cultura_club/features/auth/presentation/providers/auth_provider.dart';
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

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(signOutUseCaseProvider)();
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cerrar sesión: ${failure.message}')),
        );
      },
      (_) {
        ref.read(userSessionProvider.notifier).clearUser();
        if (context.mounted) GoRouter.of(context).go('/login');
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agendaState = ref.watch(myAgendaControllerProvider);
    final user = ref.watch(userSessionProvider).value;
    final currentUserId = user?.id;

    return Scaffold(
      appBar: AppHeaderBar(
        title: 'Mi Agenda',
        avatarInitial: user == null ? '?' : user.fullName[0].toUpperCase(),
        showLogout: true,
        onLogout: () => _signOut(context, ref),
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
              padding: const EdgeInsets.all(12.0),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        activity.titulo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AppStatusBadge(label: estado.label, color: _estadoColor),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatActivityDate(activity.fechaHora),
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
                if (activity.lugar != null &&
                    activity.lugar!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.place, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(
                        activity.lugar!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
