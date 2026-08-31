import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 루틴 공유 설정 화면.
///
/// 공유는 습관 단위가 아니라 **사용자 단위**다. 여기서 그룹을 고르면 내
/// 습관이 전부 공유되고, 개별 습관은 "비공개" 표시로만 예외를 둔다.
/// 습관마다 그룹을 지정하던 이전 방식은 습관 수에 비례해 설정 비용이
/// 늘어나서 폐기했다.
class RoutineShareSettingsScreen extends ConsumerStatefulWidget {
  const RoutineShareSettingsScreen({super.key});

  @override
  ConsumerState<RoutineShareSettingsScreen> createState() =>
      _RoutineShareSettingsScreenState();
}

class _RoutineShareSettingsScreenState
    extends ConsumerState<RoutineShareSettingsScreen> {
  /// 편집 중인 선택 상태. 서버 값을 처음 읽을 때 한 번만 초기화한다.
  Set<String>? _selected;
  bool _saving = false;

  void _initFrom(List<String> sharedGroupIds) {
    _selected ??= sharedGroupIds.toSet();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _saving = true);

    final ok = await ref
        .read(routineManagementProvider.notifier)
        .replaceShareGroups((_selected ?? const <String>{}).toList());

    if (!mounted) return;
    setState(() => _saving = false);

    if (!ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.routine_error_generic)));
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.routine_share_saved)));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final sharedAsync = ref.watch(routineShareGroupsProvider);
    final myGroups = ref.watch(myGroupsProvider).valueOrNull ?? [];

    // 앱바 액션 버튼은 앱바 전경색을 따라야 한다. 기본 TextButton 색은
    // primary인데 라이트 모드 앱바 배경도 primary라 보이지 않는다.
    final appBarForeground =
        Theme.of(context).appBarTheme.foregroundColor ??
        Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.routine_share_title),
        actions: [
          TextButton(
            onPressed: _saving || _selected == null ? null : _save,
            style: TextButton.styleFrom(foregroundColor: appBarForeground),
            child: _saving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: appBarForeground,
                    ),
                  )
                : Text(MaterialLocalizations.of(context).saveButtonLabel),
          ),
          const SizedBox(width: AppSizes.spaceS),
        ],
      ),
      body: sharedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorState(
          error: error,
          title: l10n.routine_error_generic,
          onRetry: () => ref.invalidate(routineShareGroupsProvider),
        ),
        data: (shared) {
          _initFrom(shared.map((e) => e.groupId).toList());

          if (myGroups.isEmpty) {
            return AppEmptyState(
              icon: Icons.groups_outlined,
              message: l10n.routine_share_no_groups,
            );
          }

          final selected = _selected ?? const <String>{};

          return ListView(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            children: [
              Text(
                l10n.routine_share_screen_desc,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSizes.spaceXS),
              Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSizes.spaceXS),
                  Expanded(
                    child: Text(
                      l10n.routine_share_private_note,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceM),
              Card(
                child: Column(
                  children: [
                    for (final group in myGroups)
                      CheckboxListTile(
                        value: selected.contains(group.id),
                        onChanged: (value) => setState(() {
                          final next = Set<String>.from(selected);
                          if (value == true) {
                            next.add(group.id);
                          } else {
                            next.remove(group.id);
                          }
                          _selected = next;
                        }),
                        title: Text(group.name),
                        secondary: const Icon(Icons.groups_outlined),
                      ),
                  ],
                ),
              ),
              if (selected.isEmpty) ...[
                const SizedBox(height: AppSizes.spaceM),
                Text(
                  l10n.routine_share_none,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
