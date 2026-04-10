class JourneyModel {
  final String id;
  final String userId;
  final String placeId;
  final String placeName;
  final String wilaya;
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;
  final double distanceKm;
  final double elevationGain;
  final List<String> photos;
  final String difficulty;
  final List<String> achievementsUnlocked;
  final int xpEarned;

  JourneyModel({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.placeName,
    required this.wilaya,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.distanceKm,
    required this.elevationGain,
    required this.photos,
    required this.difficulty,
    required this.achievementsUnlocked,
    required this.xpEarned,
  });

  factory JourneyModel.fromJson(Map<String, dynamic> json) {
    return JourneyModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      placeId: json['placeId'] ?? '',
      placeName: json['placeName'] ?? '',
      wilaya: json['wilaya'] ?? '',
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: DateTime.parse(json['endTime'] ?? DateTime.now().toIso8601String()),
      duration: Duration(seconds: json['durationSeconds'] ?? 0),
      distanceKm: (json['distanceKm'] ?? 0.0).toDouble(),
      elevationGain: (json['elevationGain'] ?? 0.0).toDouble(),
      photos: List<String>.from(json['photos'] ?? []),
      difficulty: json['difficulty'] ?? 'سهل',
      achievementsUnlocked: List<String>.from(json['achievementsUnlocked'] ?? []),
      xpEarned: json['xpEarned'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'placeId': placeId,
      'placeName': placeName,
      'wilaya': wilaya,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationSeconds': duration.inSeconds,
      'distanceKm': distanceKm,
      'elevationGain': elevationGain,
      'photos': photos,
      'difficulty': difficulty,
      'achievementsUnlocked': achievementsUnlocked,
      'xpEarned': xpEarned,
    };
  }
}
