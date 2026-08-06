import '../app_database.dart';
import 'package:sqflite/sqflite.dart';

class StoreDao {
  final AppDatabase db;
  StoreDao(this.db);

  Future<Database> get database async => await db.database;

  Future<List<Map<String, Object?>>> getAll() async {
    final d = await database;
    return await d.query('warehouses', orderBy: 'id DESC');
  }

  Future<Map<String, Object?>?> getById(int id) async {
    final d = await database;
    final rows = await d.query('warehouses', where: 'id = ?', whereArgs: [id]);
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<int> insert(Map<String, Object?> data) async {
    final d = await database;
    return await d.insert('warehouses', data);
  }

  Future<int> update(int id, Map<String, Object?> data) async {
    final d = await database;
    return await d.update('warehouses', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    final d = await database;
    return await d.delete('warehouses', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> count() async {
    final d = await database;
    final res = await d.rawQuery('SELECT COUNT(*) as c FROM warehouses');
    return (res.isNotEmpty) ? (res.first['c'] as int) : 0;
  }
}
