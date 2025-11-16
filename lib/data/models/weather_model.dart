class Weather {
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final int windDegree;
  final int clouds;
  final String condition;
  final String description;
  final String icon;
  final DateTime dateTime;
  final String cityName;
  final String country;
  final double latitude;
  final double longitude;
  final int? visibility;
  final DateTime? sunrise;
  final DateTime? sunset;

  Weather({
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.windDegree,
    required this.clouds,
    required this.condition,
    required this.description,
    required this.icon,
    required this.dateTime,
    required this.cityName,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.visibility,
    this.sunrise,
    this.sunset,
  });

  /// Create Weather from Open-Meteo API response
  factory Weather.fromOpenMeteoJson(
    Map<String, dynamic> json,
    double lat,
    double lon,
  ) {
    try {
      final currentWeather = json['current_weather'] as Map<String, dynamic>;
      final hourly = json['hourly'] as Map<String, dynamic>;

      final currentTemp = (currentWeather['temperature'] as num).toDouble();
      final weatherCode = (currentWeather['weathercode'] as num).toInt();
      final windSpeed = (currentWeather['windspeed'] as num).toDouble();
      final windDirection = (currentWeather['winddirection'] as num).toInt();

      // Get current hour index for hourly data
      final currentTime = DateTime.parse(currentWeather['time'] as String);
      final hourlyTimes = (hourly['time'] as List).cast<String>();
      final currentIndex = hourlyTimes.indexWhere(
        (time) => DateTime.parse(time).hour == currentTime.hour,
      );

      // Extract hourly data for current time (or use defaults)
      final humidity = currentIndex >= 0
          ? (hourly['relative_humidity_2m'] as List)[currentIndex] as int
          : 50;
      final apparentTemp = currentIndex >= 0
          ? ((hourly['apparent_temperature'] as List)[currentIndex] as num)
                .toDouble()
          : currentTemp;
      final visibility = currentIndex >= 0
          ? ((hourly['visibility'] as List)[currentIndex] as num).toDouble() /
                1000
          : 10.0;

      final weatherInfo = _getWeatherInfo(weatherCode);

      return Weather(
        temperature: currentTemp,
        feelsLike: apparentTemp,
        tempMin: currentTemp - 2, // Approximation
        tempMax: currentTemp + 2, // Approximation
        pressure: 1013, // Default (Open-Meteo doesn't provide this in basic)
        humidity: humidity,
        windSpeed: windSpeed,
        windDegree: windDirection,
        clouds: _getCloudinessFromWeatherCode(weatherCode),
        condition: weatherInfo['main']!,
        description: weatherInfo['description']!,
        icon: weatherInfo['icon']!,
        dateTime: currentTime,
        cityName: 'Current Location',
        country: '',
        latitude: lat,
        longitude: lon,
        visibility: visibility.toInt(),
        sunrise: null, // Will be added if daily data is available
        sunset: null,
      );
    } catch (e) {
      throw Exception('Failed to parse Open-Meteo weather data: $e');
    }
  }

  /// Convert WMO Weather interpretation codes to weather info
  static Map<String, String> _getWeatherInfo(int code) {
    switch (code) {
      case 0:
        return {'main': 'Clear', 'description': 'clear sky', 'icon': '01d'};
      case 1:
        return {'main': 'Clouds', 'description': 'mainly clear', 'icon': '02d'};
      case 2:
        return {
          'main': 'Clouds',
          'description': 'partly cloudy',
          'icon': '02d',
        };
      case 3:
        return {'main': 'Clouds', 'description': 'overcast', 'icon': '03d'};
      case 45:
      case 48:
        return {'main': 'Mist', 'description': 'foggy', 'icon': '50d'};
      case 51:
      case 53:
      case 55:
        return {'main': 'Drizzle', 'description': 'drizzle', 'icon': '09d'};
      case 56:
      case 57:
        return {
          'main': 'Drizzle',
          'description': 'freezing drizzle',
          'icon': '09d',
        };
      case 61:
        return {'main': 'Rain', 'description': 'slight rain', 'icon': '10d'};
      case 63:
        return {'main': 'Rain', 'description': 'moderate rain', 'icon': '10d'};
      case 65:
        return {'main': 'Rain', 'description': 'heavy rain', 'icon': '10d'};
      case 66:
      case 67:
        return {'main': 'Rain', 'description': 'freezing rain', 'icon': '13d'};
      case 71:
        return {'main': 'Snow', 'description': 'slight snow', 'icon': '13d'};
      case 73:
        return {'main': 'Snow', 'description': 'moderate snow', 'icon': '13d'};
      case 75:
        return {'main': 'Snow', 'description': 'heavy snow', 'icon': '13d'};
      case 77:
        return {'main': 'Snow', 'description': 'snow grains', 'icon': '13d'};
      case 80:
      case 81:
      case 82:
        return {'main': 'Rain', 'description': 'rain showers', 'icon': '09d'};
      case 85:
      case 86:
        return {'main': 'Snow', 'description': 'snow showers', 'icon': '13d'};
      case 95:
        return {
          'main': 'Thunderstorm',
          'description': 'thunderstorm',
          'icon': '11d',
        };
      case 96:
      case 99:
        return {
          'main': 'Thunderstorm',
          'description': 'thunderstorm with hail',
          'icon': '11d',
        };
      default:
        return {'main': 'Unknown', 'description': 'unknown', 'icon': '01d'};
    }
  }

  /// Get cloudiness percentage from weather code
  static int _getCloudinessFromWeatherCode(int code) {
    if (code == 0) return 0; // Clear
    if (code == 1) return 25; // Mainly clear
    if (code == 2) return 50; // Partly cloudy
    if (code == 3) return 75; // Overcast
    if (code >= 45 && code <= 48) return 100; // Fog
    return 60; // Default for precipitation
  }

  Map<String, dynamic> toJson() {
    return {
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'pressure': pressure,
        'humidity': humidity,
      },
      'weather': [
        {'main': condition, 'description': description, 'icon': icon},
      ],
      'wind': {'speed': windSpeed, 'deg': windDegree},
      'clouds': {'all': clouds},
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'name': cityName,
      'sys': {
        'country': country,
        'sunrise': sunrise?.millisecondsSinceEpoch ?? 0 ~/ 1000,
        'sunset': sunset?.millisecondsSinceEpoch ?? 0 ~/ 1000,
      },
      'coord': {'lat': latitude, 'lon': longitude},
      'visibility': visibility,
    };
  }

  Weather copyWith({
    double? temperature,
    double? feelsLike,
    double? tempMin,
    double? tempMax,
    int? pressure,
    int? humidity,
    double? windSpeed,
    int? windDegree,
    int? clouds,
    String? condition,
    String? description,
    String? icon,
    DateTime? dateTime,
    String? cityName,
    String? country,
    double? latitude,
    double? longitude,
    int? visibility,
    DateTime? sunrise,
    DateTime? sunset,
  }) {
    return Weather(
      temperature: temperature ?? this.temperature,
      feelsLike: feelsLike ?? this.feelsLike,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      pressure: pressure ?? this.pressure,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      windDegree: windDegree ?? this.windDegree,
      clouds: clouds ?? this.clouds,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      dateTime: dateTime ?? this.dateTime,
      cityName: cityName ?? this.cityName,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      visibility: visibility ?? this.visibility,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
    );
  }
}
