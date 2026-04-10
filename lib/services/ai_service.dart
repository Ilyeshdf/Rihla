import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/itinerary_model.dart';

class AiService {
  static Future<Itinerary> generateItinerary({
    required String userPrompt,
    required int days,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.groqApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConstants.groqApiKey}',
        },
        body: jsonEncode({
          'model': AppConstants.groqModel,
          'messages': [
            {
              'role': 'system',
              'content': AppConstants.systemPrompt,
            },
            {
              'role': 'user',
              'content': userPrompt,
            },
          ],
          'temperature': 0.7,
          'max_tokens': 2048,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;

        // Try to extract JSON from the response
        final jsonStr = _extractJson(content);
        final itineraryJson = jsonDecode(jsonStr);
        return Itinerary.fromJson(itineraryJson);
      } else {
        // API error, use fallback
        return await _loadFallbackItinerary(days);
      }
    } catch (e) {
      // Any error, use fallback
      return await _loadFallbackItinerary(days);
    }
  }

  static String _extractJson(String text) {
    // Try to find JSON in the response
    final startIndex = text.indexOf('{');
    final endIndex = text.lastIndexOf('}');

    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      return text.substring(startIndex, endIndex + 1);
    }

    return text;
  }

  static Future<Itinerary> _loadFallbackItinerary(int days) async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/fallback_itinerary.json');
      final json = jsonDecode(jsonString);
      final itinerary = Itinerary.fromJson(json);

      // Trim or repeat days to match requested number
      if (days <= itinerary.days.length) {
        return Itinerary(
          destination: itinerary.destination,
          days: itinerary.days.sublist(0, days),
        );
      } else {
        // Repeat the last day to fill remaining days
        final extendedDays = List<ItineraryDay>.from(itinerary.days);
        for (int i = itinerary.days.length; i < days; i++) {
          final sourceDay =
              itinerary.days[i % itinerary.days.length];
          extendedDays.add(ItineraryDay(
            day: i + 1,
            morning: sourceDay.morning,
            afternoon: sourceDay.afternoon,
            evening: sourceDay.evening,
          ));
        }
        return Itinerary(
          destination: itinerary.destination,
          days: extendedDays,
        );
      }
    } catch (e) {
      // Ultimate fallback - generate a minimal itinerary
      return _generateMinimalItinerary(days);
    }
  }

  static Itinerary _generateMinimalItinerary(int days) {
    final generatedDays = List.generate(days, (i) {
      return ItineraryDay(
        day: i + 1,
        morning: TimeSlot(
          place: 'القصبة',
          activity: 'جولة في أزقة القصبة العتيقة',
          category: 'تراث',
        ),
        afternoon: TimeSlot(
          place: 'مطعم دار الجلد',
          activity: 'تذوق الأطباق الجزائرية التقليدية',
          category: 'أكل',
        ),
        evening: TimeSlot(
          place: 'الجامع الكبير',
          activity: 'زيارة الجامع الكبير',
          tip: 'أفضل وقت للزيارة بعد صلاة المغرب',
        ),
      );
    });

    return Itinerary(
      destination: 'الجزائر العاصمة',
      days: generatedDays,
    );
  }
}
