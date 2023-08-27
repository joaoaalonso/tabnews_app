import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tabnews_app/extensions/dark_mode.dart';
import 'package:tabnews_app/post_details/widgets/tabcoins_counter.dart';
import 'package:tabnews_app/shared/models/post.dart';
import 'package:tabnews_app/shared/utils/open_link.dart';
import 'package:tabnews_app/shared/widgets/markdown/markdown.dart';
import 'package:tabnews_app/shared/widgets/tag.dart';
import 'package:tabnews_app/user_posts/user_posts_view.dart';

class PostContent extends StatelessWidget {
  final Post post;
  final String? rootPostOwner;
  final bool isParent;

  const PostContent(
      {super.key,
      required this.post,
      this.rootPostOwner,
      this.isParent = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            UserPostsView(username: post.ownerUsername)),
                  );
                },
                child: Tag(
                  label: post.ownerUsername,
                  type: rootPostOwner == null ||
                          post.ownerUsername == rootPostOwner
                      ? TagType.green
                      : TagType.blue,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                post.publishedIn(),
                style: const TextStyle(fontSize: 12),
              ),
              const Spacer(),
              TabCoinsCounter(post: post),
            ],
          ),
          const SizedBox(height: 12),
          post.title != ''
              ? Column(
                  children: [
                    Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                )
              : const SizedBox(),
          if (post.body != null) Markdown(body: post.body!),
          post.sourceUrl != null
              ? Column(
                  children: [
                    const SizedBox(height: 12),
                    Text.rich(
                      TextSpan(
                        children: [
                          const WidgetSpan(
                            child: Icon(Icons.link, size: 17),
                          ),
                          const WidgetSpan(
                            child: SizedBox(
                              width: 4,
                            ),
                          ),
                          const TextSpan(
                            text: "Fonte: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: post.sourceUrl!,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => openUrl(context, post.sourceUrl!),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          if (isParent && post.commentsCount != null && post.commentsCount! > 0)
            const Divider(thickness: 2),
          if (post.comments.isNotEmpty) const SizedBox(height: 12),
          _Comments(
            comments: post.comments,
            isFromParent: isParent,
            rootPostOwner: rootPostOwner ?? post.ownerUsername,
          ),
        ],
      ),
    );
  }
}

class _Comments extends StatelessWidget {
  final List<Post> comments;
  final String rootPostOwner;
  final bool isFromParent;

  const _Comments(
      {required this.comments,
      required this.rootPostOwner,
      required this.isFromParent});

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) return const SizedBox();

    return Padding(
      padding: isFromParent
          ? const EdgeInsets.all(0)
          : const EdgeInsets.only(left: 8),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: Colors.grey[context.isDarkMode ? 700 : 300]!),
              ),
            ),
            child: PostContent(
              post: comments[index],
              rootPostOwner: rootPostOwner,
            ),
          );
        },
        separatorBuilder: (context, index) {
          if (index >= comments.length) {
            return const SizedBox();
          } else {
            return const Divider();
          }
        },
        itemCount: comments.length,
      ),
    );
  }
}
