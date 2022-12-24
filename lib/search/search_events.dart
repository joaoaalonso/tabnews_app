abstract class SearchEvent {}

class LoadSearchEvent extends SearchEvent {
  final String term;

  LoadSearchEvent({required this.term});
}

class NextPageSearchEvent extends SearchEvent {}

class ResetSearchEvent extends SearchEvent {}

class RemoveRecentSearchEvent extends SearchEvent {
  final String term;

  RemoveRecentSearchEvent({required this.term});
}

class ClearRecentSearchEvent extends SearchEvent {}
