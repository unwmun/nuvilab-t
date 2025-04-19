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
import '../network/network_info.dart' as _i932;
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
  gh.singleton<_i361.Dio>(() => registerModule.dio);
  gh.factory<_i932.NetworkInfo>(() => _i932.NetworkInfoImpl());
  gh.factory<_i845.AirQualityApi>(() => _i845.AirQualityApi(gh<_i361.Dio>()));
  gh.factory<_i1051.AirQualityRepository>(() => _i779.AirQualityRepositoryImpl(
        gh<_i845.AirQualityApi>(),
        gh<_i493.AirQualityLocalDataSource>(),
        gh<_i932.NetworkInfo>(),
      ));
  gh.factory<_i460.GetAirQualityUseCase>(
      () => _i460.GetAirQualityUseCase(gh<_i1051.AirQualityRepository>()));
  return getIt;
}

class _$RegisterModule extends _i9.RegisterModule {}
