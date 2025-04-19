import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nubilab/core/network/network_info.dart';
import 'package:nubilab/data/datasources/air_quality_local_datasource.dart';
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/domain/usecases/get_air_quality_usecase.dart';
import 'package:nubilab/presentation/viewmodels/air_quality_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'air_quality_view_model_test.mocks.dart';

@GenerateMocks([GetAirQualityUseCase, AirQualityLocalDataSource, NetworkInfo])
void main() {
  late AirQualityViewModel viewModel;
  late MockGetAirQualityUseCase mockUseCase;
  late MockAirQualityLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  const testSido = '서울';

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

  setUp(() {
    mockUseCase = MockGetAirQualityUseCase();
    mockLocalDataSource = MockAirQualityLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    // 생성자에서 호출되는 메서드들에 대한 스텁 설정
    when(mockLocalDataSource.getAirQualityData(any))
        .thenAnswer((_) async => null);
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

    // 구체적인 값으로 수정합니다
    when(mockUseCase.execute(sidoName: testSido, pageNo: 1, numOfRows: 100))
        .thenAnswer((_) async => testAirQualityResponse);

    // 모델 초기화
    viewModel = AirQualityViewModel(
      mockUseCase,
      mockLocalDataSource,
      mockNetworkInfo,
    );

    // 모의 객체 상호작용 초기화
    clearInteractions(mockUseCase);
    clearInteractions(mockLocalDataSource);
    clearInteractions(mockNetworkInfo);
  });

  group('초기화 테스트', () {
    test('초기 상태는 로딩 상태여야 합니다', () {
      // 새 ViewModel 인스턴스를 생성하여 초기 상태 테스트
      final newViewModel = AirQualityViewModel(
        mockUseCase,
        mockLocalDataSource,
        mockNetworkInfo,
      );

      // assert
      expect(newViewModel.state.airQuality.isLoading, true);
      expect(newViewModel.state.selectedSido, '서울'); // 첫 번째 시도가 선택되어 있어야 함
    });
  });

  group('fetchAirQuality', () {
    test('성공적으로 대기질 데이터를 가져오면 상태가 업데이트되어야 함', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDataSource.getAirQualityData(testSido))
          .thenAnswer((_) async => null);
      when(mockUseCase.execute(
        sidoName: testSido,
        pageNo: 1,
        numOfRows: 100,
      )).thenAnswer((_) async => testAirQualityResponse);

      // act
      await viewModel.fetchAirQuality(testSido);

      // assert
      expect(viewModel.state.airQuality.hasValue, true);
      expect(viewModel.state.airQuality.value, testAirQualityResponse);
      expect(viewModel.state.selectedSido, testSido);
      expect(viewModel.state.lastUpdated, isNotNull);
      expect(viewModel.state.isRefreshing, false);
    });

    test('네트워크 연결이 없고 로컬 데이터가 있으면 로컬 데이터를 사용해야 함', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getAirQualityData(testSido))
          .thenAnswer((_) async => testAirQualityResponse);

      // viewModel이 useCase를 호출하지 않도록 명시적으로 설정
      reset(mockUseCase);

      // act
      await viewModel.fetchAirQuality(testSido);

      // assert
      expect(viewModel.state.airQuality.hasValue, true);
      expect(viewModel.state.airQuality.value, testAirQualityResponse);
      verify(mockLocalDataSource.getAirQualityData(testSido));
      verifyZeroInteractions(mockUseCase);
    });

    test('네트워크 연결이 없고 로컬 데이터도 없으면 오류가 발생해야 함', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getAirQualityData(testSido))
          .thenAnswer((_) async => null);

      // viewModel이 useCase를 호출하지 않도록 명시적으로 설정
      reset(mockUseCase);

      // act
      await viewModel.fetchAirQuality(testSido);

      // assert
      expect(viewModel.state.airQuality.hasError, true);
      verify(mockLocalDataSource.getAirQualityData(testSido));
      verifyZeroInteractions(mockUseCase);
    });

    test('API 에러가 발생하고 로컬 데이터가 있으면 로컬 데이터를 사용해야 함', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDataSource.getAirQualityData(testSido))
          .thenAnswer((_) async => testAirQualityResponse);
      when(mockUseCase.execute(
        sidoName: testSido,
        pageNo: 1,
        numOfRows: 100,
      )).thenThrow(Exception('API 에러'));

      // act
      await viewModel.fetchAirQuality(testSido);

      // assert
      expect(viewModel.state.airQuality.hasValue, true);
      expect(viewModel.state.airQuality.value, testAirQualityResponse);
      verify(mockUseCase.execute(
        sidoName: testSido,
        pageNo: 1,
        numOfRows: 100,
      ));
    });
  });

  group('updateSido', () {
    test('selectedSido가 업데이트되어야 하지만 데이터 로드는 하지 않아야 함', () async {
      // arrange - 모든 상호작용을 초기화
      clearInteractions(mockUseCase);
      clearInteractions(mockLocalDataSource);

      final newSido = '부산';

      // act
      viewModel.updateSido(newSido);

      // assert
      expect(viewModel.state.selectedSido, newSido);
      verifyNoMoreInteractions(mockUseCase);
    });

    test('이미 선택된 시도와 동일한 시도를 선택하면 상태가 변경되지 않아야 함', () async {
      // arrange - 모든 상호작용을 초기화
      clearInteractions(mockUseCase);
      clearInteractions(mockLocalDataSource);

      final initialState = viewModel.state;

      // act
      viewModel.updateSido(initialState.selectedSido);

      // assert
      expect(viewModel.state, initialState);
      verifyNoMoreInteractions(mockUseCase);
    });
  });

  group('lastUpdatedText', () {
    test('lastUpdated가 null이면 "갱신 중..."을 반환해야 함', () {
      // arrange - lastUpdated가 null인 경우를 테스트
      // ViewModel 생성자에서는 이미 데이터를 가져오는 작업이 진행되지만, 테스트할 때는 아직 업데이트되지 않았을 수 있음
      final initialViewModel = AirQualityViewModel(
        mockUseCase,
        mockLocalDataSource,
        mockNetworkInfo,
      );

      // 생성자에서 자동으로 초기화가 진행되므로 실제 앱에서는 lastUpdated가 null이 아닐 수 있음
      // 여기서는 초기 텍스트가 "갱신 중..."인지 확인
      expect(initialViewModel.lastUpdatedText, '갱신 중...');
    });

    test('lastUpdated가 1분 미만이면 "방금 전"을 반환해야 함', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDataSource.getAirQualityData(testSido))
          .thenAnswer((_) async => null);
      when(mockUseCase.execute(
        sidoName: testSido,
        pageNo: 1,
        numOfRows: 100,
      )).thenAnswer((_) async => testAirQualityResponse);

      // act
      await viewModel.fetchAirQuality(testSido);

      // assert
      expect(viewModel.lastUpdatedText, '방금 전');
    });
  });
}
