import 'package:cultura_club/core/enums/user_rol_enums.dart';
import 'package:cultura_club/features/coach/domain/entities/category_entity.dart';
import 'player_profile_entity.dart';

class UserEntity {
  final String id;
  final String clubId;
  final String email;
  final UserRole role;
  final String fullName;
  final PlayerProfileEntity? playerProfile;
  final List<CategoryEntity>? coachCategories;

  const UserEntity({
    required this.id,
    required this.clubId,
    required this.email,
    required this.role,
    required this.fullName,
    this.playerProfile,
    this.coachCategories,
  });
}
