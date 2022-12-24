import 'dart:async';

import 'package:tabnews_app/shared/models/post.dart';
import 'package:tabnews_app/shared/repositories/database.dart';

class FavoritesListStream {
  final List<Post> favorites;

  FavoritesListStream(this.favorites);
}

class FavoritesRepository {
  static final _instance = FavoritesRepository._internal();
  late List<Post> favorites;

  factory FavoritesRepository() {
    return _instance;
  }

  FavoritesRepository._internal();

  final baseUrl = "https://www.tabnews.com.br/api/v1/contents";
  static const tableName = 'favorites';

  final StreamController<FavoritesListStream> _stream =
      StreamController<FavoritesListStream>.broadcast();

  Stream<FavoritesListStream> get stream => _stream.stream;

  Map<String, dynamic> _postToMap(Post post) {
    return {
      'id': post.id,
      'slug': post.slug,
      'title': post.title,
      'body': post.body,
      'owner_username': post.ownerUsername,
    };
  }

  Future<void> addFavorite(Post post) async {
    final db = await getDb();
    await db.insert(tableName, _postToMap(post));
    fetchFavorites();
  }

  Future<void> removeFavorite(Post post) async {
    final db = await getDb();
    await db.delete(tableName, where: 'id = ?', whereArgs: [post.id]);
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    final db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    favorites = maps.map((e) => Post.fromJson(e)).toList();
    _stream.add(FavoritesListStream(favorites));
  }

  Future<bool> isPostFavorite(Post post) async {
    final db = await getDb();
    final result =
        await db.query(tableName, where: 'id = ?', whereArgs: [post.id]);
    return result.isNotEmpty;
  }
}
