import 'package:tabnews_app/shared/models/post.dart';

abstract class SearchState {
  List<Post> posts;
  bool hasMore;

  SearchState({required this.posts, required this.hasMore});
}

class LoadingSearchState extends SearchState {
  LoadingSearchState({required super.posts, required super.hasMore});
}

class SuccessSearchState extends SearchState {
  SuccessSearchState({required super.posts, required super.hasMore});
}

class ErrorSearchState extends SearchState {
  final String term;
  ErrorSearchState(
      {required this.term, required super.posts, required super.hasMore});
}

class EmptySearchState extends SearchState {
  List<String> recentSearchs;

  EmptySearchState(
      {required this.recentSearchs,
      required super.posts,
      required super.hasMore});
}
