import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nubilab/data/models/air_quality.dart';

@injectable
class AirQualityApi {
  final Dio _dio;
  final String _baseUrl = 'http://apis.data.go.kr/B552584/ArpltnInforInqireSvc';
  final String _serviceKey =
      'lW7UGCa8yfdQ7GoEA%2FSDI4WIb4h8h4XtADxpWDeLTRsTGlYNSzM89LvxppvVBDsieGkKb0rwWhSSOXVXCr%2Fnyg%3D%3D';

  AirQualityApi(this._dio);

  // 테스트 데이터를 반환합니다 (API 호출 문제 발생 시 사용)
  Future<AirQualityResponse> getMockData() async {
    // 미리 정의된 JSON 응답을 반환합니다
    return AirQualityResponse.fromJson({
      "response": {
        "body": {
          "totalCount": 3,
          "items": [
            {
              "so2Grade": "1",
              "coFlag": null,
              "khaiValue": "85",
              "so2Value": "0.004",
              "coValue": "0.6",
              "pm25Flag": null,
              "pm10Flag": null,
              "o3Grade": "2",
              "pm10Value": "66",
              "khaiGrade": "2",
              "pm25Value": "35",
              "sidoName": "서울",
              "no2Flag": null,
              "no2Grade": "2",
              "o3Flag": null,
              "pm25Grade": "2",
              "so2Flag": null,
              "dataTime": "2023-08-15 21:00",
              "coGrade": "1",
              "no2Value": "0.041",
              "stationName": "중구",
              "pm10Grade": "2",
              "o3Value": "0.040"
            },
            {
              "so2Grade": "1",
              "coFlag": null,
              "khaiValue": "118",
              "so2Value": "0.002",
              "coValue": "0.7",
              "pm25Flag": null,
              "pm10Flag": null,
              "o3Grade": "2",
              "pm10Value": "108",
              "khaiGrade": "3",
              "pm25Value": "48",
              "sidoName": "서울",
              "no2Flag": null,
              "no2Grade": "2",
              "o3Flag": null,
              "pm25Grade": "3",
              "so2Flag": null,
              "dataTime": "2023-08-15 21:00",
              "coGrade": "1",
              "no2Value": "0.039",
              "stationName": "한강대로",
              "pm10Grade": "3",
              "o3Value": "0.037"
            },
            {
              "so2Grade": "1",
              "coFlag": null,
              "khaiValue": "97",
              "so2Value": "0.004",
              "coValue": "0.6",
              "pm25Flag": null,
              "pm10Flag": null,
              "o3Grade": "2",
              "pm10Value": "90",
              "khaiGrade": "2",
              "pm25Value": "46",
              "sidoName": "서울",
              "no2Flag": null,
              "no2Grade": "2",
              "o3Flag": null,
              "pm25Grade": "2",
              "so2Flag": null,
              "dataTime": "2023-08-15 21:00",
              "coGrade": "1",
              "no2Value": "0.046",
              "stationName": "종로구",
              "pm10Grade": "2",
              "o3Value": "0.036"
            }
          ],
          "pageNo": 1,
          "numOfRows": 10
        },
        "header": {"resultMsg": "NORMAL_CODE", "resultCode": "00"}
      }
    });
  }

  Future<AirQualityResponse> getCtprvnRltmMesureDnsty({
    required String sidoName,
    int pageNo = 1,
    int numOfRows = 100,
    String returnType = 'json',
    String ver = '1.0',
  }) async {
    // 브라우저 환경에서 CORS 문제가 발생하므로 모의 데이터 사용
    return await getMockData();

    /*
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

      return AirQualityResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      print('예상치 못한 오류 발생: $e');
      throw Exception('대기질 정보를 불러오는데 실패했습니다: $e');
    }
    */
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
