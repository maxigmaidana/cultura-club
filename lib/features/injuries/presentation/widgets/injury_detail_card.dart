import 'package:flutter/material.dart';
import '../../domain/entities/player_unavailability_entity.dart';

class InjuryDetailCard extends StatelessWidget {
  final PlayerUnavailabilityEntity injury;

  const InjuryDetailCard({super.key, required this.injury});

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de la Lesión'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              injury.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Estado
            _DetailSection(
              title: 'Estado',
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(injury.status).withValues(alpha: 0.1),
                  border: Border.all(color: _getStatusColor(injury.status)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  injury.statusInSpanish,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(injury.status),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Información
            _DetailSection(
              title: 'Información',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título siempre se muestra
                  _DetailField('Título', injury.title),

                  // Descripción: solo si tiene valor
                  if (injury.description != null &&
                      injury.description!.isNotEmpty)
                    _DetailField('Descripción', injury.description!),

                  // Zona Corporal: solo si tiene valor
                  if (injury.bodyArea != null && injury.bodyArea!.isNotEmpty)
                    _DetailField('Zona Corporal', injury.bodyArea!),

                  // Lado: solo si no es NOT_APPLICABLE y tiene valor
                  if (injury.bodySideInSpanish != null)
                    _DetailField('Lado', injury.bodySideInSpanish!),

                  // Severidad: solo si tiene valor, y traducida al español
                  if (injury.severityInSpanish != null)
                    _DetailField('Severidad', injury.severityInSpanish!),

                  // Fecha de inicio: siempre se muestra
                  _DetailField('Inicio', _formatDate(injury.startDate)),

                  // Regreso Estimado: solo si tiene valor
                  if (injury.estimatedReturnDate != null)
                    _DetailField(
                      'Regreso Estimado',
                      _formatDate(injury.estimatedReturnDate!),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Disponibilidad
            _DetailSection(
              title: 'Disponibilidad',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AvailabilityRow(
                    label: 'Puede entrenar',
                    available: injury.canTrain,
                  ),
                  const SizedBox(height: 12),
                  _AvailabilityRow(
                    label: 'Puede jugar',
                    available: injury.canPlay,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Indicaciones (if present)
            if (injury.playerNotes != null && injury.playerNotes!.isNotEmpty)
              _DetailSection(
                title: 'Indicaciones',
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    injury.playerNotes!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),

            // Alta médica (if closed)
            if (injury.isClosed)
              _DetailSection(
                title: 'Alta Médica',
                child: Text(
                  injury.closedAt != null
                      ? 'Alta otorgada el ${_formatDate(injury.closedAt!)}'
                      : 'Lesión cerrada',
                  style: const TextStyle(fontSize: 14, color: Colors.green),
                ),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ACTIVE':
        return Colors.red;
      case 'RECOVERING':
        return Colors.orange;
      case 'CLOSED':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _DetailField extends StatelessWidget {
  final String label;
  final String value;

  const _DetailField(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class _AvailabilityRow extends StatelessWidget {
  final String label;
  final bool available;

  const _AvailabilityRow({required this.label, required this.available});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          available ? Icons.check_circle : Icons.cancel,
          size: 20,
          color: available ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
        Text(
          available ? 'Sí' : 'No',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: available ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }
}
