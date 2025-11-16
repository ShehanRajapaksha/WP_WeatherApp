class AppConstants {
  // App Information
  static const String appName = 'Weather App';
  static const String appVersion = '1.0.0';

  // Preferences Keys
  static const String keyLastLocation = 'last_location';
  static const String keyLastWeatherUpdate = 'last_weather_update';
  static const String keyTemperatureUnit = 'temperature_unit';

  // Default Values
  static const double defaultLatitude = 0.0;
  static const double defaultLongitude = 0.0;

  // Time Constants
  static const int cacheExpiryMinutes = 30;
  static const int locationTimeoutSeconds = 30;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double iconSize = 80.0;
  static const double smallIconSize = 40.0;
}
