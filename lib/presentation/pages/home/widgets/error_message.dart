import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final Object error;
  final StackTrace stackTrace;
  final VoidCallback onRetry;
  final bool isOffline;

  const ErrorMessage({
    super.key,
    required this.error,
    required this.stackTrace,
    required this.onRetry,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    final String errorTitle = isOffline ? '네트워크 연결 없음' : '에러 발생';

    final String errorMessage =
        isOffline ? '인터넷 연결이 없습니다.\n와이파이나 모바일 데이터 연결을 확인해주세요.' : '$error';

    final IconData errorIcon = isOffline ? Icons.wifi_off : Icons.error_outline;

    final Color errorColor = isOffline ? Colors.orange : Colors.red;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(errorIcon, size: 48, color: errorColor),
          const SizedBox(height: 16),
          Text(
            errorTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: errorColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: errorColor),
            ),
          ),
          if (!isOffline) ...[
            const SizedBox(height: 8),
            Text(
              stackTrace.toString().split('\n').first,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(isOffline ? '재연결 시도' : '다시 시도'),
          ),
        ],
      ),
    );
  }
}
