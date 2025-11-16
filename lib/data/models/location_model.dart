class Location {
  final double latitude;
  final double longitude;
  final String? cityName;
  final String? country;
  final DateTime timestamp;

  Location({
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.country,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      cityName: json['cityName'] as String?,
      country: json['country'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'cityName': cityName,
      'country': country,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  Location copyWith({
    double? latitude,
    double? longitude,
    String? cityName,
    String? country,
    DateTime? timestamp,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityName: cityName ?? this.cityName,
      country: country ?? this.country,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'Location(lat: $latitude, lon: $longitude, city: $cityName, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Location &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.cityName == cityName &&
        other.country == country;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^
        longitude.hashCode ^
        cityName.hashCode ^
        country.hashCode;
  }
}
