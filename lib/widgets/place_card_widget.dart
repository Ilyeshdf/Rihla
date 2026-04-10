import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/constants.dart';
import '../models/itinerary_model.dart';

class PlaceCardWidget extends StatelessWidget {
  final TimeSlot timeSlot;
  final String timeOfDay; // morning, afternoon, evening
  final VoidCallback onBook;

  const PlaceCardWidget({
    super.key,
    required this.timeSlot,
    required this.timeOfDay,
    required this.onBook,
  });

  Color get accentColor {
    switch (timeOfDay) {
      case 'morning':
        return AppConstants.accentTeal;
      case 'afternoon':
        return AppConstants.accentAmber;
      case 'evening':
        return AppConstants.accentGold;
      default:
        return AppConstants.accentTeal;
    }
  }

  String get timeLabel {
    switch (timeOfDay) {
      case 'morning':
        return 'MORNING';
      case 'afternoon':
        return 'AFTERNOON';
      case 'evening':
        return 'EVENING';
      default:
        return '';
    }
  }

  IconData get timeIcon {
    switch (timeOfDay) {
      case 'morning':
        return Icons.wb_sunny_outlined;
      case 'afternoon':
        return Icons.wb_cloudy_outlined;
      case 'evening':
        return Icons.nightlight_outlined;
      default:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppConstants.backgroundCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppConstants.divider.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Icon(timeIcon, color: accentColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  timeLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                if (timeSlot.category.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppConstants.backgroundElevated,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      timeSlot.category.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeSlot.place,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppConstants.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  timeSlot.activity,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: AppConstants.textSecondary,
                    height: 1.6,
                  ),
                ),

                if (timeSlot.tip.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppConstants.backgroundElevated.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppConstants.divider.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.tips_and_updates_outlined, color: AppConstants.accentGold, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            timeSlot.tip,
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              color: AppConstants.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                
                // Book Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: onBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor.withValues(alpha: 0.1),
                      foregroundColor: accentColor,
                      elevation: 0,
                      side: BorderSide(color: accentColor.withValues(alpha: 0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.bookmark_add_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'BOOK NOW',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
