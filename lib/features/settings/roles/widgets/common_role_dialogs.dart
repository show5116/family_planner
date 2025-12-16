import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/color_picker.dart';
import 'package:family_planner/features/settings/roles/models/common_role.dart';
import 'package:family_planner/features/settings/roles/providers/common_role_provider.dart';

/// 공통 역할 생성 다이얼로그
class CommonRoleCreateDialog {
  static Future<void> show(BuildContext context, WidgetRef ref) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    bool isDefaultRole = false;
    Color? selectedColor;

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('공통 역할 생성'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: '역할 이름',
                      hintText: '예: ADMIN, MEMBER',
                      border: OutlineInputBorder(),
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
                    value: isDefaultRole,
                    onChanged: (value) {
                      setState(() {
                        isDefaultRole = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                  const Text(
                    '역할 색상',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  ColorPicker(
                    selectedColor: selectedColor,
                    onColorSelected: (color) {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    showRgbInput: false,
                    showAdvancedPicker: false,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    await ref.read(commonRoleProvider.notifier).createRole(
                          name: nameController.text.trim(),
                          isDefaultRole: isDefaultRole,
                          color: selectedColor != null
                              ? '#${selectedColor!.toARGB32().toRadixString(16).substring(2).toUpperCase()}'
                              : null,
                        );

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('역할이 생성되었습니다')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('생성 실패: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text('생성'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 공통 역할 수정 다이얼로그
class CommonRoleEditDialog {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    CommonRole role,
  ) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: role.name);
    bool isDefaultRole = role.isDefaultRole;
    Color? selectedColor = role.color != null
        ? Color(int.parse(role.color!.substring(1), radix: 16) + 0xFF000000)
        : null;

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('공통 역할 수정'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: '역할 이름',
                      border: OutlineInputBorder(),
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
                    value: isDefaultRole,
                    onChanged: (value) {
                      setState(() {
                        isDefaultRole = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                  const Text(
                    '역할 색상',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  ColorPicker(
                    selectedColor: selectedColor,
                    onColorSelected: (color) {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    showRgbInput: false,
                    showAdvancedPicker: false,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    await ref.read(commonRoleProvider.notifier).updateRole(
                          role.id,
                          name: nameController.text.trim(),
                          isDefaultRole: isDefaultRole,
                          color: selectedColor != null
                              ? '#${selectedColor!.toARGB32().toRadixString(16).substring(2).toUpperCase()}'
                              : null,
                        );

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('역할이 수정되었습니다')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('수정 실패: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}
