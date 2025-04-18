import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final Object error;
  final StackTrace stackTrace;
  final VoidCallback onRetry;

  const ErrorMessage({
    super.key,
    required this.error,
    required this.stackTrace,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            '에러 발생: $error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          Text(
            '${stackTrace.toString().split('\n').first}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}
