import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tabnews_app/posts_list/posts_list_view.dart';
import 'package:tabnews_app/extensions/dark_mode.dart';
import 'package:tabnews_app/shared/repositories/post_repository.dart';

class UserPostsView extends StatelessWidget {
  final String username;

  const UserPostsView({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final postRepository = PostRepository();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              context.isDarkMode
                  ? 'lib/assets/logo.svg'
                  : 'lib/assets/logo-dark.svg',
              semanticsLabel: 'TabNews',
            ),
            const SizedBox(width: 10.0),
            Text(username),
          ],
        ),
        foregroundColor: context.isDarkMode ? Colors.white : Colors.black,
        centerTitle: false,
      ),
      body: PostsListView(
        fetchPosts: (page) =>
            postRepository.fetchPosts(username: username, page: page),
      ),
    );
  }
}
