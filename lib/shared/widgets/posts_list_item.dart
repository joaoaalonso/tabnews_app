import 'package:flutter/material.dart';
import 'package:tabnews_app/extensions/dark_mode.dart';
import 'package:tabnews_app/post_details/post_details_view.dart';
import 'package:tabnews_app/shared/models/post.dart';

class PostsListItem extends StatelessWidget {
  final Post post;

  const PostsListItem({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final subtitleComponents = [
      post.tabcoints != null ? '${post.tabcoints} tabcoins' : null,
      post.commentsCount != null ? '${post.commentsCount} comentários' : null,
      post.ownerUsername,
      post.publishedIn()
    ]..removeWhere((element) => element == null);

    return ListTile(
      title: _Title(post: post),
      subtitle: Text(
        subtitleComponents.join(" · "),
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PostDetailsView(
            username: post.ownerUsername,
            slug: post.slug,
          ),
        ));
      },
    );
  }
}

class _Title extends StatelessWidget {
  final Post post;

  const _Title({required this.post});

  @override
  Widget build(BuildContext context) {
    if (post.title != '') {
      return Text(
        post.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      return RichText(
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(
                Icons.comment_outlined,
                size: 16,
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            TextSpan(
              text: "\"${post.body}\"",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      );
    }
  }
}
