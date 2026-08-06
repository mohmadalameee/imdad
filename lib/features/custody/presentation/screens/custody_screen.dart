import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdad/shared/database/dao/custody_dao.dart';

class CustodyScreen extends ConsumerStatefulWidget {
  const CustodyScreen({super.key});

  @override
  ConsumerState<CustodyScreen> createState() => _CustodyScreenState();
}

class _CustodyScreenState extends ConsumerState<CustodyScreen> {
  List<Map<String, Object?>> _records = [];
  bool _loading = true;

  Future<CustodyDao> get _dao async => Future.value(ref.read(custodyDaoProvider));

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final dao = await _dao;
    final rows = await dao.getAll();
    setState(() {
      _records = rows;
      _loading = false;
    });
  }

  Future<void> _openIssueDialog() async {
    final itemCtl = TextEditingController();
    final empCtl = TextEditingController();
    final qtyCtl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('صرف عهدة'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: itemCtl, decoration: const InputDecoration(labelText: 'معرف الصنف')),
            TextField(controller: empCtl, decoration: const InputDecoration(labelText: 'معرف الموظف')),
            TextField(controller: qtyCtl, decoration: const InputDecoration(labelText: 'الكمية'), keyboardType: TextInputType.number),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('صرف')),
          ],
        ),
      ),
    );

    if (ok == true) {
      final dao = await _dao;
      await dao.insert({
        'item_id': int.tryParse(itemCtl.text.trim()) ?? 0,
        'employee_id': int.tryParse(empCtl.text.trim()) ?? 0,
        'quantity': double.tryParse(qtyCtl.text.trim()) ?? 0,
        'custody_date': DateTime.now().toIso8601String(),
        'status': 'active',
      });
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('العهد والحركات')),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _records.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, idx) {
                  final r = _records[idx];
                  return ListTile(
                    title: Text('الصنف: ${r['item_id'] ?? '-'} - الموظف: ${r['employee_id'] ?? '-'}'),
                    subtitle: Text('كمية: ${r['quantity'] ?? '-'} - الحالة: ${r['status'] ?? '-'}'),
                    trailing: Text(r['custody_date']?.toString() ?? ''),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(onPressed: _openIssueDialog, child: const Icon(Icons.add_chart)),
      ),
    );
  }
}
