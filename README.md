# Weather App - Student Index Edition 🌤️# Weather App 🌤️



A Flutter weather application that derives GPS coordinates from your student index number and displays real-time weather data using the free Open-Meteo API.A modern, feature-rich Flutter weather application with clean architecture, real-time weather data, and 5-day forecasts.



## 📱 Features## Features ✨



- ✅ **Student Index Input** - Enter your index (e.g., 194174B)- **Real-time Weather Data**: Powered by Open-Meteo API (no key required!)

- ✅ **Coordinate Derivation** - Automatically calculates lat/lon from index- **GPS Location**: Automatic location detection using device GPS

- ✅ **Real-time Weather** - Current weather conditions- **5-Day Forecast**: View detailed weather forecasts with 3-hour intervals

- ✅ **5-Day Forecast** - Detailed forecast with 3-hour intervals- **Beautiful UI**: Clean, modern interface with weather-appropriate colors and icons

- ✅ **No API Key Required** - Uses free Open-Meteo API- **Offline Support**: Cached weather data available when offline

- ✅ **Offline Caching** - Shows last successful result when offline- **Pull to Refresh**: Easy data refresh with pull-down gesture

- ✅ **Error Handling** - Graceful error messages with retry- **Detailed Information**: Temperature, humidity, wind speed, precipitation probability, and more

- ✅ **Information Display** - Shows index, coordinates, API URL, and last update time

## Architecture 🏗️

## 🧮 Coordinate Calculation

This project implements **Clean Architecture** principles for maintainability and testability:

The app derives coordinates from your student index using this formula:

```

```dartlib/

// Example: 194174B├── core/

firstTwo = int(index[0..1])  // 19│   ├── constants/       # API and app constants

nextTwo = int(index[2..3])   // 41│   ├── errors/          # Custom exception classes

│   └── utils/           # Helper utilities (date formatting, weather helpers)

latitude = 5 + (firstTwo / 10.0)   // 5 + 1.9 = 6.9°├── data/

longitude = 79 + (nextTwo / 10.0)  // 79 + 4.1 = 83.1°│   ├── models/          # Data models (Weather, Forecast, Location)

```│   ├── services/        # External services (API, Location, Cache)

│   └── repositories/    # Repository implementations

**Result:**└── presentation/

- Index: `194174B`    ├── providers/       # State management (Provider pattern)

- Coordinates: `Lat: 6.9°, Lon: 83.1°`    ├── screens/         # UI screens

- Location: Sri Lanka Region    └── widgets/         # Reusable UI components

```

## 🚀 Quick Start

### Key Design Patterns

### Prerequisites

- Flutter SDK 3.9.2+- **Repository Pattern**: Abstracts data sources

- Android Studio or VS Code- **Provider Pattern**: State management solution

- Android Emulator or physical device- **Service Layer**: Separation of concerns for external dependencies

- **Dependency Injection**: Loose coupling between layers

### Installation

## Prerequisites 📋

```bash

# 1. Navigate to project- Flutter SDK (3.9.2 or higher)

cd weatherapp- Dart SDK

- Android Studio / Xcode (for mobile deployment)

# 2. Install dependencies- **NO API KEY REQUIRED** ✨ (Uses free Open-Meteo API)

flutter pub get

## Setup Instructions 🚀

# 3. Run the app

flutter run### 1. Clone the Repository

```

```bash

### First Launchgit clone <repository-url>

cd weatherapp

1. **Enter Student Index** (e.g., `194174B`)```

2. **Tap "Get Weather"**

3. **View weather data!**### 2. Install Dependencies



## 📸 App Flow```bash

flutter pub get

### 1. Index Input Screen```

- Enter your student index (e.g., 194174B)

- See how coordinates are calculated### 3. Run the App

- Get instant validation feedback

**That's it! No API key configuration needed.**

### 2. Home Screen Displays:

- **Student Info**:```bash

  - Your index number# Run on connected device/emulator

  - Derived coordinates (Lat/Lon)flutter run

  - API request URL

  - Last update timestamp# Or launch a specific emulator first

- **Weather Data**:flutter emulators --launch <emulator_id>

  - Current temperatureflutter run

  - Weather condition (Clear, Rain, etc.)```

  - Feels-like temperature

  - Humidity percentage## Dependencies 📦

  - Wind speed and direction

- **Detailed Info**:### Main Dependencies

  - Pressure, visibility, cloudiness

  - Wind direction, sunrise, sunset- **provider**: ^6.1.1 - State management

- **5-Day Forecast Button**- **http**: ^1.2.0 - HTTP requests

- **geolocator**: ^11.0.0 - Location services

### 3. Forecast Screen- **permission_handler**: ^11.2.0 - Permission management

- Next 5 days of weather- **intl**: ^0.19.0 - Internationalization and date formatting

- Grouped by day- **shared_preferences**: ^2.2.2 - Local data persistence

