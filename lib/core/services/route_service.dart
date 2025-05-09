import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/air_quality.dart';
import '../../presentation/pages/detail/detail_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/settings/settings_page.dart';
import 'fcm_service.dart';

@singleton
class RouteService {
  final FCMService _fcmService;
  final ProviderContainer _providerContainer = ProviderContainer();

  final _sidoChangeController = StreamController<String>.broadcast();
  Stream<String> get sidoChangeStream => _sidoChangeController.stream;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  RouteService(this._fcmService) {
    _fcmService.deepLinkStream.listen(_handleDeepLink);
  }

  void dispose() {
    _providerContainer.dispose();
    _sidoChangeController.close();
  }

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

  Future<void> handleDeepLink(Map<String, dynamic> data) async {
    debugPrint('공개 딥링크 처리: $data');
    await _handleDeepLink(data);
  }

  void _navigateToHome() {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  void _navigateToSettings() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
  }

  void _changeSido(String sido) {
    debugPrint('시도 변경 실행: $sido');

    try {
      _navigateToHome();

      _sidoChangeController.add(sido);

      debugPrint('시도 변경 이벤트 발행 완료: $sido');
    } catch (e) {
      debugPrint('시도 변경 중 오류 발생: $e');
    }
  }

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
