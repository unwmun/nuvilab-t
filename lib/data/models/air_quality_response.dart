import 'package:nubilab/domain/entities/air_quality.dart';

class AirQualityResponse {
  final int totalCount;
  final List<AirQuality> items;

  AirQualityResponse({
    required this.totalCount,
    required this.items,
  });

  factory AirQualityResponse.fromJson(Map<String, dynamic> json) {
    final response = json['response'];
    if (response == null) {
      return AirQualityResponse(totalCount: 0, items: []);
    }

    final body = response['body'];
    if (body == null) {
      return AirQualityResponse(totalCount: 0, items: []);
    }

    final int totalCount = body['totalCount'] ?? 0;
    final items = body['items'];

    if (items == null) {
      return AirQualityResponse(totalCount: totalCount, items: []);
    }

    final List<dynamic> itemsList = items['item'] ?? [];
    final List<AirQuality> airQualityList =
        itemsList.map((item) => AirQuality.fromJson(item)).toList();

    return AirQualityResponse(
      totalCount: totalCount,
      items: airQualityList,
    );
  }
}
