import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tabnews_app/shared/widgets/skeleton/skeleton_default_theme.dart';

class PostDetailsLoading extends StatelessWidget {
  const PostDetailsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonDefaultTheme(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: const [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 14, width: 100),
                ),
                Spacer(),
                SkeletonLine(
                  style: SkeletonLineStyle(height: 14, width: 50),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const SkeletonLine(
              style: SkeletonLineStyle(height: 18),
            ),
            const SizedBox(height: 12),
            for (int x = 1; x <= 7; x++) ...[
              const SizedBox(height: 12),
              const SkeletonLine(
                style: SkeletonLineStyle(
                  height: 12,
                ),
              ),
              const SizedBox(height: 12),
              const SkeletonLine(
                style: SkeletonLineStyle(
                  height: 12,
                ),
              ),
              const SizedBox(height: 12),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 12,
                  randomLength: true,
                  minLength: MediaQuery.of(context).size.width - 120,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
