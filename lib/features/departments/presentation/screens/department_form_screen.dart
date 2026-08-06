import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdad/features/departments/presentation/providers/departments_provider.dart';

class DepartmentFormScreen extends ConsumerStatefulWidget {
  final int? departmentId;
  const DepartmentFormScreen({super.key, this.departmentId});

  @override
  ConsumerState<DepartmentFormScreen> createState() => _DepartmentFormScreenState();
}

class _DepartmentFormScreenState extends ConsumerState<DepartmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _codeCtl = TextEditingController();
  final _descCtl = TextEditingController();
  bool _isEdit = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.departmentId != null;
    if (_isEdit) _load();
  }

  Future<void> _load() async {
    final s = ref.read(departmentsProvider);
    if (s is AsyncData) {
      final rows = s.value;
      final item = rows.firstWhere((r) => r['id'] == widget.departmentId, orElse: () => {});
      _nameCtl.text = item['name']?.toString() ?? '';
      _codeCtl.text = item['code']?.toString() ?? '';
      _descCtl.text = item['description']?.toString() ?? '';
    } else {
      await ref.read(departmentsProvider.notifier).load();
      _load();
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final data = {
      'name': _nameCtl.text.trim(),
      'code': _codeCtl.text.trim(),
      'description': _descCtl.text.trim(),
      'is_active': 1,
    };
    try {
      if (_isEdit) {
        await ref.read(departmentsProvider.notifier).update(widget.departmentId!, data);
      } else {
        await ref.read(departmentsProvider.notifier).add(data);
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
    _descCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(_isEdit ? 'تعديل إدارة' : 'إضافة إدارة')),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(controller: _nameCtl, decoration: const InputDecoration(labelText: 'اسم الإدارة'), validator: (v) => v == null || v.trim().isEmpty ? 'مطلوب' : null),
                const SizedBox(height: 8),
                TextFormField(controller: _codeCtl, decoration: const InputDecoration(labelText: 'كود الإدارة'), validator: (v) => v == null || v.trim().isEmpty ? 'مطلوب' : null),
                const SizedBox(height: 8),
                TextFormField(controller: _descCtl, decoration: const InputDecoration(labelText: 'الوصف')),
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
