import 'package:cultura_club/core/enums/activity_enums.dart';
import 'package:cultura_club/core/presentation/widgets/exports.dart';
import 'package:cultura_club/features/coach/domain/entities/player_profile_entity.dart';
import 'package:cultura_club/features/coach/presentation/controller/roster_controller.dart';
import 'package:cultura_club/features/datebook/domain/entities/activity_entity.dart';
import 'package:cultura_club/features/datebook/domain/entities/activity_citation_availability_entity.dart';
import 'package:cultura_club/features/datebook/domain/entities/citation_entity.dart';
import 'package:cultura_club/features/datebook/presentation/controllers/activity_citations_availability_controller.dart';
import 'package:cultura_club/features/datebook/presentation/notifier/datebook_notifier.dart';
import 'package:cultura_club/features/datebook/presentation/screens/create_activity_screen.dart';
import 'package:cultura_club/features/datebook/presentation/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ActivityDashboardScreen extends ConsumerWidget {
  final String categoriaId;
  final String activityId;
  final ActivityEntity? initialActivity;

  const ActivityDashboardScreen({
    super.key,
    required this.categoriaId,
    required this.activityId,
    this.initialActivity,
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
    final availabilityState = ref.watch(
      activityCitationsAvailabilityControllerProvider(activityId),
    );
    // Tomamos la versión más reciente de la lista (se refetchea al invalidar tras editar)
    final activitiesState = ref.watch(datebookProvider(categoriaId));
    final matches =
        activitiesState.value?.where((a) => a.id == activityId) ?? [];
    final currentActivity = matches.isEmpty ? initialActivity : matches.first;

    if (currentActivity == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de compromiso'),
          backgroundColor: Colors.red[900],
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('No se encontro la actividad solicitada.'),
        ),
      );
    }

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

                  final availabilityByPlayerId =
                      availabilityState.asData?.value.fold<
                        Map<String, ActivityCitationAvailabilityEntity>
                      >(<String, ActivityCitationAvailabilityEntity>{}, (
                        map,
                        item,
                      ) {
                        map[item.playerId] = item;
                        return map;
                      }) ??
                      const <String, ActivityCitationAvailabilityEntity>{};

                  final unavailablePlayers =
                      availabilityState.asData?.value
                          .where(
                            (citation) =>
                                !citation.currentlyAvailableForActivity,
                          )
                          .toList() ??
                      const <ActivityCitationAvailabilityEntity>[];

                  final requiresAttention = unavailablePlayers.isNotEmpty;

                  return TabBarView(
                    children: [
                      _DashboardTabContent(
                        warningBanner: _AttentionBanner(
                          unavailableCount: unavailablePlayers.length,
                          showAction: requiresAttention,
                          onAcknowledge: requiresAttention
                              ? () => _confirmAcknowledge(
                                  context,
                                  ref,
                                  categoriaId,
                                  activityId,
                                )
                              : null,
                        ),
                        child: _PlayerList(
                          citations: _citationsFor(
                            currentActivity,
                            CitacionEstado.confirma,
                          ),
                          playersById: playersById,
                          availabilityByPlayerId: availabilityByPlayerId,
                          activityType: ActivityTipo.fromString(
                            currentActivity.tipo,
                          ),
                          emptyLabel: 'Nadie confirmó todavía.',
                        ),
                      ),
                      _DashboardTabContent(
                        warningBanner: _AttentionBanner(
                          unavailableCount: unavailablePlayers.length,
                          showAction: requiresAttention,
                          onAcknowledge: requiresAttention
                              ? () => _confirmAcknowledge(
                                  context,
                                  ref,
                                  categoriaId,
                                  activityId,
                                )
                              : null,
                        ),
                        child: _PlayerList(
                          citations: _citationsFor(
                            currentActivity,
                            CitacionEstado.pendiente,
                          ),
                          playersById: playersById,
                          availabilityByPlayerId: availabilityByPlayerId,
                          activityType: ActivityTipo.fromString(
                            currentActivity.tipo,
                          ),
                          emptyLabel: 'No hay respuestas pendientes.',
                        ),
                      ),
                      _DashboardTabContent(
                        warningBanner: _AttentionBanner(
                          unavailableCount: unavailablePlayers.length,
                          showAction: requiresAttention,
                          onAcknowledge: requiresAttention
                              ? () => _confirmAcknowledge(
                                  context,
                                  ref,
                                  categoriaId,
                                  activityId,
                                )
                              : null,
                        ),
                        child: _PlayerList(
                          citations: _citationsFor(
                            currentActivity,
                            CitacionEstado.noAsiste,
                          ),
                          playersById: playersById,
                          availabilityByPlayerId: availabilityByPlayerId,
                          activityType: ActivityTipo.fromString(
                            currentActivity.tipo,
                          ),
                          emptyLabel: 'Nadie avisó ausencia.',
                        ),
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

  Future<void> _confirmAcknowledge(
    BuildContext context,
    WidgetRef ref,
    String categoriaId,
    String activityId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Mantener convocatoria'),
          content: const Text(
            'Hay jugadores actualmente no disponibles.\n\n¿Querés mantener la convocatoria como está?\n\nEsto no modifica las citaciones.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Mantener'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await ref
          .read(
            activityCitationsAvailabilityControllerProvider(
              activityId,
            ).notifier,
          )
          .acknowledgeAvailability(categoriaId: categoriaId);

      if (!context.mounted) return;
      AppSnackBar.show(
        context,
        AppSnackBarType.success,
        'Convocatoria marcada como revisada.',
      );
    } catch (_) {
      if (!context.mounted) return;
      AppSnackBar.show(
        context,
        AppSnackBarType.error,
        'No se pudo registrar la revision de la convocatoria.',
      );
    }
  }
}

class _DashboardTabContent extends StatelessWidget {
  final Widget warningBanner;
  final Widget child;

  const _DashboardTabContent({
    required this.warningBanner,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        warningBanner,
        Expanded(child: child),
      ],
    );
  }
}

class _AttentionBanner extends StatelessWidget {
  final int unavailableCount;
  final bool showAction;
  final VoidCallback? onAcknowledge;

  const _AttentionBanner({
    required this.unavailableCount,
    required this.showAction,
    this.onAcknowledge,
  });

  @override
  Widget build(BuildContext context) {
    if (unavailableCount <= 0) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12).copyWith(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange[800]),
              const SizedBox(width: 8),
              Text(
                'Esta convocatoria requiere atencion',
                style: TextStyle(
                  color: Colors.orange[900],
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$unavailableCount ${unavailableCount == 1 ? 'jugador ya no esta disponible para este compromiso.' : 'jugadores ya no estan disponibles para este compromiso.'}',
            style: TextStyle(color: Colors.orange[900]),
          ),
          if (showAction && onAcknowledge != null) ...[
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: onAcknowledge,
              child: const Text('Mantener convocatoria'),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlayerList extends StatelessWidget {
  final List<CitationEntity> citations;
  final Map<String, PlayerProfileEntity> playersById;
  final Map<String, ActivityCitationAvailabilityEntity> availabilityByPlayerId;
  final ActivityTipo activityType;
  final String emptyLabel;

  const _PlayerList({
    required this.citations,
    required this.playersById,
    required this.availabilityByPlayerId,
    required this.activityType,
    required this.emptyLabel,
  });

  // Clasificar posiciones en categorías
  String _getPosicionCategory(List<dynamic> posiciones) {
    if (posiciones.isEmpty) return 'Otros';

    final posicionesList = posiciones
        .map((p) => p.toString().toUpperCase())
        .toList();

    // Arqueros
    if (posicionesList.contains('PO')) return 'Arqueros';

    // Defensas: DFC/DFI/DFD y variantes
    if (posicionesList.any(
      (p) => ['DFC', 'DFI', 'DFD', 'LI', 'LD', 'CAI', 'CAD'].contains(p),
    )) {
      return 'Defensas';
    }

    // Mediocampistas: MC/MD/MI/MCD/MCO
    if (posicionesList.any(
      (p) => ['MC', 'MD', 'MI', 'MCD', 'MCO'].contains(p),
    )) {
      return 'Mediocampistas';
    }

    // Delanteros: DC/SD/EI/ED
    if (posicionesList.any((p) => ['DC', 'SD', 'EI', 'ED', 'MP'].contains(p))) {
      return 'Delanteros';
    }

    return 'Otros';
  }

  Map<String, List<(CitationEntity, PlayerProfileEntity?, String)>>
  _groupByPosition() {
    final grouped =
        <String, List<(CitationEntity, PlayerProfileEntity?, String)>>{};
    const categories = [
      'Arqueros',
      'Defensas',
      'Mediocampistas',
      'Delanteros',
      'Otros',
    ];

    // Inicializar categorías vacías
    for (final category in categories) {
      grouped[category] = [];
    }

    // Agrupar citas por categoría de posición
    for (final citation in citations) {
      final player = playersById[citation.jugadorId];
      final category = _getPosicionCategory(player?.posiciones ?? []);
      final posiciones = player == null || player.posiciones.isEmpty
          ? ''
          : player.posiciones.map((p) => p.name.toUpperCase()).join(', ');

      grouped[category]?.add((citation, player, posiciones));
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    if (citations.isEmpty) {
      return Center(
        child: Text(emptyLabel, style: const TextStyle(color: Colors.grey)),
      );
    }

    final grouped = _groupByPosition();
    // Solo mostrar categorías que tengan jugadores
    final nonEmptyGroups = grouped.entries
        .where((entry) => entry.value.isNotEmpty)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(12.0),
      children: [
        for (final entry in nonEmptyGroups) ...[
          // Título de categoría
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Text(
              entry.key,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red[900],
              ),
            ),
          ),
          // Jugadores de la categoría
          ...entry.value.map((record) {
            final (citation, player, posiciones) = record;
            final name = player?.fullName ?? 'Jugador desconocido';
            final availability = availabilityByPlayerId[citation.jugadorId];

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red[50],
                child: Icon(Icons.person, color: Colors.red[900]),
              ),
              title: Text(name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (posiciones.isNotEmpty) Text(posiciones),
                  const SizedBox(height: 2),
                  Text(
                    _responseLabel(citation.estadoRespuesta),
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  ..._availabilityLines(availability, activityType),
                ],
              ),
            );
          }),
          const Divider(height: 24),
        ],
      ],
    );
  }

  String _responseLabel(String estadoRespuesta) {
    return switch (CitacionEstado.fromString(estadoRespuesta)) {
      CitacionEstado.confirma => 'Confirmo',
      CitacionEstado.pendiente => 'Pendiente',
      CitacionEstado.noAsiste => 'No asiste',
    };
  }

  List<Widget> _availabilityLines(
    ActivityCitationAvailabilityEntity? availability,
    ActivityTipo activityType,
  ) {
    if (availability == null) return const <Widget>[];
    if (activityType == ActivityTipo.evento) return const <Widget>[];
    if (availability.currentlyAvailableForActivity) return const <Widget>[];

    final statusText = activityType == ActivityTipo.partido
        ? 'No disponible para jugar'
        : 'No disponible para entrenar';

    final widgets = <Widget>[
      const SizedBox(height: 2),
      Text(
        statusText,
        style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    ];

    if (availability.blockingTitles.isNotEmpty) {
      if (availability.blockingTitles.length == 1) {
        widgets.add(
          Text(
            'Motivo: ${availability.blockingTitles.first}',
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        );
      } else {
        widgets.add(
          const Text(
            'Motivos:',
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
        );
        for (final title in availability.blockingTitles) {
          widgets.add(
            Text(
              '• $title',
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          );
        }
      }
    }

    return widgets;
  }
}
