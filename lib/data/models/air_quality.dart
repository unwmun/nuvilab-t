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
    required String? so2Grade,
    required String? coFlag,
    required String? khaiValue,
    required String? so2Value,
    required String? coValue,
    required String? pm25Flag,
    required String? pm10Flag,
    required String? o3Grade,
    required String? pm10Value,
    required String? khaiGrade,
    required String? pm25Value,
    required String? sidoName,
    required String? no2Flag,
    required String? no2Grade,
    required String? o3Flag,
    required String? pm25Grade,
    required String? so2Flag,
    required String? dataTime,
    required String? coGrade,
    required String? no2Value,
    required String? stationName,
    required String? pm10Grade,
    required String? o3Value,
  }) = _AirQualityItem;

  factory AirQualityItem.fromJson(Map<String, dynamic> json) =>
      _$AirQualityItemFromJson(json);
}
