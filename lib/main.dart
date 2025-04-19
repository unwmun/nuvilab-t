import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nubilab/core/constants/app_constants.dart';
import 'package:nubilab/core/di/dependency_injection.dart';
import 'package:nubilab/data/models/air_quality_hive_models.dart';
import 'package:nubilab/data/models/api_retry_task.dart';
import 'package:nubilab/data/models/theme_mode_hive_adapter.dart';
import 'package:nubilab/presentation/pages/home/home_page.dart';
import 'package:nubilab/presentation/viewmodels/theme_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  // Hive 초기화
  await Hive.initFlutter();

  // Hive 어댑터 등록
  Hive.registerAdapter(AirQualityCacheMetadataAdapter());
  Hive.registerAdapter(ApiRetryTaskAdapter());
  Hive.registerAdapter(ThemeModeAdapter());

  // 의존성 주입 설정
  await configureDependencies();

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

    return MaterialApp(
      title: AppConstants.appName,
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
