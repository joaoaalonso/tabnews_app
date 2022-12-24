import 'package:flutter/material.dart';
import 'package:tabnews_app/search/search_bloc.dart';
import 'package:tabnews_app/search/search_events.dart';
import 'package:tabnews_app/search/search_state.dart';
import 'package:tabnews_app/search/widgets/search_empty.dart';
import 'package:tabnews_app/search/widgets/search_failure.dart';
import 'package:tabnews_app/search/widgets/search_input.dart';
import 'package:tabnews_app/shared/widgets/posts_list_item.dart';
import 'package:tabnews_app/shared/widgets/skeleton/skeleton_list.dart';
import 'package:tabnews_app/shared/widgets/skeleton/skeleton_list_item.dart';

class SearchView extends StatefulWidget {
  final ScrollController? scrollController;

  const SearchView({
    Key? key,
    this.scrollController,
  }) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final SearchBloc bloc;
  final nextPageThreshold = 0.8;
  final textEditingController = TextEditingController();
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    bloc = SearchBloc();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController!.addListener(() {
      final nextPageTrigger =
          nextPageThreshold * _scrollController!.position.maxScrollExtent;
      if (_scrollController!.position.pixels > nextPageTrigger) {
        bloc.input.add(NextPageSearchEvent());
      }
    });
  }

  @override
  void dispose() {
    bloc.input.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchInput(
          textEditingController: textEditingController,
          onCancel: () {
            bloc.input.add(ResetSearchEvent());
          },
          onSubmitted: (value) {
            if (value != '') {
              bloc.input.add(LoadSearchEvent(term: value));
            }
          },
        ),
      ),
      body: StreamBuilder<SearchState>(
        stream: bloc.output,
        builder: (context, snapshot) {
          if (snapshot.data is SuccessSearchState) {
            final posts = snapshot.data!.posts;
            if (snapshot.data!.posts.isEmpty) {
              return const Center(
                child: Text("Nenhum resultado encontrado"),
              );
            }
            return RefreshIndicator(
              child: ListView.separated(
                controller: _scrollController,
                itemCount:
                    snapshot.data!.hasMore ? posts.length + 1 : posts.length,
                itemBuilder: (context, index) {
                  if (index == posts.length && snapshot.data!.hasMore) {
                    return Column(
                      children: const [
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
              onRefresh: () async {},
            );
          } else if (snapshot.data is ErrorSearchState) {
            final term = (snapshot.data as ErrorSearchState).term;
            return SearchFailure(
              onButtonPressed: () {
                bloc.input.add(LoadSearchEvent(term: term));
              },
            );
          } else if (snapshot.data is LoadingSearchState) {
            return const SkeletonList();
          } else if (snapshot.data is EmptySearchState) {
            final recentSearchs =
                (snapshot.data as EmptySearchState).recentSearchs;
            return SearchEmpty(
              recentSearchs: recentSearchs,
              onItemTap: (String term) {
                bloc.input.add(LoadSearchEvent(term: term));
                textEditingController.text = term;
              },
              onClear: () => bloc.input.add(ClearRecentSearchEvent()),
              onItemRemove: (term) {
                bloc.input.add(RemoveRecentSearchEvent(term: term));
              },
            );
          } else {
            return const SearchEmpty(recentSearchs: []);
          }
        },
      ),
    );
  }
}
