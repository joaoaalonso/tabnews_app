import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tabnews_app/shared/widgets/skeleton/skeleton_default_theme.dart';
import 'package:tabnews_app/shared/widgets/skeleton/skeleton_list_item.dart';

class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonDefaultTheme(
      child: SkeletonListView(
        padding: EdgeInsets.zero,
        item: const SkeletonListItem(),
      ),
    );
  }
}
