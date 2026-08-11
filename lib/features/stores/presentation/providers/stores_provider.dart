








import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:imdad/shared/database/app_database.dart';
import 'package:imdad/shared/database/dao/store_dao.dart';
import 'package:imdad/shared/database/dao/item_dao.dart';
import 'package:imdad/shared/database/dao/audit_dao.dart';


final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});


final storeDaoProvider = Provider<StoreDao>((ref) {
  return StoreDao(
    ref.read(appDatabaseProvider),
  );
});
final auditDaoProvider = Provider<AuditDao>((ref) {
  return AuditDao(
    ref.read(appDatabaseProvider),
  );
});


final itemDaoProvider = Provider<ItemDao>((ref) {
  return ItemDao(
    ref.read(appDatabaseProvider),
  );
});


final storesProvider = StateNotifierProvider<
    StoresNotifier,
    AsyncValue<List<Map<String, Object?>>>>(
  (ref) => StoresNotifier(
    ref.read(storeDaoProvider),
  ),
);


class StoresNotifier
    extends StateNotifier<AsyncValue<List<Map<String, Object?>>>> {

  final StoreDao _dao;

  StoresNotifier(this._dao)
      : super(const AsyncValue.loading()) {
    load();
  }


  Future<void> load() async {
    try {
      state = const AsyncValue.loading();

      final rows = await _dao.getAll();

      state = AsyncValue.data(rows);

    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }


  Future<int> add(Map<String, Object?> store) async {
    final id = await _dao.insert(store);
    await load();
    return id;
  }


  Future<int> update(
    int id,
    Map<String, Object?> store,
  ) async {

    final result = await _dao.update(id, store);

    await load();

    return result;
  }


  Future<int> delete(int id) async {

    final result = await _dao.delete(id);

    await load();

    return result;
  }
}
