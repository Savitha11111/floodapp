class FloodData {
  final String id;
  final double latitude;
  final double longitude;
  final String riskLevel;
  final double alertScore;
  final String status;
  final DateTime timestamp;
  final double precipitation;
  final int activeEvents;
  final double affectedAreaKm2;
  final double confidenceScore;
  final List<String> riskFactors;
  final String location;

  FloodData({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.riskLevel,
    required this.alertScore,
    required this.status,
    required this.timestamp,
    required this.precipitation,
    required this.activeEvents,
    required this.affectedAreaKm2,
    required this.confidenceScore,
    required this.riskFactors,
    required this.location,
  });

  factory FloodData.fromJson(Map<String, dynamic> json) {
    return FloodData(
      id: json['id']?.toString() ?? '',
      latitude: (json['lat'] ?? json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['lng'] ?? json['longitude'] ?? 0.0).toDouble(),
      riskLevel: json['risk_level'] ?? json['riskLevel'] ?? 'low',
      alertScore: (json['alert_score'] ?? json['alertScore'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'unknown',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      precipitation: (json['precipitation'] ?? json['precipitation_24h'] ?? 0.0).toDouble(),
      activeEvents: json['active_events'] ?? json['activeEvents'] ?? 0,
      affectedAreaKm2: (json['affected_area_km2'] ?? json['affectedAreaKm2'] ?? 0.0).toDouble(),
      confidenceScore: (json['confidence_score'] ?? json['confidenceScore'] ?? 0.0).toDouble(),
      riskFactors: List<String>.from(json['risk_factors'] ?? json['riskFactors'] ?? []),
      location: json['location'] ?? 'Unknown Location',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'riskLevel': riskLevel,
      'alertScore': alertScore,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'precipitation': precipitation,
      'activeEvents': activeEvents,
      'affectedAreaKm2': affectedAreaKm2,
      'confidenceScore': confidenceScore,
      'riskFactors': riskFactors,
      'location': location,
    };
  }

  // Get risk level color for UI
  Color get riskColor {
    switch (riskLevel.toLowerCase()) {
      case 'severe':
      case 'high':
        return const Color(0xFFD32F2F); // Red
      case 'moderate':
      case 'medium':
        return const Color(0xFFF57C00); // Orange
      case 'low':
      case 'minimal':
        return const Color(0xFF388E3C); // Green
      default:
        return const Color(0xFF757575); // Grey
    }
  }

  // Get risk level icon
  String get riskIcon {
    switch (riskLevel.toLowerCase()) {
      case 'severe':
      case 'high':
        return '🔴';
      case 'moderate':
      case 'medium':
        return '🟡';
      case 'low':
      case 'minimal':
        return '🟢';
      default:
        return '⚪';
    }
  }

  // Get detailed risk description
  String get riskDescription {
    switch (riskLevel.toLowerCase()) {
      case 'severe':
        return 'SEVERE FLOOD RISK - Immediate action required';
      case 'high':
        return 'HIGH FLOOD RISK - Monitor conditions closely';
      case 'moderate':
      case 'medium':
        return 'MODERATE FLOOD RISK - Stay alert';
      case 'low':
      case 'minimal':
        return 'LOW FLOOD RISK - Normal conditions';
      default:
        return 'UNKNOWN RISK LEVEL';
    }
  }
}