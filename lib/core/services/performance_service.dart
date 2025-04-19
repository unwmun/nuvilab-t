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
}
