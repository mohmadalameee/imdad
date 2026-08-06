import '../app_database.dart';
import 'package:sqflite/sqflite.dart';

class EmployeeDao {
  final AppDatabase db;
  EmployeeDao(this.db);

  Future<Database> get database async => await db.database;

  Future<List<Map<String, Object?>>> getAll() async {
    final d = await database;
    return await d.query('employees', orderBy: 'id DESC');
  }

  Future<Map<String, Object?>?> getById(int id) async {
    final d = await database;
    final rows = await d.query('employees', where: 'id = ?', whereArgs: [id]);
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<int> insert(Map<String, Object?> data) async {
    final d = await database;
    return await d.insert('employees', data);
  }

  Future<int> update(int id, Map<String, Object?> data) async {
    final d = await database;
    return await d.update('employees', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    final d = await database;
    return await d.delete('employees', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> count() async {
    final d = await database;
    final res = await d.rawQuery('SELECT COUNT(*) as c FROM employees');
    return (res.isNotEmpty) ? (res.first['c'] as int) : 0;
  }
}
