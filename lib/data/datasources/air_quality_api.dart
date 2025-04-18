import 'package:dio/dio.dart';
import 'package:nubilab/data/models/air_quality.dart';

class AirQualityApi {
  final Dio _dio;
  final String _baseUrl = 'http://apis.data.go.kr/B552584/ArpltnInforInqireSvc';
  final String _serviceKey =
      'lW7UGCa8yfdQ7GoEA%2FSDI4WIb4h8h4XtADxpWDeLTRsTGlYNSzM89LvxppvVBDsieGkKb0rwWhSSOXVXCr%2Fnyg%3D%3D';

  AirQualityApi(this._dio);

  // 테스트 데이터를 반환합니다 (API 호출 문제 발생 시 사용)
  Future<AirQualityResponse> getMockData(
      {int pageNo = 1, int numOfRows = 10}) async {
    // 전체 모의 데이터
    final allItems = [
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
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "100",
        "so2Value": "0.004",
        "coValue": "0.7",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "1",
        "pm10Value": "101",
        "khaiGrade": "2",
        "pm25Value": "42",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "2",
        "o3Flag": null,
        "pm25Grade": "2",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.051",
        "stationName": "청계천로",
        "pm10Grade": "2",
        "o3Value": "0.027"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "89",
        "so2Value": "0.003",
        "coValue": "0.8",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "1",
        "pm10Value": "82",
        "khaiGrade": "2",
        "pm25Value": "42",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "2",
        "o3Flag": null,
        "pm25Grade": "2",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.046",
        "stationName": "종로",
        "pm10Grade": "2",
        "o3Value": "0.027"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "105",
        "so2Value": "0.003",
        "coValue": "0.6",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "2",
        "pm10Value": "85",
        "khaiGrade": "3",
        "pm25Value": "39",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "1",
        "o3Flag": null,
        "pm25Grade": "3",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.024",
        "stationName": "용산구",
        "pm10Grade": "2",
        "o3Value": "0.050"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "100",
        "so2Value": "0.003",
        "coValue": "0.6",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "2",
        "pm10Value": "86",
        "khaiGrade": "2",
        "pm25Value": "40",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "1",
        "o3Flag": null,
        "pm25Grade": "2",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.026",
        "stationName": "광진구",
        "pm10Grade": "2",
        "o3Value": "0.067"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "92",
        "so2Value": "0.003",
        "coValue": "0.5",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "2",
        "pm10Value": "85",
        "khaiGrade": "2",
        "pm25Value": "40",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "2",
        "o3Flag": null,
        "pm25Grade": "2",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.031",
        "stationName": "성동구",
        "pm10Grade": "2",
        "o3Value": "0.053"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "116",
        "so2Value": "0.003",
        "coValue": "0.7",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "2",
        "pm10Value": "96",
        "khaiGrade": "3",
        "pm25Value": "36",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "2",
        "o3Flag": null,
        "pm25Grade": "2",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.052",
        "stationName": "강변북로",
        "pm10Grade": "3",
        "o3Value": "0.033"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "101",
        "so2Value": "0.003",
        "coValue": "0.5",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "2",
        "pm10Value": "100",
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
        "no2Value": "0.030",
        "stationName": "중랑구",
        "pm10Grade": "2",
        "o3Value": "0.050"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "96",
        "so2Value": "0.003",
        "coValue": "0.6",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "2",
        "pm10Value": "96",
        "khaiGrade": "2",
        "pm25Value": "45",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "2",
        "o3Flag": null,
        "pm25Grade": "2",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.041",
        "stationName": "동대문구",
        "pm10Grade": "2",
        "o3Value": "0.039"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "78",
        "so2Value": "0.002",
        "coValue": "0.5",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "2",
        "pm10Value": "59",
        "khaiGrade": "2",
        "pm25Value": "12",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "1",
        "o3Flag": null,
        "pm25Grade": "2",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.025",
        "stationName": "강북구",
        "pm10Grade": "2",
        "o3Value": "0.046"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "93",
        "so2Value": "0.003",
        "coValue": "0.6",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "2",
        "pm10Value": "88",
        "khaiGrade": "2",
        "pm25Value": "40",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "2",
        "o3Flag": null,
        "pm25Grade": "2",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.037",
        "stationName": "양천구",
        "pm10Grade": "2",
        "o3Value": "0.042"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "88",
        "so2Value": "0.003",
        "coValue": "0.6",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "2",
        "pm10Value": "82",
        "khaiGrade": "2",
        "pm25Value": "33",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "2",
        "o3Flag": null,
        "pm25Grade": "2",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.038",
        "stationName": "노원구",
        "pm10Grade": "2",
        "o3Value": "0.048"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "100",
        "so2Value": "0.003",
        "coValue": "0.6",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "2",
        "pm10Value": "85",
        "khaiGrade": "2",
        "pm25Value": "48",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "2",
        "o3Flag": null,
        "pm25Grade": "2",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.044",
        "stationName": "화랑로",
        "pm10Grade": "2",
        "o3Value": "0.045"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "173",
        "so2Value": "0.003",
        "coValue": "0.5",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "2",
        "pm10Value": "101",
        "khaiGrade": "3",
        "pm25Value": "46",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "1",
        "o3Flag": null,
        "pm25Grade": "3",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.018",
        "stationName": "서초구",
        "pm10Grade": "3",
        "o3Value": "0.067"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "170",
        "so2Value": "0.003",
        "coValue": "0.5",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "2",
        "pm10Value": "102",
        "khaiGrade": "3",
        "pm25Value": "44",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "1",
        "o3Flag": null,
        "pm25Grade": "3",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.027",
        "stationName": "도산대로",
        "pm10Grade": "3",
        "o3Value": "0.052"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "114",
        "so2Value": "0.003",
        "coValue": "0.6",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "1",
        "pm10Value": "98",
        "khaiGrade": "3",
        "pm25Value": "42",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "2",
        "o3Flag": null,
        "pm25Grade": "3",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.046",
        "stationName": "강남대로",
        "pm10Grade": "3",
        "o3Value": "0.026"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "92",
        "so2Value": "0.004",
        "coValue": "0.5",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "2",
        "pm10Value": "91",
        "khaiGrade": "2",
        "pm25Value": "36",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "2",
        "o3Flag": null,
        "pm25Grade": "2",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.030",
        "stationName": "송파구",
        "pm10Grade": "2",
        "o3Value": "0.053"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "166",
        "so2Value": "0.003",
        "coValue": "0.8",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "2",
        "pm10Value": "108",
        "khaiGrade": "3",
        "pm25Value": "47",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "1",
        "o3Flag": null,
        "pm25Grade": "3",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.029",
        "stationName": "강동구",
        "pm10Grade": "3",
        "o3Value": "0.063"
      },
      {
        "so2Grade": "1",
        "coFlag": null,
        "khaiValue": "93",
        "so2Value": "0.003",
        "coValue": "0.7",
        "pm25Flag": null,
        "pm10Flag": null,
        "o3Grade": "2",
        "pm10Value": "89",
        "khaiGrade": "2",
        "pm25Value": "32",
        "sidoName": "서울",
        "no2Flag": null,
        "no2Grade": "2",
        "o3Flag": null,
        "pm25Grade": "2",
        "so2Flag": null,
        "dataTime": "2023-08-15 21:00",
        "coGrade": "1",
        "no2Value": "0.044",
        "stationName": "천호대로",
        "pm10Grade": "2",
        "o3Value": "0.047"
      }
    ];

    // 페이징 처리
    final totalCount = allItems.length;
    final startIndex = (pageNo - 1) * numOfRows;
    final endIndex = (startIndex + numOfRows) > totalCount
        ? totalCount
        : (startIndex + numOfRows);
    final items =
        (startIndex < totalCount) ? allItems.sublist(startIndex, endIndex) : [];

    await Future.delayed(
        const Duration(milliseconds: 800)); // 실제 API 호출처럼 지연 시간 추가

    // 페이징된 결과 반환
    return AirQualityResponse.fromJson({
      "response": {
        "body": {
          "totalCount": totalCount,
          "items": items,
          "pageNo": pageNo,
          "numOfRows": numOfRows
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
    return await getMockData(pageNo: pageNo, numOfRows: numOfRows);

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
