import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/forecast_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_display.dart';
import '../../core/utils/date_formatter.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  @override
  void initState() {
    super.initState();
    // Load forecast data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().loadForecast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('5-Day Forecast'), elevation: 0),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.forecastStatus == WeatherStatus.loading) {
            return const LoadingIndicator(message: 'Loading forecast...');
          }

          if (provider.forecastStatus == WeatherStatus.error) {
            return ErrorDisplay(
              message:
                  provider.forecastErrorMessage ?? 'Failed to load forecast',
              onRetry: () => provider.loadForecast(),
            );
          }

          if (provider.forecast == null) {
            return const LoadingIndicator();
          }

          final forecast = provider.forecast!;
          final dailyForecasts = forecast.getDailyForecasts();
          final sortedDays = dailyForecasts.keys.toList()..sort();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedDays.length,
            itemBuilder: (context, dayIndex) {
              final date = sortedDays[dayIndex];
              final dayForecasts = dailyForecasts[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Day Header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormatter.getRelativeDayName(
                            DateTime.parse(date),
                          ),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormatter.formatShortDate(DateTime.parse(date)),
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                  // Forecast items for this day
                  ...dayForecasts.map(
                    (forecast) => ForecastCard(forecast: forecast),
                  ),

                  const SizedBox(height: 8),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
