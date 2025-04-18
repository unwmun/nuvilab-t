import 'package:flutter/material.dart';
import 'package:nubilab/data/models/air_quality.dart';

class AirQualityItemCard extends StatelessWidget {
  final AirQualityItem item;

  const AirQualityItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.stationName}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildAirQualityGradeChip(item.khaiGrade),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '측정 시간: ${item.dataTime}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            _buildMeasurementRow('미세먼지(PM10)', item.pm10Value, item.pm10Grade),
            _buildMeasurementRow(
                '초미세먼지(PM2.5)', item.pm25Value, item.pm25Grade),
            _buildMeasurementRow('이산화질소(NO2)', item.no2Value, item.no2Grade),
            _buildMeasurementRow('오존(O3)', item.o3Value, item.o3Grade),
            _buildMeasurementRow('일산화탄소(CO)', item.coValue, item.coGrade),
            _buildMeasurementRow('아황산가스(SO2)', item.so2Value, item.so2Grade),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementRow(String title, String? value, String? grade) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                value ?? '-',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              _buildGradeIndicator(grade, title),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradeIndicator(String? grade, String title) {
    if (grade == null) return const SizedBox();

    Color color;
    String tooltip;

    switch (grade) {
      case '1':
        color = Colors.blue;
        tooltip = '좋음';
        break;
      case '2':
        color = Colors.green;
        tooltip = '보통';
        break;
      case '3':
        color = Colors.orange;
        tooltip = '나쁨';
        break;
      case '4':
        color = Colors.red;
        tooltip = '매우나쁨';
        break;
      default:
        color = Colors.grey;
        tooltip = '정보없음';
    }

    return Tooltip(
      message: '$title: $tooltip',
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAirQualityGradeChip(String? grade) {
    if (grade == null) return const SizedBox();

    String text;
    Color color;
    IconData icon;

    switch (grade) {
      case '1':
        text = '좋음';
        color = Colors.blue;
        icon = Icons.sentiment_very_satisfied;
        break;
      case '2':
        text = '보통';
        color = Colors.green;
        icon = Icons.sentiment_satisfied;
        break;
      case '3':
        text = '나쁨';
        color = Colors.orange;
        icon = Icons.sentiment_dissatisfied;
        break;
      case '4':
        text = '매우나쁨';
        color = Colors.red;
        icon = Icons.sentiment_very_dissatisfied;
        break;
      default:
        text = '정보없음';
        color = Colors.grey;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
