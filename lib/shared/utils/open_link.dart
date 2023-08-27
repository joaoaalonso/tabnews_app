import 'package:flutter/material.dart';
import 'package:tabnews_app/post_details/post_details_view.dart';
import 'package:tabnews_app/user_posts/user_posts_view.dart';
import 'package:url_launcher/url_launcher.dart';

void openUrl(BuildContext context, String? url) async {
  if (url == null) return;

  final uri = Uri.parse(url);
  if ((uri.host == 'www.tabnews.com.br' || uri.host == '') &&
      uri.pathSegments.isNotEmpty) {
    if (uri.pathSegments.length > 1) {
      List<String> segments = uri.pathSegments;

      String username = segments[0];
      String slug = segments[1];

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PostDetailsView(
            username: username,
            slug: slug,
          ),
        ),
      );
    } else if (uri.pathSegments.isNotEmpty) {
      List<String> segments = uri.pathSegments;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UserPostsView(username: segments[0]),
        ),
      );
    }
  } else {
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.inAppWebView);
    }
  }
}
