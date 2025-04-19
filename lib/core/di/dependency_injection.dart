import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasources/air_quality_api.dart';
import '../../data/datasources/air_quality_local_datasource.dart';
import '../../domain/repositories/air_quality_repository.dart';
import '../../domain/usecases/get_air_quality_usecase.dart';
import '../network/network_info.dart';
import '../network/retry_interceptor.dart';
import '../network/ssl_pinning.dart';
import '../security/debug_detector.dart';
import '../security/secure_storage.dart';
import '../services/api_retry_service.dart';
import '../services/crashlytics_service.dart';
import '../services/deep_link_service.dart';
import '../services/fcm_service.dart';
import '../services/performance_service.dart';
import '../services/route_service.dart';
import '../services/theme_service.dart';
import 'dependency_injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async {
  init(getIt);

  if (!getIt.isRegistered<SecureNetworkClient>()) {
    getIt.registerSingleton<SecureNetworkClient>(SecureNetworkClient());
  }
  if (!getIt.isRegistered<DebugDetector>()) {
    getIt.registerSingleton<DebugDetector>(DebugDetector());
  }

  if (!getIt.isRegistered<CrashlyticsService>()) {
    getIt.registerSingleton<CrashlyticsService>(CrashlyticsService());
  }

  if (!getIt.isRegistered<PerformanceService>()) {
    getIt.registerSingleton<PerformanceService>(PerformanceService());
  }

  if (!getIt.isRegistered<FCMService>()) {
    getIt.registerSingleton<FCMService>(FCMService());
  }

  if (!getIt.isRegistered<Dio>(instanceName: "secureClient")) {
    getIt.registerSingleton<Dio>(getIt<SecureNetworkClient>().client,
        instanceName: "secureClient");
  }

  if (!getIt.isRegistered<RouteService>()) {
    getIt.registerSingleton<RouteService>(
      RouteService(getIt<FCMService>()),
    );
  }

  if (!getIt.isRegistered<DeepLinkService>()) {
    getIt.registerSingleton<DeepLinkService>(
      DeepLinkService(getIt<RouteService>()),
    );
  }

  final debugDetector = getIt<DebugDetector>();
  debugDetector.enforceReleaseOnlyMode();

  final themeService = getIt<ThemeService>();
  await themeService.init();
}

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return getIt<SecureNetworkClient>().client;
    }

    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ));

    dio.interceptors.add(getIt<RetryInterceptor>());

    return dio;
  }
}

final dioProvider = Provider<Dio>((ref) => getIt<Dio>());

final airQualityApiProvider =
    Provider<AirQualityApi>((ref) => getIt<AirQualityApi>());

final airQualityLocalDataSourceProvider = Provider<AirQualityLocalDataSource>(
    (ref) => getIt<AirQualityLocalDataSource>());

final networkInfoProvider =
    Provider<NetworkInfo>((ref) => getIt<NetworkInfo>());

final apiRetryServiceProvider =
    Provider<ApiRetryService>((ref) => getIt<ApiRetryService>());

final retryInterceptorProvider =
    Provider<RetryInterceptor>((ref) => getIt<RetryInterceptor>());

final airQualityRepositoryProvider = Provider<AirQualityRepository>(
  (ref) => getIt<AirQualityRepository>(),
);

final getAirQualityUseCaseProvider = Provider<GetAirQualityUseCase>(
  (ref) => getIt<GetAirQualityUseCase>(),
);

final crashlyticsServiceProvider = Provider<CrashlyticsService>(
  (ref) => getIt<CrashlyticsService>(),
);

final performanceServiceProvider = Provider<PerformanceService>(
  (ref) => getIt<PerformanceService>(),
);

final fcmServiceProvider = Provider<FCMService>(
  (ref) => getIt<FCMService>(),
);

final routeServiceProvider = Provider<RouteService>(
  (ref) => getIt<RouteService>(),
);

final deepLinkServiceProvider = Provider<DeepLinkService>(
  (ref) => getIt<DeepLinkService>(),
);

final secureStorageProvider = Provider<SecureStorage>(
  (ref) => getIt<SecureStorage>(),
);

final debugDetectorProvider = Provider<DebugDetector>(
  (ref) => getIt<DebugDetector>(),
);

final secureNetworkClientProvider = Provider<SecureNetworkClient>(
  (ref) => getIt<SecureNetworkClient>(),
);
