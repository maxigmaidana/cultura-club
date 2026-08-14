import 'package:cultura_club/core/enums/user_rol_enums.dart';

import '../../domain/entity/user_entity.dart';

class UserModel {
  final String id;
  final String clubId;
  final String email;
  final UserRole role;
  final String fullName;

  const UserModel({
    required this.id,
    required this.clubId,
    required this.email,
    required this.role,
    required this.fullName,
  });

  // Mapeamos desde el JSON de Supabase
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      clubId: json['club_id'] ?? '',
      email: json['email'] ?? '',
      role: UserRole.fromString(json['role'] ?? json['rol'] ?? 'JUGADOR'),
      fullName: json['full_name'] ?? 'Usuario',
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
    );
  }
}