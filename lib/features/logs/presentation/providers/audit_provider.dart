import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdad/shared/database/app_database.dart';
import 'package:imdad/shared/database/dao/audit_dao.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final auditDaoProvider = Provider<AuditDao>((ref) {
  return AuditDao(
    ref.read(appDatabaseProvider),
  );
});

