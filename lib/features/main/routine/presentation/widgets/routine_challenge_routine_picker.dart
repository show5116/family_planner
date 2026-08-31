import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';

/// 챌린지에 연결할 내 습관을 고르는 바텀시트.
///
/// 선택한 습관 ID를 반환하고, 취소하면 null을 반환한다.
/// **비공개 습관은 목록에서 제외한다** — "함께 겨룬다"는 챌린지의 취지와
/// 맞지 않아 서버도 400으로 막는다.
Future<String?> showRoutineChallengeRoutinePicker(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizes.radiusLarge),
      ),
    ),
    builder: (_) => const _RoutinePickerSheet(),
  );
}

class _RoutinePickerSheet extends ConsumerWidget {
  const _RoutinePickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final routines = ref.watch(routineListProvider(null)).valueOrNull;

    // 비공개 습관과 종료된 습관은 챌린지에 연결할 수 없다.
    final selectable = (routines ?? const <Routine>[])
        .where((r) => !r.isPrivate && r.status != RoutineStatus.ended)
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceL,
              AppSizes.spaceL,
              AppSizes.spaceL,
              AppSizes.spaceS,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.routine_challenge_select_routine,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSizes.spaceXS),
                Text(
                  l10n.routine_challenge_select_routine_desc,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: routines == null
                ? const Center(child: CircularProgressIndicator())
                : selectable.isEmpty
                ? AppEmptyState(
                    icon: Icons.checklist_outlined,
                    message: l10n.routine_challenge_no_routine,
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: selectable.length,
                    itemBuilder: (context, index) {
                      final routine = selectable[index];
                      return ListTile(
                        leading:
                            (routine.emoji != null && routine.emoji!.isNotEmpty)
                            ? Text(
                                routine.emoji!,
                                style: const TextStyle(fontSize: 20),
                              )
                            : const Icon(Icons.check_circle_outline),
                        title: Text(
                          routine.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        onTap: () => Navigator.pop(context, routine.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
