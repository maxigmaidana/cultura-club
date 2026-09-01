import 'package:cultura_club/core/enums/activity_enums.dart';
import 'package:cultura_club/features/coach/domain/entities/player_profile_entity.dart';
import 'package:cultura_club/features/coach/presentation/controller/roster_controller.dart';
import 'package:cultura_club/features/datebook/domain/entities/activity_entity.dart';
import 'package:cultura_club/features/datebook/domain/entities/citation_entity.dart';
import 'package:cultura_club/features/datebook/presentation/notifier/datebook_notifier.dart';
import 'package:cultura_club/features/datebook/presentation/screens/create_activity_screen.dart';
import 'package:cultura_club/features/datebook/presentation/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ActivityDashboardScreen extends ConsumerWidget {
  final String categoriaId;
  final ActivityEntity activity;

  const ActivityDashboardScreen({
    super.key,
    required this.categoriaId,
    required this.activity,
  });

  static String buildPath(String categoriaId, String activityId) =>
      '/datebook/$categoriaId/activity/$activityId/dashboard';

  List<CitationEntity> _citationsFor(
    ActivityEntity currentActivity,
    CitacionEstado estado,
  ) {
    return currentActivity.citaciones
        .where((c) => CitacionEstado.fromString(c.estadoRespuesta) == estado)
        .toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rosterState = ref.watch(rosterControllerProvider(categoriaId));
    // Tomamos la versión más reciente de la lista (se refetchea al invalidar tras editar)
    final activitiesState = ref.watch(datebookProvider(categoriaId));
    final matches =
        activitiesState.value?.where((a) => a.id == activity.id) ?? [];
    final currentActivity = matches.isEmpty ? activity : matches.first;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(currentActivity.titulo),
          backgroundColor: Colors.red[900],
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Editar actividad',
              onPressed: () {
                GoRouter.of(context).push(
                  CreateActivityScreen.buildEditPath(
                    categoriaId,
                    currentActivity.id,
                  ),
                  extra: currentActivity,
                );
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Confirmados'),
              Tab(text: 'Pendientes'),
              Tab(text: 'No Asisten'),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Colors.red[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ActivityTipo.fromString(currentActivity.tipo).label,
                    style: TextStyle(
                      color: Colors.red[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(formatActivityDate(currentActivity.fechaHora)),
                  if (currentActivity.lugar != null &&
                      currentActivity.lugar!.isNotEmpty)
                    Text(currentActivity.lugar!),
                ],
              ),
            ),
            Expanded(
              child: rosterState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
                error: (error, stack) => Center(
                  child: Text(
                    'Error al cargar el plantel: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                data: (roster) {
                  final playersById = {
                    for (final player in roster) player.userId: player,
                  };

                  return TabBarView(
                    children: [
                      _PlayerList(
                        citations: _citationsFor(
                          currentActivity,
                          CitacionEstado.confirma,
                        ),
                        playersById: playersById,
                        emptyLabel: 'Nadie confirmó todavía.',
                      ),
                      _PlayerList(
                        citations: _citationsFor(
                          currentActivity,
                          CitacionEstado.pendiente,
                        ),
                        playersById: playersById,
                        emptyLabel: 'No hay respuestas pendientes.',
                      ),
                      _PlayerList(
                        citations: _citationsFor(
                          currentActivity,
                          CitacionEstado.noAsiste,
                        ),
                        playersById: playersById,
                        emptyLabel: 'Nadie avisó ausencia.',
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerList extends StatelessWidget {
  final List<CitationEntity> citations;
  final Map<String, PlayerProfileEntity> playersById;
  final String emptyLabel;

  const _PlayerList({
    required this.citations,
    required this.playersById,
    required this.emptyLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (citations.isEmpty) {
      return Center(
        child: Text(emptyLabel, style: const TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: citations.length,
      itemBuilder: (context, index) {
        final citation = citations[index];
        final player = playersById[citation.jugadorId];
        final name = player?.fullName ?? 'Jugador desconocido';
        final posiciones = player == null || player.posiciones.isEmpty
            ? null
            : player.posiciones.map((p) => p.name.toUpperCase()).join(', ');

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red[50],
            child: Icon(Icons.person, color: Colors.red[900]),
          ),
          title: Text(name),
          subtitle: posiciones != null ? Text(posiciones) : null,
        );
      },
    );
  }
}
