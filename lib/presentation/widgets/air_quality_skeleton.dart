import 'package:flutter/material.dart';

class AirQualitySkeleton extends StatelessWidget {
  const AirQualitySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSkeletonText(width: 120, height: 24),
                _buildSkeletonCircle(size: 40),
              ],
            ),
            const SizedBox(height: 12),
            _buildSkeletonText(width: 150, height: 16),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            ...List.generate(
              6,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSkeletonText(width: 100, height: 16),
                    Row(
                      children: [
                        _buildSkeletonText(width: 50, height: 16),
                        const SizedBox(width: 8),
                        _buildSkeletonCircle(size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonText({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildSkeletonCircle({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}
