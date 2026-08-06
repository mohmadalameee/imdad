import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdad/shared/database/dao/item_dao.dart';
import 'package:imdad/shared/database/dao/employee_dao.dart';
import 'package:imdad/shared/database/dao/store_dao.dart';
import 'package:imdad/shared/database/dao/audit_dao.dart';

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
