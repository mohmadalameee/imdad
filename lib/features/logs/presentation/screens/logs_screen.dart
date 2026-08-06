import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdad/shared/database/dao/audit_dao.dart';

class LogsScreen extends ConsumerStatefulWidget {
  const LogsScreen({super.key});

  @override
  ConsumerState<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends ConsumerState<LogsScreen> {
  List<Map<String, Object?>> _logs = [];
  bool _loading = true;

  AuditDao get _dao => ref.read(auditDaoProvider);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final rows = await _dao.recent(500);
    setState(() {
      _logs = rows;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('سجلات النظام')),
        body: _loading ? const Center(child: CircularProgressIndicator()) : ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: _logs.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, idx) {
            final r = _logs[idx];
            return ListTile(
              title: Text(r['action']?.toString() ?? ''),
              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('المستخدم: ${r['user_id'] ?? '-'}'),
                Text('الجدول: ${r['table_name'] ?? '-'}'),
                Text('الوقت: ${r['timestamp'] ?? '-'}'),
              ]),
              isThreeLine: true,
            );
          },
        ),
      ),
    );
  }
}
