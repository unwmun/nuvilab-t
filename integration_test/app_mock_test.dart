import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nubilab/data/datasources/air_quality_api.dart';
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/main.dart' as app;
import 'package:nubilab/core/constants/sido_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/core/di/dependency_injection.dart' as di;
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:dio/dio.dart' hide Response;

class MockAirQualityApi extends Mock implements AirQualityApi {
  @override
  Future<AirQualityResponse> getCtprvnRltmMesureDnsty({
    required String sidoName,
    int pageNo = 1,
    int numOfRows = 100,
    String returnType = 'json',
    String ver = '1.0',
  }) async {
    // 모의 응답 데이터 반환
    return AirQualityResponse(
      response: Response(
        body: Body(
          totalCount: 1,
          items: [
            AirQualityItem(
              so2Grade: '1',
              khaiValue: '50',
              so2Value: '0.003',
              coValue: '0.4',
              o3Grade: '1',
              pm10Value: '25',
              khaiGrade: '1',
              pm25Value: '15',
              sidoName: sidoName,
              no2Grade: '1',
              pm25Grade: '1',
              dataTime: '2023-05-01 14:00',
              coGrade: '1',
              no2Value: '0.015',
              stationName: '중구',
              pm10Grade: '1',
              o3Value: '0.035',
            ),
          ],
          pageNo: pageNo,
          numOfRows: numOfRows,
        ),
        header: Header(
          resultMsg: 'OK',
          resultCode: '00',
        ),
      ),
    );
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late AirQualityApi mockApi;

  setUp(() {
    // Mock API 설정
    mockApi = MockAirQualityApi();

    // 의존성 주입 오버라이드
    try {
      if (di.getIt.isRegistered<AirQualityApi>()) {
        di.getIt.unregister<AirQualityApi>();
      }
      di.getIt.registerSingleton<AirQualityApi>(mockApi);
    } catch (e) {
      print('의존성 주입 오류: $e');
    }
  });

  group('대기질 정보 앱 모의 통합 테스트', () {
    testWidgets('앱 실행 및 모의 데이터 표시 테스트', (WidgetTester tester) async {
      // 앱 실행
      app.main();
      await tester.pumpAndSettle();

      // 앱 제목이 표시되는지 확인
      expect(find.text('대기질 정보'), findsOneWidget);

      // 초기 시도가 표시되는지 확인
      expect(find.text(SidoList.sidoNames.first), findsOneWidget);

      // 데이터 로드 대기
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 모킹된 데이터가 표시되는지 확인
      expect(find.text('중구'), findsOneWidget);
      expect(find.text('미세먼지(PM10): 25 ㎍/㎥'), findsOneWidget);
      expect(find.text('초미세먼지(PM2.5): 15 ㎍/㎥'), findsOneWidget);
    });

    testWidgets('시도 변경 테스트 (모의 데이터)', (WidgetTester tester) async {
      // 앱 실행
      app.main();
      await tester.pumpAndSettle();

      // 데이터 로드 대기
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 시도 선택 드롭다운 메뉴 찾기
      final dropdown = find.byType(DropdownButton<String>);
      expect(dropdown, findsOneWidget);

      // 드롭다운 메뉴 탭하기
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // 다른 시도(부산) 선택하기
      await tester.tap(find.text('부산').last);
      await tester.pumpAndSettle();

      // 시도가 변경되었는지 확인
      expect(find.text('부산'), findsWidgets);

      // 데이터 로드 대기
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 모킹된 데이터가 부산으로 업데이트되었는지 확인 (sidoName은 변경되어야 함)
      expect(find.text('중구'), findsOneWidget); // 동일한 관측소 이름
      expect(find.text('미세먼지(PM10): 25 ㎍/㎥'), findsOneWidget);
      expect(find.text('초미세먼지(PM2.5): 15 ㎍/㎥'), findsOneWidget);
    });
  });
}
