import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/location_model.dart';
import '../services/weather_api_service.dart';
import '../services/location_service.dart';
import '../services/cache_service.dart';
import '../../core/errors/exceptions.dart';

class WeatherRepository {
  final WeatherApiService apiService;
  final LocationService locationService;
  final CacheService cacheService;

  WeatherRepository({
    required this.apiService,
    required this.locationService,
    required this.cacheService,
  });

  /// Get current weather for user's location
  Future<Weather> getCurrentWeather() async {
    try {
      // Try to get cached weather first
      if (cacheService.isCacheValid()) {
        final cachedWeather = cacheService.getCachedWeather();
        if (cachedWeather != null) {
          return cachedWeather;
        }
      }

      // Get current location
      final location = await locationService.getCurrentLocation();

      // Fetch weather data
      final weather = await apiService.getCurrentWeather(
        location.latitude,
        location.longitude,
      );

      // Cache the weather data
      await cacheService.cacheWeather(weather);
      await cacheService.cacheLocation(location);

      return weather;
    } on LocationException {
      rethrow;
    } on NetworkException {
      // If network fails, try to return cached data
      final cachedWeather = cacheService.getCachedWeather();
      if (cachedWeather != null) {
        return cachedWeather;
      }
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw WeatherException('Failed to get current weather: ${e.toString()}');
    }
  }

  /// Get weather for specific location
  Future<Weather> getWeatherForLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      final weather = await apiService.getCurrentWeather(latitude, longitude);
      await cacheService.cacheWeather(weather);
      return weather;
    } on NetworkException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw WeatherException('Failed to get weather: ${e.toString()}');
    }
  }

  /// Get weather forecast
  Future<WeatherForecast> getWeatherForecast() async {
    try {
      // Get current location (from cache or GPS)
      Location? location = cacheService.getCachedLocation();

      if (location == null) {
        location = await locationService.getCurrentLocation();
        await cacheService.cacheLocation(location);
      }

      // Fetch forecast data
      final forecast = await apiService.getWeatherForecast(
        location.latitude,
        location.longitude,
      );

      return forecast;
    } on LocationException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw WeatherException('Failed to get weather forecast: ${e.toString()}');
    }
  }

  /// Get weather forecast for specific location
  Future<WeatherForecast> getWeatherForecastForLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      final forecast = await apiService.getWeatherForecast(latitude, longitude);
      return forecast;
    } on NetworkException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw WeatherException('Failed to get forecast: ${e.toString()}');
    }
  }

  /// Refresh weather data
  Future<Weather> refreshWeather() async {
    try {
      await cacheService.clearCache();
      return await getCurrentWeather();
    } catch (e) {
      throw WeatherException('Failed to refresh weather: ${e.toString()}');
    }
  }

  /// Get current location
  Future<Location> getCurrentLocation() async {
    try {
      return await locationService.getCurrentLocation();
    } on LocationException {
      rethrow;
    } catch (e) {
      throw LocationException('Failed to get location: ${e.toString()}');
    }
  }

  /// Get cached weather if available
  Weather? getCachedWeather() {
    return cacheService.getCachedWeather();
  }

  /// Check location permission
  Future<bool> checkLocationPermission() async {
    try {
      return await locationService.checkAndRequestPermission();
    } catch (e) {
      return false;
    }
  }

  /// Open location settings
  Future<void> openLocationSettings() async {
    await locationService.openLocationSettings();
  }

  /// Dispose resources
  void dispose() {
    apiService.dispose();
  }
}
