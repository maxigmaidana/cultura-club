import 'package:flutter/material.dart';

class CoachPlayerSanctionsScreen extends StatelessWidget {
  final String categoryId;
  final String playerId;

  const CoachPlayerSanctionsScreen({
    super.key,
    required this.categoryId,
    required this.playerId,
  });

  static const String pathName =
      '/coach/category/:categoryId/player/:playerId/sanctions';

  static String buildPath(String categoryId, String playerId) =>
      '/coach/category/$categoryId/player/$playerId/sanctions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sanciones'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No hay sanciones registradas.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Las sanciones deportivas aparecerán aquí cuando corresponda.',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
