import 'package:flutter/material.dart';
import 'package:tabnews_app/extensions/dark_mode.dart';
import 'package:tabnews_app/post_details/widgets/tabcoins_counter.dart';
import 'package:tabnews_app/posts_list/posts_list_view.dart';
import 'package:tabnews_app/shared/models/post.dart';
import 'package:tabnews_app/shared/utils/open_link.dart';
import 'package:tabnews_app/shared/widgets/markdown.dart';
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
                    Row(
                      children: [
                        const Icon(Icons.link),
                        const SizedBox(
                          width: 4,
                        ),
                        const Text(
                          "Fonte: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () => openUrl(context, post.sourceUrl!),
                          child: Text(
                            post.sourceUrl!,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
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
