import 'dart:async';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:nubilab/core/network/network_info.dart';
import 'package:nubilab/core/utils/logger.dart';
import 'package:nubilab/data/models/api_retry_task.dart';
import 'package:uuid/uuid.dart';

@singleton
class ApiRetryService {
  static const String _boxName = 'api_retry_tasks';
  static const int _maxRetryCount = 5; // 최대 재시도 횟수
  static const Duration _checkInterval = Duration(seconds: 10); // 재시도 큐 확인 간격

  final NetworkInfo _networkInfo;
  final _retryController = StreamController<ApiRetryTask>.broadcast();
  Timer? _retryTimer;
  bool _isProcessing = false;

  ApiRetryService(this._networkInfo) {
    _initializeService();
  }

  Stream<ApiRetryTask> get retryStream => _retryController.stream;

  Future<void> _initializeService() async {
    // 주기적으로 재시도 큐 확인
    Timer.periodic(_checkInterval, (timer) async {
      final isConnected = await _networkInfo.isConnected;
      if (isConnected && !_isProcessing) {
        _processRetryQueue();
      }
    });
  }

  // 실패한 API 호출을 큐에 추가
  Future<void> addRetryTask({
    required String endpoint,
    required Map<String, dynamic> parameters,
    required String taskType,
  }) async {
    final box = await Hive.openBox<ApiRetryTask>(_boxName);

    final task = ApiRetryTask(
      id: const Uuid().v4(),
      endpoint: endpoint,
      parameters: parameters,
      createdAt: DateTime.now(),
      taskType: taskType,
      nextRetryTime: DateTime.now(), // 첫 시도는 즉시 가능
    );

    await box.put(task.id, task);
    _scheduleNextRetry();
  }

  // 다음 재시도 시간에 맞춰 스케줄링
  void _scheduleNextRetry() async {
    final box = await Hive.openBox<ApiRetryTask>(_boxName);
    final tasks = box.values.toList();

    if (tasks.isEmpty) return;

    // 가장 빠른 다음 재시도 시간 찾기
    DateTime? earliestRetryTime;
    for (final task in tasks) {
      if (task.nextRetryTime != null) {
        earliestRetryTime = earliestRetryTime == null
            ? task.nextRetryTime
            : task.nextRetryTime!.isBefore(earliestRetryTime)
                ? task.nextRetryTime
                : earliestRetryTime;
      }
    }

    if (earliestRetryTime != null) {
      _retryTimer?.cancel();
      final now = DateTime.now();
      final delay = earliestRetryTime.difference(now);
      if (delay.isNegative) {
        _processRetryQueue();
      } else {
        _retryTimer = Timer(delay, () {
          _processRetryQueue();
        });
      }
    }
  }

  // 재시도 큐 처리
  Future<void> _processRetryQueue() async {
    if (_isProcessing) return;

    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) return;

    _isProcessing = true;

    try {
      final box = await Hive.openBox<ApiRetryTask>(_boxName);
      final now = DateTime.now();
      final tasks = box.values.where((task) => task.canRetry).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

      for (final task in tasks) {
        if (task.retryCount >= _maxRetryCount) {
          // 최대 재시도 횟수 초과
          AppLogger.warning('작업 ${task.id} 최대 재시도 횟수 초과로 삭제');
          await box.delete(task.id);
          continue;
        }

        // 재시도 작업 스트림으로 전송
        _retryController.add(task);

        // 재시도 횟수 증가 및 다음 재시도 시간 계산
        final updatedTask = task.copyWith(
          retryCount: task.retryCount + 1,
          nextRetryTime: task.calculateNextRetryTime(),
        );
        await box.put(task.id, updatedTask);

        // 작업 간 짧은 지연 추가
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // 다음 재시도 스케줄링
      _scheduleNextRetry();
    } finally {
      _isProcessing = false;
    }
  }

  // 작업 완료 처리
  Future<void> completeTask(String taskId) async {
    final box = await Hive.openBox<ApiRetryTask>(_boxName);
    await box.delete(taskId);
    _scheduleNextRetry(); // 남은 작업 재스케줄링
  }

  // 서비스 정리
  Future<void> dispose() async {
    _retryTimer?.cancel();
    await _retryController.close();
  }

  // 현재 대기 중인 재시도 작업 수 조회
  Future<int> getPendingTaskCount() async {
    final box = await Hive.openBox<ApiRetryTask>(_boxName);
    return box.length;
  }

  // 특정 작업의 재시도 상태 조회
  Future<ApiRetryTask?> getTaskStatus(String taskId) async {
    final box = await Hive.openBox<ApiRetryTask>(_boxName);
    return box.get(taskId);
  }
}
