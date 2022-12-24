import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tabnews_app/shared/models/post.dart';
import 'package:tabnews_app/shared/repositories/database.dart';

class SearchRepository {
  final baseUrl =
      "https://u2s48iwq23.execute-api.us-east-1.amazonaws.com/search";
  static const tableName = 'recent_search';

  Future<List<Post>> search(String term, {int page = 1}) async {
    final url = '$baseUrl?term=$term&page=$page';
    final response = await http.get(Uri.parse(url));
    final List parsedResponse = jsonDecode(response.body);
    return parsedResponse.map((e) => Post.fromJson(e)).toList();
  }

  Future<void> addSearch(String term) async {
    await removeSearch(term);
    final db = await getDb();
    await db.insert(tableName, {'term': term});
  }

  Future<void> removeSearch(String term) async {
    final db = await getDb();
    await db.delete(tableName, where: 'term = ?', whereArgs: [term]);
  }

  Future<void> clearSearch() async {
    final db = await getDb();
    await db.delete(tableName);
  }

  Future<List<String>> getRecentSearchs() async {
    final db = await getDb();
    final List<Map<String, dynamic>> maps =
        await db.query(tableName, columns: ['term']);
    return maps.map<String>((e) => e['term']).toList();
  }
}
