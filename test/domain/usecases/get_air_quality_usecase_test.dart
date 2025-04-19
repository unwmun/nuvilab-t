import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/domain/repositories/air_quality_repository.dart';
import 'package:nubilab/domain/usecases/get_air_quality_usecase.dart';

import 'get_air_quality_usecase_test.mocks.dart';

@GenerateMocks([AirQualityRepository])
void main() {
  late GetAirQualityUseCase useCase;
  late MockAirQualityRepository mockRepository;

  setUp(() {
    mockRepository = MockAirQualityRepository();
    useCase = GetAirQualityUseCase(mockRepository);
  });

  const testSido = '서울';
  const testPageNo = 1;
  const testNumOfRows = 10;

  const testAirQuality = AirQualityResponse(
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
        numOfRows: 10,
      ),
      header: Header(
        resultMsg: 'OK',
        resultCode: '00',
      ),
    ),
  );

  test('should get air quality data from repository', () async {
    // arrange
    when(mockRepository.getAirQualityBySido(
      sidoName: testSido,
      pageNo: testPageNo,
      numOfRows: testNumOfRows,
    )).thenAnswer((_) async => testAirQuality);

    // act
    final result = await useCase.execute(
      sidoName: testSido,
      pageNo: testPageNo,
      numOfRows: testNumOfRows,
    );

    // assert
    expect(result, testAirQuality);
    verify(mockRepository.getAirQualityBySido(
      sidoName: testSido,
      pageNo: testPageNo,
      numOfRows: testNumOfRows,
    ));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should use default values for optional parameters', () async {
    // arrange
    when(mockRepository.getAirQualityBySido(
      sidoName: testSido,
      pageNo: 1,
      numOfRows: 100,
    )).thenAnswer((_) async => testAirQuality);

    // act
    final result = await useCase.execute(sidoName: testSido);

    // assert
    expect(result, testAirQuality);
    verify(mockRepository.getAirQualityBySido(
      sidoName: testSido,
      pageNo: 1,
      numOfRows: 100,
    ));
    verifyNoMoreInteractions(mockRepository);
  });
}
