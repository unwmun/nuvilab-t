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

    return Scaffold(
      appBar: AppBar(
        title: const Text('대기질 정보'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(airQualityViewModelProvider.notifier)
                  .fetchAirQuality('서울');
            },
          ),
        ],
      ),
      body: airQualityState.when(
        data: (airQualityResponse) {
          final items = airQualityResponse.response.body.items;
          if (items.isEmpty) {
            return const Center(
              child: Text('데이터가 없습니다'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref
                  .read(airQualityViewModelProvider.notifier)
                  .fetchAirQuality('서울');
            },
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
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
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
                onPressed: () {
                  ref
                      .read(airQualityViewModelProvider.notifier)
                      .fetchAirQuality('서울');
                },
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
