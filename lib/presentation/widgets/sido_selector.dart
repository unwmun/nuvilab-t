import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/sido_list.dart';
import '../viewmodels/air_quality_view_model.dart';

class SidoSelector extends ConsumerWidget {
  const SidoSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(airQualityViewModelProvider);
    final viewModel = ref.read(airQualityViewModelProvider.notifier);
    final selectedSido = state.selectedSido;

    return DropdownButton<String>(
      value: selectedSido,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: Theme.of(context).textTheme.titleMedium,
      underline: Container(
        height: 2,
        color: Theme.of(context).primaryColor,
      ),
      onChanged: (String? newValue) {
        if (newValue != null && newValue != selectedSido) {
          viewModel.fetchAirQuality(newValue);
        }
      },
      items: SidoList.sidoNames.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
