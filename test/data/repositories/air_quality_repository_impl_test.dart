import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nubilab/core/network/network_info.dart';
import 'package:nubilab/data/datasources/air_quality_api.dart';
import 'package:nubilab/data/datasources/air_quality_local_datasource.dart';
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/data/repositories/air_quality_repository_impl.dart';

import 'air_quality_repository_impl_test.mocks.dart';

@GenerateMocks([AirQualityApi, AirQualityLocalDataSource, NetworkInfo])
void main() {
  late AirQualityRepositoryImpl repository;
  late MockAirQualityApi mockApi;
  late MockAirQualityLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockApi = MockAirQualityApi();
    mockLocalDataSource = MockAirQualityLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AirQualityRepositoryImpl(
      mockApi,
      mockLocalDataSource,
      mockNetworkInfo,
    );
  });

  const testSido = '서울';
  const testPageNo = 1;
  const testNumOfRows = 100;

  const testAirQualityResponse = AirQualityResponse(
    response: Response(
      body: Body(
        totalCount: 1,
        items: [
          AirQualityItem(
            so2Grade: '1',
            khaiValue: '100',
            so2Value: '0.003',
            coValue: '0.4',
            o3Grade: '1',
            pm10Value: '15',
            khaiGrade: '2',
            pm25Value: '10',
            sidoName: '서울',
            no2Grade: '1',
            pm25Grade: '1',
            dataTime: '2023-05-01 14:00',
            coGrade: '1',
            no2Value: '0.015',
            stationName: '강남구',
            pm10Grade: '1',
            o3Value: '0.040',
          ),
        ],
        pageNo: 1,
        numOfRows: 100,
      ),
      header: Header(
        resultMsg: 'OK',
        resultCode: '00',
      ),
    ),
  );

  group('getAirQualityBySido', () {
    test('네트워크 연결이 가능할 때 원격 데이터를 반환해야 함', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDataSource.getAirQualityData(testSido))
          .thenAnswer((_) async => null);
      when(mockApi.getCtprvnRltmMesureDnsty(
        sidoName: testSido,
        pageNo: testPageNo,
        numOfRows: testNumOfRows,
      )).thenAnswer((_) async => testAirQualityResponse);

      // act
      final result = await repository.getAirQualityBySido(
        sidoName: testSido,
        pageNo: testPageNo,
        numOfRows: testNumOfRows,
      );

      // assert
      expect(result, testAirQualityResponse);
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDataSource.getAirQualityData(testSido));
      verify(mockApi.getCtprvnRltmMesureDnsty(
        sidoName: testSido,
        pageNo: testPageNo,
        numOfRows: testNumOfRows,
      ));
      verify(mockLocalDataSource.saveAirQualityData(
        sidoName: testSido,
        data: testAirQualityResponse,
      ));
    });

    test('네트워크 연결이 없을 때 캐시된 데이터를 반환해야 함', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getAirQualityData(testSido))
          .thenAnswer((_) async => testAirQualityResponse);

      // act
      final result = await repository.getAirQualityBySido(
        sidoName: testSido,
        pageNo: testPageNo,
        numOfRows: testNumOfRows,
      );

      // assert
      expect(result, testAirQualityResponse);
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDataSource.getAirQualityData(testSido));
      verifyNever(mockApi.getCtprvnRltmMesureDnsty(
        sidoName: anyNamed('sidoName'),
        pageNo: anyNamed('pageNo'),
        numOfRows: anyNamed('numOfRows'),
      ));
    });

    test('네트워크 연결이 없고 캐시된 데이터도 없을 때 예외를 발생시켜야 함', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getAirQualityData(testSido))
          .thenAnswer((_) async => null);

      // act
      final call = repository.getAirQualityBySido(
        sidoName: testSido,
        pageNo: testPageNo,
        numOfRows: testNumOfRows,
      );

      // assert
      await expectLater(call, throwsA(isA<Exception>()));
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDataSource.getAirQualityData(testSido));
      verifyNever(mockApi.getCtprvnRltmMesureDnsty(
        sidoName: anyNamed('sidoName'),
        pageNo: anyNamed('pageNo'),
        numOfRows: anyNamed('numOfRows'),
      ));
    });

    test('API에서 예외가 발생했을 때 캐시된 데이터를 반환해야 함', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDataSource.getAirQualityData(testSido))
          .thenAnswer((_) async => testAirQualityResponse);
      when(mockApi.getCtprvnRltmMesureDnsty(
        sidoName: testSido,
        pageNo: testPageNo,
        numOfRows: testNumOfRows,
      )).thenThrow(Exception('API 오류'));

      // act
      final result = await repository.getAirQualityBySido(
        sidoName: testSido,
        pageNo: testPageNo,
        numOfRows: testNumOfRows,
      );

      // assert
      expect(result, testAirQualityResponse);
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDataSource.getAirQualityData(testSido));
      verify(mockApi.getCtprvnRltmMesureDnsty(
        sidoName: testSido,
        pageNo: testPageNo,
        numOfRows: testNumOfRows,
      ));
      verifyNever(mockLocalDataSource.saveAirQualityData(
        sidoName: testSido,
        data: testAirQualityResponse,
      ));
    });

    test('API 실패 시 캐시된 데이터가 없으면 예외를 다시 발생시켜야 함', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDataSource.getAirQualityData(testSido))
          .thenAnswer((_) async => null);
      when(mockApi.getCtprvnRltmMesureDnsty(
        sidoName: testSido,
        pageNo: testPageNo,
        numOfRows: testNumOfRows,
      )).thenThrow(Exception('API 오류'));

      // act
      final call = repository.getAirQualityBySido(
        sidoName: testSido,
        pageNo: testPageNo,
        numOfRows: testNumOfRows,
      );

      // assert
      await expectLater(call, throwsA(isA<Exception>()));
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDataSource.getAirQualityData(testSido));
      verify(mockApi.getCtprvnRltmMesureDnsty(
        sidoName: testSido,
        pageNo: testPageNo,
        numOfRows: testNumOfRows,
      ));
    });
  });
}
