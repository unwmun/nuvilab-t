import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nubilab/data/datasources/air_quality_api.dart';
import 'package:nubilab/data/repositories/air_quality_repository_impl.dart';
import 'package:nubilab/domain/repositories/air_quality_repository.dart';
import 'package:nubilab/domain/usecases/get_air_quality_usecase.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Core
  getIt.registerSingleton<Dio>(
    Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      // CORS 문제 해결을 위한 설정
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      validateStatus: (status) {
        return status != null && status < 500;
      },
    )),
  );

  // Data sources
  getIt.registerSingleton<AirQualityApi>(AirQualityApi(getIt<Dio>()));

  // Repositories
  getIt.registerSingleton<AirQualityRepository>(
    AirQualityRepositoryImpl(getIt<AirQualityApi>()),
  );

  // Usecases
  getIt.registerSingleton<GetAirQualityUseCase>(
    GetAirQualityUseCase(getIt<AirQualityRepository>()),
  );
}

// Riverpod 프로바이더
final dioProvider = Provider<Dio>((ref) => getIt<Dio>());

final airQualityApiProvider =
    Provider<AirQualityApi>((ref) => getIt<AirQualityApi>());

final airQualityRepositoryProvider = Provider<AirQualityRepository>(
  (ref) => getIt<AirQualityRepository>(),
);

final getAirQualityUseCaseProvider = Provider<GetAirQualityUseCase>(
  (ref) => getIt<GetAirQualityUseCase>(),
);
