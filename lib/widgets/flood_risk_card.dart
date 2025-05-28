import 'package:flutter/material.dart';
import '../models/flood_data.dart';

class FloodRiskCard extends StatelessWidget {
  final FloodData floodData;

  const FloodRiskCard({
    super.key,
    required this.floodData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              floodData.riskColor.withOpacity(0.1),
              floodData.riskColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: floodData.riskColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.water_drop,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Flood Risk Assessment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          floodData.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    floodData.riskIcon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Risk Level
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: floodData.riskColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: floodData.riskColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      floodData.riskLevel.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: floodData.riskColor,
                      ),
                    ),
                    Text(
                      floodData.riskDescription,
                      style: TextStyle(
                        fontSize: 12,
                        color: floodData.riskColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Metrics Row
              Row(
                children: [
                  Expanded(
                    child: _buildMetric(
                      'Alert Score',
                      '${(floodData.alertScore * 100).toInt()}%',
                      Icons.warning,
                    ),
                  ),
                  Expanded(
                    child: _buildMetric(
                      'Confidence',
                      '${(floodData.confidenceScore * 100).toInt()}%',
                      Icons.verified,
                    ),
                  ),
                  Expanded(
                    child: _buildMetric(
                      'Active Events',
                      '${floodData.activeEvents}',
                      Icons.event,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Additional Info
              if (floodData.precipitation > 0) ...[
                Row(
                  children: [
                    Icon(Icons.grain, size: 16, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      'Precipitation: ${floodData.precipitation.toStringAsFixed(1)}mm',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
              
              if (floodData.affectedAreaKm2 > 0) ...[
                Row(
                  children: [
                    Icon(Icons.area_chart, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      'Affected Area: ${floodData.affectedAreaKm2.toStringAsFixed(1)} km²',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 8),
              
              // Last Updated
              Row(
                children: [
                  Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Updated: ${_formatTime(floodData.timestamp)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}