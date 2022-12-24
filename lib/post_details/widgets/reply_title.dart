import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tabnews_app/shared/models/post.dart';
import 'package:tabnews_app/shared/utils/open_link.dart';

class ReplyTitle extends StatelessWidget {
  final Post post;

  const ReplyTitle({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    if (post.parent == null || post.root == null) return const SizedBox();

    final root = post.root!;
    final parent = post.parent!;

    final parentIsRoot = parent.id == root.id;

    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text.rich(
          TextSpan(
            children: [
              const WidgetSpan(
                child: Icon(Icons.comment_outlined, size: 16),
              ),
              parentIsRoot
                  ? const TextSpan(text: " Em resposta a ")
                  : const TextSpan(text: " Respondendo a "),
              if (!parentIsRoot)
                TextSpan(
                  text: parent.ownerUsername,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      openUrl(context,
                          'https://www.tabnews.com.br/${parent.ownerUsername}');
                    },
                ),
              if (!parentIsRoot) const TextSpan(text: ' dentro da publicação '),
              TextSpan(
                text: root.title,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    openUrl(context,
                        'https://www.tabnews.com.br/${root.ownerUsername}/${root.slug}');
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
