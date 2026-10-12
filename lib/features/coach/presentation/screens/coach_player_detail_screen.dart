import 'package:cultura_club/features/coach/domain/entities/player_profile_entity.dart';
import 'package:cultura_club/features/coach/presentation/controller/roster_controller.dart';
import 'package:cultura_club/core/enums/player_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CoachPlayerDetailScreen extends ConsumerWidget {
  final String categoryId;
  final String playerId;
  final PlayerProfileEntity? initialPlayer;

  const CoachPlayerDetailScreen({
    super.key,
    required this.categoryId,
    required this.playerId,
    this.initialPlayer,
  });

  static const String pathName = '/coach/category/:categoryId/player/:playerId';

  static String buildPath(String categoryId, String playerId) =>
      '/coach/category/$categoryId/player/$playerId';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener el roster de la categoría
    final rosterState = ref.watch(rosterControllerProvider(categoryId));

    return rosterState.when(
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text('Detalle del Jugador'),
          backgroundColor: Colors.red[900],
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator(color: Colors.red)),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: Colors.red[900],
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Text(
            'Error al cargar datos del jugador: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      data: (players) {
        // Buscar el jugador por ID
        final player = players.firstWhere(
          (p) => p.userId == playerId,
          orElse: () =>
              initialPlayer ??
              PlayerProfileEntity(
                userId: playerId,
                fullName: 'Jugador Desconocido',
                posiciones: [],
                piernaHabil: PiernaHabil.derecha,
                sectorCancha: SectorCancha.defensa,
              ),
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalle del Jugador'),
            backgroundColor: Colors.red[900],
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con información del jugador
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.red[50],
                              child: Icon(
                                Icons.person,
                                color: Colors.red[900],
                                size: 36,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    player.fullName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    player.sectorCancha.label,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (player.posiciones.isNotEmpty)
                                    Text(
                                      player.posiciones
                                          .map((p) => p.name.toUpperCase())
                                          .join(', '),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  if (player.posiciones.isEmpty)
                                    Text(
                                      'Sin posiciones',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pierna Hábil',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    player.piernaHabil.name.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (player.alturaCm != null)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Altura',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${player.alturaCm!.toStringAsFixed(0)} cm',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (player.pesoKg != null)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Peso',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${player.pesoKg!.toStringAsFixed(0)} kg',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Información del Jugador',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900],
                  ),
                ),
                const SizedBox(height: 12),
                // Opciones de menú
                _MenuCard(
                  icon: Icons.favorite,
                  title: 'Estado Físico',
                  description: 'Disponibilidad y lesiones',
                  onTap: () {
                    GoRouter.of(context).push('/player-injuries/$playerId');
                  },
                ),
                const SizedBox(height: 12),
                _MenuCard(
                  icon: Icons.warning_outlined,
                  title: 'Sanciones',
                  description: 'Sanciones deportivas del jugador',
                  onTap: () {
                    GoRouter.of(context).push(
                      '/coach/category/$categoryId/player/$playerId/sanctions',
                    );
                  },
                ),
                const SizedBox(height: 12),
                _MenuCard(
                  icon: Icons.person_outline,
                  title: 'Datos del Jugador',
                  description: 'Información personal y deportiva',
                  onTap: () {
                    // Esta opción abrirá un detalle adicional o permanecerá en la ficha
                    // Por ahora puede navegar a un detalle específico si lo hay
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Datos del jugador - En desarrollo'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Icon(icon, color: Colors.red[900], size: 28),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}
