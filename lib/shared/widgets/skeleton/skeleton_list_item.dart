import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tabnews_app/shared/widgets/skeleton/skeleton_default_theme.dart';

class SkeletonListItem extends StatelessWidget {
  const SkeletonListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonDefaultTheme(
      child: Column(
        children: [
          SkeletonListTile(
            hasLeading: false,
            hasSubtitle: true,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            titleStyle: SkeletonLineStyle(
              height: 18,
              borderRadius: BorderRadius.circular(4),
            ),
            subtitleStyle: SkeletonLineStyle(
              height: 12,
              borderRadius: BorderRadius.circular(4),
              width: MediaQuery.of(context).size.width - 100,
            ),
          ),
          const SkeletonLine(
            style: SkeletonLineStyle(height: 1),
          )
        ],
      ),
    );
  }
}
