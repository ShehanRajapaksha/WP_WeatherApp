class ApiConstants {
  // Open-Meteo API Configuration (No API key required!)
  static const String baseUrl = 'https://api.open-meteo.com/v1';

  // API Endpoints
  static const String forecastEndpoint = '/forecast';

  // Query Parameters
  static const String latParam = 'latitude';
  static const String lonParam = 'longitude';
  static const String currentWeatherParam = 'current_weather';
  static const String hourlyParam = 'hourly';
  static const String dailyParam = 'daily';
  static const String timezoneParam = 'timezone';

  // Weather variables for hourly forecast
  static const String hourlyWeatherVars =
      'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation_probability,precipitation,weather_code,visibility,wind_speed_10m,wind_direction_10m';

  // Weather variables for daily forecast
  static const String dailyWeatherVars =
      'weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum,precipitation_probability_max';

  // Build URL helpers
  static String getCurrentWeatherUrl(double lat, double lon) {
    return '$baseUrl$forecastEndpoint?$latParam=$lat&$lonParam=$lon&$currentWeatherParam=true&$hourlyParam=$hourlyWeatherVars&$timezoneParam=auto';
  }

  static String getForecastUrl(double lat, double lon) {
    return '$baseUrl$forecastEndpoint?$latParam=$lat&$lonParam=$lon&$currentWeatherParam=true&$hourlyParam=$hourlyWeatherVars&$dailyParam=$dailyWeatherVars&$timezoneParam=auto&forecast_days=7';
  }
}
