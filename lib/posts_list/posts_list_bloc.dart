import 'dart:async';

import 'package:tabnews_app/posts_list/posts_list_events.dart';
import 'package:tabnews_app/posts_list/posts_list_state.dart';
import 'package:tabnews_app/shared/models/post.dart';

class PostsListBloc {
  final Future<List<Post>> Function(int page) fetchPosts;

  final StreamController<PostsListEvent> _inputController =
      StreamController<PostsListEvent>();
  final StreamController<PostsListState> _outputController =
      StreamController<PostsListState>();

  Sink<PostsListEvent> get input => _inputController.sink;
  Stream<PostsListState> get output => _outputController.stream;

  PostsListBloc(this.fetchPosts) {
    _inputController.stream.listen(_mapEventToState);
  }

  var page = 1;
  var isLoadingNextPage = false;
  List<Post> posts = [];
  final pageSize = 30;

  _mapEventToState(PostsListEvent event) async {
    if (event is LoadPostsListEvent) {
      _outputController.add(LoadingPostsListState(posts: [], hasMore: false));
      try {
        posts = await fetchPosts(page);
        _outputController.add(SuccessPostsListState(
            posts: posts, hasMore: posts.length >= pageSize));
      } catch (e) {
        _outputController
            .add(ErrorPostsListState(posts: posts, hasMore: false));
      }
    } else if (event is NextPagePostListEvent) {
      if (isLoadingNextPage || posts.length < pageSize) return;
      _outputController.add(LoadingPostsListState(posts: posts, hasMore: true));
      isLoadingNextPage = true;
      try {
        final nextPagePosts = await fetchPosts(page + 1);
        posts = posts + nextPagePosts;
        isLoadingNextPage = false;
        _outputController.add(SuccessPostsListState(
            posts: posts, hasMore: nextPagePosts.length >= pageSize));
        page++;
      } catch (e) {
        isLoadingNextPage = false;
        _outputController
            .add(ErrorPostsListState(posts: posts, hasMore: false));
      }
    }
  }
}
