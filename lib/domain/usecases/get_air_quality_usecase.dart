import 'package:injectable/injectable.dart';
import '../../data/models/air_quality.dart';
import '../repositories/air_quality_repository.dart';

@injectable
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
