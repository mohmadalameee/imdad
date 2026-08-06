import '../app_database.dart';
import 'package:sqflite/sqflite.dart';

class DepartmentDao {
  final AppDatabase db;
  DepartmentDao(this.db);

  Future<Database> get database async => await db.database;

  Future<List<Map<String, Object?>>> getAll() async {
    final d = await database;
    return await d.query('departments', orderBy: 'id DESC');
  }

  Future<Map<String, Object?>?> getById(int id) async {
    final d = await database;
    final rows = await d.query('departments', where: 'id = ?', whereArgs: [id]);
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<int> insert(Map<String, Object?> data) async {
    final d = await database;
    return await d.insert('departments', data);
  }

  Future<int> update(int id, Map<String, Object?> data) async {
    final d = await database;
    return await d.update('departments', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    final d = await database;
    return await d.delete('departments', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> count() async {
    final d = await database;
    final res = await d.rawQuery('SELECT COUNT(*) as c FROM departments');
    return (res.isNotEmpty) ? (res.first['c'] as int) : 0;
  }
}
