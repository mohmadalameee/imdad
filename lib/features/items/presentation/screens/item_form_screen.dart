import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:imdad/features/items/presentation/providers/items_provider.dart';

class ItemFormScreen extends ConsumerStatefulWidget {
  final int? itemId;
  const ItemFormScreen({super.key, this.itemId});

  @override
  ConsumerState<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends ConsumerState<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _codeCtl = TextEditingController();
  final _unitCtl = TextEditingController();
  final _quantityCtl = TextEditingController();

  bool _isEdit = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.itemId != null;
    if (_isEdit) _load();
  }

  Future<void> _load() async {
    final s = ref.read(itemsProvider);
    if (s is AsyncData) {
      final rows = s.value;
      final item = rows.firstWhere((r) => r['id'] == widget.itemId, orElse: () => {});
      _nameCtl.text = item['name']?.toString() ?? '';
      _codeCtl.text = item['code']?.toString() ?? '';
      _unitCtl.text = item['unit']?.toString() ?? '';
      _quantityCtl.text = (item['quantity']?.toString() ?? '');
    } else {
      await ref.read(itemsProvider.notifier).load();
      _load();
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final data = {
      'name': _nameCtl.text.trim(),
      'code': _codeCtl.text.trim(),
      'unit': _unitCtl.text.trim(),
      'quantity': double.tryParse(_quantityCtl.text.trim()) ?? 0,
      'last_updated': DateTime.now().toIso8601String(),
    };
    try {
      if (_isEdit) {
        await ref.read(itemsProvider.notifier).update(widget.itemId!, data);
      } else {
        await ref.read(itemsProvider.notifier).add(data);
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
    _unitCtl.dispose();
    _quantityCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(_isEdit ? 'تعديل صنف' : 'إضافة صنف')),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(controller: _nameCtl, decoration: const InputDecoration(labelText: 'اسم الصنف'), validator: (v) => v == null || v.trim().isEmpty ? 'مطلوب' : null),
                const SizedBox(height: 8),
                TextFormField(controller: _codeCtl, decoration: const InputDecoration(labelText: 'الكود')),
                const SizedBox(height: 8),
                TextFormField(controller: _unitCtl, decoration: const InputDecoration(labelText: 'الوحدة')),
                const SizedBox(height: 8),
                TextFormField(controller: _quantityCtl, decoration: const InputDecoration(labelText: 'الكمية'), keyboardType: TextInputType.number),
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
