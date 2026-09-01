import 'package:cultura_club/core/enums/activity_enums.dart';
import 'package:cultura_club/features/datebook/domain/entities/activity_entity.dart';
import 'package:cultura_club/features/datebook/presentation/notifier/datebook_notifier.dart';
import 'package:cultura_club/features/datebook/presentation/screens/activity_dashboard_screen.dart';
import 'package:cultura_club/features/datebook/presentation/screens/activity_detail_screen.dart';
import 'package:cultura_club/features/datebook/presentation/screens/create_activity_screen.dart';
import 'package:cultura_club/features/user/presentation/providers/user_session_provider.dart';
import 'package:cultura_club/features/datebook/presentation/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DatebookScreen extends ConsumerWidget {
  final String categoriaId;

  const DatebookScreen({super.key, required this.categoriaId});

  static const String pathName = '/datebook/:categoriaId';
  static String buildPath(String categoriaId) => '/datebook/$categoriaId';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesState = ref.watch(datebookProvider(categoriaId));
    final currentUser = ref.watch(userSessionProvider).value;
    final isCoach = currentUser?.role.isCoach ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        color: Colors.red[900],
        onRefresh: () =>
            ref.read(datebookProvider(categoriaId).notifier).refresh(),
        child: activitiesState.when(
          loading: () =>
              const Center(child: CircularProgressIndicator(color: Colors.red)),
          error: (error, stack) => ListView(
            children: [
              const SizedBox(height: 120),
              Center(
                child: Text(
                  'Error al cargar la agenda: $error',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          data: (activities) {
            if (activities.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(
                    child: Text(
                      'No hay actividades programadas.',
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
                return _ActivityCard(
                  activity: activity,
                  onTap: () {
                    if (isCoach) {
                      GoRouter.of(context).push(
                        ActivityDashboardScreen.buildPath(
                          categoriaId,
                          activity.id,
                        ),
                        extra: activity,
                      );
                    } else {
                      GoRouter.of(context).push(
                        ActivityDetailScreen.buildPath(
                          categoriaId,
                          activity.id,
                        ),
                        extra: activity,
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: isCoach
          ? FloatingActionButton(
              backgroundColor: Colors.red[900],
              foregroundColor: Colors.white,
              onPressed: () {
                GoRouter.of(
                  context,
                ).push(CreateActivityScreen.buildPath(categoriaId));
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final ActivityEntity activity;
  final VoidCallback onTap;

  const _ActivityCard({required this.activity, required this.onTap});

  IconData get _icon {
    switch (ActivityTipo.fromString(activity.tipo)) {
      case ActivityTipo.partido:
        return Icons.sports_soccer;
      case ActivityTipo.evento:
        return Icons.event;
      case ActivityTipo.entrenamiento:
        return Icons.fitness_center;
    }
  }

  Color get _estadoColor {
    switch (ActivityEstado.fromString(activity.estado)) {
      case ActivityEstado.borrador:
        return Colors.grey[600]!;
      case ActivityEstado.cancelada:
        return Colors.red[900]!;
      case ActivityEstado.publicada:
        return Colors.green[700]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_icon, color: Colors.red[900], size: 28),
              ),
              const SizedBox(width: 16),
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
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatActivityDate(activity.fechaHora),
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Chip(
                label: Text(
                  ActivityEstado.fromString(activity.estado).label,
                  style: const TextStyle(fontSize: 11, color: Colors.white),
                ),
                backgroundColor: _estadoColor,
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
