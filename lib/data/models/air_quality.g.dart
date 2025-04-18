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
      header: Header.fromJson(json['header'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ResponseImplToJson(_$ResponseImpl instance) =>
    <String, dynamic>{
      'body': instance.body,
      'header': instance.header,
    };

_$BodyImpl _$$BodyImplFromJson(Map<String, dynamic> json) => _$BodyImpl(
      totalCount: (json['totalCount'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => AirQualityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageNo: (json['pageNo'] as num).toInt(),
      numOfRows: (json['numOfRows'] as num).toInt(),
    );

Map<String, dynamic> _$$BodyImplToJson(_$BodyImpl instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'items': instance.items,
      'pageNo': instance.pageNo,
      'numOfRows': instance.numOfRows,
    };

_$HeaderImpl _$$HeaderImplFromJson(Map<String, dynamic> json) => _$HeaderImpl(
      resultMsg: json['resultMsg'] as String,
      resultCode: json['resultCode'] as String,
    );

Map<String, dynamic> _$$HeaderImplToJson(_$HeaderImpl instance) =>
    <String, dynamic>{
      'resultMsg': instance.resultMsg,
      'resultCode': instance.resultCode,
    };

_$AirQualityItemImpl _$$AirQualityItemImplFromJson(Map<String, dynamic> json) =>
    _$AirQualityItemImpl(
      so2Grade: _stringFromJson(json['so2Grade']),
      coFlag: json['coFlag'] as String?,
      khaiValue: _stringFromJson(json['khaiValue']),
      so2Value: _stringFromJson(json['so2Value']),
      coValue: _stringFromJson(json['coValue']),
      pm25Flag: json['pm25Flag'] as String?,
      pm10Flag: json['pm10Flag'] as String?,
      o3Grade: _stringFromJson(json['o3Grade']),
      pm10Value: _stringFromJson(json['pm10Value']),
      khaiGrade: _stringFromJson(json['khaiGrade']),
      pm25Value: _stringFromJson(json['pm25Value']),
      sidoName: json['sidoName'] as String,
      no2Flag: json['no2Flag'] as String?,
      no2Grade: _stringFromJson(json['no2Grade']),
      o3Flag: json['o3Flag'] as String?,
      pm25Grade: _stringFromJson(json['pm25Grade']),
      so2Flag: json['so2Flag'] as String?,
      dataTime: json['dataTime'] as String,
      coGrade: _stringFromJson(json['coGrade']),
      no2Value: _stringFromJson(json['no2Value']),
      stationName: json['stationName'] as String,
      pm10Grade: _stringFromJson(json['pm10Grade']),
      o3Value: _stringFromJson(json['o3Value']),
    );

Map<String, dynamic> _$$AirQualityItemImplToJson(
        _$AirQualityItemImpl instance) =>
    <String, dynamic>{
      'so2Grade': instance.so2Grade,
      'coFlag': instance.coFlag,
      'khaiValue': instance.khaiValue,
      'so2Value': instance.so2Value,
      'coValue': instance.coValue,
      'pm25Flag': instance.pm25Flag,
      'pm10Flag': instance.pm10Flag,
      'o3Grade': instance.o3Grade,
      'pm10Value': instance.pm10Value,
      'khaiGrade': instance.khaiGrade,
      'pm25Value': instance.pm25Value,
      'sidoName': instance.sidoName,
      'no2Flag': instance.no2Flag,
      'no2Grade': instance.no2Grade,
      'o3Flag': instance.o3Flag,
      'pm25Grade': instance.pm25Grade,
      'so2Flag': instance.so2Flag,
      'dataTime': instance.dataTime,
      'coGrade': instance.coGrade,
      'no2Value': instance.no2Value,
      'stationName': instance.stationName,
      'pm10Grade': instance.pm10Grade,
      'o3Value': instance.o3Value,
    };
