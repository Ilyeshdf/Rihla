import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/place_model.dart';

class PlacesData {
  static PlaceData? _cachedData;

  static Future<PlaceData> load() async {
    if (_cachedData != null) return _cachedData!;

    final jsonString =
        await rootBundle.loadString('assets/data/places.json');
    final json = jsonDecode(jsonString);
    _cachedData = PlaceData.fromJson(json);
    return _cachedData!;
  }

  static Future<Wilaya?> getWilaya(String id) async {
    final data = await load();
    return data.getWilaya(id);
  }

  static Future<List<Wilaya>> getAllWilayas() async {
    final data = await load();
    return data.wilayas;
  }
}
