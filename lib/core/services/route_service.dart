import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:nubilab/core/services/fcm_service.dart';
import 'package:nubilab/data/datasources/air_quality_api.dart';
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/presentation/pages/detail/detail_page.dart';
import 'package:nubilab/presentation/pages/home/home_page.dart';
import 'package:nubilab/presentation/pages/settings/settings_page.dart';

@singleton
class RouteService {
  final FCMService _fcmService;
  final AirQualityApi _airQualityApi;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  RouteService(this._fcmService, this._airQualityApi) {
    // 딥링크 리스너 설정
    _fcmService.deepLinkStream.listen(_handleDeepLink);
  }

  // 딥링크 처리
  Future<void> _handleDeepLink(Map<String, dynamic> data) async {
    final screen = data['screen'] as String?;

    if (screen == null) return;

    switch (screen) {
      case 'home':
        _navigateToHome();
        break;
      case 'settings':
        _navigateToSettings();
        break;
      case 'detail':
        final stationName = data['stationName'] as String?;
        if (stationName != null) {
          await _navigateToDetail(stationName);
        }
        break;
      default:
        debugPrint('알 수 없는 화면 라우트: $screen');
    }
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

  // 상세 화면으로 이동
  Future<void> _navigateToDetail(String stationName) async {
    // 선택적으로 API에서 측정소 데이터 가져오기
    AirQualityItem? airQualityItem;

    try {
      // 실제 앱에서는 여기서 API로 해당 측정소의 최신 정보를 가져올 수 있습니다.
      // final response = await _airQualityApi.getAirQualityByStation(stationName);
      // airQualityItem = response.response.body.items.first;

      // 지금은 빈 데이터로 이동
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => DetailPage(
            stationName: stationName,
            item: airQualityItem,
          ),
        ),
      );
    } catch (e) {
      debugPrint('측정소 정보 가져오기 실패: $e');

      // 오류가 발생해도 측정소 이름으로만 페이지 이동
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => DetailPage(
            stationName: stationName,
          ),
        ),
      );
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
