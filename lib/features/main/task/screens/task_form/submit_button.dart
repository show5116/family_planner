import 'package:flutter/material.dart';

import 'package:family_planner/core/widgets/loading_button.dart';
import 'package:family_planner/features/main/task/providers/task_form_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 제출 버튼 위젯
class SubmitButton extends StatelessWidget {
  final TaskFormState formState;
  final VoidCallback onPressed;

  const SubmitButton({
    super.key,
    required this.formState,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return LoadingButton(
      isLoading: formState.isSubmitting,
      onPressed: onPressed,
      child: Text(
        formState.isEditMode ? l10n.common_save : l10n.schedule_add,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
