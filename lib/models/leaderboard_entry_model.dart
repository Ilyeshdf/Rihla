class LeaderboardEntryModel {
  final int rank;
  final String userId;
  final String username;
  final String wilaya;
  final int xp;
  final int placesUnlocked;
  final String badge;

  LeaderboardEntryModel({
    required this.rank,
    this.userId = '',
    required this.username,
    required this.wilaya,
    required this.xp,
    required this.placesUnlocked,
    this.badge = '',
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      rank: json['rank'] ?? 0,
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      wilaya: json['wilaya'] ?? '',
      xp: json['xp'] ?? 0,
      placesUnlocked: json['places'] ?? 0,
      badge: json['badge'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'userId': userId,
      'username': username,
      'wilaya': wilaya,
      'xp': xp,
      'places': placesUnlocked,
      'badge': badge,
    };
  }
}
