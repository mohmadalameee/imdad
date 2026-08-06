import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdad/features/employees/presentation/providers/employees_provider.dart';

class EmployeeFormScreen extends ConsumerStatefulWidget {
  final int? employeeId;
  const EmployeeFormScreen({super.key, this.employeeId});

  @override
  ConsumerState<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends ConsumerState<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nationalId = TextEditingController();
  final _fullName = TextEditingController();
  final _rank = TextEditingController();
  final _phone = TextEditingController();

  bool _isEdit = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.employeeId != null;
    if (_isEdit) _load();
  }

  Future<void> _load() async {
    final s = ref.read(employeesProvider);
    if (s is AsyncData) {
      final rows = s.value;
      final item = rows.firstWhere((r) => r['id'] == widget.employeeId, orElse: () => {});
      _nationalId.text = item['national_id']?.toString() ?? '';
      _fullName.text = item['full_name']?.toString() ?? '';
      _rank.text = item['rank']?.toString() ?? '';
      _phone.text = item['phone']?.toString() ?? '';
    } else {
      await ref.read(employeesProvider.notifier).load();
      _load();
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final data = {
      'national_id': _nationalId.text.trim(),
      'full_name': _fullName.text.trim(),
      'rank': _rank.text.trim(),
      'phone': _phone.text.trim(),
      'created_at': DateTime.now().toIso8601String(),
    };
    try {
      if (_isEdit) {
        await ref.read(employeesProvider.notifier).update(widget.employeeId!, data);
      } else {
        await ref.read(employeesProvider.notifier).add(data);
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
    _nationalId.dispose();
    _fullName.dispose();
    _rank.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(_isEdit ? 'تعديل موظف' : 'إضافة موظف')),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nationalId,
                  decoration: const InputDecoration(labelText: 'الهوية الوطنية'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _fullName,
                  decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'مطلوب' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(controller: _rank, decoration: const InputDecoration(labelText: 'الرتبة')),
                const SizedBox(height: 8),
                TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'الهاتف')),
                const SizedBox(height: 16),
                _saving
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(onPressed: _save, child: const Text('حفظ')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
