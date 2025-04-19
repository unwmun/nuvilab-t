// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/datasources/air_quality_api.dart' as _i845;
import '../../data/datasources/air_quality_local_datasource.dart' as _i493;
import '../../data/repositories/air_quality_repository_impl.dart' as _i779;
import '../../domain/repositories/air_quality_repository.dart' as _i1051;
import '../../domain/usecases/get_air_quality_usecase.dart' as _i460;
import '../../presentation/viewmodels/auth_viewmodel.dart' as _i279;
import '../network/network_info.dart' as _i932;
import '../network/retry_interceptor.dart' as _i10;
import '../network/ssl_pinning.dart' as _i758;
import '../security/debug_detector.dart' as _i853;
import '../security/secure_storage.dart' as _i989;
import '../services/api_retry_service.dart' as _i132;
import '../services/theme_service.dart' as _i982;
import 'dependency_injection.dart' as _i9;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i493.AirQualityLocalDataSource>(
      () => _i493.AirQualityLocalDataSource());
  gh.singleton<_i989.SecureStorage>(() => _i989.SecureStorage());
  gh.singleton<_i758.SecureNetworkClient>(() => _i758.SecureNetworkClient());
  gh.singleton<_i853.DebugDetector>(() => _i853.DebugDetector());
  gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
  gh.lazySingleton<_i982.ThemeService>(() => _i982.ThemeService());
  gh.factory<_i279.AuthViewModel>(
      () => _i279.AuthViewModel(gh<_i989.SecureStorage>()));
  gh.factory<_i932.NetworkInfo>(() => _i932.NetworkInfoImpl());
  gh.factory<_i845.AirQualityApi>(
      () => _i845.AirQualityApi(gh<_i361.Dio>(instanceName: 'secureClient')));
  gh.singleton<_i132.ApiRetryService>(
      () => _i132.ApiRetryService(gh<_i932.NetworkInfo>()));
  gh.factory<_i1051.AirQualityRepository>(() => _i779.AirQualityRepositoryImpl(
        gh<_i845.AirQualityApi>(),
        gh<_i493.AirQualityLocalDataSource>(),
        gh<_i932.NetworkInfo>(),
      ));
  gh.singleton<_i10.RetryInterceptor>(
      () => _i10.RetryInterceptor(gh<_i132.ApiRetryService>()));
  gh.factory<_i460.GetAirQualityUseCase>(
      () => _i460.GetAirQualityUseCase(gh<_i1051.AirQualityRepository>()));
  return getIt;
}

class _$RegisterModule extends _i9.RegisterModule {}
