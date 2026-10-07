import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/player_unavailability_model.dart';

abstract class InjuriesRemoteDataSource {
  Future<List<PlayerUnavailabilityModel>> getPlayerUnavailabilities(
    String playerId,
  );
}

class InjuriesRemoteDataSourceImpl implements InjuriesRemoteDataSource {
  final SupabaseClient supabaseClient;

  InjuriesRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<PlayerUnavailabilityModel>> getPlayerUnavailabilities(
    String playerId,
  ) async {
    try {
      log(
        '📡 REQUEST | table: player_unavailabilities | action: select | '
        'filters: player_id = $playerId | order: start_date DESC',
        name: 'Supabase',
      );

      final response = await supabaseClient
          .from('player_unavailabilities')
          .select()
          .eq('player_id', playerId)
          .order('start_date', ascending: false);

      log(
        '✅ RESPONSE | table: player_unavailabilities | action: select | '
        'records: ${response.length}',
        name: 'Supabase',
      );

      return (response as List<dynamic>)
          .map(
            (json) => PlayerUnavailabilityModel.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (error, stackTrace) {
      log(
        '❌ ERROR | table: player_unavailabilities | action: select | error: $error',
        name: 'Supabase',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
