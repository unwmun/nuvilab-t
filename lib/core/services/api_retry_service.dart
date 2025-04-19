import 'dart:async';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/api_retry_task.dart';
import '../network/network_info.dart';
import '../utils/logger.dart';

@singleton
class ApiRetryService {
  static const String _boxName = 'api_retry_tasks';
  static const int _maxRetryCount = 5;
  static const Duration _checkInterval = Duration(seconds: 10);

  final NetworkInfo _networkInfo;
  final _retryController = StreamController<ApiRetryTask>.broadcast();
  Timer? _retryTimer;
  bool _isProcessing = false;

  ApiRetryService(this._networkInfo) {
    _initializeService();
  }

  Stream<ApiRetryTask> get retryStream => _retryController.stream;

  Future<void> _initializeService() async {
    Timer.periodic(_checkInterval, (timer) async {
      final isConnected = await _networkInfo.isConnected;
      if (isConnected && !_isProcessing) {
        await _processRetryQueue();
      }
    });
  }

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
      nextRetryTime: DateTime.now(),
    );

    await box.put(task.id, task);
    _scheduleNextRetry();
  }

  void _scheduleNextRetry() async {
    final box = await Hive.openBox<ApiRetryTask>(_boxName);
    final tasks = box.values.toList();

    if (tasks.isEmpty) return;

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
        await _processRetryQueue();
      } else {
        _retryTimer = Timer(delay, () {
          _processRetryQueue();
        });
      }
    }
  }

  Future<void> _processRetryQueue() async {
    if (_isProcessing) return;

    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) return;

    _isProcessing = true;

    try {
      final box = await Hive.openBox<ApiRetryTask>(_boxName);
      final tasks = box.values.where((task) => task.canRetry).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

      for (final task in tasks) {
        if (task.retryCount >= _maxRetryCount) {
          AppLogger.warning('작업 ${task.id} 최대 재시도 횟수 초과로 삭제');
          await box.delete(task.id);
          continue;
        }

        _retryController.add(task);

        final updatedTask = task.copyWith(
          retryCount: task.retryCount + 1,
          nextRetryTime: task.calculateNextRetryTime(),
        );
        await box.put(task.id, updatedTask);

        await Future.delayed(const Duration(milliseconds: 100));
      }

      _scheduleNextRetry();
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> completeTask(String taskId) async {
    final box = await Hive.openBox<ApiRetryTask>(_boxName);
    await box.delete(taskId);
    _scheduleNextRetry();
  }

  Future<void> dispose() async {
    _retryTimer?.cancel();
    await _retryController.close();
  }

  Future<int> getPendingTaskCount() async {
    final box = await Hive.openBox<ApiRetryTask>(_boxName);
    return box.length;
  }

  Future<ApiRetryTask?> getTaskStatus(String taskId) async {
    final box = await Hive.openBox<ApiRetryTask>(_boxName);
    return box.get(taskId);
  }
}
