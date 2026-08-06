import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdad/features/stores/presentation/providers/stores_provider.dart';

class StoresListScreen extends ConsumerWidget {
  const StoresListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storesProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('المخازن')),
        body: state.when(
          data: (rows) => ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: rows.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, idx) {
              final r = rows[idx];
              return ListTile(
                title: Text(r['name']?.toString() ?? ''),
                subtitle: Text('موقع: ${r['location'] ?? '-'}'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(icon: const Icon(Icons.edit), onPressed: () => context.go('/stores/${r['id']}')),
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
                      await ref.read(storesProvider.notifier).delete(r['id'] as int);
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
        floatingActionButton: FloatingActionButton(onPressed: () => context.go('/stores/new'), child: const Icon(Icons.add)),
      ),
    );
  }
}
