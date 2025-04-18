import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/presentation/viewmodels/air_quality_view_model.dart';
import 'package:nubilab/presentation/widgets/air_quality_item_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final airQualityState = ref.watch(airQualityViewModelProvider);
    final viewModel = ref.read(airQualityViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('대기질 정보'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                viewModel.fetchAirQuality(viewModel.selectedSidoName),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            // 서울, 부산, 대구, 인천, 광주, 대전, 울산, 경기, 강원, 충북, 충남, 전북, 전남, 경북, 경남, 제주, 세종
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: '서울', label: Text('서울')),
                ButtonSegment(value: '부산', label: Text('부산')),
                ButtonSegment(value: '대구', label: Text('대구')),
                ButtonSegment(value: '인천', label: Text('인천')),
                ButtonSegment(value: '광주', label: Text('광주')),
                ButtonSegment(value: '대전', label: Text('대전')),
                ButtonSegment(value: '울산', label: Text('울산')),
                ButtonSegment(value: '경기', label: Text('경기')),
                ButtonSegment(value: '강원', label: Text('강원')),
                ButtonSegment(value: '충북', label: Text('충북')),
                ButtonSegment(value: '충남', label: Text('충남')),
                ButtonSegment(value: '전북', label: Text('전북')),
                ButtonSegment(value: '전남', label: Text('전남')),
                ButtonSegment(value: '경북', label: Text('경북')),
                ButtonSegment(value: '경남', label: Text('경남')),
                ButtonSegment(value: '제주', label: Text('제주')),
                ButtonSegment(value: '세종', label: Text('세종')),
              ],
              selected: {viewModel.selectedSidoName},
              onSelectionChanged: (Set<String> selected) {
                final sidoName = selected.first;
                viewModel.setSelectedSidoName(sidoName);
                viewModel.fetchAirQuality(sidoName);
              },
              showSelectedIcon: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '마지막 갱신: ${viewModel.lastUpdatedText}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: airQualityState.when(
              data: (airQualityResponse) {
                final items = airQualityResponse.response.body.items;
                if (items.isEmpty) {
                  return const Center(
                    child: Text('데이터가 없습니다'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      viewModel.fetchAirQuality(viewModel.selectedSidoName),
                  child: ListView.builder(
                    itemCount: items.length,
                    padding: const EdgeInsets.only(bottom: 16),
                    itemBuilder: (context, index) {
                      return AirQualityItemCard(item: items[index]);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      '에러 발생: $error',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${stackTrace.toString().split('\n').first}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          viewModel.fetchAirQuality(viewModel.selectedSidoName),
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
