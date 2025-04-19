import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nubilab/core/utils/logger.dart';
import 'package:nubilab/core/services/api_retry_service.dart';
import 'package:nubilab/data/models/api_retry_task.dart';

@singleton
class RetryInterceptor extends Interceptor {
  final ApiRetryService _retryService;

  RetryInterceptor(this._retryService) {
    _setupRetryListener();
  }

  void _setupRetryListener() {
    _retryService.retryStream.listen((task) async {
      try {
        AppLogger.info(
            'API 재시도 시작: ${task.endpoint} (시도 횟수: ${task.retryCount})');

        final dio = Dio(); // 새로운 Dio 인스턴스 생성
        final response = await dio.request(
          task.endpoint,
          options: Options(
            method: task.parameters['method'],
            headers: task.parameters['headers'],
          ),
          queryParameters: task.parameters['queryParameters'],
          data: task.parameters['data'],
        );

        if (response.statusCode != null && response.statusCode! < 400) {
          AppLogger.info('API 재시도 성공: ${task.endpoint}');
          await _retryService.completeTask(task.id);
        } else {
          AppLogger.warning(
            'API 재시도 실패 (상태 코드: ${response.statusCode}): ${task.endpoint}',
          );
        }
      } catch (e) {
        AppLogger.error(
          'API 재시도 중 오류 발생: ${task.endpoint}',
          e,
        );
      }
    });
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      try {
        AppLogger.info('API 호출 실패, 재시도 큐에 추가: ${err.requestOptions.path}');

        await _retryService.addRetryTask(
          endpoint: err.requestOptions.path,
          parameters: {
            'method': err.requestOptions.method,
            'headers': err.requestOptions.headers,
            'queryParameters': err.requestOptions.queryParameters,
            'data': err.requestOptions.data,
          },
          taskType: 'api_request',
        );

        final pendingTasks = await _retryService.getPendingTaskCount();
        AppLogger.info('현재 대기 중인 재시도 작업 수: $pendingTasks');
      } catch (e) {
        AppLogger.error('재시도 큐 추가 실패', e);
        handler.next(err);
        return;
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    final shouldRetry = err.error is SocketException || // 네트워크 연결 오류
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        (err.response?.statusCode != null &&
            err.response!.statusCode! >= 500); // 서버 오류

    if (shouldRetry) {
      AppLogger.info(
        'API 재시도 조건 충족: ${err.requestOptions.path} (${err.type})',
      );
    }

    return shouldRetry;
  }
}