- 3-hour interval forecasts- **weather_icons**: ^3.0.0 - Weather-specific icons

- Precipitation probability

## Permissions 🔐

## 🎯 Assignment Requirements Met

### Android

✅ Reads your student index (e.g., 194174B)

✅ Derives latitude/longitude from it using formulaThe app requires the following permissions (already configured in AndroidManifest.xml):

✅ Calls Open-Meteo API (no API key needed)

✅ Shows current weather- `INTERNET` - For API calls

✅ Displays index, coords, request URL, last update time- `ACCESS_FINE_LOCATION` - For precise location

✅ Handles errors gracefully- `ACCESS_COARSE_LOCATION` - For approximate location

✅ Caches last successful result locally- `ACCESS_BACKGROUND_LOCATION` - For background location updates

✅ Works offline with cached data

### iOS

## 🧮 Coordinate Formula

Add the following to `ios/Runner/Info.plist`:

```

firstTwo = int(index[0..1])      // First 2 digits```xml

nextTwo = int(index[2..3])       // Next 2 digits<key>NSLocationWhenInUseUsageDescription</key>

<string>This app needs access to location to show weather for your area</string>

latitude = 5 + (firstTwo / 10.0)   // Range: 5.0° - 15.9°<key>NSLocationAlwaysUsageDescription</key>

longitude = 79 + (nextTwo / 10.0)  // Range: 79.0° - 89.9°<string>This app needs access to location to provide weather updates</string>

``````



**Examples:**## Usage 📱

- `194174B` → Lat: 6.9°, Lon: 83.1° (Sri Lanka)

- `123456A` → Lat: 6.2°, Lon: 82.4° (Sri Lanka)### Home Screen

- `000000X` → Lat: 5.0°, Lon: 79.0° (Indian Ocean)

- `999900Y` → Lat: 14.9°, Lon: 88.9° (India/Myanmar)- Displays current weather for your location

- Shows temperature, feels like, humidity, and wind speed

## 📡 API Integration- Pull down to refresh weather data

- Tap "View 5-Day Forecast" to see extended forecast

### Open-Meteo API (No Key Required!)

### Forecast Screen

**Endpoint:**

```- Shows 5-day weather forecast

GET https://api.open-meteo.com/v1/forecast- Hourly breakdown for each day

  ?latitude={lat}- Displays temperature, conditions, and precipitation probability

  &longitude={lon}

  &current_weather=true### Features in Action

  &hourly=temperature_2m,humidity,apparent_temperature,

          precipitation_probability,visibility,1. **Auto-Location**: App automatically detects your location on first launch

          wind_speed_10m,wind_direction_10m2. **Permission Handling**: Prompts for location permission if not granted

  &timezone=auto3. **Offline Mode**: Shows cached data when internet is unavailable

```4. **Error Handling**: Friendly error messages with retry options



**Response includes:**## API Integration 🌐

- Current temperature

- Weather code (WMO standard)### OpenWeatherMap API

- Wind speed and direction

- Hourly forecast dataThe app uses OpenWeatherMap API endpoints:

- Precipitation probability

- **Current Weather**: `/weather`

## 💾 Offline Support- **5-Day Forecast**: `/forecast`



- **Cache Duration**: 30 minutes**Parameters**:

- **Storage**: SharedPreferences (local device)- Latitude and Longitude for location

- **Offline Behavior**: Shows last successful result- Units: Metric (Celsius)

- **Cache Indicator**: "(offline)" shown when using cached data- Language: English



## 🏗️ Project Structure### Data Caching



```- Weather data is cached for 30 minutes

lib/- Reduces API calls and improves offline experience

├── core/- Automatic cache invalidation

│   ├── constants/

│   │   ├── api_constants.dart         # API endpoints## Error Handling 🛠️

│   │   └── app_constants.dart         # App settings

│   ├── errors/The app includes comprehensive error handling:

│   │   └── exceptions.dart            # Custom exceptions

│   └── utils/- **Network Errors**: No internet connection detection

│       ├── coordinate_calculator.dart  # Index → Coordinates- **Location Errors**: Permission denied, GPS disabled

│       ├── date_formatter.dart- **Server Errors**: API failures, invalid responses

│       └── weather_helper.dart- **Cache Errors**: Local storage issues

├── data/

│   ├── models/Each error type has user-friendly messages and retry mechanisms.

│   │   ├── weather_model.dart         # Weather data model

│   │   ├── forecast_model.dart        # Forecast data model## Testing 🧪

│   │   └── location_model.dart

│   ├── services/### Running Tests

│   │   ├── weather_api_service.dart   # API client

│   │   └── cache_service.dart         # Local caching```bash

│   └── repositories/# Run all tests

│       └── weather_repository.dart    # Data layerflutter test

