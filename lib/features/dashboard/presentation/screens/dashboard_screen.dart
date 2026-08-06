import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdad/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:imdad/core/theme/app_theme.dart';
import 'package:imdad/features/authentication/presentation/providers/auth_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardProvider);
    final authState = ref.watch(authProvider);
    final userName = authState.user?.fullName ?? '';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة التحكم'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                context.go('/login');
              },
            )
          ],
        ),
        drawer: _buildDrawer(context),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: statsAsync.when(
            data: (stats) => SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('مرحبا، $userName', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('نظرة سريعة', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Wrap(spacing: 12, runSpacing: 12, children: [
                  _statCard(context, 'الموظفين', stats.totalEmployees.toString(), Icons.people, onTap: () => context.go('/employees')),
                  _statCard(context, 'المخازن', stats.totalStores.toString(), Icons.store, onTap: () => context.go('/stores')),
                  _statCard(context, 'الأصناف', stats.totalItems.toString(), Icons.inventory_2, onTap: () => context.go('/items')),
                  _statCard(context, 'تنبيهات منخفضة المخزون', stats.lowStockCount.toString(), Icons.warning, color: Colors.red, onTap: () => context.go('/items')),
                ]),
                const SizedBox(height: 20),
                Text('آخر الأحداث', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...stats.recentEvents.map((e) {
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(e['action']?.toString() ?? ''),
                    subtitle: Text(e['timestamp']?.toString() ?? ''),
                  );
                }).toList(),
              ]),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('حدث خطأ: $e')),
          ),
        ),
      ),
    );
  }

  Widget _statCard(BuildContext context, String title, String value, IconData icon, {Color? color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        child: SizedBox(
          width: 180,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                Icon(icon, color: color ?? Theme.of(context).primaryColor),
              ]),
              const SizedBox(height: 8),
              Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            ]),
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          decoration: BoxDecoration(color: AppTheme.primaryColor),
          child: const Align(
              alignment: Alignment.bottomLeft,
              child: Text('نظام IMDAD', style: TextStyle(color: Colors.white, fontSize: 18))),
        ),
        ListTile(leading: const Icon(Icons.dashboard), title: const Text('لوحة التحكم'), onTap: () => Navigator.pop(context)),
        ListTile(leading: const Icon(Icons.people), title: const Text('الموظفين'), onTap: () => context.go('/employees')),
        ListTile(leading: const Icon(Icons.apartment), title: const Text('الإدارات'), onTap: () => context.go('/departments')),
        ListTile(leading: const Icon(Icons.store), title: const Text('المخازن'), onTap: () => context.go('/stores')),
        ListTile(leading: const Icon(Icons.inventory_2), title: const Text('الأصناف'), onTap: () => context.go('/items')),
        ListTile(leading: const Icon(Icons.handshake), title: const Text('العهد والحركات'), onTap: () => context.go('/custody')),
        ListTile(leading: const Icon(Icons.report), title: const Text('التقارير'), onTap: () => context.go('/reports')),
        ListTile(leading: const Icon(Icons.save_alt), title: const Text('نسخ احتياطي'), onTap: () => context.go('/backup')),
        ListTile(leading: const Icon(Icons.list_alt), title: const Text('سجلات النظام'), onTap: () => context.go('/logs')),
      ]),
    );
  }
}
