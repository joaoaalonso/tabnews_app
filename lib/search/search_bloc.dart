import 'dart:async';

import 'package:tabnews_app/search/search_events.dart';
import 'package:tabnews_app/search/search_state.dart';
import 'package:tabnews_app/shared/models/post.dart';
import 'package:tabnews_app/shared/repositories/search_repository.dart';

class SearchBloc {
  final SearchRepository _searchRepository = SearchRepository();

  final StreamController<SearchEvent> _inputController =
      StreamController<SearchEvent>();
  final StreamController<SearchState> _outputController =
      StreamController<SearchState>();

  Sink<SearchEvent> get input => _inputController.sink;
  Stream<SearchState> get output => _outputController.stream;

  SearchBloc() {
    _inputController.stream.listen(_mapEventToState);
    // _outputController.add(EmptySearchState(posts: [], hasMore: false));
    _searchRepository
        .getRecentSearchs()
        .then((recentSearchs) => _outputController.add(
              EmptySearchState(
                posts: [],
                hasMore: false,
                recentSearchs: recentSearchs,
              ),
            ));
  }

  var term = '';
  var page = 1;
  var isLoadingNextPage = false;
  List<Post> posts = [];

  _mapEventToState(SearchEvent event) async {
    const postsPerPage = 20;
    if (event is LoadSearchEvent) {
      _outputController.add(LoadingSearchState(posts: [], hasMore: false));
      try {
        term = event.term;
        posts = await _searchRepository.search(term);
        _outputController.add(SuccessSearchState(
            posts: posts, hasMore: posts.length == postsPerPage));
        _searchRepository.addSearch(term);
      } catch (e) {
        _outputController
            .add(ErrorSearchState(term: term, posts: posts, hasMore: false));
      }
    } else if (event is NextPageSearchEvent) {
      if (isLoadingNextPage) return;
      isLoadingNextPage = true;
      try {
        final nextPagePosts =
            await _searchRepository.search(term, page: page + 1);
        posts = posts + nextPagePosts;
        isLoadingNextPage = false;
        _outputController.add(SuccessSearchState(
            posts: posts, hasMore: nextPagePosts.length == postsPerPage));
        page++;
      } catch (e) {
        isLoadingNextPage = false;
        _outputController
            .add(ErrorSearchState(term: term, posts: posts, hasMore: false));
      }
    } else if (event is ResetSearchEvent) {
      posts = [];
      page = 1;
      isLoadingNextPage = false;
      final recentSearchs = await _searchRepository.getRecentSearchs();
      _outputController.add(EmptySearchState(
        posts: [],
        hasMore: false,
        recentSearchs: recentSearchs,
      ));
    } else if (event is RemoveRecentSearchEvent) {
      await _searchRepository.removeSearch(event.term);
      final recentSearchs = await _searchRepository.getRecentSearchs();
      _outputController.add(EmptySearchState(
        posts: [],
        hasMore: false,
        recentSearchs: recentSearchs,
      ));
    } else if (event is ClearRecentSearchEvent) {
      _searchRepository.clearSearch();
      _outputController.add(EmptySearchState(
        posts: [],
        hasMore: false,
        recentSearchs: [],
      ));
    }
  }
}
