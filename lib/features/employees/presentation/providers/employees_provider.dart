import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdad/shared/database/dao/employee_dao.dart';

final employeesProvider = StateNotifierProvider<EmployeesNotifier, AsyncValue<List<Map<String, Object?>>>>(
  (ref) => EmployeesNotifier(ref.read),
);

class EmployeesNotifier extends StateNotifier<AsyncValue<List<Map<String, Object?>>>> {
  final Reader _read;
  EmployeesNotifier(this._read) : super(const AsyncValue.loading()) {
    load();
  }

  EmployeeDao get _dao => _read(employeeDaoProvider);

  Future<void> load() async {
    try {
      state = const AsyncValue.loading();
      final rows = await _dao.getAll();
      state = AsyncValue.data(rows);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<int> add(Map<String, Object?> employee) async {
    final id = await _dao.insert(employee);
    await load();
    return id;
  }

  Future<int> update(int id, Map<String, Object?> employee) async {
    final cnt = await _dao.update(id, employee);
    await load();
    return cnt;
  }

  Future<int> delete(int id) async {
    final cnt = await _dao.delete(id);
    await load();
    return cnt;
  }
}
