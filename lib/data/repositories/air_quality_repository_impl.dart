import 'package:injectable/injectable.dart';
import 'package:nubilab/data/datasources/air_quality_api.dart';
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/domain/repositories/air_quality_repository.dart';

@Injectable(as: AirQualityRepository)
class AirQualityRepositoryImpl implements AirQualityRepository {
  final AirQualityApi _airQualityApi;

  AirQualityRepositoryImpl(this._airQualityApi);

  @override
  Future<AirQualityResponse> getAirQualityBySido({
    required String sidoName,
    int pageNo = 1,
    int numOfRows = 100,
  }) {
    return _airQualityApi.getCtprvnRltmMesureDnsty(
      sidoName: sidoName,
      pageNo: pageNo,
      numOfRows: numOfRows,
    );
  }
}
