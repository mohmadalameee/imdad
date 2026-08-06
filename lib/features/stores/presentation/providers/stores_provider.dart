import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdad/shared/database/dao/store_dao.dart';

final storesProvider = StateNotifierProvider<StoresNotifier, AsyncValue<List<Map<String, Object?>>>>(
  (ref) => StoresNotifier(ref.read),
);

class StoresNotifier extends StateNotifier<AsyncValue<List<Map<String, Object?>>>> {
  final Reader _read;
  StoresNotifier(this._read) : super(const AsyncValue.loading()) {
    load();
  }

  StoreDao get _dao => _read(storeDaoProvider);

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

  Future<int> update(int id, Map<String, Object?> store) async {
    final cnt = await _dao.update(id, store);
    await load();
    return cnt;
  }

  Future<int> delete(int id) async {
    final cnt = await _dao.delete(id);
    await load();
    return cnt;
  }
}
