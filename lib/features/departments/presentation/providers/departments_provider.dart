import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdad/shared/database/dao/department_dao.dart';

final departmentsProvider = StateNotifierProvider<DepartmentsNotifier, AsyncValue<List<Map<String, Object?>>>>(
  (ref) => DepartmentsNotifier(ref.read),
);

class DepartmentsNotifier extends StateNotifier<AsyncValue<List<Map<String, Object?>>>> {
  final Reader _read;
  DepartmentsNotifier(this._read) : super(const AsyncValue.loading()) {
    load();
  }

  DepartmentDao get _dao => _read(departmentDaoProvider);

  Future<void> load() async {
    try {
      state = const AsyncValue.loading();
      final rows = await _dao.getAll();
      state = AsyncValue.data(rows);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<int> add(Map<String, Object?> dept) async {
    final id = await _dao.insert(dept);
    await load();
    return id;
  }

  Future<int> update(int id, Map<String, Object?> dept) async {
    final cnt = await _dao.update(id, dept);
    await load();
    return cnt;
  }

  Future<int> delete(int id) async {
    final cnt = await _dao.delete(id);
    await load();
    return cnt;
  }
}
