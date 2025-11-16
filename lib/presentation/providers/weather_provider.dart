import 'package:flutter/foundation.dart';
import '../../data/models/weather_model.dart';
import '../../data/models/forecast_model.dart';
import '../../data/models/location_model.dart';
import '../../data/repositories/weather_repository.dart';
import '../../core/errors/exceptions.dart';

enum WeatherStatus { initial, loading, loaded, error }

class WeatherProvider with ChangeNotifier {
  final WeatherRepository repository;

  WeatherProvider(this.repository);

  // Current weather state
  Weather? _currentWeather;
  WeatherStatus _status = WeatherStatus.initial;
  String? _errorMessage;

  // Forecast state
  WeatherForecast? _forecast;
  WeatherStatus _forecastStatus = WeatherStatus.initial;
  String? _forecastErrorMessage;

  // Location state
  Location? _currentLocation;

  // Student index state
  String? _studentIndex;
  double? _derivedLatitude;
  double? _derivedLongitude;
  String? _apiRequestUrl;
  DateTime? _lastUpdateTime;

  // Getters
  Weather? get currentWeather => _currentWeather;
  WeatherStatus get status => _status;
  String? get errorMessage => _errorMessage;

  WeatherForecast? get forecast => _forecast;
  WeatherStatus get forecastStatus => _forecastStatus;
  String? get forecastErrorMessage => _forecastErrorMessage;

  Location? get currentLocation => _currentLocation;

  bool get isLoading => _status == WeatherStatus.loading;
  bool get isError => _status == WeatherStatus.error;
  bool get isLoaded => _status == WeatherStatus.loaded;

  // Student index getters
  String? get studentIndex => _studentIndex;
  double? get derivedLatitude => _derivedLatitude;
  double? get derivedLongitude => _derivedLongitude;
  String? get apiRequestUrl => _apiRequestUrl;
  DateTime? get lastUpdateTime => _lastUpdateTime;

  /// Initialize and load weather data
  Future<void> initialize() async {
    await loadCurrentWeather();
  }

  /// Load current weather
  Future<void> loadCurrentWeather() async {
    try {
      _status = WeatherStatus.loading;
      _errorMessage = null;
      notifyListeners();

      _currentWeather = await repository.getCurrentWeather();
      _currentLocation = Location(
        latitude: _currentWeather!.latitude,
        longitude: _currentWeather!.longitude,
        cityName: _currentWeather!.cityName,
        country: _currentWeather!.country,
      );

      _status = WeatherStatus.loaded;
      _errorMessage = null;
      notifyListeners();
    } on LocationException catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = e.message;
      notifyListeners();
    } on NetworkException catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = e.message;
      // Try to load cached data
      final cachedWeather = repository.getCachedWeather();
      if (cachedWeather != null) {
        _currentWeather = cachedWeather;
        _status = WeatherStatus.loaded;
      }
      notifyListeners();
    } on ServerException catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = 'An unexpected error occurred';
      notifyListeners();
    }
  }

  /// Load weather forecast
  Future<void> loadForecast() async {
    try {
      _forecastStatus = WeatherStatus.loading;
      _forecastErrorMessage = null;
      notifyListeners();

      _forecast = await repository.getWeatherForecast();

      _forecastStatus = WeatherStatus.loaded;
      _forecastErrorMessage = null;
      notifyListeners();
    } on LocationException catch (e) {
      _forecastStatus = WeatherStatus.error;
      _forecastErrorMessage = e.message;
      notifyListeners();
    } on NetworkException catch (e) {
      _forecastStatus = WeatherStatus.error;
      _forecastErrorMessage = e.message;
      notifyListeners();
    } on ServerException catch (e) {
      _forecastStatus = WeatherStatus.error;
      _forecastErrorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _forecastStatus = WeatherStatus.error;
      _forecastErrorMessage = 'An unexpected error occurred';
      notifyListeners();
    }
  }

  /// Load weather for specific location
  Future<void> loadWeatherForLocation(double latitude, double longitude) async {
    try {
      _status = WeatherStatus.loading;
      _errorMessage = null;
      notifyListeners();

      _currentWeather = await repository.getWeatherForLocation(
        latitude,
        longitude,
      );
      _currentLocation = Location(
        latitude: _currentWeather!.latitude,
        longitude: _currentWeather!.longitude,
        cityName: _currentWeather!.cityName,
        country: _currentWeather!.country,
      );

      _status = WeatherStatus.loaded;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = 'Failed to load weather for location';
      notifyListeners();
    }
  }

  /// Set student index and store derived coordinates
  void setStudentIndex(String index, double latitude, double longitude) {
    _studentIndex = index;
    _derivedLatitude = latitude;
    _derivedLongitude = longitude;
    notifyListeners();
  }

  /// Load weather by coordinates (for student index-derived location)
  Future<void> loadWeatherByCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      _status = WeatherStatus.loading;
      _errorMessage = null;
      _lastUpdateTime = DateTime.now();

      // Build API URL for display
      _apiRequestUrl =
          'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true';

      notifyListeners();

      _currentWeather = await repository.getWeatherForLocation(
        latitude,
        longitude,
      );
      _currentLocation = Location(
        latitude: latitude,
        longitude: longitude,
        cityName: _currentWeather!.cityName,
        country: _currentWeather!.country,
      );

      _status = WeatherStatus.loaded;
      _errorMessage = null;
      _lastUpdateTime = DateTime.now();
      notifyListeners();
    } on NetworkException catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = e.message;
      // Try to load cached data
      final cachedWeather = repository.getCachedWeather();
      if (cachedWeather != null) {
        _currentWeather = cachedWeather;
        _status = WeatherStatus.loaded;
        _errorMessage = 'Showing cached data (offline)';
      }
      notifyListeners();
    } catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Refresh weather data
  Future<void> refresh() async {
    try {
      _status = WeatherStatus.loading;
      notifyListeners();

      _currentWeather = await repository.refreshWeather();
      _currentLocation = Location(
        latitude: _currentWeather!.latitude,
        longitude: _currentWeather!.longitude,
        cityName: _currentWeather!.cityName,
        country: _currentWeather!.country,
      );

      _status = WeatherStatus.loaded;
      _errorMessage = null;
      notifyListeners();

      // Also refresh forecast
      await loadForecast();
    } catch (e) {
      _status = WeatherStatus.error;
      _errorMessage = 'Failed to refresh weather';
      notifyListeners();
    }
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    try {
      return await repository.checkLocationPermission();
    } catch (e) {
      return false;
    }
  }

  /// Open location settings
  Future<void> openLocationSettings() async {
    await repository.openLocationSettings();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    repository.dispose();
    super.dispose();
  }
}
