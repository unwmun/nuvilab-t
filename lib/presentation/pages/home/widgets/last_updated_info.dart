import 'package:flutter/material.dart';

class LastUpdatedInfo extends StatelessWidget {
  final String lastUpdatedText;

  const LastUpdatedInfo({
    super.key,
    required this.lastUpdatedText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        '마지막 갱신: $lastUpdatedText',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
