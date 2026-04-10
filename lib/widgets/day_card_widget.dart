import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/constants.dart';
import '../models/itinerary_model.dart';
import 'place_card_widget.dart';

class DayCardWidget extends StatelessWidget {
  final ItineraryDay day;
  final Function(String placeName, String category) onBook;

  const DayCardWidget({
    super.key,
    required this.day,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day indicator
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppConstants.accentTeal,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'YOUR SCHEDULE FOR DAY ${day.day}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppConstants.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Morning card
          PlaceCardWidget(
            timeSlot: day.morning,
            timeOfDay: 'morning',
            onBook: () => onBook(day.morning.place, day.morning.category),
          ),

          // Afternoon card
          PlaceCardWidget(
            timeSlot: day.afternoon,
            timeOfDay: 'afternoon',
            onBook: () =>
                onBook(day.afternoon.place, day.afternoon.category),
          ),

          // Evening card
          PlaceCardWidget(
            timeSlot: day.evening,
            timeOfDay: 'evening',
            onBook: () => onBook(day.evening.place, day.evening.category),
          ),
        ],
      ),
    );
  }
}
