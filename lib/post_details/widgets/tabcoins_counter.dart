import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:tabnews_app/shared/models/post.dart';

class TabCoinsCounter extends StatefulWidget {
  final Post post;

  const TabCoinsCounter({super.key, required this.post});

  @override
  State<StatefulWidget> createState() => _TabCoinsCounterState();
}

class _TabCoinsCounterState extends State<TabCoinsCounter> {
  int tabcoins = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      tabcoins = widget.post.tabcoints ?? 0;
    });
  }

  void upvote() {
    print("UPVOTE ${widget.post.slug}");
    setState(() => tabcoins++);
  }

  void downvote() {
    print("DOWNVOTE ${widget.post.slug}");
    setState(() => tabcoins--);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: upvote,
          child: const Icon(Icons.arrow_drop_up),
        ),
        AnimatedFlipCounter(
          value: tabcoins,
        ),
        InkWell(
          onTap: downvote,
          child: const Icon(Icons.arrow_drop_down),
        ),
      ],
    );
  }
}
