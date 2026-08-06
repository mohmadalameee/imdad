import 'dart:convert';
import '../app_database.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  final AppDatabase db;

  UserDao(this.db);

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final Database database = await db.database;
    final List<Map<String, dynamic>> result = await database.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final Database database = await db.database;
    return await database.insert('users', user);
  }

  // إضافة دوال أخرى (تحديث، حذف، قائمة) حسب الحاجة
}
