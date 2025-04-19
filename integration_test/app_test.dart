import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nubilab/main.dart' as app;
import 'package:nubilab/core/constants/sido_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('대기질 정보 앱 통합 테스트', () {
    testWidgets('앱 실행 및 기본 화면 표시 테스트', (WidgetTester tester) async {
      // 앱 실행
      app.main();
      await tester.pumpAndSettle();

      // 앱 제목이 표시되는지 확인
      expect(find.text('대기질 정보'), findsOneWidget);

      // 초기 시도가 표시되는지 확인
      expect(find.text(SidoList.sidoNames.first), findsOneWidget);

      // 로딩 인디케이터가 표시되는지 확인
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // 데이터 로드 대기 (최대 10초)
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // 데이터가 로드된 후에는 로딩 인디케이터가 사라져야 함
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // 대기질 데이터 카드가 표시되는지 확인
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('시도 변경 테스트', (WidgetTester tester) async {
      // 앱 실행
      app.main();
      await tester.pumpAndSettle();

      // 데이터 로드 대기
      await tester.pumpAndSettle(const Duration(seconds: 10));

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
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // 대기질 데이터 카드가 표시되는지 확인
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('새로고침 기능 테스트', (WidgetTester tester) async {
      // 앱 실행
      app.main();
      await tester.pumpAndSettle();

      // 데이터 로드 대기
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // 새로고침 버튼 찾기
      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);

      // 새로고침 버튼 탭하기
      await tester.tap(refreshButton);
      await tester.pumpAndSettle();

      // 새로고침 중에는 로딩 인디케이터가 표시되어야 함
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // 데이터 로드 대기
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // 로딩이 완료되면 로딩 인디케이터가 사라져야 함
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // 대기질 데이터 카드가 표시되는지 확인
      expect(find.byType(Card), findsWidgets);
    });
  });
}
