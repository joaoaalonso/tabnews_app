import 'package:flutter/material.dart';

import 'package:tabnews_app/extensions/dark_mode.dart';
import 'package:tabnews_app/home/home_view_model.dart';
import 'package:tabnews_app/posts_list/posts_list_view.dart';
import 'package:tabnews_app/shared/models/tag.dart';
import 'package:tabnews_app/shared/repositories/post_repository.dart';
import 'package:tabnews_app/shared/repositories/tag_repository.dart';
import 'package:tabnews_app/shared/widgets/default_app_bar.dart';

class HomeView extends StatefulWidget {
  final ScrollController? scrollController;

  const HomeView({super.key, this.scrollController});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Tag> tags = [];
  List<ScrollController> scrollControllers = [
    ScrollController(),
    ScrollController(),
  ];

  int currentIndex = 0;
  final viewModel = HomeViewModel();
  final tagRepository = TagRepository();
  final postRepository = PostRepository();

  @override
  initState() {
    super.initState();
    viewModel.getAvailableTags().then((availableTags) {
      for (var _ in availableTags) {
        scrollControllers.add(ScrollController());
      }
      setState(() {
        tags = availableTags;
      });
    });
  }

  void onItemTap(int index) {
    if (currentIndex == index) {
      final scrollController = scrollControllers[index];
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
    currentIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tags.length + 2,
      child: Scaffold(
        appBar: DefaultAppBar(
          title: 'TabNews',
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                onTap: onItemTap,
                isScrollable: true,
                labelColor: context.isDarkMode ? Colors.white : Colors.black,
                indicatorColor:
                    context.isDarkMode ? Colors.white : Colors.black,
                tabs: [
                  const Tab(text: 'Relevantes'),
                  const Tab(text: 'Recentes'),
                  ...tags.map((Tag tag) => Tab(text: tag.name)).toList(),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            PostsListView(
              scrollController: scrollControllers[0],
              fetchPosts: (page) =>
                  postRepository.fetchPosts(sort: 'relevant', page: page),
            ),
            PostsListView(
              scrollController: scrollControllers[1],
              fetchPosts: (page) =>
                  postRepository.fetchPosts(sort: 'new', page: page),
            ),
            ...tags.asMap().entries.map((entry) {
              return PostsListView(
                scrollController: scrollControllers[entry.key + 2],
                fetchPosts: (page) => tagRepository.fetchPostsByTag(
                    slug: entry.value.slug, page: page),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
