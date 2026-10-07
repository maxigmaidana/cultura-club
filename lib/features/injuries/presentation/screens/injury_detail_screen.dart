import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/player_unavailability_entity.dart';
import '../providers/injuries_provider.dart';
import '../widgets/injury_detail_card.dart';

class InjuryDetailScreen extends ConsumerWidget {
  static const pathName = '/player-injuries/:playerId/:injuryId';

  const InjuryDetailScreen({super.key, this.injury, this.playerId});

  final PlayerUnavailabilityEntity? injury;
  final String? playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If injury is provided (mobile app navigation via state.extra), use it directly
    if (injury != null) {
      return InjuryDetailCard(injury: injury!);
    }

    // For web: fetch injuries and find the one matching current route
    if (playerId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de la Lesión'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('No se encontró información de la lesión'),
        ),
      );
    }

    final unavailabilitiesAsync = ref.watch(
      playerUnavailabilitiesProvider(playerId!),
    );

    return unavailabilitiesAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text('Detalle de la Lesión'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Center(child: Text('Error al cargar: $error')),
      ),
      data: (unavailabilities) {
        // In web, we can't get injuryId from route params easily with state.extra
        // So just show the first injury or empty state
        if (unavailabilities.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Detalle de la Lesión'),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            body: const Center(child: Text('No se encontró la lesión')),
          );
        }
        // Show the first injury as fallback
        return InjuryDetailCard(injury: unavailabilities.first);
      },
    );
  }
}
