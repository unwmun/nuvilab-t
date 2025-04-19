import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:nubilab/core/network/network_info.dart';
import 'package:nubilab/core/network/retry_interceptor.dart';
import 'package:nubilab/core/services/api_retry_service.dart';
import 'package:nubilab/data/datasources/air_quality_api.dart';
import 'package:nubilab/data/datasources/air_quality_local_datasource.dart';
import 'package:nubilab/domain/repositories/air_quality_repository.dart';
import 'package:nubilab/domain/usecases/get_air_quality_usecase.dart';
import 'dependency_injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // $initGetIt 대신 사용할 이름
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async {
  init(getIt);
}

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio {
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
