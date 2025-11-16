/// Custom exceptions for the weather app
class WeatherException implements Exception {
  final String message;
  final String? code;

  WeatherException(this.message, {this.code});

  @override
  String toString() => message;
}

class NetworkException extends WeatherException {
  NetworkException([String message = 'Network error occurred'])
    : super(message, code: 'NETWORK_ERROR');
}

class ServerException extends WeatherException {
  ServerException([String message = 'Server error occurred'])
    : super(message, code: 'SERVER_ERROR');
}

class LocationException extends WeatherException {
  LocationException([String message = 'Location error occurred'])
    : super(message, code: 'LOCATION_ERROR');
}

class CacheException extends WeatherException {
  CacheException([String message = 'Cache error occurred'])
    : super(message, code: 'CACHE_ERROR');
}

class ParseException extends WeatherException {
  ParseException([String message = 'Failed to parse data'])
    : super(message, code: 'PARSE_ERROR');
}
