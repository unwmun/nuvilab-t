import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

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
    required Header header,
  }) = _Response;

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);
}

@freezed
class Body with _$Body {
  const factory Body({
    required int totalCount,
    required List<AirQualityItem> items,
    required int pageNo,
    required int numOfRows,
  }) = _Body;

  factory Body.fromJson(Map<String, dynamic> json) => _$BodyFromJson(json);
}

@freezed
class Header with _$Header {
  const factory Header({
    required String resultMsg,
    required String resultCode,
  }) = _Header;

  factory Header.fromJson(Map<String, dynamic> json) => _$HeaderFromJson(json);
}

@freezed
class AirQualityItem with _$AirQualityItem {
  const factory AirQualityItem({
    @JsonKey(fromJson: _stringFromJson) required String so2Grade,
    String? coFlag,
    @JsonKey(fromJson: _stringFromJson) required String khaiValue,
    @JsonKey(fromJson: _stringFromJson) required String so2Value,
    @JsonKey(fromJson: _stringFromJson) required String coValue,
    String? pm25Flag,
    String? pm10Flag,
    @JsonKey(fromJson: _stringFromJson) required String o3Grade,
    @JsonKey(fromJson: _stringFromJson) required String pm10Value,
    @JsonKey(fromJson: _stringFromJson) required String khaiGrade,
    @JsonKey(fromJson: _stringFromJson) required String pm25Value,
    required String sidoName,
    String? no2Flag,
    @JsonKey(fromJson: _stringFromJson) required String no2Grade,
    String? o3Flag,
    @JsonKey(fromJson: _stringFromJson) required String pm25Grade,
    String? so2Flag,
    required String dataTime,
    @JsonKey(fromJson: _stringFromJson) required String coGrade,
    @JsonKey(fromJson: _stringFromJson) required String no2Value,
    required String stationName,
    @JsonKey(fromJson: _stringFromJson) required String pm10Grade,
    @JsonKey(fromJson: _stringFromJson) required String o3Value,
  }) = _AirQualityItem;

  factory AirQualityItem.fromJson(Map<String, dynamic> json) =>
      _$AirQualityItemFromJson(json);
}

String _stringFromJson(dynamic value) {
  if (value == null) return '';
  return value.toString();
}
