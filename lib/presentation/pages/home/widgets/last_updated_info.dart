import 'package:flutter/material.dart';

class LastUpdatedInfo extends StatelessWidget {
  final String lastUpdatedText;
  final bool isOffline;
  final bool isUsingCachedData;

  const LastUpdatedInfo({
    super.key,
    required this.lastUpdatedText,
    this.isOffline = false,
    this.isUsingCachedData = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '마지막 갱신: $lastUpdatedText',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isOffline ? Colors.red : null,
                  fontWeight: isOffline ? FontWeight.bold : null,
                ),
          ),
          if (isOffline && isUsingCachedData) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.orange,
            ),
          ],
        ],
      ),
    );
  }
}
