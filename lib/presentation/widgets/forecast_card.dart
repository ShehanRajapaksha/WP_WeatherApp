import 'package:flutter/material.dart';
import '../../data/models/forecast_model.dart';
import '../../core/utils/weather_helper.dart';
import '../../core/utils/date_formatter.dart';

class ForecastCard extends StatelessWidget {
  final ForecastItem forecast;

  const ForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          WeatherHelper.getWeatherIcon(forecast.condition),
          size: 32,
          color: WeatherHelper.getTemperatureColor(forecast.temperature),
        ),
        title: Text(
          DateFormatter.formatTime(forecast.dateTime),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(forecast.description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              WeatherHelper.formatTemperature(forecast.temperature),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (forecast.pop != null)
              Text(
                '${(forecast.pop! * 100).round()}%',
                style: TextStyle(fontSize: 12, color: Colors.blue[700]),
              ),
          ],
        ),
      ),
    );
  }
}
