import 'package:flutter/material.dart';
import 'package:nubilab/data/models/air_quality.dart';
import 'package:nubilab/presentation/widgets/air_quality_item_card.dart';

class AirQualityListView extends StatelessWidget {
  final List<AirQualityItem> items;
  final Future<void> Function() onRefresh;

  const AirQualityListView({
    super.key,
    required this.items,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.only(bottom: 16),
        itemBuilder: (context, index) {
          return AirQualityItemCard(item: items[index]);
        },
      ),
    );
  }
}
