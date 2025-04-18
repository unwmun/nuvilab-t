// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'air_quality.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AirQualityResponseImpl _$$AirQualityResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AirQualityResponseImpl(
      response: Response.fromJson(json['response'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AirQualityResponseImplToJson(
        _$AirQualityResponseImpl instance) =>
    <String, dynamic>{
      'response': instance.response,
    };

_$ResponseImpl _$$ResponseImplFromJson(Map<String, dynamic> json) =>
    _$ResponseImpl(
      body: Body.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ResponseImplToJson(_$ResponseImpl instance) =>
    <String, dynamic>{
      'body': instance.body,
    };

_$BodyImpl _$$BodyImplFromJson(Map<String, dynamic> json) => _$BodyImpl(
      totalCount: (json['totalCount'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => AirQualityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BodyImplToJson(_$BodyImpl instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'items': instance.items,
    };

_$AirQualityItemImpl _$$AirQualityItemImplFromJson(Map<String, dynamic> json) =>
    _$AirQualityItemImpl(
      stationName: json['stationName'] as String,
      sidoName: json['sidoName'] as String,
      dataTime: json['dataTime'] as String,
      so2Value: _stringFromJson(json['so2Value']),
      coValue: _stringFromJson(json['coValue']),
      o3Value: _stringFromJson(json['o3Value']),
      no2Value: _stringFromJson(json['no2Value']),
      pm10Value: _stringFromJson(json['pm10Value']),
      pm25Value: _stringFromJson(json['pm25Value']),
      khaiValue: _stringFromJson(json['khaiValue']),
      so2Grade: _stringFromJson(json['so2Grade']),
      coGrade: _stringFromJson(json['coGrade']),
      o3Grade: _stringFromJson(json['o3Grade']),
      no2Grade: _stringFromJson(json['no2Grade']),
      pm10Grade: _stringFromJson(json['pm10Grade']),
      pm25Grade: _stringFromJson(json['pm25Grade']),
      khaiGrade: _stringFromJson(json['khaiGrade']),
      so2Flag: json['so2Flag'] as String?,
      coFlag: json['coFlag'] as String?,
      o3Flag: json['o3Flag'] as String?,
      no2Flag: json['no2Flag'] as String?,
      pm10Flag: json['pm10Flag'] as String?,
      pm25Flag: json['pm25Flag'] as String?,
    );

Map<String, dynamic> _$$AirQualityItemImplToJson(
        _$AirQualityItemImpl instance) =>
    <String, dynamic>{
      'stationName': instance.stationName,
      'sidoName': instance.sidoName,
      'dataTime': instance.dataTime,
      'so2Value': instance.so2Value,
      'coValue': instance.coValue,
      'o3Value': instance.o3Value,
      'no2Value': instance.no2Value,
      'pm10Value': instance.pm10Value,
      'pm25Value': instance.pm25Value,
      'khaiValue': instance.khaiValue,
      'so2Grade': instance.so2Grade,
      'coGrade': instance.coGrade,
      'o3Grade': instance.o3Grade,
      'no2Grade': instance.no2Grade,
      'pm10Grade': instance.pm10Grade,
      'pm25Grade': instance.pm25Grade,
      'khaiGrade': instance.khaiGrade,
      'so2Flag': instance.so2Flag,
      'coFlag': instance.coFlag,
      'o3Flag': instance.o3Flag,
      'no2Flag': instance.no2Flag,
      'pm10Flag': instance.pm10Flag,
      'pm25Flag': instance.pm25Flag,
    };
