import 'package:flutter/material.dart';
import 'package:tabnews_app/favorites/favorites_bloc.dart';
import 'package:tabnews_app/favorites/favorites_events.dart';
import 'package:tabnews_app/favorites/favorites_state.dart';
import 'package:tabnews_app/favorites/widgets/favorites_empty.dart';
import 'package:tabnews_app/favorites/widgets/favorites_failure.dart';
import 'package:tabnews_app/shared/widgets/default_app_bar.dart';
import 'package:tabnews_app/shared/widgets/posts_list_item.dart';
import 'package:tabnews_app/shared/widgets/skeleton/skeleton_list.dart';

class FavoritesView extends StatefulWidget {
  final ScrollController? scrollController;

  const FavoritesView({
    Key? key,
    this.scrollController,
  }) : super(key: key);

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  late final FavoritesBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = FavoritesBloc();
    load();
  }

  @override
  void dispose() {
    bloc.input.close();
    super.dispose();
  }

  void load() {
    bloc.input.add(LoadFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: 'Favoritos'),
      body: StreamBuilder<FavoritesState>(
          stream: bloc.output,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final posts = snapshot.data!.posts;
              if (posts.isEmpty) {
                return const FavoritesEmpty();
              }
              return RefreshIndicator(
                child: ListView.separated(
                  controller: widget.scrollController,
                  itemCount: posts.length,
                  itemBuilder: (context, index) =>
                      PostsListItem(post: posts[index]),
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                ),
                onRefresh: () async {
                  load();
                },
              );
            } else if (snapshot.data is ErrorFavoritesState) {
              return FavoritesFailure(
                onButtonPressed: load,
              );
            } else {
              return const SkeletonList();
            }
          }),
    );
  }
}
