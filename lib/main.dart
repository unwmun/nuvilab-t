import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/di/dependency_injection.dart';
import 'core/security/debug_detector.dart';
import 'core/services/crashlytics_service.dart';
import 'core/services/deep_link_service.dart';
import 'core/services/fcm_service.dart';
import 'core/services/performance_service.dart';
import 'data/models/air_quality_hive_models.dart';
import 'data/models/api_retry_task.dart';
import 'data/models/theme_mode_hive_adapter.dart';
import 'firebase_options.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/viewmodels/theme_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase 초기화 성공');
  } catch (e) {
    debugPrint('Firebase 초기화 실패: $e');
  }

  await Hive.initFlutter();

  Hive.registerAdapter(AirQualityCacheMetadataAdapter());
  Hive.registerAdapter(ApiRetryTaskAdapter());
  Hive.registerAdapter(ThemeModeAdapter());

  await configureDependencies();

  try {
    await getIt<CrashlyticsService>().init();
    debugPrint('Crashlytics 초기화 성공');
  } catch (e) {
    debugPrint('Crashlytics 초기화 실패: $e');
  }

  if (kDebugMode) {
    final performanceService = getIt<PerformanceService>();
    performanceService.printDevToolsUsageGuide();
    performanceService.printPerformanceGuidelines();
  }

  try {
    await getIt<FCMService>().init();
    debugPrint('FCM 서비스 초기화 성공');
  } catch (e) {
    debugPrint('FCM 서비스 초기화 실패: $e');
  }

  try {
    await getIt<DeepLinkService>().init();
    debugPrint('딥링크 서비스 초기화 성공');
  } catch (e) {
    debugPrint('딥링크 서비스 초기화 실패: $e');
  }

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
