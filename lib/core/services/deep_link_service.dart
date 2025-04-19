import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:nubilab/core/services/route_service.dart';

/// URL 스킴을 통한 딥링크 처리를 담당하는 서비스
///
/// nlab:// 스킴을 사용하여 외부에서 앱을 실행하고 특정 화면으로 이동할 수 있습니다.
///
/// 예시:
/// - nlab://home - 홈 화면으로 이동
/// - nlab://settings - 설정 화면으로 이동
/// - nlab://changeSido?sido=서울 - 시도를 변경
@singleton
class DeepLinkService {
  final RouteService _routeService;
  final _appLinks = AppLinks();
  StreamSubscription? _linkSubscription;
  bool _isInitialized = false;

  DeepLinkService(this._routeService);

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // 앱이 완전히 종료된 상태에서 딥링크로 실행된 경우 처리
      final initialLink = await _appLinks.getInitialAppLink();
      if (initialLink != null) {
        debugPrint('초기 딥링크: $initialLink');
        _handleLink(initialLink);
      }

      // 앱이 백그라운드에 있는 상태에서 딥링크로 호출된 경우 처리
      _linkSubscription =
          _appLinks.uriLinkStream.listen(_handleLink, onError: (e) {
        debugPrint('딥링크 에러: $e');
      });

      _isInitialized = true;
    } catch (e) {
      debugPrint('딥링크 서비스 초기화 에러: $e');
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }

  void _handleLink(Uri? uri) {
    if (uri == null) return;

    try {
      // 스킴 확인 (nlab://)
      if (uri.scheme.toLowerCase() != 'nlab') {
        debugPrint('지원하지 않는 스킴: ${uri.scheme}');
        return;
      }

      // 호스트(path)는 이동할 화면 (home, settings, detail 등)
      // 대소문자 구분 없이 처리하기 위해 소문자로 변환
      String screen;

      if (uri.host.isNotEmpty) {
        screen = uri.host;
      } else if (uri.path.isNotEmpty) {
        // 첫 번째 슬래시(/) 제거
        screen = uri.path.startsWith('/') ? uri.path.substring(1) : uri.path;
      } else {
        debugPrint('잘못된 딥링크 형식: $uri');
        return;
      }

      // 화면 이름 표준화 (소문자로 통일)
      screen = screen.toLowerCase();

      // 화면 이름 매핑 (소문자 -> 정확한 화면 이름)
      final screenMapping = {
        'home': 'home',
        'settings': 'settings',
        'changesido': 'changeSido', // 소문자로 입력해도 정확한 화면으로 매핑
      };

      final normalizedScreen = screenMapping[screen] ?? screen;

      // 파라미터를 Map으로 변환
      final params = <String, dynamic>{
        'screen': normalizedScreen,
      };

      // 쿼리 파라미터가 있으면 추가
      uri.queryParameters.forEach((key, value) {
        params[key] = value;
      });

      debugPrint('딥링크 파라미터: $params');

      // 경로 처리
      _routeService.handleDeepLink(params);
    } catch (e) {
      debugPrint('딥링크 처리 에러: $e');
    }
  }

  /// 테스트용 딥링크 URL 생성
  String generateTestDeepLink(Map<String, dynamic> params) {
    final screen = params['screen'] as String;
    final queryParams = <String, String>{};

    // screen을 제외한 모든 파라미터를 쿼리 파라미터로 변환
    params.forEach((key, value) {
      if (key != 'screen' && value is String) {
        queryParams[key] = value;
      }
    });

    final uri = Uri(
      scheme: 'nlab',
      host: screen,
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    return uri.toString();
  }
}
