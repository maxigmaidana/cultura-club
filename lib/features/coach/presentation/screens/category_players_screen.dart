import 'package:cultura_club/features/coach/presentation/controller/roster_controller.dart';
import 'package:cultura_club/features/coach/domain/entities/player_profile_entity.dart';
import 'package:cultura_club/core/enums/player_enums.dart';
import 'package:cultura_club/features/datebook/presentation/screens/create_activity_screen.dart';
import 'package:cultura_club/features/datebook/presentation/screens/datebook_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../evaluation/presentation/screens/evaluation_form_screen.dart';

class CategoryPlayersScreen extends ConsumerWidget {
  final String categoryId;
  final String categoryName;

  const CategoryPlayersScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  static const String pathName = '/coach/category/:categoryId';
  static String buildPath(String categoryId) => '/coach/category/$categoryId';

  // Clasificar posiciones en categorías
  String _getPosicionCategory(List<Posicion> posiciones) {
    if (posiciones.isEmpty) return 'Otros';

    final posicionesList = posiciones.map((p) => p.name.toUpperCase()).toList();

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

  Map<String, List<PlayerProfileEntity>> _groupByPosition(
    List<PlayerProfileEntity> players,
  ) {
    final grouped = <String, List<PlayerProfileEntity>>{};
    const categories = [
      'Arqueros',
      'Defensas',
      'Mediocampistas',
      'Delanteros',
      'Otros',
    ];

    for (final category in categories) {
      grouped[category] = [];
    }

    for (final PlayerProfileEntity player in players) {
      final category = _getPosicionCategory(player.posiciones);
      grouped[category]?.add(player);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el estado de la lista de jugadores filtrada por categoría
    final rosterState = ref.watch(rosterControllerProvider(categoryId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Plantel - $categoryName'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Ver actividades programadas',
            onPressed: () {
              GoRouter.of(context).push(DatebookScreen.buildPath(categoryId));
            },
          ),
        ],
      ),
      // Manejamos los 3 estados: cargando, error, o datos listos
      body: rosterState.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.red)),
        error: (error, stack) => Center(
          child: Text(
            'Error al cargar jugadores: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (players) {
          if (players.isEmpty) {
            return const Center(
              child: Text(
                'No hay jugadores asignados a esta categoría.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final grouped = _groupByPosition(players);
          final nonEmptyGroups = grouped.entries
              .where(
                (MapEntry<String, List<PlayerProfileEntity>> entry) =>
                    entry.value.isNotEmpty,
              )
              .toList();

          // Dibujamos la lista agrupada por categoría de posición
          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              for (final MapEntry<String, List<PlayerProfileEntity>> entry
                  in nonEmptyGroups) ...[
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
                ...entry.value.map((PlayerProfileEntity player) {
                  final posicionesText = player.posiciones
                      .map((Posicion p) => p.name.toUpperCase())
                      .join(', ');

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.red[50],
                        child: Icon(
                          Icons.person,
                          color: Colors.red[900],
                          size: 30,
                        ),
                      ),
                      title: Text(
                        player.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Posiciones: $posicionesText'),
                            Text(
                              'Pierna: ${player.piernaHabil.name.toUpperCase()}',
                            ),
                          ],
                        ),
                      ),
                      trailing: Icon(
                        Icons.analytics_outlined,
                        color: Colors.red[900],
                      ),
                      onTap: () {
                        GoRouter.of(context).push(
                          EvaluationFormScreen.buildPath(
                            categoryId,
                            player.userId,
                          ),
                          extra: player.fullName,
                        );
                      },
                    ),
                  );
                }),
                const Divider(height: 24),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        icon: const Icon(Icons.event_note),
        label: const Text('Agendar'),
        onPressed: () {
          GoRouter.of(context).push(CreateActivityScreen.buildPath(categoryId));
        },
      ),
    );
  }
}
