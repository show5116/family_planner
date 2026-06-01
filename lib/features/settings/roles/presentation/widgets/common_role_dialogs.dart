import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
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
    if (!_formKey.currentState!.validate()) return;

    setState(() { _isSaving = true; _errorMsg = null; });

    try {
      final notifier = widget.ref.read(commonRoleProvider.notifier);
      final colorHex = _selectedColor != null ? _colorHex(_selectedColor!) : null;

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
        SnackBar(content: Text(_isEdit ? '역할이 수정되었습니다' : '역할이 생성되었습니다')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _errorMsg = _isEdit ? '수정 실패: ${e.toString()}' : '생성 실패: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? '공통 역할 수정' : '공통 역할 생성'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '역할 이름',
                  hintText: _isEdit ? null : '예: ADMIN, MEMBER',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '역할 이름을 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spaceM),
              CheckboxListTile(
                title: const Text('기본 역할'),
                subtitle: const Text('신규 가입 시 자동으로 부여되는 역할'),
                value: _isDefaultRole,
                onChanged: _isSaving
                    ? null
                    : (value) => setState(() => _isDefaultRole = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: AppSizes.spaceM),
              const Text(
                '역할 색상',
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
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _handleSave,
          child: Text(_isEdit ? '저장' : '생성'),
        ),
      ],
    );
  }
}
