import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdad/features/stores/presentation/providers/stores_provider.dart';

class StoreFormScreen extends ConsumerStatefulWidget {
  final int? storeId;
  const StoreFormScreen({super.key, this.storeId});

  @override
  ConsumerState<StoreFormScreen> createState() => _StoreFormScreenState();
}

class _StoreFormScreenState extends ConsumerState<StoreFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _codeCtl = TextEditingController();
  final _locationCtl = TextEditingController();
  bool _isEdit = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.storeId != null;
    if (_isEdit) _load();
  }

  Future<void> _load() async {
    final s = ref.read(storesProvider);
    if (s is AsyncData) {
      final rows = s.value;
      final item = rows.firstWhere((r) => r['id'] == widget.storeId, orElse: () => {});
      _nameCtl.text = item['name']?.toString() ?? '';
      _codeCtl.text = item['code']?.toString() ?? '';
      _locationCtl.text = item['location']?.toString() ?? '';
    } else {
      await ref.read(storesProvider.notifier).load();
      _load();
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final data = {
      'name': _nameCtl.text.trim(),
      'code': _codeCtl.text.trim(),
      'location': _locationCtl.text.trim(),
      'is_active': 1,
    };
    try {
      if (_isEdit) {
        await ref.read(storesProvider.notifier).update(widget.storeId!, data);
      } else {
        await ref.read(storesProvider.notifier).add(data);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم الحفظ')));
        context.pop();
      }
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _codeCtl.dispose();
    _locationCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(_isEdit ? 'تعديل مخزن' : 'إضافة مخزن')),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(controller: _nameCtl, decoration: const InputDecoration(labelText: 'اسم المخزن'), validator: (v) => v == null || v.trim().isEmpty ? 'مطلوب' : null),
                const SizedBox(height: 8),
                TextFormField(controller: _codeCtl, decoration: const InputDecoration(labelText: 'الكود')),
                const SizedBox(height: 8),
                TextFormField(controller: _locationCtl, decoration: const InputDecoration(labelText: 'الموقع')),
                const SizedBox(height: 16),
                _saving ? const Center(child: CircularProgressIndicator()) : ElevatedButton(onPressed: _save, child: const Text('حفظ')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
