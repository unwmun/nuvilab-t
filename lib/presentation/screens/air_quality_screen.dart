import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/presentation/providers/air_quality_provider.dart';
import 'package:nubilab/presentation/widgets/air_quality_item_card.dart';
import 'package:nubilab/presentation/widgets/error_widget.dart';
import 'package:nubilab/presentation/widgets/loading_widget.dart';

class AirQualityScreen extends ConsumerStatefulWidget {
  const AirQualityScreen({super.key});

  @override
  ConsumerState<AirQualityScreen> createState() => _AirQualityScreenState();
}

class _AirQualityScreenState extends ConsumerState<AirQualityScreen> {
  final _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreData();
    }
  }

  Future<void> _loadInitialData() async {
    ref.read(airQualityProvider.notifier).getAirQuality(
          sidoName: '서울',
          pageNo: _currentPage,
          numOfRows: _itemsPerPage,
        );
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) return;

    final airQualityState = ref.read(airQualityProvider);

    // 더 이상 불러올 데이터가 없는 경우
    if (airQualityState.hasReachedMax) return;

    setState(() {
      _isLoading = true;
    });

    _currentPage++;

    await ref.read(airQualityProvider.notifier).getAirQuality(
          sidoName: '서울',
          pageNo: _currentPage,
          numOfRows: _itemsPerPage,
          isLoadMore: true,
        );

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      _currentPage = 1;
    });

    await ref.read(airQualityProvider.notifier).getAirQuality(
          sidoName: '서울',
          pageNo: _currentPage,
          numOfRows: _itemsPerPage,
        );
  }

  @override
  Widget build(BuildContext context) {
    final airQualityState = ref.watch(airQualityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('대기질 정보'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: airQualityState.isLoading && airQualityState.airQualities.isEmpty
          ? const LoadingWidget()
          : airQualityState.error != null
              ? CustomErrorWidget(
                  message: airQualityState.error!,
                  onRetry: _refreshData,
                )
              : RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: airQualityState.airQualities.length + 1,
                    itemBuilder: (context, index) {
                      if (index < airQualityState.airQualities.length) {
                        final airQuality = airQualityState.airQualities[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: AirQualityItemCard(airQuality: airQuality),
                        );
                      } else if (airQualityState.isLoading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (!airQualityState.hasReachedMax) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: TextButton(
                              onPressed: _loadMoreData,
                              child: const Text('더 보기'),
                            ),
                          ),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Text('데이터를 모두 불러왔습니다.'),
                          ),
                        );
                      }
                    },
                  ),
                ),
    );
  }
}
