import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tabnews_app/shared/repositories/favorites_repository.dart';
import 'package:tabnews_app/shared/repositories/search_repository.dart';

Future<Database> getDb() async {
  const favoritesTable = FavoritesRepository.tableName;
  const recentSearchTable = SearchRepository.tableName;

  return openDatabase(join(await getDatabasesPath(), 'main.db'),
      onCreate: (db, version) async {
    await db.execute(
      'CREATE TABLE $favoritesTable(id TEXT PRIMARY KEY, slug TEXT, title TEXT, body TEXT, owner_username TEXT, published_at TEXT)',
    );
    await db.execute(
      'CREATE TABLE $recentSearchTable(id INTEGER PRIMARY KEY AUTOINCREMENT, term TEXT)',
    );
  }, version: 1);
}
