import 'package:flutter/material.dart';

class WeatherData {
  final double temperature;
  final double humidity;
  final double pressure;
  final double windSpeed;
  final String description;
  final String main;
  final double rainfall;
  final double visibility;
  final DateTime timestamp;
  final String cityName;
  final double latitude;
  final double longitude;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.description,
    required this.main,
    required this.rainfall,
    required this.visibility,
    required this.timestamp,
    required this.cityName,
    required this.latitude,
    required this.longitude,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['main']?['temp'] ?? 0.0).toDouble(),
      humidity: (json['main']?['humidity'] ?? 0.0).toDouble(),
      pressure: (json['main']?['pressure'] ?? 0.0).toDouble(),
      windSpeed: (json['wind']?['speed'] ?? 0.0).toDouble(),
      description: json['weather']?[0]?['description'] ?? 'Unknown',
      main: json['weather']?[0]?['main'] ?? 'Unknown',
      rainfall: (json['rain']?['1h'] ?? json['rain']?['3h'] ?? 0.0).toDouble(),
      visibility: (json['visibility'] ?? 10000.0).toDouble() / 1000,
      timestamp: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      cityName: json['name'] ?? 'Unknown City',
      latitude: (json['coord']?['lat'] ?? 0.0).toDouble(),
      longitude: (json['coord']?['lon'] ?? 0.0).toDouble(),
    );
  }

  // Get weather icon based on conditions
  IconData get weatherIcon {
    switch (main.toLowerCase()) {
      case 'thunderstorm':
        return Icons.thunderstorm;
      case 'drizzle':
        return Icons.grain;
      case 'rain':
        return Icons.water_drop;
      case 'snow':
        return Icons.ac_unit;
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      default:
        return Icons.help_outline;
    }
  }

  // Get temperature color
  Color get temperatureColor {
    if (temperature > 35) return Colors.red;
    if (temperature > 25) return Colors.orange;
    if (temperature > 15) return Colors.blue;
    return Colors.lightBlue;
  }

  // Check if conditions favor flooding
  bool get floodPotential {
    return rainfall > 10 || // Heavy rain
           (humidity > 80 && rainfall > 5) || // High humidity + moderate rain
           description.toLowerCase().contains('heavy');
  }

  // Get rainfall intensity description
  String get rainfallIntensity {
    if (rainfall > 50) return 'Very Heavy';
    if (rainfall > 20) return 'Heavy';
    if (rainfall > 10) return 'Moderate';
    if (rainfall > 2) return 'Light';
    return 'No Rain';
  }

  // Get flood risk based on weather conditions
  String get floodRisk {
    if (rainfall > 50) return 'Severe';
    if (rainfall > 20) return 'High';
    if (rainfall > 10) return 'Moderate';
    return 'Low';
  }
}