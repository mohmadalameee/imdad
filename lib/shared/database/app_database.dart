import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';

/// قاعدة البيانات الرئيسية للتطبيق.
/// تتبع نمط Singleton وتدعم الترحيل المستقبلي.
class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  static Database? _database;

  /// الحصول على نسخة من قاعدة البيانات (فتحها إذا لزم الأمر).
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// تهيئة قاعدة البيانات مع دعم المنصات (Android, Windows, Web).
  Future<Database> _initDatabase() async {
    // دعم Windows عبر FFI
    if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path;
    if (Platform.isAndroid || Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      path = join(directory.path, 'imdad.db');
    } else if (Platform.isWindows) {
      final appData = Platform.environment['APPDATA']!;
      path = join(appData, 'imdad', 'imdad.db');
      // إنشاء المجلد إذا لم يكن موجوداً
      final dir = Directory(join(appData, 'imdad'));
      if (!await dir.exists()) await dir.create(recursive: true);
    } else {
      // Web (يستخدم IndexedDB عبر sqflite_common_ffi)
      path = 'imdad.db';
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// إنشاء الجداول لأول مرة.
  Future<void> _onCreate(Database db, int version) async {
    // جدول المستخدمين (يستخدم لتسجيل الدخول)
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        full_name TEXT NOT NULL,
        role TEXT NOT NULL,
        is_active INTEGER DEFAULT 1,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // جدول الموظفين
    await db.execute('''
      CREATE TABLE employees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        national_id TEXT UNIQUE NOT NULL,
        full_name TEXT NOT NULL,
        rank TEXT,
        department_id INTEGER,
        phone TEXT,
        email TEXT,
        hire_date TEXT,
        status TEXT DEFAULT 'active',
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // جدول الإدارات
    await db.execute('''
      CREATE TABLE departments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        code TEXT UNIQUE NOT NULL,
        description TEXT,
        parent_id INTEGER,
        is_active INTEGER DEFAULT 1
      )
    ''');

    // جدول المخازن
    await db.execute('''
      CREATE TABLE warehouses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        code TEXT UNIQUE NOT NULL,
        location TEXT,
        manager_id INTEGER,
        is_active INTEGER DEFAULT 1
      )
    ''');

    // جدول الأصناف (المخزون)
    await db.execute('''
      CREATE TABLE inventory_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        code TEXT UNIQUE NOT NULL,
        category TEXT,
        unit TEXT,
        quantity REAL DEFAULT 0,
        min_threshold REAL DEFAULT 0,
        max_threshold REAL DEFAULT 0,
        warehouse_id INTEGER,
        last_updated TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // جدول العهد (تسليم واستلام)
    await db.execute('''
      CREATE TABLE custody (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_id INTEGER NOT NULL,
        employee_id INTEGER NOT NULL,
        quantity REAL NOT NULL,
        custody_date TEXT NOT NULL,
        return_date TEXT,
        status TEXT DEFAULT 'active',
        notes TEXT
      )
    ''');

    // جدول المركبات
    await db.execute('''
      CREATE TABLE vehicles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plate_number TEXT UNIQUE NOT NULL,
        model TEXT,
        type TEXT,
        status TEXT DEFAULT 'available',
        driver_id INTEGER,
        warehouse_id INTEGER,
        notes TEXT
      )
    ''');

    // جدول الوقود
    await db.execute('''
      CREATE TABLE fuel_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicle_id INTEGER NOT NULL,
        fuel_type TEXT NOT NULL,
        quantity REAL NOT NULL,
        transaction_date TEXT DEFAULT CURRENT_TIMESTAMP,
        notes TEXT
      )
    ''');

    // جدول الأسلحة
    await db.execute('''
      CREATE TABLE weapons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        serial_number TEXT UNIQUE NOT NULL,
        weapon_type TEXT NOT NULL,
        caliber TEXT,
        status TEXT DEFAULT 'in_stock',
        assigned_to_id INTEGER,
        notes TEXT
      )
    ''');

    // جدول سجل العمليات (Audit Log)
    await db.execute('''
      CREATE TABLE audit_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        action TEXT NOT NULL,
        table_name TEXT,
        record_id INTEGER,
        old_value TEXT,
        new_value TEXT,
        timestamp TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // إدراج مستخدم افتراضي (admin)
    await db.insert('users', {
      'username': 'admin',
      'password': 'admin123', // في الإنتاج يجب تشفيرها
      'full_name': 'المدير العام',
      'role': 'admin',
      'is_active': 1,
    });
  }

  /// ترقية قاعدة البيانات (يُضاف لاحقاً).
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // سيتم إضافة ترحيلات لاحقة
  }

  /// إغلاق قاعدة البيانات عند الخروج.
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
