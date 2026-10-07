import 'package:flutter/material.dart';
import '../../domain/entities/player_unavailability_entity.dart';
import '../widgets/injury_detail_card.dart';

class InjuryDetailScreen extends StatelessWidget {
  static const pathName = '/player-injuries/:playerId/:injuryId';

  const InjuryDetailScreen({
    super.key,
    required this.injury,
  });

  final PlayerUnavailabilityEntity injury;

  @override
  Widget build(BuildContext context) {
    return InjuryDetailCard(injury: injury);
  }
}
