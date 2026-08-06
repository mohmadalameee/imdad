import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdad/core/di/injection.dart';
import 'package:imdad/shared/database/app_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BackupScreen extends ConsumerWidget {
  const BackupScreen({super.key});

  Future<String> _createBackup() async {
    final db = getIt<AppDatabase>();
    final database = await db.database;

    final employees = await database.query('employees');
    final items = await database.query('inventory_items');
    final content = {
      'employees': employees,
      'inventory_items': items,
    };

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/imdad-backup-${DateTime.now().toIso8601String()}.json';
    final f = File(path);
    await f.writeAsString(content.toString());
    return path;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('النسخ الاحتياطي')),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            const Text('إنشاء نسخة احتياطية و مشاركتها/حفظها.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final path = await _createBackup();
                await Share.shareXFiles([XFile(path)], text: 'نسخة احتياطية لنظام IMDAD');
              },
              child: const Text('إنشاء و مشاركة النسخة الاحتياطية'),
            ),
          ]),
        ),
      ),
    );
  }
}
