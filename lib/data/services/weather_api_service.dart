import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherApiService {
  final http.Client client;

  WeatherApiService({http.Client? client}) : client = client ?? http.Client();

  /// Get current weather for a location
  Future<Weather> getCurrentWeather(double latitude, double longitude) async {
    try {
      final url = ApiConstants.getCurrentWeatherUrl(latitude, longitude);

      final response = await client
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw NetworkException('Connection timeout');
            },
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Weather.fromOpenMeteoJson(data, latitude, longitude);
      } else if (response.statusCode == 404) {
        throw ServerException('Location not found');
      } else if (response.statusCode >= 500) {
        throw ServerException('Server error occurred');
      } else {
        throw ServerException(
          'Failed to fetch weather data: ${response.statusCode}',
        );
      }
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        throw NetworkException('No internet connection');
      }
      throw NetworkException('Network error: ${e.toString()}');
    }
  }

  /// Get weather forecast for a location
  Future<WeatherForecast> getWeatherForecast(
    double latitude,
    double longitude,
  ) async {
    try {
      final url = ApiConstants.getForecastUrl(latitude, longitude);

      final response = await client
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw NetworkException('Connection timeout');
            },
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return WeatherForecast.fromOpenMeteoJson(data, latitude, longitude);
      } else if (response.statusCode == 404) {
        throw ServerException('Location not found');
      } else if (response.statusCode >= 500) {
        throw ServerException('Server error occurred');
      } else {
        throw ServerException(
          'Failed to fetch forecast data: ${response.statusCode}',
        );
      }
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('HandshakeException')) {
        throw NetworkException('No internet connection');
      }
      throw NetworkException('Network error: ${e.toString()}');
    }
  }

  /// Dispose the HTTP client
  void dispose() {
    client.close();
  }
}
