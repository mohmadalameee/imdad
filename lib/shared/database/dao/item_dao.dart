import '../app_database.dart';
import 'package:sqflite/sqflite.dart';

class ItemDao {
  final AppDatabase db;
  ItemDao(this.db);

  Future<Database> get database async => await db.database;

  Future<List<Map<String, Object?>>> getAll() async {
    final d = await database;
    return await d.query('inventory_items', orderBy: 'id DESC');
  }

  Future<Map<String, Object?>?> getById(int id) async {
    final d = await database;
    final rows = await d.query('inventory_items', where: 'id = ?', whereArgs: [id]);
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<int> insert(Map<String, Object?> data) async {
    final d = await database;
    return await d.insert('inventory_items', data);
  }

  Future<int> update(int id, Map<String, Object?> data) async {
    final d = await database;
    return await d.update('inventory_items', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    final d = await database;
    return await d.delete('inventory_items', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> count() async {
    final d = await database;
    final res = await d.rawQuery('SELECT COUNT(*) as c FROM inventory_items');
    return (res.isNotEmpty) ? (res.first['c'] as int) : 0;
  }

  Future<int> lowStockCount() async {
    final d = await database;
    final res = await d.rawQuery('SELECT COUNT(*) as c FROM inventory_items WHERE quantity <= min_threshold');
    return (res.isNotEmpty) ? (res.first['c'] as int) : 0;
  }
}
