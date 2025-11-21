class ForecastItem {
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
  final double? pop; // Probability of precipitation

  ForecastItem({
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
    this.pop,
  });

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
      'pop': pop,
    };
  }
}

class WeatherForecast {
  final List<ForecastItem> items;
  final String cityName;
  final String country;
  final double latitude;
  final double longitude;

  WeatherForecast({
    required this.items,
    required this.cityName,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  /// Create WeatherForecast from Open-Meteo API response
  factory WeatherForecast.fromOpenMeteoJson(
    Map<String, dynamic> json,
    double lat,
    double lon,
  ) {
    try {
      final hourly = json['hourly'] as Map<String, dynamic>;

      final times = (hourly['time'] as List).cast<String>();
      final temps = (hourly['temperature_2m'] as List);
      final apparentTemps = (hourly['apparent_temperature'] as List);
      final humidities = (hourly['relative_humidity_2m'] as List);
      final precipProbs = (hourly['precipitation_probability'] as List);
      final weatherCodes = (hourly['weather_code'] as List);
      final windSpeeds = (hourly['wind_speed_10m'] as List);
      final windDirections = (hourly['wind_direction_10m'] as List);

      final List<ForecastItem> forecastItems = [];

      // Get current date and tomorrow's date to filter out past data
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final fiveDaysFromNow = tomorrow.add(const Duration(days: 5));

      // Get forecast for next 5 days (starting from tomorrow), every 3 hours
      for (int i = 0; i < times.length && forecastItems.length < 40; i += 3) {
        final forecastTime = DateTime.parse(times[i]);

        // Only include forecasts from tomorrow onwards, and limit to 5 days
        if (forecastTime.isBefore(tomorrow) ||
            forecastTime.isAfter(fiveDaysFromNow)) {
          continue;
        }

        final weatherCode = (weatherCodes[i] as num).toInt();
        final weatherInfo = _getWeatherInfo(weatherCode);
        final temp = (temps[i] as num).toDouble();

        forecastItems.add(
          ForecastItem(
            temperature: temp,
            feelsLike: (apparentTemps[i] as num).toDouble(),
            tempMin: temp - 1,
            tempMax: temp + 1,
            pressure: 1013,
            humidity: (humidities[i] as num).toInt(),
            windSpeed: (windSpeeds[i] as num).toDouble(),
            windDegree: (windDirections[i] as num).toInt(),
            clouds: _getCloudinessFromWeatherCode(weatherCode),
            condition: weatherInfo['main']!,
            description: weatherInfo['description']!,
            icon: weatherInfo['icon']!,
            dateTime: forecastTime,
            pop: (precipProbs[i] as num?)?.toDouble() ?? 0.0,
          ),
        );
      }

      return WeatherForecast(
        items: forecastItems,
        cityName: 'Current Location',
        country: '',
        latitude: lat,
        longitude: lon,
      );
    } catch (e) {
      throw Exception('Failed to parse Open-Meteo forecast data: $e');
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

  /// Get forecast items grouped by day
  Map<String, List<ForecastItem>> getDailyForecasts() {
    final Map<String, List<ForecastItem>> dailyForecasts = {};

    for (final item in items) {
      final dateKey =
          '${item.dateTime.year}-${item.dateTime.month.toString().padLeft(2, '0')}-${item.dateTime.day.toString().padLeft(2, '0')}';

      if (!dailyForecasts.containsKey(dateKey)) {
        dailyForecasts[dateKey] = [];
      }
      dailyForecasts[dateKey]!.add(item);
    }

    return dailyForecasts;
  }

  Map<String, dynamic> toJson() {
    return {
      'list': items.map((item) => item.toJson()).toList(),
      'city': {
        'name': cityName,
        'country': country,
        'coord': {'lat': latitude, 'lon': longitude},
      },
    };
  }
}
