import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/stores_provider.dart';

class StoreFormScreen extends ConsumerStatefulWidget {
  final int? storeId;

  const StoreFormScreen({
    super.key,
    this.storeId,
  });

  @override
  ConsumerState<StoreFormScreen> createState() =>
      _StoreFormScreenState();
}

class _StoreFormScreenState
    extends ConsumerState<StoreFormScreen> {

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _locationController = TextEditingController();

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    if (widget.storeId != null) {
      _loadStore();
    }
  }

  Future<void> _loadStore() async {
    final data = ref.read(storesProvider);

    if (data is AsyncData) {
      final rows = data.value;

      if (rows == null) return;

      for (final item in rows) {
        if (item['id'] == widget.storeId) {
          _nameController.text =
              item['name']?.toString() ?? '';

          _codeController.text =
              item['code']?.toString() ?? '';

          _locationController.text =
              item['location']?.toString() ?? '';

          break;
        }
      }
    }
  }

  Future<void> _save() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final data = {
      'name': _nameController.text,
      'code': _codeController.text,
      'location': _locationController.text,
    };

    if (widget.storeId == null) {
      await ref.read(storesProvider.notifier).add(data);
    } else {
      await ref.read(storesProvider.notifier).update(
        widget.storeId!,
        data,
      );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.storeId == null
              ? 'إضافة مخزن'
              : 'تعديل مخزن',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم المخزن',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'أدخل اسم المخزن';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'رمز المخزن',
                ),
              ),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'الموقع',
                ),
              ),

              const SizedBox(height:20),

              _saving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _save,
                      child: const Text('حفظ'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
