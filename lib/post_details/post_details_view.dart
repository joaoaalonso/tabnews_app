import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tabnews_app/extensions/dark_mode.dart';
import 'package:tabnews_app/favorites/favorites_button.dart';
import 'package:tabnews_app/post_details/post_details_bloc.dart';
import 'package:tabnews_app/post_details/post_details_events.dart';
import 'package:tabnews_app/post_details/post_details_state.dart';
import 'package:tabnews_app/post_details/widgets/post_details.dart';
import 'package:tabnews_app/post_details/widgets/post_details_failure.dart';
import 'package:tabnews_app/post_details/widgets/post_details_loading.dart';
import 'package:tabnews_app/post_details/widgets/reply_title.dart';

class PostDetailsView extends StatefulWidget {
  final String username;
  final String slug;

  const PostDetailsView(
      {super.key, required this.username, required this.slug});

  @override
  State<PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends State<PostDetailsView> {
  late final PostDetailsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = PostDetailsBloc();
    load();
  }

  @override
  void dispose() {
    bloc.input.close();
    super.dispose();
  }

  void load() {
    bloc.input.add(
        LoadPostDetailsEvent(username: widget.username, slug: widget.slug));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              foregroundColor: context.isDarkMode ? Colors.white : Colors.black,
              backgroundColor: context.isDarkMode
                  ? const Color.fromRGBO(27, 29, 33, 1)
                  : Colors.white,
              actions: [
                StreamBuilder<PostDetailsState>(
                  stream: bloc.output,
                  builder: (context, snapshot) {
                    if (snapshot.data is SuccessPostDetailsState) {
                      final post =
                          (snapshot.data as SuccessPostDetailsState).post;
                      return FavoritesButton(post: post);
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                IconButton(
                  onPressed: () {
                    Share.share(
                        'https://www.tabnews.com.br/${widget.username}/${widget.slug}');
                  },
                  icon: const Icon(Icons.share),
                ),
                const SizedBox(width: 12.0),
              ],
            ),
            SliverToBoxAdapter(
              child: StreamBuilder<PostDetailsState>(
                stream: bloc.output,
                builder: (context, snapshot) {
                  if (snapshot.data is SuccessPostDetailsState) {
                    final post =
                        (snapshot.data as SuccessPostDetailsState).post;
                    return Column(
                      children: [
                        ReplyTitle(post: post),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12, left: 12, right: 12),
                          child: PostContent(
                            post: post,
                            isParent: true,
                          ),
                        ),
                        if (post.commentsCount != null &&
                            post.commentsCount! > 0 &&
                            post.comments.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: CircularProgressIndicator(
                                color: Colors
                                    .grey[context.isDarkMode ? 400 : 800]),
                          ),
                      ],
                    );
                  } else if (snapshot.data is FailurePostDetailsState) {
                    return PostDetailsFailure(onButtonPressed: load);
                  } else {
                    return const PostDetailsLoading();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
