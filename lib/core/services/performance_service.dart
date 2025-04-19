import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

/// 앱 성능 최적화 및 모니터링을 위한 서비스
/// - 메모리 사용량 추적
/// - 렌더링 성능 모니터링
/// - 개발 중 성능 병목 지점 파악
@singleton
class PerformanceService {
  // 활성화된 Timeline 이벤트 추적 여부
  bool _isTimelineTracingActive = false;

  /// Timeline 성능 추적 활성화/비활성화
  /// 활성화 시 DevTools의 Timeline 탭에서 성능 데이터를 볼 수 있음
  void toggleTimelineTracing() {
    _isTimelineTracingActive = !_isTimelineTracingActive;
    debugPrint('Timeline 추적 ${_isTimelineTracingActive ? '활성화' : '비활성화'}됨');
  }

  /// 특정 작업에 대한 Timeline 이벤트 추적
  /// [name]: 추적할 작업의 이름
  /// [callback]: 추적할 작업을 수행하는 콜백 함수
  Future<T> traceAction<T>(String name, Future<T> Function() callback) async {
    try {
      developer.Timeline.startSync(name);
      return await callback();
    } finally {
      developer.Timeline.finishSync();
    }
  }

  /// 복잡한 위젯의 빌드 성능 측정을 위한 래퍼
  /// 이 함수로 감싼 위젯은 DevTools의 Performance 탭에서 추적 가능
  Widget trackBuildPerformance(String widgetName, Widget child) {
    if (kReleaseMode) return child;

    return LayoutBuilder(
      builder: (context, constraints) {
        developer.Timeline.startSync('Build: $widgetName');
        final result = child;
        developer.Timeline.finishSync();
        return result;
      },
    );
  }

  /// 메모리 누수 디버깅용 로그 출력
  /// 위젯의 dispose 메서드에서 호출하여 객체 소멸 확인
  void logDispose(String className) {
    if (kDebugMode) {
      debugPrint('🗑️ $className disposed');
    }
  }

  /// 메모리 사용량 로깅
  /// DevTools에서 확인 가능한 메모리 사용량 정보 출력
  void logMemoryUsage() {
    if (kDebugMode) {
      final memoryInfo = developer.Service.getInfo();
      debugPrint('📊 메모리 사용 정보: $memoryInfo');
    }
  }

  /// 특정 코드 블록의 실행 시간 측정
  /// [name]: 측정할 작업의 이름
  /// [action]: 측정할 작업을 수행하는 콜백 함수
  Future<T> measureExecutionTime<T>(
      String name, Future<T> Function() action) async {
    if (!kDebugMode) return action();

    final stopwatch = Stopwatch()..start();
    try {
      return await action();
    } finally {
      stopwatch.stop();
      debugPrint('⏱️ $name 실행 시간: ${stopwatch.elapsedMilliseconds}ms');
    }
  }

  /// 앱 성능 개선을 위한 가이드라인 출력
  void printPerformanceGuidelines() {
    if (!kDebugMode) return;

    debugPrint('''
======== 성능 최적화 체크리스트 ========
1. 불필요한 빌드 방지: const 생성자 사용, setState 최소화
2. 이미지 최적화: 적절한 크기로 리사이징, 캐싱 활용
3. 무거운 연산은 백그라운드에서 처리: compute() 함수 활용
4. 애니메이션 최적화: RepaintBoundary 사용
5. 리스트 최적화: ListView.builder 사용
6. 메모리 누수 방지: Stream/Controller 해제 확인
7. 코드 스플리팅: 필요한 기능만 로딩
8. 네트워크 요청 최적화: 캐싱, 요청 병합
========================================
''');
  }

  /// DevTools 사용 가이드 출력
  void printDevToolsUsageGuide() {
    if (!kDebugMode) return;

    debugPrint('''
======== DevTools 활용 가이드 ========
1. Performance 탭: 프레임 드롭, UI 렌더링 성능 확인
2. Memory 탭: 메모리 누수, 객체 할당 확인
3. CPU Profiler: 병목 현상 찾기
4. Network 탭: API 요청 지연 확인
5. Logging: 디버그 메시지 및 예외 확인
====================================
''');
  }
}
