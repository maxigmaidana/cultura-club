import 'package:cultura_club/features/coach/presentation/controller/roster_controller.dart';
import 'package:cultura_club/features/user/domain/entity/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../evaluation/presentation/screens/evaluation_form_screen.dart';

class CoachDashboardScreen extends ConsumerWidget {
  final UserEntity user;

  const CoachDashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el estado de la lista de jugadores (AsyncValue)
    final rosterState = ref.watch(rosterControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Plantel de ${user.fullName}'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
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
                'No tenés jugadores asignados a tu categoría aún.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Dibujamos la lista si hay jugadores
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];

              // Convertimos la lista de ENUMs a un string legible (Ej: "MCO, DC")
              final posicionesText = player.posiciones
                  .map((p) => p.name.toUpperCase())
                  .join(', ');

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.red[50],
                    child: Icon(Icons.person, color: Colors.red[900], size: 30),
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
                  // ¡Acá conectamos con el formulario que hicimos recién!
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EvaluationFormScreen(
                          playerId: player.userId,
                          playerName: player.fullName,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
