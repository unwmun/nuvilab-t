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
      print('응답 데이터 타입: ${response.data.runtimeType}');

      return AirQualityResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('Dio 에러 발생: ${e.message}');
      print('에러 응답: ${e.response?.data}');
      throw _handleDioError(e);
    } catch (e) {
      print('예상치 못한 오류 발생: $e');
      throw Exception('대기질 정보를 불러오는데 실패했습니다: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('서버 연결 시간이 초과되었습니다. 네트워크 상태를 확인해주세요.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 400 && statusCode < 500) {
            return Exception('요청이 잘못되었습니다. (${statusCode})');
          } else if (statusCode >= 500) {
            return Exception('서버에 문제가 발생했습니다. (${statusCode})');
          }
        }
        return Exception('응답 처리 중 오류가 발생했습니다.');
      case DioExceptionType.cancel:
        return Exception('요청이 취소되었습니다.');
      default:
        return Exception('네트워크 오류가 발생했습니다: ${e.message}');
    }
  }
}
