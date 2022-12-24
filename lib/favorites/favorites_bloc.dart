import 'dart:async';

import 'package:tabnews_app/favorites/favorites_events.dart';
import 'package:tabnews_app/favorites/favorites_state.dart';
import 'package:tabnews_app/shared/models/post.dart';
import 'package:tabnews_app/shared/repositories/favorites_repository.dart';

class FavoritesBloc {
  final FavoritesRepository _repository = FavoritesRepository();

  final StreamController<FavoritesEvent> _inputController =
      StreamController<FavoritesEvent>();
  final StreamController<FavoritesState> _outputController =
      StreamController<FavoritesState>();

  Sink<FavoritesEvent> get input => _inputController.sink;
  Stream<FavoritesState> get output => _outputController.stream;

  FavoritesBloc() {
    _inputController.stream.listen(_mapEventToState);
    _repository.stream.listen((event) {
      _outputController.add(SuccessFavoritesState(posts: event.favorites));
    });
  }

  List<Post> posts = [];

  _mapEventToState(FavoritesEvent event) async {
    if (event is LoadFavoritesEvent) {
      _outputController.add(LoadingFavoritesState(posts: []));
      try {
        _repository.fetchFavorites();
      } catch (e) {
        _outputController.add(ErrorFavoritesState(posts: posts));
      }
    }
  }
}
