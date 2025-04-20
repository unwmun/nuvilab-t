import 'package:flutter/material.dart';
import '../../../data/models/air_quality.dart';

class DetailPage extends StatelessWidget {
  final String stationName;
  final AirQualityItem? item;

  const DetailPage({
    super.key,
    required this.stationName,
    this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('측정소 상세정보'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Text(
                stationName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 24),
            if (item != null)
              _buildDetailContent(context, item!)
            else
              _buildLoadingOrError(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, AirQualityItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(
          context,
          '측정 정보',
          [
            _buildInfoRow('측정소', item.stationName ?? '정보 없음'),
            _buildInfoRow('측정 시간', item.dataTime ?? '정보 없음'),
            _buildInfoRow('지역', item.sidoName ?? '정보 없음'),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          '대기 오염 수치',
          [
            _buildInfoRow('미세먼지(PM10)',
                '${item.pm10Value ?? '-'} ㎍/㎥ (등급: ${_getGradeText(item.pm10Grade)})'),
            _buildInfoRow('초미세먼지(PM2.5)',
                '${item.pm25Value ?? '-'} ㎍/㎥ (등급: ${_getGradeText(item.pm25Grade)})'),
            _buildInfoRow('이산화질소',
                '${item.no2Value ?? '-'} ppm (등급: ${_getGradeText(item.no2Grade)})'),
            _buildInfoRow('오존',
                '${item.o3Value ?? '-'} ppm (등급: ${_getGradeText(item.o3Grade)})'),
            _buildInfoRow('일산화탄소',
                '${item.coValue ?? '-'} ppm (등급: ${_getGradeText(item.coGrade)})'),
            _buildInfoRow('아황산가스',
                '${item.so2Value ?? '-'} ppm (등급: ${_getGradeText(item.so2Grade)})'),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          '통합 대기 환경 지수',
          [
            _buildInfoRow('통합 지수(KHAI)',
                '${item.khaiValue ?? '-'} (등급: ${_getGradeText(item.khaiGrade)})'),
          ],
        ),
      ],
    );
  }

  String _getGradeText(String? grade) {
    if (grade == null || grade.isEmpty) return '정보없음';

    switch (grade) {
      case '1':
        return '좋음';
      case '2':
        return '보통';
      case '3':
        return '나쁨';
      case '4':
        return '매우나쁨';
      default:
        return '정보없음';
    }
  }

  Widget _buildInfoCard(
      BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildLoadingOrError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            '측정소 정보를 불러오는 중입니다',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
