import 'package:hive/hive.dart';

part 'api_retry_task.g.dart';

@HiveType(typeId: 1)
class ApiRetryTask {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String endpoint;

  @HiveField(2)
  final Map<String, dynamic> parameters;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final int retryCount;

  @HiveField(5)
  final String taskType;

  @HiveField(6)
  final DateTime? nextRetryTime;

  const ApiRetryTask({
    required this.id,
    required this.endpoint,
    required this.parameters,
    required this.createdAt,
    this.retryCount = 0,
    required this.taskType,
    this.nextRetryTime,
  });

  ApiRetryTask copyWith({
    String? id,
    String? endpoint,
    Map<String, dynamic>? parameters,
    DateTime? createdAt,
    int? retryCount,
    String? taskType,
    DateTime? nextRetryTime,
  }) {
    return ApiRetryTask(
      id: id ?? this.id,
      endpoint: endpoint ?? this.endpoint,
      parameters: parameters ?? this.parameters,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      taskType: taskType ?? this.taskType,
      nextRetryTime: nextRetryTime ?? this.nextRetryTime,
    );
  }

  DateTime calculateNextRetryTime() {
    const baseDelay = 5;
    const jitterRange = 3;

    final delay = baseDelay * (1 << retryCount);

    final jitter = (DateTime.now().millisecondsSinceEpoch % jitterRange) -
        (jitterRange ~/ 2);

    return DateTime.now().add(Duration(seconds: delay + jitter));
  }

  bool get canRetry => nextRetryTime?.isBefore(DateTime.now()) ?? true;
}
