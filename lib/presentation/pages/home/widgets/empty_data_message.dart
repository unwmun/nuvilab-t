import 'package:flutter/material.dart';

class EmptyDataMessage extends StatelessWidget {
  const EmptyDataMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('데이터가 없습니다'),
    );
  }
}
