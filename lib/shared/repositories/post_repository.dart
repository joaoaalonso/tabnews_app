import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tabnews_app/shared/models/post.dart';

class _PostCache {
  final Post post;
  final DateTime expireAt;

  _PostCache(this.expireAt, this.post);
}

class PostRepository {
  static final _instance = PostRepository._internal();

  factory PostRepository() {
    return _instance;
  }

  PostRepository._internal();

  final baseUrl = "https://www.tabnews.com.br/api/v1/contents";
  final cacheDurationInSeconds = 60;

  final Map<String, _PostCache> _cache = {};

  Future<List<Post>> fetchPosts(
      {int page = 1, String sort = 'relevant', String? username}) async {
    final url = '$baseUrl/${username ?? ''}?page=$page&strategy=$sort';
    final response = await http.get(Uri.parse(url));
    final List<dynamic> parsedResponse = jsonDecode(response.body);
    return parsedResponse.map((e) => Post.fromJson(e)).toList();
  }

  Future<Post> fetchPost(String username, String slug) async {
    final id = '$username/$slug';
    final cachedPost = _getPostFromCache(id);
    if (cachedPost != null) {
      return cachedPost;
    }

    final url = '$baseUrl/$id';
    final response = await http.get(Uri.parse(url));
    var post = Post.fromJson(jsonDecode(response.body));
    if (post.hasParent) {
      final results = await Future.wait([
        http.get(Uri.parse('$url/parent')),
        http.get(Uri.parse('$url/root'))
      ]);
      final parent = Post.fromJson(jsonDecode(results[0].body));
      final root = Post.fromJson(jsonDecode(results[1].body));
      post = post.copyWith(parent: parent, root: root);
    }
    _savePostToCache(id, post);
    return post;
  }

  Future<List<Post>> fetchPostComments(String username, String slug) async {
    final response =
        await http.get(Uri.parse('$baseUrl/$username/$slug/children'));
    final List<dynamic> parsedResponse = jsonDecode(response.body);
    return parsedResponse.map((e) => Post.fromJson(e)).toList();
  }

  void _savePostToCache(String id, Post post) {
    final expireAt =
        DateTime.now().add(Duration(seconds: cacheDurationInSeconds));
    _cache[id] = _PostCache(expireAt, post);
  }

  Post? _getPostFromCache(String id) {
    if (_cache[id] != null && DateTime.now().isBefore(_cache[id]!.expireAt)) {
      return _cache[id]!.post;
    } else {
      return null;
    }
  }
}
