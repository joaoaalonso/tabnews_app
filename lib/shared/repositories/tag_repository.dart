import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tabnews_app/shared/models/post.dart';
import 'package:tabnews_app/shared/models/tag.dart';

class TagRepository {
  static final _instance = TagRepository._internal();

  factory TagRepository() {
    return _instance;
  }

  TagRepository._internal();

  final baseUrl = "https://tn-search.s3.amazonaws.com/tags";

  Future<List<Post>> fetchPostsByTag(
      {required String slug, int page = 1}) async {
    final url = '$baseUrl/$slug/$page.json';
    final response = await http.get(Uri.parse(url));
    final List<dynamic> parsedResponse =
        jsonDecode(utf8.decode(response.bodyBytes));
    return parsedResponse.map((e) => Post.fromJson(e)).toList();
  }

  Future<List<Tag>> getAvailableTags() async {
    return [];
    // final url = '$baseUrl/available.json';
    // final response = await http.get(Uri.parse(url));
    // final List<dynamic> parsedResponse =
    //     jsonDecode(utf8.decode(response.bodyBytes));
    // return parsedResponse.map((e) => Tag.fromJson(e)).toList();
  }
}
