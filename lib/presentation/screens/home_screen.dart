import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import '../widgets/weather_detail_card.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_display.dart';
import 'forecast_screen.dart';
import 'index_input_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Don't auto-initialize - data comes from IndexInputScreen
  }

  Future<void> _refreshWeather() async {
    await context.read<WeatherProvider>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshWeather,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.currentWeather == null) {
            return const LoadingIndicator(message: 'Loading weather data...');
          }

          if (provider.isError && provider.currentWeather == null) {
            return ErrorDisplay(
              message: provider.errorMessage ?? 'Failed to load weather',
              onRetry: () => provider.loadCurrentWeather(),
            );
          }

          if (provider.currentWeather == null) {
            return const LoadingIndicator();
          }

          final weather = provider.currentWeather!;

          return RefreshIndicator(
            onRefresh: _refreshWeather,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Student Index Info Card
                if (provider.studentIndex != null) ...[
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              Text(
                                'Student Index: ${provider.studentIndex}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            Icons.location_on,
                            'Coordinates',
                            'Lat: ${provider.derivedLatitude?.toStringAsFixed(1)}°, '
                                'Lon: ${provider.derivedLongitude?.toStringAsFixed(1)}°',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.access_time,
                            'Last Update',
                            provider.lastUpdateTime != null
                                ? _formatDateTime(provider.lastUpdateTime!)
                                : 'N/A',
                          ),
                          const SizedBox(height: 16),
                          // Change Index Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => _changeIndex(context),
                              icon: const Icon(Icons.edit),
                              label: const Text('Change Index'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Main Weather Card
                WeatherCard(weather: weather),
                const SizedBox(height: 24),

                // View Forecast Button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForecastScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('View 5-Day Forecast'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Weather Details Section
                Text(
                  'Weather Details',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Details Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    WeatherDetailCard(
                      icon: Icons.compress,
                      title: 'Pressure',
                      value: '${weather.pressure} hPa',
                      color: Colors.indigo,
                    ),
                    WeatherDetailCard(
                      icon: Icons.visibility,
                      title: 'Visibility',
                      value: weather.visibility != null
                          ? '${(weather.visibility! / 1000).toStringAsFixed(1)} km'
                          : 'N/A',
                      color: Colors.teal,
                    ),
                    WeatherDetailCard(
                      icon: Icons.cloud,
                      title: 'Cloudiness',
                      value: '${weather.clouds}%',
                      color: Colors.blueGrey,
                    ),
                    WeatherDetailCard(
                      icon: Icons.navigation,
                      title: 'Wind Direction',
                      value: '${weather.windDegree}°',
                      color: Colors.cyan,
                    ),
                  ],
                ),

                // Sunrise/Sunset Section
                if (weather.sunrise != null && weather.sunset != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Sun Times',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: WeatherDetailCard(
                          icon: Icons.wb_sunny,
                          title: 'Sunrise',
                          value:
                              '${weather.sunrise!.hour.toString().padLeft(2, '0')}:${weather.sunrise!.minute.toString().padLeft(2, '0')}',
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: WeatherDetailCard(
                          icon: Icons.brightness_3,
                          title: 'Sunset',
                          value:
                              '${weather.sunset!.hour.toString().padLeft(2, '0')}:${weather.sunset!.minute.toString().padLeft(2, '0')}',
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 24),
                // Footer Info
                Center(
                  child: Text(
                    'Last updated: ${weather.dateTime.hour}:${weather.dateTime.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isUrl = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isUrl ? 11 : 14,
                  color: Colors.black87,
                ),
                maxLines: isUrl ? 2 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  void _changeIndex(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const IndexInputScreen()),
    );
  }
}
