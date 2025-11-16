/// Calculate latitude and longitude from student index number
class CoordinateCalculator {
  /// Derive coordinates from student index (e.g., "194174B")
  ///
  /// Formula:
  /// - firstTwo = int(index[0..1]) // e.g., 19
  /// - nextTwo = int(index[2..3]) // e.g., 41
  /// - lat = 5 + (firstTwo / 10.0) // 5.0 .. 15.9
  /// - lon = 79 + (nextTwo / 10.0) // 79.0 .. 89.9
  static Map<String, double> calculateFromIndex(String index) {
    // Remove any non-digit characters except at the end
    final cleanIndex = index.toUpperCase().replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanIndex.length < 4) {
      throw ArgumentError(
        'Index must contain at least 4 digits (e.g., 194174B)',
      );
    }

    // Extract first two and next two digits
    final firstTwo = int.parse(cleanIndex.substring(0, 2));
    final nextTwo = int.parse(cleanIndex.substring(2, 4));

    // Calculate coordinates
    final latitude = 5.0 + (firstTwo / 10.0);
    final longitude = 79.0 + (nextTwo / 10.0);

    return {
      'latitude': latitude,
      'longitude': longitude,
      'firstTwo': firstTwo.toDouble(),
      'nextTwo': nextTwo.toDouble(),
    };
  }

  /// Format coordinates for display
  static String formatCoordinates(double lat, double lon) {
    return 'Lat: ${lat.toStringAsFixed(1)}°, Lon: ${lon.toStringAsFixed(1)}°';
  }

  /// Get readable location description
  static String getLocationDescription(double lat, double lon) {
    // Basic location detection for Sri Lanka region
    if (lat >= 5.0 && lat <= 10.0 && lon >= 79.0 && lon <= 82.0) {
      return 'Sri Lanka Region';
    } else if (lat >= 8.0 && lat <= 13.0 && lon >= 77.0 && lon <= 81.0) {
      return 'South India / Sri Lanka';
    }
    return 'Custom Location';
  }
}
