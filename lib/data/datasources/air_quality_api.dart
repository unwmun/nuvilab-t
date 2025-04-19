import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import '../../core/network/ssl_pinning.dart';
import '../../core/utils/logger.dart';
import '../models/air_quality.dart';

@injectable
class AirQualityApi {
  final Dio _dio;
  final String _serviceKey;

  AirQualityApi(@Named("secureClient") this._dio)
      : _serviceKey = SecureNetworkClient.serviceKey;

  @visibleForTesting
  factory AirQualityApi.withCustomDio(Dio dio, String serviceKey) {
    return AirQualityApi._test(dio, serviceKey);
  }

  AirQualityApi._test(this._dio, this._serviceKey);

  Future<AirQualityResponse> getCtprvnRltmMesureDnsty({
    required String sidoName,
    int pageNo = 1,
    int numOfRows = 100,
    String returnType = 'json',
    String ver = '1.0',
  }) async {
    try {
      final response = await _dio.get(
        '/getCtprvnRltmMesureDnsty',
        queryParameters: {
          'sidoName': sidoName,
          'pageNo': pageNo,
          'numOfRows': numOfRows,
          'returnType': returnType,
          'serviceKey': _serviceKey,
          'ver': ver,
        },
      );

      AppLogger.debug('API 응답 데이터: ${response.data}');

      try {
        return AirQualityResponse.fromJson(response.data);
      } catch (e, stackTrace) {
        AppLogger.error('JSON 파싱 에러 발생');
        AppLogger.error('에러 타입: ${e.runtimeType}');
        AppLogger.error('에러 메시지: $e');
        AppLogger.error('응답 데이터 구조:');
        _printJsonStructure(response.data);
        AppLogger.error('스택 트레이스: $stackTrace');
        rethrow;
      }
    } on DioException catch (e) {
      AppLogger.error('Dio 에러 발생: ${e.message}');
      AppLogger.error('에러 응답: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      AppLogger.error('예상치 못한 오류 발생: $e');
      throw Exception('대기질 정보를 불러오는데 실패했습니다: $e');
    }
  }

  void _printJsonStructure(dynamic data, [String indent = '']) {
    if (data == null) {
      AppLogger.debug('${indent}null');
      return;
    }

    if (data is Map) {
      AppLogger.debug('$indent{');
      data.forEach((key, value) {
        AppLogger.debug('$indent  $key: ${value.runtimeType}');
        if (value is Map || value is List) {
          _printJsonStructure(value, '$indent  ');
        }
      });
      AppLogger.debug('$indent}');
    } else if (data is List) {
      AppLogger.debug('$indent[');
      if (data.isNotEmpty) {
        AppLogger.debug('$indent  ${data.first.runtimeType}');
        if (data.first is Map || data.first is List) {
          _printJsonStructure(data.first, '$indent  ');
        }
      }
      AppLogger.debug('$indent]');
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('서버 연결 시간이 초과되었습니다.');
      case DioExceptionType.badResponse:
        return Exception('서버 응답 오류: ${e.response?.statusCode}');
      case DioExceptionType.cancel:
        return Exception('요청이 취소되었습니다.');
      default:
        return Exception('네트워크 오류가 발생했습니다: ${e.message}');
    }
  }
}
