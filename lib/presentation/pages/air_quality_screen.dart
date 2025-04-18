import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/presentation/viewmodels/air_quality_viewmodel.dart';

class AirQualityScreen extends ConsumerWidget {
  const AirQualityScreen({super.key});

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
            onPressed: () => viewModel.refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '마지막 갱신: ${viewModel.lastUpdatedText}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: airQualityState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('오류가 발생했습니다: $error'),
              ),
              data: (airQuality) => ListView.builder(
                itemCount: airQuality.response.body.items.length,
                itemBuilder: (context, index) {
                  final item = airQuality.response.body.items[index];
                  return ListTile(
                    title: Text(item.stationName),
                    subtitle:
                        Text('PM10: ${item.pm10Value} (${item.pm10Grade}등급)'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
