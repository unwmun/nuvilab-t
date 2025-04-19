import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import '../../firebase_options.dart';

bool get _isIosSimulator {
  return Platform.isIOS &&
      !const bool.fromEnvironment('dart.vm.product') &&
      defaultTargetPlatform == TargetPlatform.iOS;
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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

  final _deepLinkController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get deepLinkStream => _deepLinkController.stream;

  NotificationDetails? _platformChannelSpecifics;

  final String _simulatorToken =
      'simulator-fcm-token-${DateTime.now().millisecondsSinceEpoch}';

  Future<void> init() async {
    try {
      if (_isIosSimulator) {
        debugPrint('iOS 시뮬레이터에서 실행 중입니다. FCM 기능이 제한됩니다.');
        await _setupLocalNotifications();
        return;
      }

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      await _setupLocalNotifications();

      await _requestPermission();

      if (Platform.isIOS) {
        await _waitForAPNSToken();
      }

      final token = await _firebaseMessaging.getToken();
      debugPrint('FCM 토큰: $token');

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

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

  Future<void> _waitForAPNSToken() async {
    if (!Platform.isIOS) return;

    if (_isIosSimulator) {
      debugPrint('iOS 시뮬레이터에서는 실제 APNS 토큰을 얻을 수 없습니다.');
      return;
    }

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

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    debugPrint('사용자 알림 권한 상태: ${settings.authorizationStatus}');
  }

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

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('포그라운드 메시지 수신: ${message.messageId}');

    String title = message.notification?.title ?? '새로운 알림';
    String body = message.notification?.body ?? '';
    Map<String, dynamic> data = message.data;

    await _showLocalNotification(title, body, data);
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('알림 터치 (백그라운드): ${message.messageId}');
    processDeepLink(message.data);
  }

  void _handleInitialMessage(RemoteMessage message) {
    debugPrint('초기 메시지 (앱이 종료된 상태): ${message.messageId}');
    processDeepLink(message.data);
  }

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

  void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    debugPrint('iOS 로컬 알림 수신: $id');
  }

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

  void processDeepLink(Map<String, dynamic> data) {
    try {
      debugPrint('딥링크 데이터 처리: $data');
      _deepLinkController.add(data);
    } catch (e) {
      debugPrint('딥링크 처리 오류: $e');
    }
  }

  Future<String?> getToken() async {
    if (_isIosSimulator) {
      debugPrint('iOS 시뮬레이터에서는 실제 FCM 토큰을 얻을 수 없습니다. 가상 토큰을 반환합니다.');
      return _simulatorToken;
    }

    try {
      final token = await _firebaseMessaging.getToken();
      debugPrint('FCM 토큰: $token');
      return token;
    } catch (e) {
      debugPrint('FCM 토큰 가져오기 오류: $e');
      return null;
    }
  }

  Future<String?> getAPNSToken() async {
    if (!Platform.isIOS) return null;

    if (_isIosSimulator) {
      return 'simulator-apns-token-${DateTime.now().millisecondsSinceEpoch}';
    }

    try {
      final token = await _firebaseMessaging.getAPNSToken();
      debugPrint('APNS 토큰: $token');
      return token;
    } catch (e) {
      debugPrint('APNS 토큰 가져오기 오류: $e');
      return null;
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    if (_isIosSimulator) {
      debugPrint('iOS 시뮬레이터에서는 토픽 구독이 지원되지 않습니다.');
      return;
    }

    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('토픽 구독 성공: $topic');
    } catch (e) {
      debugPrint('토픽 구독 오류: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    if (_isIosSimulator) {
      debugPrint('iOS 시뮬레이터에서는 토픽 구독 해제가 지원되지 않습니다.');
      return;
    }

    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('토픽 구독 해제 성공: $topic');
    } catch (e) {
      debugPrint('토픽 구독 해제 오류: $e');
    }
  }

  void dispose() {
    _deepLinkController.close();
  }

  Future<void> showTestNotification() async {
    await _showLocalNotification(
      '테스트 알림',
      '이것은 테스트 알림입니다.',
      {
        'screen': 'home',
        'action': 'test',
      },
    );
  }
}