└── presentation/

    ├── providers/# Run with coverage

    │   └── weather_provider.dart      # State managementflutter test --coverage

    ├── screens/```

    │   ├── index_input_screen.dart    # Student index input

    │   ├── home_screen.dart           # Main weather display### Test Structure

    │   └── forecast_screen.dart       # 5-day forecast

    └── widgets/- Unit tests for models, services, and repositories

        ├── weather_card.dart- Widget tests for UI components

        ├── weather_detail_card.dart- Integration tests for complete user flows

        ├── forecast_card.dart

        ├── loading_indicator.dart## Building for Production 📦

        └── error_display.dart

```### Android



## 📦 Dependencies```bash

flutter build apk --release

```yaml# or for app bundle

dependencies:flutter build appbundle --release

  provider: ^6.1.1              # State management```

  http: ^1.2.0                  # HTTP requests

  shared_preferences: ^2.2.2    # Local storage### iOS

  intl: ^0.19.0                 # Date formatting

  weather_icons: ^3.0.0         # Weather icons```bash

```flutter build ios --release

```

## 🧪 Testing

## Performance Optimizations ⚡

### Manual Test Cases

- Efficient caching mechanism

**Valid Indexes:**- Lazy loading of forecast data

```- Optimized image and icon usage

194174B → Lat: 6.9°, Lon: 83.1° ✅- Minimal rebuilds with Provider

123456  → Lat: 6.2°, Lon: 82.4° ✅

000099  → Lat: 5.0°, Lon: 79.9° ✅## Future Enhancements 🔮

```

- [ ] Search for cities manually

**Invalid Indexes:**- [ ] Multiple location management

```- [ ] Weather alerts and notifications

123     → Error: "Index must have at least 4 digits" ❌- [ ] Animated weather backgrounds

ABC     → Error: "Index must have at least 4 digits" ❌- [ ] Dark mode support

```- [ ] Weather maps integration

- [ ] Historical weather data

### Run Tests- [ ] Weather widgets

```bash

flutter test        # Run unit tests## Troubleshooting 🔧

flutter analyze     # Check for errors

```### Common Issues



## 🐛 Troubleshooting**Location not working:**

- Ensure location permissions are granted

### "Index must contain at least 4 digits"- Check if location services are enabled on device

**Solution:** Enter an index with 4+ digits (e.g., 194174B)- Try refreshing the app



### "Failed to fetch weather data"**API errors:**

**Solution:**- Verify API key is correct

- Check internet connection- Check internet connection

- Try pulling down to refresh- Ensure API key has proper permissions

- Verify coordinates are in valid range

**Build errors:**

### App shows cached data- Run `flutter clean`

**Info:** This is normal when offline. Data is from last successful API call.- Delete `pubspec.lock`

- Run `flutter pub get`

### "Network error"

**Solution:**## Contributing 🤝

- Check device internet connection

- App will show cached data if availableContributions are welcome! Please follow these steps:

- Pull to refresh when online

1. Fork the repository

## 📱 Build & Deploy2. Create a feature branch

3. Commit your changes

### Debug Build (Development)4. Push to the branch

```bash5. Open a Pull Request

flutter run

```## License 📄



### Release Build (Production)This project is licensed under the MIT License - see the LICENSE file for details.

```bash

# Android APK## Contact 📧

flutter build apk --release

For questions or support, please contact [your-email@example.com]

# Install on connected device

flutter install --release## Acknowledgments 🙏

```

- OpenWeatherMap for providing the weather API

**Output:** `build/app/outputs/flutter-apk/app-release.apk`- Flutter community for excellent packages

- Material Design for UI guidelines

## 🎓 Learning Outcomes

---

This project demonstrates:

- ✅ Flutter UI development**Built with ❤️ using Flutter**

- ✅ State management (Provider)
- ✅ REST API integration
- ✅ Data caching strategies
- ✅ Form validation
- ✅ Mathematical calculations
- ✅ Error handling
- ✅ Clean architecture
- ✅ Material Design

## 📚 Documentation

- `QUICKSTART.md` - Quick setup guide
- `MIGRATION.md` - Open-Meteo API migration
- `ARCHITECTURE.md` - Technical architecture
- `FEATURES.md` - Feature documentation
- `SUMMARY.md` - Complete project summary

## 🔧 Configuration

### Change Default Index
`lib/presentation/screens/index_input_screen.dart`:
```dart
final _indexController = TextEditingController(text: '194174B');
```

### Adjust Cache Duration
`lib/core/constants/app_constants.dart`:
```dart
static const int cacheExpiryMinutes = 30; // Change value
```

## 📄 License

Educational project - Free to use

---

## 🚀 Quick Commands Reference

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Format code
dart format lib/

# Analyze code
flutter analyze

# Clean build
flutter clean

# Build APK
flutter build apk --release
```

---

**🌟 Ready to use! Enter your student index and get weather data instantly!** 🌤️

**No API key | No registration | Just works!** ✨
