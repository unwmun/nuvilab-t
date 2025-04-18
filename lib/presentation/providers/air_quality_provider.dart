import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/data/datasources/air_quality_api.dart';
import 'package:nubilab/domain/entities/air_quality.dart';

class AirQualityState {
  final List<AirQuality> airQualities;
  final bool isLoading;
  final String? error;
  final bool hasReachedMax;
  final int totalCount;

  AirQualityState({
    this.airQualities = const [],
    this.isLoading = false,
    this.error,
    this.hasReachedMax = false,
    this.totalCount = 0,
  });

  AirQualityState copyWith({
    List<AirQuality>? airQualities,
    bool? isLoading,
    String? error,
    bool? hasReachedMax,
    int? totalCount,
  }) {
    return AirQualityState(
      airQualities: airQualities ?? this.airQualities,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class AirQualityNotifier extends StateNotifier<AirQualityState> {
  final AirQualityApi _airQualityApi;

  AirQualityNotifier(this._airQualityApi) : super(AirQualityState());

  Future<void> getAirQuality({
    required String sidoName,
    required int pageNo,
    required int numOfRows,
    bool isLoadMore = false,
  }) async {
    if (!isLoadMore) {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );
    }

    try {
      final result = await _airQualityApi.getCtprvnRltmMesureDnsty(
        sidoName: sidoName,
        pageNo: pageNo,
        numOfRows: numOfRows,
      );

      final totalCount = result.totalCount;
      final items = result.items;
      final hasReachedMax =
          items.length < numOfRows || (pageNo * numOfRows) >= totalCount;

      if (isLoadMore) {
        state = state.copyWith(
          airQualities: [...state.airQualities, ...items],
          isLoading: false,
          hasReachedMax: hasReachedMax,
          totalCount: totalCount,
        );
      } else {
        state = state.copyWith(
          airQualities: items,
          isLoading: false,
          hasReachedMax: hasReachedMax,
          totalCount: totalCount,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final airQualityProvider =
    StateNotifierProvider<AirQualityNotifier, AirQualityState>((ref) {
  final airQualityApi = AirQualityApi();
  return AirQualityNotifier(airQualityApi);
});
