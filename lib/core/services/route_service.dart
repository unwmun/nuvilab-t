import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:nubilab/core/di/dependency_injection.dart';
import 'package:nubilab/core/services/fcm_service.dart';
import 'package:nubilab/data/datasources/air_quality_api.dart';
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/presentation/pages/detail/detail_page.dart';
import 'package:nubilab/presentation/pages/home/home_page.dart';
import 'package:nubilab/presentation/pages/settings/settings_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/presentation/viewmodels/air_quality_view_model.dart';
import 'package:flutter/foundation.dart';

@singleton
class RouteService {
  final FCMService _fcmService;
  final AirQualityApi _airQualityApi;
  final ProviderContainer _providerContainer = ProviderContainer();

  // 글로벌 EventBus 역할을 할 스트림 컨트롤러
  final _sidoChangeController = StreamController<String>.broadcast();
  Stream<String> get sidoChangeStream => _sidoChangeController.stream;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  RouteService(this._fcmService, this._airQualityApi) {
    // 딥링크 리스너 설정
    _fcmService.deepLinkStream.listen(_handleDeepLink);
  }

  // 리소스 해제
  void dispose() {
    _providerContainer.dispose();
    _sidoChangeController.close();
  }

  // 딥링크 처리
  Future<void> _handleDeepLink(Map<String, dynamic> data) async {
    final screen = data['screen'] as String?;
    debugPrint('딥링크 처리: $data (화면: $screen)');

    if (screen == null) return;

    switch (screen) {
      case 'home':
        _navigateToHome();
        break;
      case 'settings':
        _navigateToSettings();
        break;
      case 'changeSido':
        final sido = data['sido'] as String?;
        debugPrint('시도 변경 시도: $sido');
        if (sido != null) {
          _changeSido(sido);
        } else {
          debugPrint('시도 변경 실패: sido 파라미터가 없습니다');
        }
        break;
      default:
        debugPrint('알 수 없는 화면 라우트: $screen');
    }
  }

  // 외부에서 딥링크 처리를 위한 공개 메서드
  Future<void> handleDeepLink(Map<String, dynamic> data) async {
    debugPrint('공개 딥링크 처리: $data');
    await _handleDeepLink(data);
  }

  // 홈 화면으로 이동
  void _navigateToHome() {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  // 설정 화면으로 이동
  void _navigateToSettings() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
  }

  // 시도 변경 처리
  void _changeSido(String sido) {
    debugPrint('시도 변경 실행: $sido');

    try {
      // 홈 화면으로 이동
      _navigateToHome();

      // 시도 변경 이벤트 발행
      _sidoChangeController.add(sido);

      debugPrint('시도 변경 이벤트 발행 완료: $sido');
    } catch (e) {
      debugPrint('시도 변경 중 오류 발생: $e');
    }
  }

  // 라우트 초기화
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
      case '/settings':
        return MaterialPageRoute(
          builder: (context) => const SettingsPage(),
        );
      case '/detail':
        final args = settings.arguments as Map<String, dynamic>?;
        final stationName = args?['stationName'] as String? ?? '알 수 없는 측정소';
        final item = args?['item'] as AirQualityItem?;

        return MaterialPageRoute(
          builder: (context) => DetailPage(
            stationName: stationName,
            item: item,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
    }
  }
}
