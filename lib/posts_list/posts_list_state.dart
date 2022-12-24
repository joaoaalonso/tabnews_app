import 'package:tabnews_app/shared/models/post.dart';

abstract class PostsListState {
  List<Post> posts;
  bool hasMore;

  PostsListState({required this.posts, required this.hasMore});
}

class LoadingPostsListState extends PostsListState {
  LoadingPostsListState({required super.posts, required super.hasMore});
}

class SuccessPostsListState extends PostsListState {
  SuccessPostsListState({required super.posts, required super.hasMore});
}

class ErrorPostsListState extends PostsListState {
  ErrorPostsListState({required super.posts, required super.hasMore});
}
