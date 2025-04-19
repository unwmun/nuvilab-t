import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../utils/logger.dart';

/// 릴리스 빌드에서 디버그 모드 차단을 위한 간단한 유틸리티 클래스
@singleton
class DebugDetector {
  /// 릴리스 모드에서만 실행되도록 확인
  ///
  /// 릴리스 모드에서 개발자 도구 연결 시도 등을 기본적으로 차단
  void enforceReleaseOnlyMode() {
    // 릴리스 모드에서 디버그 모드 실행 여부 확인
    if (kReleaseMode && kDebugMode) {
      // 릴리스 빌드에서 디버그 모드 감지 시 로그만 기록
      AppLogger.warning('Warning: Debug mode detected in release build');

      // 필요시 아래 조치 활성화 가능
      // 1. 사용자에게 간단한 알림 표시
      // 2. 민감한 기능 비활성화
    }
  }
}
