import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/domain/repositories/air_quality_repository.dart';

class GetAirQualityUseCase {
  final AirQualityRepository _repository;

  GetAirQualityUseCase(this._repository);

  Future<AirQualityResponse> execute({
    required String sidoName,
    int pageNo = 1,
    int numOfRows = 100,
  }) {
    return _repository.getAirQualityBySido(
      sidoName: sidoName,
      pageNo: pageNo,
      numOfRows: numOfRows,
    );
  }
}
