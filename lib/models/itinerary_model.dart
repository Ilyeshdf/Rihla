class Itinerary {
  final String destination;
  final List<ItineraryDay> days;

  Itinerary({required this.destination, required this.days});

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      destination: json['destination'] ?? '',
      days: (json['days'] as List<dynamic>?)
              ?.map((d) => ItineraryDay.fromJson(d))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'destination': destination,
      'days': days.map((d) => d.toJson()).toList(),
    };
  }
}

class ItineraryDay {
  final int day;
  final TimeSlot morning;
  final TimeSlot afternoon;
  final TimeSlot evening;

  ItineraryDay({
    required this.day,
    required this.morning,
    required this.afternoon,
    required this.evening,
  });

  factory ItineraryDay.fromJson(Map<String, dynamic> json) {
    return ItineraryDay(
      day: json['day'] ?? 1,
      morning: TimeSlot.fromJson(json['morning'] ?? {}),
      afternoon: TimeSlot.fromJson(json['afternoon'] ?? {}),
      evening: TimeSlot.fromJson(json['evening'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'morning': morning.toJson(),
      'afternoon': afternoon.toJson(),
      'evening': evening.toJson(),
    };
  }
}

class TimeSlot {
  final String place;
  final String activity;
  final String category;
  final String tip;

  TimeSlot({
    required this.place,
    required this.activity,
    this.category = '',
    this.tip = '',
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      place: json['place'] ?? '',
      activity: json['activity'] ?? '',
      category: json['category'] ?? '',
      tip: json['tip'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place': place,
      'activity': activity,
      'category': category,
      'tip': tip,
    };
  }
}
