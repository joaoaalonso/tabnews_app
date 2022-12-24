import 'package:tabnews_app/shared/models/post.dart';

abstract class FavoritesState {
  List<Post> posts;

  FavoritesState({required this.posts});
}

class LoadingFavoritesState extends FavoritesState {
  LoadingFavoritesState({required super.posts});
}

class SuccessFavoritesState extends FavoritesState {
  SuccessFavoritesState({required super.posts});
}

class ErrorFavoritesState extends FavoritesState {
  ErrorFavoritesState({required super.posts});
}
