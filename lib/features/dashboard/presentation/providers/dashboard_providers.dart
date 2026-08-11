import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdad/shared/database/dao/item_dao.dart';
import 'package:imdad/shared/database/dao/employee_dao.dart';
import 'package:imdad/shared/database/dao/store_dao.dart';
import 'package:imdad/shared/database/dao/audit_dao.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// تأكد من أن مسار استيراد ملف قاعدة البيانات لديك يطابق هذا المسار أو عدله حسب هيكل مشروعك:
import 'package:imdad/core/database/app_database.dart'; 

// 1. تعريف موفر قاعدة البيانات الأساسي (إذا لم يكن معرفاً مسبقاً)
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// 2. تعريف employeeDaoProvider
final employeeDaoProvider = Provider<EmployeeDao>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return database.employeeDao;
});

// 3. تعريف storeDaoProvider
final storeDaoProvider = Provider<StoreDao>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return database.storeDao;
});

// 4. تعريف auditDaoProvider
final auditDaoProvider = Provider<AuditDao>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return database.auditDao;
});


final dashboardProvider = FutureProvider<DashboardStats>((ref) async {
  final itemDao = ref.read(itemDaoProvider);
  final empDao = ref.read(employeeDaoProvider);
  final storeDao = ref.read(storeDaoProvider);
  final auditDao = ref.read(auditDaoProvider);

  final totalEmployees = await empDao.count();
  final totalStores = await storeDao.count();
  final totalItems = await itemDao.count();
  final lowStockCount = await itemDao.lowStockCount();
  final recentEventsData = await auditDao.recent(5);

  return DashboardStats(
    totalEmployees: totalEmployees,
    totalStores: totalStores,
    totalItems: totalItems,
    lowStockCount: lowStockCount,
    recentEvents: recentEventsData,
  );
});

class DashboardStats {
  final int totalEmployees;
  final int totalStores;
  final int totalItems;
  final int lowStockCount;
  final List<Map<String, Object?>> recentEvents;

  DashboardStats({
    required this.totalEmployees,
    required this.totalStores,
    required this.totalItems,
    required this.lowStockCount,
    required this.recentEvents,
  });
}
