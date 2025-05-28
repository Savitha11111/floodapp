import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/flood_data.dart';
import '../models/weather_data.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';

class FloodDataProvider extends ChangeNotifier {
  final ApiService _apiService;
  final LocationService _locationService;

  FloodDataProvider(this._apiService, this._locationService);

  // Current data
  FloodData? _currentFloodData;
  WeatherData? _currentWeatherData;
  String? _currentLocation;
  Position? _currentPosition;
  DateTime? _lastUpdated;
  bool _isLoading = false;
  String? _error;

  // Getters
  FloodData? get currentFloodData => _currentFloodData;
  WeatherData? get currentWeatherData => _currentWeatherData;
  String? get currentLocation => _currentLocation;
  Position? get currentPosition => _currentPosition;
  DateTime? get lastUpdated => _lastUpdated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize and get current location
  Future<void> initialize() async {
    await getCurrentLocation();
  }

  // Get current location and fetch data
  Future<void> getCurrentLocation() async {
    try {
      _setLoading(true);
      _clearError();

      final position = await _locationService.getCurrentPosition();
      _currentPosition = position;

      // Get location name
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        _currentLocation = '${placemark.locality}, ${placemark.administrativeArea}';
      }

      // Fetch flood and weather data
      await _fetchAllData();
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to get location: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch data for specific coordinates
  Future<void> fetchDataForLocation(double lat, double lon, String locationName) async {
    try {
      _setLoading(true);
      _clearError();

      _currentPosition = Position(
        latitude: lat,
        longitude: lon,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
      );
      _currentLocation = locationName;

      await _fetchAllData();
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch data: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Refresh current data
  Future<void> refreshData() async {
    if (_currentPosition != null) {
      await fetchDataForLocation(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        _currentLocation ?? 'Current Location',
      );
    }
  }

  // Private methods
  Future<void> _fetchAllData() async {
    if (_currentPosition == null) return;

    final lat = _currentPosition!.latitude;
    final lon = _currentPosition!.longitude;

    try {
      // Fetch weather data
      _currentWeatherData = await _apiService.getWeatherData(lat, lon);
      
      // Fetch flood data
      _currentFloodData = await _apiService.getFloodData(lat, lon);
      
      _lastUpdated = DateTime.now();
    } catch (e) {
      // If APIs fail, create basic data with location info
      _currentWeatherData = WeatherData(
        temperature: 25.0,
        humidity: 65.0,
        pressure: 1013.0,
        windSpeed: 5.0,
        description: 'Data unavailable - API connection needed',
        main: 'Unknown',
        rainfall: 0.0,
        visibility: 10.0,
        timestamp: DateTime.now(),
        cityName: _currentLocation ?? 'Unknown',
        latitude: lat,
        longitude: lon,
      );

      _currentFloodData = FloodData(
        id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        latitude: lat,
        longitude: lon,
        riskLevel: 'unknown',
        alertScore: 0.0,
        status: 'api_unavailable',
        timestamp: DateTime.now(),
        precipitation: 0.0,
        activeEvents: 0,
        affectedAreaKm2: 0.0,
        confidenceScore: 0.0,
        riskFactors: ['API connection required for real-time data'],
        location: _currentLocation ?? 'Unknown Location',
      );

      _setError('API connection needed for real-time flood monitoring');
    }
  }

  // Get AI analysis for current conditions
  Future<String> getAIAnalysis() async {
    if (_currentFloodData == null || _currentWeatherData == null) {
      return 'No data available for analysis. Please ensure location data is loaded.';
    }

    try {
      final prompt = '''
      Analyze the current flood risk for ${_currentLocation}:
      
      Weather Conditions:
      - Temperature: ${_currentWeatherData!.temperature}°C
      - Rainfall: ${_currentWeatherData!.rainfall}mm
      - Humidity: ${_currentWeatherData!.humidity}%
      - Description: ${_currentWeatherData!.description}
      
      Flood Data:
      - Risk Level: ${_currentFloodData!.riskLevel}
      - Alert Score: ${_currentFloodData!.alertScore}
      - Active Events: ${_currentFloodData!.activeEvents}
      - Affected Area: ${_currentFloodData!.affectedAreaKm2} km²
      
      Provide a brief analysis and safety recommendations for residents.
      ''';

      return await _apiService.getAIAnalysis(prompt);
    } catch (e) {
      return 'AI analysis unavailable. Please check your internet connection and API configuration.';
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}