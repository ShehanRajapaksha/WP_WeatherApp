import 'package:flutter/material.dart';

class WeatherHelper {
  /// Get weather description based on condition code
  static String getWeatherDescription(String condition) {
    return condition;
  }

  /// Get appropriate icon based on weather condition
  static IconData getWeatherIcon(String condition) {
    condition = condition.toLowerCase();

    if (condition.contains('clear')) {
      return Icons.wb_sunny;
    } else if (condition.contains('cloud')) {
      return Icons.wb_cloudy;
    } else if (condition.contains('rain') || condition.contains('drizzle')) {
      return Icons.umbrella;
    } else if (condition.contains('thunder')) {
      return Icons.flash_on;
    } else if (condition.contains('snow')) {
      return Icons.ac_unit;
    } else if (condition.contains('fog') || condition.contains('mist')) {
      return Icons.cloud;
    } else {
      return Icons.wb_sunny;
    }
  }

  /// Get color based on temperature
  static Color getTemperatureColor(double temperature) {
    if (temperature >= 30) {
      return Colors.red;
    } else if (temperature >= 20) {
      return Colors.orange;
    } else if (temperature >= 10) {
      return Colors.amber;
    } else if (temperature >= 0) {
      return Colors.lightBlue;
    } else {
      return Colors.blue;
    }
  }

  /// Format temperature
  static String formatTemperature(double temperature) {
    return '${temperature.round()}°';
  }

  /// Get air quality description
  static String getAirQualityDescription(int aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for Sensitive Groups';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  /// Get UV index description
  static String getUVIndexDescription(int uvIndex) {
    if (uvIndex <= 2) return 'Low';
    if (uvIndex <= 5) return 'Moderate';
    if (uvIndex <= 7) return 'High';
    if (uvIndex <= 10) return 'Very High';
    return 'Extreme';
  }
}
