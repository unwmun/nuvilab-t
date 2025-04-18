import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/core/di/dependency_injection.dart';
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/domain/usecases/get_air_quality_usecase.dart';

// 대기질 정보의 상태를 표현하는 클래스
class AirQualityState {
  final List<AirQualityItem> items;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final bool canLoadMore;
  final int currentPage;

  AirQualityState({
    required this.items,
    required this.isLoading,
    required this.hasError,
    this.errorMessage,
    required this.canLoadMore,
    required this.currentPage,
  });

  // 초기 상태
  factory AirQualityState.initial() => AirQualityState(
        items: [],
        isLoading: true,
        hasError: false,
        canLoadMore: true,
        currentPage: 1,
      );

  // 상태 복제
  AirQualityState copyWith({
    List<AirQualityItem>? items,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    bool? canLoadMore,
    int? currentPage,
  }) {
    return AirQualityState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

final airQualityViewModelProvider =
    StateNotifierProvider<AirQualityViewModel, AirQualityState>((ref) {
  final getAirQualityUseCase = ref.read(getAirQualityUseCaseProvider);
  return AirQualityViewModel(getAirQualityUseCase);
});

// 저장소 프로바이더는 실제 의존성 주입 설정에서 제공되어야 합니다.
final airQualityRepositoryProvider =
    Provider((ref) => throw UnimplementedError());

class AirQualityViewModel extends StateNotifier<AirQualityState> {
  final GetAirQualityUseCase _getAirQualityUseCase;
  static const int _itemsPerPage = 10;

  AirQualityViewModel(this._getAirQualityUseCase)
      : super(AirQualityState.initial()) {
    fetchAirQuality('서울');
  }

  // 대기질 정보 초기 로드
  Future<void> fetchAirQuality(String sidoName) async {
    state = AirQualityState.initial();

    try {
      final result = await _getAirQualityUseCase.execute(
        sidoName: sidoName,
        pageNo: 1,
        numOfRows: _itemsPerPage,
      );

      final totalItems = result.response.body.totalCount;
      final items = result.response.body.items;

      state = state.copyWith(
        items: items,
        isLoading: false,
        hasError: false,
        canLoadMore: items.length < totalItems,
        currentPage: 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }

  // 더 많은 데이터 로드 (무한 스크롤)
  Future<void> loadMore(String sidoName) async {
    // 이미 로딩 중이거나 더 로드할 데이터가 없으면 무시
    if (state.isLoading || !state.canLoadMore) {
      return;
    }

    state = state.copyWith(isLoading: true);
    final nextPage = state.currentPage + 1;

    try {
      final result = await _getAirQualityUseCase.execute(
        sidoName: sidoName,
        pageNo: nextPage,
        numOfRows: _itemsPerPage,
      );

      final totalItems = result.response.body.totalCount;
      final newItems = result.response.body.items;
      final allItems = [...state.items, ...newItems];

      state = state.copyWith(
        items: allItems,
        isLoading: false,
        currentPage: nextPage,
        canLoadMore: allItems.length < totalItems,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }

  // 데이터 새로고침
  Future<void> refresh(String sidoName) async {
    fetchAirQuality(sidoName);
  }
}
