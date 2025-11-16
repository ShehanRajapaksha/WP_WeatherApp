import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/weather_model.dart';
import '../models/location_model.dart';

class CacheService {
  final SharedPreferences preferences;

  CacheService(this.preferences);

  /// Save weather data to cache
  Future<void> cacheWeather(Weather weather) async {
    try {
      final jsonString = json.encode(weather.toJson());
      await preferences.setString('cached_weather', jsonString);
      await preferences.setInt(
        'cached_weather_time',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheException('Failed to cache weather data');
    }
  }

  /// Get cached weather data
  Weather? getCachedWeather() {
    try {
      final jsonString = preferences.getString('cached_weather');
      if (jsonString == null) return null;

      final cacheTime = preferences.getInt('cached_weather_time');
      if (cacheTime == null) return null;

      // Check if cache is expired (30 minutes)
      final cacheDateTime = DateTime.fromMillisecondsSinceEpoch(cacheTime);
      final now = DateTime.now();
      final difference = now.difference(cacheDateTime);

      if (difference.inMinutes > AppConstants.cacheExpiryMinutes) {
        return null;
      }

      // Cache format is still using old format, return null for now
      // Can be re-cached with new format on next API call
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Save location to cache
  Future<void> cacheLocation(Location location) async {
    try {
      final jsonString = json.encode(location.toJson());
      await preferences.setString('cached_location', jsonString);
    } catch (e) {
      throw CacheException('Failed to cache location');
    }
  }

  /// Get cached location
  Location? getCachedLocation() {
    try {
      final jsonString = preferences.getString('cached_location');
      if (jsonString == null) return null;

      final data = json.decode(jsonString) as Map<String, dynamic>;
      return Location.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// Clear all cache
  Future<void> clearCache() async {
    try {
      await preferences.remove('cached_weather');
      await preferences.remove('cached_weather_time');
      await preferences.remove('cached_location');
    } catch (e) {
      throw CacheException('Failed to clear cache');
    }
  }

  /// Check if cache is valid
  bool isCacheValid() {
    final cacheTime = preferences.getInt('cached_weather_time');
    if (cacheTime == null) return false;

    final cacheDateTime = DateTime.fromMillisecondsSinceEpoch(cacheTime);
    final now = DateTime.now();
    final difference = now.difference(cacheDateTime);

    return difference.inMinutes <= AppConstants.cacheExpiryMinutes;
  }
}
