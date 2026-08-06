import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdad/features/items/presentation/providers/items_provider.dart';

class ItemsListScreen extends ConsumerWidget {
  const ItemsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(itemsProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الأصناف')),
        body: state.when(
          data: (rows) => ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: rows.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, idx) {
              final r = rows[idx];
              return ListTile(
                title: Text(r['name']?.toString() ?? ''),
                subtitle: Text('الكمية: ${r['quantity'] ?? 0} ${r['unit'] ?? ''}'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(icon: const Icon(Icons.edit), onPressed: () => context.go('/items/${r['id']}')),
                  IconButton(icon: const Icon(Icons.delete), onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => Directionality(
                        textDirection: TextDirection.rtl,
                        child: AlertDialog(
                          title: const Text('تأكيد الحذف'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حذف')),
                          ],
                        ),
                      ),
                    );
                    if (ok == true) {
                      await ref.read(itemsProvider.notifier).delete(r['id'] as int);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحذف')));
                    }
                  }),
                ]),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('خطأ: $e')),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () => context.go('/items/new'), child: const Icon(Icons.add)),
      ),
    );
  }
}
