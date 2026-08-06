import '../app_database.dart';
import 'package:sqflite/sqflite.dart';

class AuditDao {
  final AppDatabase db;
  AuditDao(this.db);

  Future<Database> get database async => await db.database;

  Future<List<Map<String, Object?>>> recent(int limit) async {
    final d = await database;
    return await d.query('audit_log', orderBy: 'id DESC', limit: limit);
  }

  Future<int> insert(Map<String, Object?> data) async {
    final d = await database;
    return await d.insert('audit_log', data);
  }
}
