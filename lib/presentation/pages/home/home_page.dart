import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nubilab/core/di/dependency_injection.dart';
import 'package:nubilab/core/services/fcm_service.dart';
import 'package:nubilab/presentation/pages/home/widgets/air_quality_list_view.dart';
import 'package:nubilab/presentation/pages/home/widgets/empty_data_message.dart';
import 'package:nubilab/presentation/pages/home/widgets/error_message.dart';
import 'package:nubilab/presentation/pages/home/widgets/last_updated_info.dart';
import 'package:nubilab/presentation/pages/home/widgets/loading_indicator.dart';
import 'package:nubilab/presentation/pages/settings/settings_page.dart';
import 'package:nubilab/presentation/viewmodels/air_quality_view_model.dart';
import 'package:nubilab/presentation/widgets/sido_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:nubilab/core/services/route_service.dart';

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _subscribeToDeeepLinks() {
    // 시도 변경 이벤트 구독
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

    // 시도 변경 및 데이터 로드
    viewModel.updateSido(sido);
    viewModel.fetchAirQuality(sido);

    // 사용자에게 피드백
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
          LastUpdatedInfo(lastUpdatedText: viewModel.lastUpdatedText),
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
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // FCM 토큰 확인
            final fcmToken = await fcmService.getToken();
            debugPrint('FCM 토큰: $fcmToken');

            // FCM 테스트 알림 표시
            await fcmService.showTestNotification();

            // 테스트 알림이 발송되었음을 사용자에게 알림
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
