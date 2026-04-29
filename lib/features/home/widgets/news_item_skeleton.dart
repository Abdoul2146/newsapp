import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewsItemSkeleton extends StatelessWidget {
  const NewsItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
            highlightColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 12, width: 50, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(height: 90, width: double.infinity, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
