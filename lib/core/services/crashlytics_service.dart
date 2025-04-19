import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Firebase Crashlytics를 관리하는 서비스
/// 크래시 리포트 수집 및 커스텀 에러 로깅을 처리합니다.
@singleton
class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Crashlytics 서비스 초기화
  Future<void> init() async {
    // 릴리즈 모드에서만 Crashlytics 활성화
    final enableCollection = !kDebugMode;

    // Crashlytics 수집 활성화/비활성화 설정
    await _crashlytics.setCrashlyticsCollectionEnabled(enableCollection);

    // Flutter 에러를 Crashlytics로 전송
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kDebugMode) {
        // 디버그 모드에서는 콘솔에 출력
        FlutterError.dumpErrorToConsole(details);
      } else {
        // 릴리즈 모드에서는 Crashlytics로 전송
        _crashlytics.recordFlutterError(details);
      }
    };

    // 비동기 에러도 처리하기 위한 구성
    PlatformDispatcher.instance.onError = (error, stack) {
      if (!kDebugMode) {
        _crashlytics.recordError(error, stack, fatal: true);
      }
      return true;
    };

    debugPrint('Crashlytics 초기화 완료. 수집 활성화: $enableCollection');
  }

  /// 사용자 식별자 설정
  Future<void> setUserIdentifier(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  /// 커스텀 키-값 로그 추가
  Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  /// 일반 로그 메시지 추가
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  /// 비치명적 에러 기록 (앱 크래시는 발생하지 않지만 로깅이 필요한 에러)
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stack,
      reason: reason,
      fatal: fatal,
    );
  }

  /// 특정 빌드/세션에 대한 테스트 크래시 발생
  /// 개발 중 Crashlytics가 제대로 작동하는지 테스트할 때 사용
  Future<void> sendTestCrash() async {
    if (!kDebugMode) {
      _crashlytics.crash();
    } else {
      debugPrint('디버그 모드에서는 테스트 크래시가 실행되지 않습니다.');
    }
  }
}
