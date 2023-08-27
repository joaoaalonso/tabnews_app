import 'package:flutter/material.dart';
import 'package:tabnews_app/posts_list/posts_list_bloc.dart';
import 'package:tabnews_app/posts_list/posts_list_events.dart';
import 'package:tabnews_app/posts_list/posts_list_state.dart';
import 'package:tabnews_app/posts_list/widgets/posts_list_failure.dart';
import 'package:tabnews_app/shared/models/post.dart';
import 'package:tabnews_app/shared/widgets/posts_list_item.dart';
import 'package:tabnews_app/shared/widgets/skeleton/skeleton_list.dart';
import 'package:tabnews_app/shared/widgets/skeleton/skeleton_list_item.dart';

class PostsListView extends StatefulWidget {
  final ScrollController? scrollController;
  final Future<List<Post>> Function(int page) fetchPosts;

  const PostsListView({
    Key? key,
    required this.fetchPosts,
    this.scrollController,
  }) : super(key: key);

  @override
  State<PostsListView> createState() => _PostsListViewState();
}

class _PostsListViewState extends State<PostsListView>
    with AutomaticKeepAliveClientMixin {
  ScrollController? _scrollController;
  late final PostsListBloc bloc;
  final nextPageThreshold = 0.8;

  @override
  void initState() {
    super.initState();
    bloc = PostsListBloc(widget.fetchPosts);
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController!.addListener(() {
      final nextPageTrigger =
          nextPageThreshold * _scrollController!.position.maxScrollExtent;
      if (_scrollController!.position.pixels > nextPageTrigger) {
        bloc.input.add(NextPagePostListEvent());
      }
    });
    load();
  }

  @override
  void dispose() {
    bloc.input.close();
    super.dispose();
  }

  void load() {
    bloc.input.add(LoadPostsListEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<PostsListState>(
      stream: bloc.output,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.posts.isNotEmpty) {
          final posts = snapshot.data!.posts;
          return RefreshIndicator(
            child: ListView.separated(
              controller: _scrollController,
              itemCount:
                  snapshot.data!.hasMore ? posts.length + 1 : posts.length,
              itemBuilder: (context, index) {
                if (index == posts.length && snapshot.data!.hasMore) {
                  return const Column(
                    children: [
                      SkeletonListItem(),
                      SkeletonListItem(),
                    ],
                  );
                } else {
                  return PostsListItem(post: posts[index]);
                }
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
            onRefresh: () async {
              load();
            },
          );
        } else if (snapshot.data is ErrorPostsListState) {
          return PostsListFailure(
            onButtonPressed: load,
          );
        } else {
          return const SkeletonList();
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
