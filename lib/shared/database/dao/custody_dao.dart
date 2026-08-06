import '../app_database.dart';
import 'package:sqflite/sqflite.dart';

class CustodyDao {
  final AppDatabase db;
  CustodyDao(this.db);

  Future<Database> get database async => await db.database;

  Future<List<Map<String, Object?>>> getAll() async {
    final d = await database;
    return await d.query('custody', orderBy: 'id DESC');
  }

  Future<int> insert(Map<String, Object?> data) async {
    final d = await database;
    return await d.insert('custody', data);
  }
}
