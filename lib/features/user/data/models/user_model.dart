import 'package:cultura_club/core/enums/user_rol_enums.dart';

import '../../domain/entity/user_entity.dart';
import 'player_profile_model.dart';

class UserModel {
  final String id;
  final String clubId;
  final String email;
  final UserRole role;
  final String fullName;
  final PlayerProfileModel? playerProfile;

  const UserModel({
    required this.id,
    required this.clubId,
    required this.email,
    required this.role,
    required this.fullName,
    this.playerProfile,
  });

  // Mapeamos desde el JSON de Supabase
  factory UserModel.fromJson(Map<String, dynamic> json) {
    PlayerProfileModel? playerProfile;

    // Si es JUGADOR y tiene datos en jugadores_perfil, mapear el perfil
    final role = UserRole.fromString(json['role'] ?? json['rol'] ?? 'JUGADOR');
    if (role == UserRole.jugador) {
      final playerData = json['jugadores_perfil'] as Map<String, dynamic>?;
      if (playerData != null && playerData.isNotEmpty) {
        playerProfile = PlayerProfileModel.fromJson(playerData);
      }
    }

    return UserModel(
      id: json['id'] ?? '',
      clubId: json['club_id'] ?? '',
      email: json['email'] ?? '',
      role: role,
      fullName: json['nombre_completo'] ?? 'Usuario',
      playerProfile: playerProfile,
    );
  }

  // Mapeamos hacia nuestra Entidad Pura de Dominio
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      clubId: clubId,
      email: email,
      role: role,
      fullName: fullName,
      playerProfile: playerProfile,
    );
  }
}
