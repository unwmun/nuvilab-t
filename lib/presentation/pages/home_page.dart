import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/presentation/viewmodels/air_quality_view_model.dart';
import 'package:nubilab/presentation/widgets/air_quality_item_card.dart';
import 'package:nubilab/presentation/widgets/air_quality_skeleton.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final airQualityState = ref.watch(airQualityViewModelProvider);
    final viewModel = ref.read(airQualityViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          '대기질 정보',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              viewModel.refresh('서울');
            },
          ),
        ],
      ),
      body: airQualityState.hasError
          ? _buildErrorView(context, airQualityState.errorMessage, viewModel)
          : _buildContentView(context, airQualityState, viewModel),
    );
  }

  Widget _buildContentView(
    BuildContext context,
    AirQualityState state,
    AirQualityViewModel viewModel,
  ) {
    // 초기 로딩 중이고 아이템이 없는 경우
    if (state.isLoading && state.items.isEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 5,
        itemBuilder: (context, index) => const AirQualitySkeleton(),
      );
    }

    // 아이템이 없는 경우
    if (state.items.isEmpty) {
      return const Center(
        child: Text('데이터가 없습니다'),
      );
    }

    // 아이템이 있는 경우 (무한 스크롤 구현)
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          if (notification.metrics.extentAfter < 300 &&
              !state.isLoading &&
              state.canLoadMore) {
            viewModel.loadMore('서울');
          }
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          viewModel.refresh('서울');
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.items.length +
              (state.isLoading && state.items.isNotEmpty ? 1 : 0),
          itemBuilder: (context, index) {
            // 로딩 인디케이터를 보여주는 마지막 아이템
            if (index == state.items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return AirQualityItemCard(item: state.items[index]);
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(
    BuildContext context,
    String? errorMessage,
    AirQualityViewModel viewModel,
  ) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 24),
            Text(
              '에러 발생',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? '알 수 없는 오류가 발생했습니다',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                viewModel.refresh('서울');
              },
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
