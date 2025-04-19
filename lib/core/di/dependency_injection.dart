import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:nubilab/core/network/network_info.dart';
import 'package:nubilab/core/network/retry_interceptor.dart';
import 'package:nubilab/core/security/debug_detector.dart';
import 'package:nubilab/core/security/secure_storage.dart';
import 'package:nubilab/core/network/ssl_pinning.dart';
import 'package:nubilab/core/services/api_retry_service.dart';
import 'package:nubilab/core/services/crashlytics_service.dart';
import 'package:nubilab/core/services/fcm_service.dart';
import 'package:nubilab/core/services/performance_service.dart';
import 'package:nubilab/core/services/route_service.dart';
import 'package:nubilab/data/datasources/air_quality_api.dart';
import 'package:nubilab/data/datasources/air_quality_local_datasource.dart';
import 'package:nubilab/domain/repositories/air_quality_repository.dart';
import 'package:nubilab/domain/usecases/get_air_quality_usecase.dart';
import 'dependency_injection.config.dart';
import 'package:nubilab/core/services/theme_service.dart';
import 'package:nubilab/core/services/deep_link_service.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // getIt.init() 대신 getIt.$init()을 사용하기 위한 이름 변경
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async {
  // config.dart 파일에 생성된 init 함수 호출
  init(getIt);

  // 보안 클래스 등록 - SecureStorage는 이미 등록되어 있으므로 다시 등록하지 않음
  if (!getIt.isRegistered<SecureNetworkClient>()) {
    getIt.registerSingleton<SecureNetworkClient>(SecureNetworkClient());
  }
  if (!getIt.isRegistered<DebugDetector>()) {
    getIt.registerSingleton<DebugDetector>(DebugDetector());
  }

  // Crashlytics 서비스 등록
  if (!getIt.isRegistered<CrashlyticsService>()) {
    getIt.registerSingleton<CrashlyticsService>(CrashlyticsService());
  }

  // 성능 모니터링 서비스 등록
  if (!getIt.isRegistered<PerformanceService>()) {
    getIt.registerSingleton<PerformanceService>(PerformanceService());
  }

  // FCM 서비스 등록
  if (!getIt.isRegistered<FCMService>()) {
    getIt.registerSingleton<FCMService>(FCMService());
  }

  // 보안 통신용 Dio 인스턴스 등록 (AirQualityApi에서 사용)
  if (!getIt.isRegistered<Dio>(instanceName: "secureClient")) {
    getIt.registerSingleton<Dio>(getIt<SecureNetworkClient>().client,
        instanceName: "secureClient");
  }

  // RouteService 등록 (FCM 서비스와 AirQualityApi에 의존)
  if (!getIt.isRegistered<RouteService>()) {
    getIt.registerSingleton<RouteService>(
      RouteService(getIt<FCMService>(), getIt<AirQualityApi>()),
    );
  }

  // DeepLinkService 등록 (RouteService에 의존)
  if (!getIt.isRegistered<DeepLinkService>()) {
    getIt.registerSingleton<DeepLinkService>(
      DeepLinkService(getIt<RouteService>()),
    );
  }

  // 보안 확인 진행
  final debugDetector = getIt<DebugDetector>();
  debugDetector.enforceReleaseOnlyMode();

  // ThemeService 초기화
  final themeService = getIt<ThemeService>();
  await themeService.init();
}

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio {
    // 보안 설정이 적용된 Dio 클라이언트 사용 (프로덕션 환경)
    if (const bool.fromEnvironment('dart.vm.product')) {
      return getIt<SecureNetworkClient>().client;
    }

    // 개발 환경용 Dio 설정
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

    // 재시도 인터셉터 등록
    dio.interceptors.add(getIt<RetryInterceptor>());

    return dio;
  }
}

// Riverpod 프로바이더
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

// Crashlytics 서비스 프로바이더
final crashlyticsServiceProvider = Provider<CrashlyticsService>(
  (ref) => getIt<CrashlyticsService>(),
);

// 성능 모니터링 서비스 프로바이더
final performanceServiceProvider = Provider<PerformanceService>(
  (ref) => getIt<PerformanceService>(),
);

// FCM 서비스 프로바이더
final fcmServiceProvider = Provider<FCMService>(
  (ref) => getIt<FCMService>(),
);

// 라우트 서비스 프로바이더
final routeServiceProvider = Provider<RouteService>(
  (ref) => getIt<RouteService>(),
);

// 딥링크 서비스 프로바이더
final deepLinkServiceProvider = Provider<DeepLinkService>(
  (ref) => getIt<DeepLinkService>(),
);

// 보안 관련 프로바이더
final secureStorageProvider = Provider<SecureStorage>(
  (ref) => getIt<SecureStorage>(),
);

final debugDetectorProvider = Provider<DebugDetector>(
  (ref) => getIt<DebugDetector>(),
);

final secureNetworkClientProvider = Provider<SecureNetworkClient>(
  (ref) => getIt<SecureNetworkClient>(),
);
