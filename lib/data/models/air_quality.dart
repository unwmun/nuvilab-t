import 'package:freezed_annotation/freezed_annotation.dart';

part 'air_quality.freezed.dart';
part 'air_quality.g.dart';

@freezed
class AirQualityResponse with _$AirQualityResponse {
  const factory AirQualityResponse({
    required Response response,
  }) = _AirQualityResponse;

  factory AirQualityResponse.fromJson(Map<String, dynamic> json) =>
      _$AirQualityResponseFromJson(json);
}

@freezed
class Response with _$Response {
  const factory Response({
    required Body body,
  }) = _Response;

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);
}

@freezed
class Body with _$Body {
  const factory Body({
    required int totalCount,
    required List<AirQualityItem> items,
  }) = _Body;

  factory Body.fromJson(Map<String, dynamic> json) => _$BodyFromJson(json);
}

@freezed
class AirQualityItem with _$AirQualityItem {
  const factory AirQualityItem({
    required String stationName,
    required String sidoName,
    required String dataTime,
    @JsonKey(fromJson: _stringFromJson) required String so2Value,
    @JsonKey(fromJson: _stringFromJson) required String coValue,
    @JsonKey(fromJson: _stringFromJson) required String o3Value,
    @JsonKey(fromJson: _stringFromJson) String? no2Value,
    @JsonKey(fromJson: _stringFromJson) required String pm10Value,
    @JsonKey(fromJson: _stringFromJson) required String pm25Value,
    @JsonKey(fromJson: _stringFromJson) required String khaiValue,
    @JsonKey(fromJson: _stringFromJson) required String so2Grade,
    @JsonKey(fromJson: _stringFromJson) required String coGrade,
    @JsonKey(fromJson: _stringFromJson) required String o3Grade,
    @JsonKey(fromJson: _stringFromJson) String? no2Grade,
    @JsonKey(fromJson: _stringFromJson) required String pm10Grade,
    @JsonKey(fromJson: _stringFromJson) required String pm25Grade,
    @JsonKey(fromJson: _stringFromJson) String? khaiGrade,
    String? so2Flag,
    String? coFlag,
    String? o3Flag,
    String? no2Flag,
    String? pm10Flag,
    String? pm25Flag,
  }) = _AirQualityItem;

  factory AirQualityItem.fromJson(Map<String, dynamic> json) =>
      _$AirQualityItemFromJson(json);
}

String _stringFromJson(dynamic value) {
  if (value == null) return '-';
  return value.toString();
}
