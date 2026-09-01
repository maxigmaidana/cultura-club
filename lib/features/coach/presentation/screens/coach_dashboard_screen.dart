import 'package:cultura_club/features/coach/presentation/controller/coach_categories_controller.dart';
import 'package:cultura_club/features/coach/presentation/screens/category_players_screen.dart';
import 'package:cultura_club/features/user/domain/entity/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CoachDashboardScreen extends ConsumerWidget {
  final UserEntity user;

  const CoachDashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el estado de las categorías del coach
    final categoriesState = ref.watch(coachCategoriesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Categorías'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      // Manejamos los 3 estados: cargando, error, o datos listos
      body: categoriesState.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.red)),
        error: (error, stack) => Center(
          child: Text(
            'Error al cargar categorías: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(
              child: Text(
                'No tenés categorías asignadas.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Dibujamos la lista de categorías
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.red[50],
                    child: Icon(Icons.groups, color: Colors.red[900], size: 32),
                  ),
                  title: Text(
                    category.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.red[900],
                  ),
                  onTap: () {
                    GoRouter.of(context).push(
                      CategoryPlayersScreen.buildPath(category.id),
                      extra: category.nombre,
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
