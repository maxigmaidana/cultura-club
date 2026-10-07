import 'package:flutter/material.dart';
import '../../domain/entities/player_unavailability_entity.dart';

class InjuryCard extends StatelessWidget {
  final PlayerUnavailabilityEntity injury;
  final VoidCallback onTap;

  const InjuryCard({
    super.key,
    required this.injury,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              injury.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(injury.status),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                injury.statusInSpanish,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Start date
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Desde ${_formatDate(injury.startDate)}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Availability info
            Row(
              children: [
                _availabilityBadge(
                  'Entrenar',
                  injury.canTrain,
                ),
                const SizedBox(width: 16),
                _availabilityBadge(
                  'Jugar',
                  injury.canPlay,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Detail button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onTap,
                child: const Text('Ver detalle'),
              ),
            ),
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

  Widget _availabilityBadge(String label, bool available) {
    return Row(
      children: [
        Icon(
          available ? Icons.check_circle : Icons.cancel,
          size: 16,
          color: available ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 4),
        Text(
          available ? 'Puede $label' : 'No puede $label',
          style: TextStyle(
            fontSize: 13,
            color: available ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
