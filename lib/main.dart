import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nubilab/core/constants/app_constants.dart';
import 'package:nubilab/core/di/dependency_injection.dart';
import 'package:nubilab/core/security/debug_detector.dart';
import 'package:nubilab/core/services/crashlytics_service.dart';
import 'package:nubilab/core/services/fcm_service.dart';
import 'package:nubilab/core/services/performance_service.dart';
import 'package:nubilab/core/services/route_service.dart';
import 'package:nubilab/data/models/air_quality_hive_models.dart';
import 'package:nubilab/data/models/api_retry_task.dart';
import 'package:nubilab/data/models/theme_mode_hive_adapter.dart';
import 'package:nubilab/firebase_options.dart';
import 'package:nubilab/presentation/pages/home/home_page.dart';
import 'package:nubilab/presentation/viewmodels/theme_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:nubilab/core/services/deep_link_service.dart';

void main() async {
  // Flutter 엔진 초기화 (반드시 가장 먼저 호출)
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  try {
    // Firebase 초기화 (FCM 서비스보다 먼저 초기화해야 함)
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase 초기화 성공');
  } catch (e) {
    // Firebase 초기화 실패해도 앱은 계속 실행되도록 함
    debugPrint('Firebase 초기화 실패: $e');
  }

  // Hive 초기화
  await Hive.initFlutter();

  // Hive 어댑터 등록
  Hive.registerAdapter(AirQualityCacheMetadataAdapter());
  Hive.registerAdapter(ApiRetryTaskAdapter());
  Hive.registerAdapter(ThemeModeAdapter());

  // 의존성 주입 설정
  await configureDependencies();

  try {
    // Crashlytics 초기화
    await getIt<CrashlyticsService>().init();
    debugPrint('Crashlytics 초기화 성공');
  } catch (e) {
    // Crashlytics 초기화 실패해도 앱은 계속 실행되도록 함
    debugPrint('Crashlytics 초기화 실패: $e');
  }

  // 디버그 모드에서 성능 모니터링 가이드 출력
  if (kDebugMode) {
    final performanceService = getIt<PerformanceService>();
    performanceService.printDevToolsUsageGuide();
    performanceService.printPerformanceGuidelines();
  }

  try {
    // FCM 서비스 초기화
    await getIt<FCMService>().init();
    debugPrint('FCM 서비스 초기화 성공');
  } catch (e) {
    // FCM 초기화 실패해도 앱은 계속 실행되도록 함
    debugPrint('FCM 서비스 초기화 실패: $e');
  }

  try {
    // 딥링크 서비스 초기화
    await getIt<DeepLinkService>().init();
    debugPrint('딥링크 서비스 초기화 성공');
  } catch (e) {
    // 딥링크 초기화 실패해도 앱은 계속 실행되도록 함
    debugPrint('딥링크 서비스 초기화 실패: $e');
  }

  // 릴리스 빌드에서 디버그 모드 차단
  if (const bool.fromEnvironment('dart.vm.product')) {
    final debugDetector = getIt<DebugDetector>();
    debugDetector.enforceReleaseOnlyMode();
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final routeService = ref.watch(routeServiceProvider);

    return MaterialApp(
      title: AppConstants.appName,
      navigatorKey: routeService.navigatorKey,
      onGenerateRoute: routeService.onGenerateRoute,
      themeMode: themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
