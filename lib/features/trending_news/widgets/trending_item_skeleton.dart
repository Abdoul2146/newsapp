import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TrendingItemSkeleton extends StatelessWidget {
  const TrendingItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
      highlightColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
