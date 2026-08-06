import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('التقارير')),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            ListTile(leading: const Icon(Icons.pie_chart), title: const Text('تقرير المخزون'), onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('قيد التطوير')))),
            ListTile(leading: const Icon(Icons.assignment), title: const Text('تقرير الحركات'), onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('قيد التطوير')))),
            ListTile(leading: const Icon(Icons.person), title: const Text('تقرير الموظفين'), onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('قيد التطوير')))),
          ]),
        ),
      ),
    );
  }
}
