import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/theme_provider.dart';
import '../providers/injuries_provider.dart';
import '../widgets/injury_card.dart';

class PlayerInjuriesScreen extends ConsumerWidget {
  static const pathName = '/player-injuries';

  const PlayerInjuriesScreen({super.key, required this.playerId});

  final String playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = ref.watch(primaryColorProvider);
    final unavailabilitiesAsync = ref.watch(
      playerUnavailabilitiesProvider(playerId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sanciones'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: unavailabilitiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorState(
          onRetry: () {
            ref.refresh(playerUnavailabilitiesProvider(playerId));
          },
        ),
        data: (unavailabilities) {
          if (unavailabilities.isEmpty) {
            return _EmptyState();
          }

          // Separate into current and closed
          final current = unavailabilities.where((u) => u.isCurrent).toList();
          final history = unavailabilities.where((u) => u.isClosed).toList();

          return RefreshIndicator(
            onRefresh: () async {
              await ref.refresh(
                playerUnavailabilitiesProvider(playerId).future,
              );
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Current injuries
                if (current.isEmpty && history.isNotEmpty)
                  _SectionHeader(title: 'Actuales')
                else if (current.isNotEmpty)
                  _SectionHeader(title: 'Actuales'),
                if (current.isEmpty && history.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Text(
                      'No tenés lesiones activas.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  )
                else if (current.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      children: current.map((injury) {
                        return InjuryCard(
                          injury: injury,
                          onTap: () {
                            GoRouter.of(context).push(
                              '/player-injuries/$playerId/${injury.id}',
                              extra: injury,
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),

                // History section
                if (history.isNotEmpty) ...[
                  _SectionHeader(title: 'Historial'),
                  Column(
                    children: history.map((injury) {
                      return InjuryCard(
                        injury: injury,
                        onTap: () {
                          GoRouter.of(context).push(
                            '/player-injuries/$playerId/${injury.id}',
                            extra: injury,
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.health_and_safety_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            const Text(
              'No tenés lesiones o indisponibilidades registradas.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Text(
              'Cuando exista alguna, vas a poder consultar acá su estado y seguimiento.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'No pudimos cargar tus lesiones.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onRetry, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}
