import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/dependency_injection.dart';
import '../../core/services/performance_service.dart';

/// 성능이 최적화된 리스트 위젯
///
/// DevTools 성능 모니터링을 위한 추적이 내장되어 있으며,
/// 메모리 사용 최적화와 렌더링 성능 개선을 위한 다양한 기법이 적용되어 있습니다.
class OptimizedList<T> extends ConsumerStatefulWidget {
  /// 리스트 아이템 데이터
  final List<T> items;

  /// 각 아이템을 위젯으로 변환하는 빌더 함수
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// 리스트 스크롤 방향 (기본값: 세로)
  final Axis scrollDirection;

  /// 빈 리스트일 때 표시할 위젯
  final Widget? emptyWidget;

  /// 리스트 패딩
  final EdgeInsetsGeometry? padding;

  /// 아이템 간 구분선 사용 여부
  final bool useDivider;

  /// 구분선 높이/두께
  final double dividerThickness;

  /// 성능 측정을 위한 위젯 이름 (DevTools에 표시됨)
  final String widgetName;

  /// 항목 캐싱 활성화 여부
  final bool enableItemCaching;

  const OptimizedList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.emptyWidget,
    this.padding,
    this.useDivider = false,
    this.dividerThickness = 1.0,
    this.widgetName = 'OptimizedList',
    this.enableItemCaching = true,
  });

  @override
  ConsumerState<OptimizedList<T>> createState() => _OptimizedListState<T>();
}

class _OptimizedListState<T> extends ConsumerState<OptimizedList<T>>
    with AutomaticKeepAliveClientMixin {
  // 성능 모니터링 서비스
  final PerformanceService _performanceService = getIt<PerformanceService>();

  // 아이템 캐시 (enableItemCaching이 true일 때 사용)
  final Map<int, Widget> _cachedItems = {};

  @override
  void initState() {
    super.initState();

    // 메모리 누수 디버깅 목적
    if (kDebugMode) {
      debugPrint('🔧 $runtimeType 초기화됨');
    }
  }

  @override
  void didUpdateWidget(OptimizedList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 아이템 리스트가 변경되면 캐시 초기화
    if (widget.items != oldWidget.items) {
      _cachedItems.clear();
    }
  }

  @override
  void dispose() {
    // 메모리 누수 디버깅 목적
    _performanceService.logDispose(runtimeType.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // 빈 리스트 처리
    if (widget.items.isEmpty) {
      return widget.emptyWidget ??
          const Center(
            child: Text('데이터가 없습니다.'),
          );
    }

    return _performanceService.trackBuildPerformance(
      widget.widgetName,
      _buildOptimizedList(),
    );
  }

  Widget _buildOptimizedList() {
    return ListView.separated(
      scrollDirection: widget.scrollDirection,
      padding: widget.padding,
      // 항목 수 최적화 (divider 고려)
      itemCount: widget.items.length,
      // RepaintBoundary로 감싸 불필요한 리페인팅 방지
      separatorBuilder: (context, index) => widget.useDivider
          ? Divider(height: widget.dividerThickness)
          : const SizedBox.shrink(),
      // itemBuilder 최적화
      itemBuilder: (context, index) {
        // 캐싱 활성화된 경우 캐시 사용
        if (widget.enableItemCaching && _cachedItems.containsKey(index)) {
          return _cachedItems[index]!;
        }

        // 아이템 생성
        final item = RepaintBoundary(
          child: widget.itemBuilder(context, widget.items[index], index),
        );

        // 캐싱 활성화된 경우 캐시에 저장
        if (widget.enableItemCaching) {
          _cachedItems[index] = item;
        }

        return item;
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
