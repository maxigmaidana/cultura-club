class ActivityCitationAvailabilityEntity {
  final String citationId;
  final String playerId;
  final String playerName;
  final String? playerCategoryId;
  final String? playerCategoryName;
  final String responseStatus;
  final DateTime? responseDate;
  final bool canTrain;
  final bool canPlay;
  final int activeInjuriesCount;
  final bool hasRecoveringInjury;
  final bool currentlyAvailableForActivity;
  final List<String> blockingTitles;

  const ActivityCitationAvailabilityEntity({
    required this.citationId,
    required this.playerId,
    required this.playerName,
    this.playerCategoryId,
    this.playerCategoryName,
    required this.responseStatus,
    this.responseDate,
    required this.canTrain,
    required this.canPlay,
    required this.activeInjuriesCount,
    required this.hasRecoveringInjury,
    required this.currentlyAvailableForActivity,
    required this.blockingTitles,
  });
}
