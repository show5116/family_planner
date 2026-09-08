import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/widgets/color_picker.dart';
import 'package:family_planner/features/settings/roles/models/common_role.dart';
import 'package:family_planner/features/settings/roles/providers/common_role_provider.dart';

/// 공통 역할 생성 다이얼로그
class CommonRoleCreateDialog {
  static Future<void> show(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (context) => _CommonRoleFormDialog(ref: ref),
    );
  }
}

/// 공통 역할 수정 다이얼로그
class CommonRoleEditDialog {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    CommonRole role,
  ) {
    return showDialog(
      context: context,
      builder: (context) => _CommonRoleFormDialog(ref: ref, role: role),
    );
  }
}

class _CommonRoleFormDialog extends StatefulWidget {
  const _CommonRoleFormDialog({required this.ref, this.role});

  final WidgetRef ref;
  final CommonRole? role;

  @override
  State<_CommonRoleFormDialog> createState() => _CommonRoleFormDialogState();
}

class _CommonRoleFormDialogState extends State<_CommonRoleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late bool _isDefaultRole;
  Color? _selectedColor;
  bool _isSaving = false;
  String? _errorMsg;

  bool get _isEdit => widget.role != null;

  @override
  void initState() {
    super.initState();
    final role = widget.role;
    _nameController = TextEditingController(text: role?.name ?? '');
    _isDefaultRole = role?.isDefaultRole ?? false;
    _selectedColor = role?.color != null
        ? Color(int.parse(role!.color!.substring(1), radix: 16) + 0xFF000000)
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _colorHex(Color c) =>
      '#${c.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _errorMsg = null;
    });

    try {
      final notifier = widget.ref.read(commonRoleProvider.notifier);
      final colorHex = _selectedColor != null
          ? _colorHex(_selectedColor!)
          : null;

      if (_isEdit) {
        await notifier.updateRole(
          widget.role!.id,
          name: _nameController.text.trim(),
          isDefaultRole: _isDefaultRole,
          color: colorHex,
        );
      } else {
        await notifier.createRole(
          name: _nameController.text.trim(),
          isDefaultRole: _isDefaultRole,
          color: colorHex,
        );
      }

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEdit ? l10n.role_updated : l10n.role_created),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _errorMsg = _isEdit
            ? '${l10n.role_update_failed}\n$e'
            : '${l10n.role_create_failed}\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(_isEdit ? l10n.role_edit_title : l10n.role_create_title),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.role_field_name,
                  hintText: _isEdit ? null : l10n.role_field_name_hint,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.role_field_name_required;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spaceM),
              CheckboxListTile(
                title: Text(l10n.role_default),
                subtitle: Text(l10n.role_default_desc),
                value: _isDefaultRole,
                onChanged: _isSaving
                    ? null
                    : (value) =>
                          setState(() => _isDefaultRole = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: AppSizes.spaceM),
              Text(
                l10n.role_color,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSizes.spaceS),
              ColorPicker(
                selectedColor: _selectedColor,
                onColorSelected: _isSaving
                    ? (_) {}
                    : (color) => setState(() => _selectedColor = color),
              ),
              if (_errorMsg != null) ...[
                const SizedBox(height: AppSizes.spaceS),
                Text(
                  _errorMsg!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: Text(l10n.common_cancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _handleSave,
          child: Text(_isEdit ? l10n.common_save : l10n.common_create),
        ),
      ],
    );
  }
}
