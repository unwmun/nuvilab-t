import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/dependency_injection.dart';
import '../../viewmodels/air_quality_view_model.dart';
import '../../widgets/sido_selector.dart';
import '../settings/settings_page.dart';
import 'widgets/air_quality_list_view.dart';
import 'widgets/empty_data_message.dart';
import 'widgets/error_message.dart';
import 'widgets/last_updated_info.dart';
import 'widgets/loading_indicator.dart';
import 'widgets/offline_banner.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    _subscribeToDeeepLinks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleConnectionStatusChange();
    });
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleConnectionStatusChange();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleConnectionStatusChange();
    });
  }

  void _handleConnectionStatusChange() {
    final state = ref.read(airQualityViewModelProvider);
    final viewModel = ref.read(airQualityViewModelProvider.notifier);

    if (state.connectionStatusChange != null && mounted) {
      final statusChange = state.connectionStatusChange!;
      final Color backgroundColor =
          statusChange.type == ConnectionChangeType.online
              ? Colors.green
              : Colors.orange;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(statusChange.message),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 3),
        ),
      );

      // 메시지를 표시한 후 소비
      viewModel.consumeConnectionStatusChange();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _subscribeToDeeepLinks() {
    final routeService = ref.read(routeServiceProvider);
    routeService.sidoChangeStream.listen((sido) {
      debugPrint('HomePage에서 시도 변경 이벤트 수신: $sido');
      _changeSido(sido);
    });
  }

  void _changeSido(String sido) {
    final viewModel = ref.read(airQualityViewModelProvider.notifier);
    final currentSido = viewModel.selectedSido;

    debugPrint('시도 변경 실행: $currentSido -> $sido');

    viewModel.updateSido(sido);
    viewModel.fetchAirQuality(sido);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('시도를 $sido(으)로 변경했습니다'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final airQualityState = ref.watch(airQualityViewModelProvider);
    final viewModel = ref.read(airQualityViewModelProvider.notifier);
    final selectedSido = airQualityState.selectedSido;
    final fcmService = ref.watch(fcmServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('대기질 정보'),
        actions: [
          const SidoSelector(),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => viewModel.fetchAirQuality(selectedSido),
              ),
              if (airQualityState.isRefreshing)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (airQualityState.isOffline)
            OfflineBanner(isUsingCachedData: airQualityState.isUsingCachedData),
          LastUpdatedInfo(
            lastUpdatedText: viewModel.lastUpdatedText,
            isOffline: airQualityState.isOffline,
            isUsingCachedData: airQualityState.isUsingCachedData,
          ),
          Expanded(
            child: airQualityState.airQuality.when(
              data: (airQualityResponse) {
                final items = airQualityResponse.response.body.items;
                if (items.isEmpty) {
                  return const EmptyDataMessage();
                }

                return AirQualityListView(
                  items: items,
                  onRefresh: () => viewModel.fetchAirQuality(selectedSido),
                );
              },
              loading: () => const LoadingIndicator(),
              error: (error, stackTrace) => ErrorMessage(
                error: error,
                stackTrace: stackTrace,
                onRetry: () => viewModel.fetchAirQuality(selectedSido),
                isOffline: airQualityState.isOffline,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final fcmToken = await fcmService.getToken();
            debugPrint('FCM 토큰: $fcmToken');

            await fcmService.showTestNotification();

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('테스트 알림이 발송되었습니다.'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } catch (e, stack) {
            debugPrint('FCM 테스트 중 오류: $e');
            debugPrint('스택 트레이스: $stack');

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('오류 발생: $e'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 5),
                ),
              );
            }
          }
        },
        tooltip: 'FCM 테스트',
        child: const Icon(Icons.notification_add),
      ),
    );
  }
}
