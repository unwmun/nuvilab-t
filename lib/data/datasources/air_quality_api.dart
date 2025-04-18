import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nubilab/data/models/air_quality.dart';

@injectable
class AirQualityApi {
  final Dio _dio;
  final String _baseUrl = 'http://apis.data.go.kr/B552584/ArpltnInforInqireSvc';
  final String _serviceKey =
      'lW7UGCa8yfdQ7GoEA/SDI4WIb4h8h4XtADxpWDeLTRsTGlYNSzM89LvxppvVBDsieGkKb0rwWhSSOXVXCr/nyg==';

  AirQualityApi(this._dio) {
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<AirQualityResponse> getCtprvnRltmMesureDnsty({
    required String sidoName,
    int pageNo = 1,
    int numOfRows = 100,
    String returnType = 'json',
    String ver = '1.0',
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/getCtprvnRltmMesureDnsty',
        queryParameters: {
          'sidoName': sidoName,
          'pageNo': pageNo,
          'numOfRows': numOfRows,
          'returnType': returnType,
          'serviceKey': _serviceKey,
          'ver': ver,
        },
      );

      print('API 응답 데이터: ${response.data}');

      try {
        return AirQualityResponse.fromJson(response.data);
      } catch (e, stackTrace) {
        print('JSON 파싱 에러 발생');
        print('에러 타입: ${e.runtimeType}');
        print('에러 메시지: $e');
        print('응답 데이터 구조:');
        _printJsonStructure(response.data);
        print('스택 트레이스: $stackTrace');
        rethrow;
      }
    } on DioException catch (e) {
      print('Dio 에러 발생: ${e.message}');
      print('에러 응답: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('예상치 못한 오류 발생: $e');
      throw Exception('대기질 정보를 불러오는데 실패했습니다: $e');
    }
  }

  void _printJsonStructure(dynamic data, [String indent = '']) {
    if (data == null) {
      print('${indent}null');
      return;
    }

    if (data is Map) {
      print('${indent}{');
      data.forEach((key, value) {
        print('$indent  $key: ${value.runtimeType}');
        if (value is Map || value is List) {
          _printJsonStructure(value, '$indent  ');
        }
      });
      print('$indent}');
    } else if (data is List) {
      print('${indent}[');
      if (data.isNotEmpty) {
        print('$indent  ${data.first.runtimeType}');
        if (data.first is Map || data.first is List) {
          _printJsonStructure(data.first, '$indent  ');
        }
      }
      print('$indent]');
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
