import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/flood_data.dart';
import '../models/weather_data.dart';

class ApiService {
  static const String openWeatherApiKey = 'YOUR_OPENWEATHER_API_KEY';
  static const String ambeeApiKey = 'YOUR_AMBEE_API_KEY';
  static const String cohereApiKey = 'YOUR_COHERE_API_KEY';
  
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
  }

  /// Fetch real-time weather data from OpenWeather API
  Future<WeatherData> getWeatherData(double lat, double lon) async {
    try {
      final response = await _dio.get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': openWeatherApiKey,
          'units': 'metric',
        },
      );

      return WeatherData.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch weather data: ${e.toString()}');
    }
  }

  /// Fetch flood risk data from Ambee API
  Future<FloodData> getFloodData(double lat, double lon) async {
    try {
      final response = await _dio.get(
        'https://api.ambeedata.com/floods/latest/by-lat-lng',
        queryParameters: {
          'lat': lat,
          'lng': lon,
        },
        options: Options(
          headers: {
            'x-api-key': ambeeApiKey,
            'Content-type': 'application/json',
          },
        ),
      );

      return FloodData.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch flood data: ${e.toString()}');
    }
  }

  /// Get AI-powered flood analysis using Cohere
  Future<String> getAIAnalysis(String prompt) async {
    try {
      final response = await _dio.post(
        'https://api.cohere.ai/v1/generate',
        data: {
          'model': 'command',
          'prompt': prompt,
          'max_tokens': 300,
          'temperature': 0.3,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $cohereApiKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.data['generations'][0]['text'];
    } catch (e) {
      throw Exception('Failed to get AI analysis: ${e.toString()}');
    }
  }

  /// Fetch historical flood data
  Future<List<FloodData>> getHistoricalFloodData(
    double lat, 
    double lon, 
    DateTime startDate, 
    DateTime endDate,
  ) async {
    try {
      final response = await _dio.get(
        'https://api.ambeedata.com/floods/history',
        queryParameters: {
          'lat': lat,
          'lng': lon,
          'from': startDate.toIso8601String(),
          'to': endDate.toIso8601String(),
        },
        options: Options(
          headers: {
            'x-api-key': ambeeApiKey,
            'Content-type': 'application/json',
          },
        ),
      );

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((item) => FloodData.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to fetch historical data: ${e.toString()}');
    }
  }
}