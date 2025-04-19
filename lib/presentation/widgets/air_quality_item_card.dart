import 'package:flutter/material.dart';
import '../../data/models/air_quality.dart';
import '../pages/detail/detail_page.dart';

class AirQualityItemCard extends StatelessWidget {
  final AirQualityItem item;

  const AirQualityItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.stationName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildAirQualityGradeChip(item.khaiGrade),
                ],
              ),
              const SizedBox(height: 12),
              Text('측정 시간: ${item.dataTime}'),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              _buildMeasurementRow(
                  '미세먼지(PM10)', item.pm10Value, item.pm10Grade),
              _buildMeasurementRow(
                  '초미세먼지(PM2.5)', item.pm25Value, item.pm25Grade),
              _buildMeasurementRow('이산화질소(NO2)', item.no2Value, item.no2Grade),
              _buildMeasurementRow('오존(O3)', item.o3Value, item.o3Grade),
              _buildMeasurementRow('일산화탄소(CO)', item.coValue, item.coGrade),
              _buildMeasurementRow('아황산가스(SO2)', item.so2Value, item.so2Grade),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailPage(
          stationName: item.stationName,
          item: item,
        ),
      ),
    );
  }

  Widget _buildMeasurementRow(String title, String? value, String? grade) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Row(
            children: [
              Text(value ?? '-'),
              const SizedBox(width: 8),
              _buildGradeIndicator(grade),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradeIndicator(String? grade) {
    if (grade == null) return const SizedBox();

    Color color;

    switch (grade) {
      case '1':
        color = Colors.blue;
        break;
      case '2':
        color = Colors.green;
        break;
      case '3':
        color = Colors.orange;
        break;
      case '4':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildAirQualityGradeChip(String? grade) {
    if (grade == null) return const SizedBox();

    String text;
    Color color;

    switch (grade) {
      case '1':
        text = '좋음';
        color = Colors.blue;
        break;
      case '2':
        text = '보통';
        color = Colors.green;
        break;
      case '3':
        text = '나쁨';
        color = Colors.orange;
        break;
      case '4':
        text = '매우나쁨';
        color = Colors.red;
        break;
      default:
        text = '정보없음';
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
    );
  }
}
