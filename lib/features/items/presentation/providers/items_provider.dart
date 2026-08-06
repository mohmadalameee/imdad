import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdad/shared/database/dao/item_dao.dart';

final itemsProvider = StateNotifierProvider<ItemsNotifier, AsyncValue<List<Map<String, Object?>>>>(
  (ref) => ItemsNotifier(ref.read),
);

class ItemsNotifier extends StateNotifier<AsyncValue<List<Map<String, Object?>>>> {
  final Reader _read;
  ItemsNotifier(this._read) : super(const AsyncValue.loading()) {
    load();
  }

  ItemDao get _dao => _read(itemDaoProvider);

  Future<void> load() async {
    try {
      state = const AsyncValue.loading();
      final rows = await _dao.getAll();
      state = AsyncValue.data(rows);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<int> add(Map<String, Object?> item) async {
    final id = await _dao.insert(item);
    await load();
    return id;
  }

  Future<int> update(int id, Map<String, Object?> item) async {
    final cnt = await _dao.update(id, item);
    await load();
    return cnt;
  }

  Future<int> delete(int id) async {
    final cnt = await _dao.delete(id);
    await load();
    return cnt;
  }
}
