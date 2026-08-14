import 'package:cultura_club/features/coach/presentation/controller/roster_controller.dart';
import 'package:cultura_club/features/user/domain/entity/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoachDashboardScreen extends ConsumerWidget {
  final UserEntity user;
  const CoachDashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos la lista de jugadores
    final rosterState = ref.watch(rosterControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Plantel - DT: ${user.fullName}'),
        backgroundColor: Colors.red[900], // Podés pasarlo a Theme
      ),
      body: rosterState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (players) {
          if (players.isEmpty) {
            return const Center(
              child: Text('No hay jugadores asignados a tu categoría.'),
            );
          }

          return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              // Convertimos la lista de ENUMs a un string lindo (Ej: "DC, SD")
              final posicionesText = player.posiciones.map((p) => p.name.toUpperCase()).join(', ');

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red[100],
                    child: const Icon(Icons.person, color: Colors.red),
                  ),
                  title: Text(player.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Posiciones: $posicionesText\nPierna hábil: ${player.piernaHabil.name}'),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Acá a futuro abriremos el formulario para cargarle métricas
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cargar métricas a ${player.fullName}')),
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