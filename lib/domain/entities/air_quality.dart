class AirQuality {
  final String stationName;
  final String sidoName;
  final String pm10Value;
  final String pm25Value;
  final String dataTime;
  final String khaiValue;
  final String khaiGrade;

  AirQuality({
    required this.stationName,
    required this.sidoName,
    required this.pm10Value,
    required this.pm25Value,
    required this.dataTime,
    required this.khaiValue,
    required this.khaiGrade,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
      stationName: json['stationName'] ?? '',
      sidoName: json['sidoName'] ?? '',
      pm10Value: json['pm10Value'] ?? '',
      pm25Value: json['pm25Value'] ?? '',
      dataTime: json['dataTime'] ?? '',
      khaiValue: json['khaiValue'] ?? '',
      khaiGrade: json['khaiGrade'] ?? '',
    );
  }
}
