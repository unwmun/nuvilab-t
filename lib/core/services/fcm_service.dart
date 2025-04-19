import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import '../../firebase_options.dart';

// iOS 시뮬레이터 여부 확인
bool get _isIosSimulator {
  return Platform.isIOS &&
      !const bool.fromEnvironment('dart.vm.product') &&
      defaultTargetPlatform == TargetPlatform.iOS;
}

// 백그라운드 메시지 핸들러
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 백그라운드 핸들러에서는 Firebase가 초기화되지 않았을 수 있으므로 초기화 유지
  // 하지만 이미 초기화된 경우 자동으로 무시됨
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('백그라운드 메시지 수신: ${message.messageId}');
}

@singleton
class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 딥링크 핸들링을 위한 컨트롤러 (스트림)
  final _deepLinkController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get deepLinkStream => _deepLinkController.stream;

  NotificationDetails? _platformChannelSpecifics;

  // 시뮬레이터 모드에서 사용할 가상 토큰
  final String _simulatorToken =
      'simulator-fcm-token-${DateTime.now().millisecondsSinceEpoch}';

  Future<void> init() async {
    try {
      // iOS 시뮬레이터에서는 FCM 관련 작업 생략 또는 모의 처리
      if (_isIosSimulator) {
        debugPrint('iOS 시뮬레이터에서 실행 중입니다. FCM 기능이 제한됩니다.');
        // 로컬 알림 설정만 진행
        await _setupLocalNotifications();
        return;
      }

      // 백그라운드 핸들러 등록 (가장 먼저 설정)
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // 로컬 알림 설정 (iOS에서 FCM 사용 전에 필요)
      await _setupLocalNotifications();

      // 알림 권한 요청
      await _requestPermission();

      // APNS 토큰이 준비되었는지 확인 (iOS)
      if (Platform.isIOS) {
        // APNS 토큰이 준비될 때까지 기다림
        await _waitForAPNSToken();
      }

      // FCM 토큰 얻기
      final token = await _firebaseMessaging.getToken();
      debugPrint('FCM 토큰: $token');

      // 포그라운드 메시지 핸들링
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // 알림 탭 핸들링
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // 앱이 종료된 상태에서 알림을 통해 시작된 경우 처리
      final initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        _handleInitialMessage(initialMessage);
      }
    } catch (e, stackTrace) {
      debugPrint('FCM 초기화 오류: $e');
      debugPrint('스택 트레이스: $stackTrace');
    }
  }

  // iOS에서 APNS 토큰을 기다리는 함수
  Future<void> _waitForAPNSToken() async {
    if (!Platform.isIOS) return;

    // iOS 시뮬레이터에서는 실제 APNS 토큰을 얻을 수 없으므로 처리 생략
    if (_isIosSimulator) {
      debugPrint('iOS 시뮬레이터에서는 실제 APNS 토큰을 얻을 수 없습니다.');
      return;
    }

    // 최대 5번 시도, 각 시도마다 1초 대기
    for (int i = 0; i < 5; i++) {
      final apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken != null) {
        debugPrint('APNS 토큰 준비됨: $apnsToken');
        return;
      }
      debugPrint('APNS 토큰 아직 준비되지 않음, ${i + 1}번째 시도 (최대 5회)');
      await Future.delayed(const Duration(seconds: 1));
    }
    debugPrint('APNS 토큰을 얻지 못했지만, 계속 진행합니다.');
  }

  // 알림 권한 요청
  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true, // 프로비저닝 권한 사용 (사용자에게 덜 방해됨)
      sound: true,
    );

    debugPrint('사용자 알림 권한 상태: ${settings.authorizationStatus}');
  }

  // 로컬 알림 설정
  Future<void> _setupLocalNotifications() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
      );

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      );

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'nubilab_notification_channel',
        'Nubilab 알림',
        channelDescription: 'Nubilab 앱의 알림을 표시합니다',
        importance: Importance.max,
        priority: Priority.high,
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      _platformChannelSpecifics = const NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );
    } catch (e) {
      debugPrint('로컬 알림 설정 오류: $e');
    }
  }

  // 포그라운드 메시지 처리
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('포그라운드 메시지 수신: ${message.messageId}');

    // 알림 데이터 추출
    String title = message.notification?.title ?? '새로운 알림';
    String body = message.notification?.body ?? '';
    Map<String, dynamic> data = message.data;

    // 로컬 알림 표시
    await _showLocalNotification(title, body, data);
  }

  // 메시지 탭 시 처리 (앱이 백그라운드에 있는 경우)
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('알림 터치 (백그라운드): ${message.messageId}');
    processDeepLink(message.data);
  }

  // 앱이 종료된 상태에서 알림을 통해 시작된 경우 처리
  void _handleInitialMessage(RemoteMessage message) {
    debugPrint('초기 메시지 (앱이 종료된 상태): ${message.messageId}');
    processDeepLink(message.data);
  }

  // 로컬 알림 표시
  Future<void> _showLocalNotification(
      String title, String body, Map<String, dynamic> data) async {
    try {
      if (_platformChannelSpecifics == null) {
        debugPrint('알림 채널이 초기화되지 않았습니다');
        return;
      }

      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        _platformChannelSpecifics,
        payload: json.encode(data),
      );
    } catch (e) {
      debugPrint('로컬 알림 표시 오류: $e');
    }
  }

  // iOS 로컬 알림 처리 (iOS 10 미만)
  void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    debugPrint('iOS 로컬 알림 수신: $id');
  }

  // 알림 탭 처리 (로컬 알림)
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    final String? payload = response.payload;

    if (payload != null) {
      debugPrint('로컬 알림 페이로드: $payload');
      try {
        final data = json.decode(payload) as Map<String, dynamic>;
        processDeepLink(data);
      } catch (e) {
        debugPrint('페이로드 파싱 오류: $e');
      }
    }
  }

  // 딥링크 데이터 처리
  void processDeepLink(Map<String, dynamic> data) {
    debugPrint('딥링크 데이터 처리: $data');
    _deepLinkController.add(data);
  }

  // FCM 토큰 갱신
  Future<String?> getToken() async {
    try {
      // iOS 시뮬레이터는 FCM 토큰을 지원하지 않으므로 가상 토큰 반환
      if (_isIosSimulator) {
        return _simulatorToken;
      }
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('FCM 토큰 획득 오류: $e');
      if (_isIosSimulator) {
        return _simulatorToken;
      }
      return null;
    }
  }

  // iOS APNS 토큰 가져오기
  Future<String?> getAPNSToken() async {
    if (!Platform.isIOS) return null;

    // iOS 시뮬레이터에서는 가상 APNS 토큰 제공
    if (_isIosSimulator) {
      return 'simulator-apns-token';
    }

    try {
      return await _firebaseMessaging.getAPNSToken();
    } catch (e) {
      debugPrint('APNS 토큰 획득 오류: $e');
      return null;
    }
  }

  // 구독
  Future<void> subscribeToTopic(String topic) async {
    // 시뮬레이터에서는 무시
    if (_isIosSimulator) {
      debugPrint('시뮬레이터에서는 토픽 구독이 지원되지 않습니다: $topic');
      return;
    }

    try {
      await _firebaseMessaging.subscribeToTopic(topic);
    } catch (e) {
      debugPrint('토픽 구독 오류: $e');
    }
  }

  // 구독 해제
  Future<void> unsubscribeFromTopic(String topic) async {
    // 시뮬레이터에서는 무시
    if (_isIosSimulator) {
      debugPrint('시뮬레이터에서는 토픽 구독 해제가 지원되지 않습니다: $topic');
      return;
    }

    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
    } catch (e) {
      debugPrint('토픽 구독 해제 오류: $e');
    }
  }

  // 서비스 해제
  void dispose() {
    _deepLinkController.close();
  }

  // 수동으로 알림 표시 (테스트용)
  Future<void> showTestNotification() async {
    try {
      await _showLocalNotification(
        '테스트 알림',
        '이것은 테스트 알림입니다',
        {'screen': 'detail', 'id': '123'},
      );
    } catch (e) {
      debugPrint('테스트 알림 전송 오류: $e');
    }
  }
}
