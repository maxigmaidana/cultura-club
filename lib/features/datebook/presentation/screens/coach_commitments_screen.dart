import 'package:cultura_club/core/enums/activity_enums.dart';
import 'package:cultura_club/features/coach/domain/entities/category_entity.dart';
import 'package:cultura_club/features/coach/presentation/controller/coach_categories_controller.dart';
import 'package:cultura_club/features/datebook/domain/entities/coach_commitment_entity.dart';
import 'package:cultura_club/features/datebook/presentation/controllers/coach_commitments_controller.dart';
import 'package:cultura_club/features/datebook/presentation/screens/activity_dashboard_screen.dart';
import 'package:cultura_club/features/datebook/presentation/screens/create_activity_screen.dart';
import 'package:cultura_club/features/datebook/presentation/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CoachCommitmentsScreen extends ConsumerWidget {
  const CoachCommitmentsScreen({super.key});

  Future<void> _openCreateFlow(BuildContext context, WidgetRef ref) async {
    final categoriesState = ref.read(coachCategoriesControllerProvider);

    if (categoriesState.isLoading) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cargando categorias...')));
      return;
    }

    if (categoriesState.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No se pudieron cargar las categorias.'),
          action: SnackBarAction(
            label: 'Reintentar',
            onPressed: () {
              ref.invalidate(coachCategoriesControllerProvider);
            },
          ),
        ),
      );
      return;
    }

    final categories = categoriesState.value ?? const <CategoryEntity>[];

    if (categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No tenes categorias asignadas para agendar un compromiso.',
          ),
        ),
      );
      return;
    }

    String? selectedCategoryId;

    if (categories.length == 1) {
      selectedCategoryId = categories.first.id;
    } else {
      selectedCategoryId = await showModalBottomSheet<String>(
        context: context,
        showDragHandle: true,
        builder: (sheetContext) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  title: Text(
                    'Agendar compromiso',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Selecciona una categoria'),
                ),
                const Divider(height: 1),
                ...categories.map(
                  (category) => ListTile(
                    leading: const Icon(Icons.groups_2_outlined),
                    title: Text(category.nombre),
                    onTap: () => Navigator.of(sheetContext).pop(category.id),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      );
    }

    if (selectedCategoryId == null || !context.mounted) return;

    await GoRouter.of(
      context,
    ).push(CreateActivityScreen.buildPath(selectedCategoryId));

    if (!context.mounted) return;
    ref.invalidate(coachCommitmentsControllerProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commitmentsState = ref.watch(coachCommitmentsControllerProvider);
    ref.watch(coachCategoriesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compromisos'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Agendar'),
        onPressed: () => _openCreateFlow(context, ref),
      ),
      body: RefreshIndicator(
        color: Colors.red[900],
        onRefresh: () =>
            ref.read(coachCommitmentsControllerProvider.notifier).refresh(),
        child: commitmentsState.when(
          loading: () => ListView(
            children: const [
              SizedBox(height: 200),
              Center(child: CircularProgressIndicator(color: Colors.red)),
            ],
          ),
          error: (error, stack) => ListView(
            children: [
              const SizedBox(height: 140),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Error al cargar compromisos: $error',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          data: (commitments) {
            if (commitments.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Proximos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 160),
                  Center(
                    child: Text(
                      'No hay compromisos futuros.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12).copyWith(bottom: 40),
              itemCount: commitments.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 4, right: 4, bottom: 8),
                    child: Text(
                      'Proximos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                final commitment = commitments[index - 1];
                return _CommitmentCard(commitment: commitment);
              },
            );
          },
        ),
      ),
    );
  }
}

class _CommitmentCard extends StatelessWidget {
  final CoachCommitmentEntity commitment;

  const _CommitmentCard({required this.commitment});

  @override
  Widget build(BuildContext context) {
    final typeLabel = ActivityTipo.fromString(commitment.tipo).label;
    final unavailableCount = commitment.unavailablePlayersCount;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          GoRouter.of(context).push(
            ActivityDashboardScreen.buildPath(
              commitment.categoryId,
              commitment.activityId,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                commitment.categoryName,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.red[900],
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                typeLabel.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                commitment.titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                formatActivityDate(commitment.fechaHora),
                style: const TextStyle(color: Colors.black87),
              ),
              if (commitment.lugar != null && commitment.lugar!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  commitment.lugar!,
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
              const SizedBox(height: 10),
              Text(
                '${commitment.citedPlayersCount} citados',
                style: TextStyle(color: Colors.grey[700]),
              ),
              if (commitment.requiresAttention) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange[800],
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Requiere atencion · $unavailableCount ${unavailableCount == 1 ? 'jugador no disponible' : 'jugadores no disponibles'}',
                          style: TextStyle(
                            color: Colors.orange[900],
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (unavailableCount > 0) ...[
                const SizedBox(height: 10),
                Text(
                  'Revisado',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
