import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tabnews_app/extensions/dark_mode.dart';

class SkeletonDefaultTheme extends StatelessWidget {
  final Widget child;

  const SkeletonDefaultTheme({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.isDarkMode
        ? const [
            Color.fromARGB(255, 50, 50, 50),
            Color.fromARGB(255, 46, 44, 44),
            Color.fromARGB(255, 50, 50, 50),
          ]
        : const [
            Color(0xFFD8E3E7),
            Color(0xFFC8D5DA),
            Color(0xFFD8E3E7),
          ];

    return SkeletonTheme(
        shimmerGradient: LinearGradient(
          colors: colors,
        ),
        child: child);
  }
}
