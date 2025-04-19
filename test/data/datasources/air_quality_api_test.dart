import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:nubilab/data/datasources/air_quality_api.dart';
import 'package:nubilab/data/models/air_quality.dart' hide Response;

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late AirQualityApi airQualityApi;
  const testServiceKey = 'test_service_key';

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://test-api.com'));
    dioAdapter = DioAdapter(dio: dio);
    airQualityApi = AirQualityApi.withCustomDio(dio, testServiceKey);
  });

  group('getCtprvnRltmMesureDnsty', () {
    const testSidoName = '서울';

    test('정상적인 응답 데이터를 받았을 때 AirQualityResponse 객체를 반환해야 한다', () async {
      // 준비
      final responseJson = {
        'response': {
          'body': {
            'totalCount': 1,
            'items': [
              {
                'so2Grade': '1',
                'khaiValue': '50',
                'so2Value': '0.003',
                'coValue': '0.4',
                'o3Grade': '1',
                'pm10Value': '25',
                'khaiGrade': '1',
                'pm25Value': '15',
                'sidoName': '서울',
                'no2Grade': '1',
                'pm25Grade': '1',
                'dataTime': '2023-05-01 14:00',
                'coGrade': '1',
                'no2Value': '0.015',
                'stationName': '중구',
                'pm10Grade': '1',
                'o3Value': '0.035'
              }
            ],
            'pageNo': 1,
            'numOfRows': 100
          },
          'header': {'resultMsg': 'NORMAL_CODE', 'resultCode': '00'}
        }
      };

      // API 모킹 설정
      dioAdapter.onGet(
        '/getCtprvnRltmMesureDnsty',
        (server) => server.reply(200, responseJson),
        queryParameters: {
          'sidoName': testSidoName,
          'pageNo': 1,
          'numOfRows': 100,
          'returnType': 'json',
          'serviceKey': testServiceKey,
          'ver': '1.0',
        },
      );

      // 실행
      final result = await airQualityApi.getCtprvnRltmMesureDnsty(
        sidoName: testSidoName,
      );

      // 검증
      expect(result, isA<AirQualityResponse>());
      expect(result.response.body.items.length, 1);
      expect(result.response.body.totalCount, 1);
      expect(result.response.body.items[0].sidoName, testSidoName);
      expect(result.response.header.resultCode, '00');
    });

    test('API 호출 중 에러가 발생했을 때 예외를 발생시켜야 한다', () async {
      // 준비
      dioAdapter.onGet(
        '/getCtprvnRltmMesureDnsty',
        (server) => server.throws(
          404,
          DioException(
            requestOptions: RequestOptions(path: '/getCtprvnRltmMesureDnsty'),
            type: DioExceptionType.badResponse,
            error: 'Not Found',
            response: Response(
              statusCode: 404,
              requestOptions: RequestOptions(path: '/getCtprvnRltmMesureDnsty'),
              data: {'error': 'Not Found'},
            ),
          ),
        ),
        queryParameters: {
          'sidoName': testSidoName,
          'pageNo': 1,
          'numOfRows': 100,
          'returnType': 'json',
          'serviceKey': testServiceKey,
          'ver': '1.0',
        },
      );

      // 실행 및 검증
      expect(
        () => airQualityApi.getCtprvnRltmMesureDnsty(sidoName: testSidoName),
        throwsA(isA<Exception>()),
      );
    });

    test('잘못된 형식의 응답 데이터를 받았을 때 예외를 발생시켜야 한다', () async {
      // 준비
      final invalidResponseJson = {
        'wrongFormat': {'invalid': 'data'}
      };

      // API 모킹 설정
      dioAdapter.onGet(
        '/getCtprvnRltmMesureDnsty',
        (server) => server.reply(200, invalidResponseJson),
        queryParameters: {
          'sidoName': testSidoName,
          'pageNo': 1,
          'numOfRows': 100,
          'returnType': 'json',
          'serviceKey': testServiceKey,
          'ver': '1.0',
        },
      );

      // 실행 및 검증
      expect(
        () => airQualityApi.getCtprvnRltmMesureDnsty(sidoName: testSidoName),
        throwsA(isA<Exception>()),
      );
    });
  });
}
