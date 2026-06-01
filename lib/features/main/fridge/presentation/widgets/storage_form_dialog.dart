import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';

class StorageFormDialog extends ConsumerStatefulWidget {
  final StorageModel? storage;
  const StorageFormDialog({super.key, this.storage});

  @override
  ConsumerState<StorageFormDialog> createState() => _StorageFormDialogState();
}

class _StorageFormDialogState extends ConsumerState<StorageFormDialog> {
  final _nameController = TextEditingController();
  StorageType _type = StorageType.fridge;
  bool _loading = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    if (widget.storage != null) {
      _nameController.text = widget.storage!.name;
      _type = widget.storage!.type;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    setState(() => _loading = true);
    try {
      final groupId = ref.read(fridgeSelectedGroupIdProvider);
      if (widget.storage == null) {
        await ref.read(storagesProvider.notifier).create(
              CreateStorageDto(
                groupId: groupId ?? '',
                name: name,
                type: _type,
              ),
            );
      } else {
        await ref.read(storagesProvider.notifier).edit(
              widget.storage!.id,
              UpdateStorageDto(name: name, type: _type),
            );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _errorMsg = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.storage != null;

    return AlertDialog(
      title: Text(isEdit ? l10n.fridge_storage_edit : l10n.fridge_storage_add),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.fridge_item_name,
              hintText: l10n.fridge_storage_name_hint,
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          if (_errorMsg != null) ...[
            const SizedBox(height: AppSizes.spaceXS),
            Text(
              _errorMsg!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
          const SizedBox(height: AppSizes.spaceM),
          SegmentedButton<StorageType>(
            segments: [
              ButtonSegment(
                value: StorageType.fridge,
                label: Text(l10n.fridge_storage_type_fridge),
                icon: const Icon(Icons.kitchen_outlined),
              ),
              ButtonSegment(
                value: StorageType.freezer,
                label: Text(l10n.fridge_storage_type_freezer),
                icon: const Icon(Icons.ac_unit_outlined),
              ),
              ButtonSegment(
                value: StorageType.pantry,
                label: Text(l10n.fridge_storage_type_pantry),
                icon: const Icon(Icons.shelves),
              ),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: Text(l10n.common_cancel),
        ),
        FilledButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEdit ? l10n.common_save : l10n.common_add),
        ),
      ],
    );
  }
}
