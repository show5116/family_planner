import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 캘린더 AppBar용 그룹 필터 + 카테고리 필터
class CalendarGroupSelector extends ConsumerWidget {
  const CalendarGroupSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedGroupIds = ref.watch(selectedGroupIdsProvider);
    final includePersonal = ref.watch(includePersonalProvider);
    final selectedCategoryIds = ref.watch(selectedCategoryIdsProvider);
    final groupsAsync = ref.watch(myGroupsProvider);

    return groupsAsync.when(
      data: (groups) {
        final String groupDisplayText = _buildGroupDisplayText(
          l10n,
          selectedGroupIds,
          includePersonal,
          groups,
        );

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 그룹 필터 버튼
            InkWell(
              onTap: () => _showGroupFilterDialog(context, ref, groups),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceS,
                  vertical: AppSizes.spaceXS,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_outline, size: 18),
                    const SizedBox(width: AppSizes.spaceXS),
                    Text(
                      groupDisplayText,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Icon(Icons.arrow_drop_down, size: 20),
                  ],
                ),
              ),
            ),

            const SizedBox(width: AppSizes.spaceXS),

            // 카테고리 필터 버튼
            InkWell(
              onTap: () => _showCategoryFilterDialog(context, ref, groups),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceS,
                  vertical: AppSizes.spaceXS,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.label_outline,
                      size: 18,
                    ),
                    if (selectedCategoryIds.isNotEmpty) ...[
                      const SizedBox(width: AppSizes.spaceXS),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${selectedCategoryIds.length}',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => Text(l10n.nav_calendar),
      error: (error, stack) => Text(l10n.nav_calendar),
    );
  }

  String _buildGroupDisplayText(
    AppLocalizations l10n,
    List<String> selectedGroupIds,
    bool includePersonal,
    List<Group> groups,
  ) {
    final int selectedCount = selectedGroupIds.length + (includePersonal ? 1 : 0);

    // 전체 선택 (개인 + 모든 그룹)
    if (includePersonal && selectedGroupIds.length == groups.length) {
      return l10n.common_all;
    }

    // 아무것도 선택 안됨
    if (!includePersonal && selectedGroupIds.isEmpty) {
      return l10n.common_all;
    }

    // 하나만 선택됨
    if (selectedCount == 1) {
      if (includePersonal) {
        return l10n.schedule_personal;
      } else {
        final matchingGroups = groups.where((g) => g.id == selectedGroupIds.first);
        if (matchingGroups.isNotEmpty) {
          return matchingGroups.first.name;
        }
      }
    }

    // 2개 이상 선택됨: "첫번째 외 N개"
    String firstName;
    if (includePersonal) {
      firstName = l10n.schedule_personal;
    } else {
      final matchingGroups = groups.where((g) => g.id == selectedGroupIds.first);
      firstName = matchingGroups.isNotEmpty ? matchingGroups.first.name : '';
    }

    return '$firstName 외 ${selectedCount - 1}개';
  }

  void _showGroupFilterDialog(
    BuildContext context,
    WidgetRef ref,
    List<Group> groups,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLarge)),
      ),
      builder: (context) => _GroupFilterSheet(groups: groups),
    );
  }

  void _showCategoryFilterDialog(
    BuildContext context,
    WidgetRef ref,
    List<Group> groups,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLarge)),
      ),
      builder: (context) => _CategoryFilterSheet(groups: groups),
    );
  }
}

/// 그룹 필터 바텀 시트
class _GroupFilterSheet extends ConsumerStatefulWidget {
  final List<Group> groups;

  const _GroupFilterSheet({required this.groups});

  @override
  ConsumerState<_GroupFilterSheet> createState() => _GroupFilterSheetState();
}

class _GroupFilterSheetState extends ConsumerState<_GroupFilterSheet> {
  late List<String> _selectedGroupIds;
  late bool _includePersonal;

  @override
  void initState() {
    super.initState();
    _selectedGroupIds = List.from(ref.read(selectedGroupIdsProvider));
    _includePersonal = ref.read(includePersonalProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.group_title,
                  style: theme.textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceM),

            // 개인 일정 옵션
            CheckboxListTile(
              value: _includePersonal,
              onChanged: (value) {
                setState(() {
                  _includePersonal = value ?? true;
                });
              },
              title: Row(
                children: [
                  const Icon(Icons.person, size: 20),
                  const SizedBox(width: AppSizes.spaceS),
                  Text(l10n.schedule_personal),
                ],
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),

            if (widget.groups.isNotEmpty) ...[
              const Divider(),
              // 그룹 목록
              ...widget.groups.map((group) {
                final isSelected = _selectedGroupIds.contains(group.id);
                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedGroupIds.add(group.id);
                      } else {
                        _selectedGroupIds.remove(group.id);
                      }
                    });
                  },
                  title: Row(
                    children: [
                      Icon(
                        Icons.group,
                        size: 20,
                        color: _parseColor(group.defaultColor),
                      ),
                      const SizedBox(width: AppSizes.spaceS),
                      Expanded(
                        child: Text(
                          group.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                );
              }),
            ],

            const SizedBox(height: AppSizes.spaceM),

            // 적용 버튼
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _applyFilter,
                child: Text(l10n.common_confirm),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyFilter() {
    ref.read(selectedGroupIdsProvider.notifier).state = _selectedGroupIds;
    ref.read(includePersonalProvider.notifier).state = _includePersonal;
    Navigator.pop(context);
  }

  Color? _parseColor(String? colorHex) {
    if (colorHex == null) return null;
    return Color(
      int.parse('FF${colorHex.replaceFirst('#', '')}', radix: 16),
    );
  }
}

/// 카테고리 필터 바텀 시트 (그룹별 표시)
class _CategoryFilterSheet extends ConsumerStatefulWidget {
  final List<Group> groups;

  const _CategoryFilterSheet({required this.groups});

  @override
  ConsumerState<_CategoryFilterSheet> createState() => _CategoryFilterSheetState();
}

class _CategoryFilterSheetState extends ConsumerState<_CategoryFilterSheet> {
  late List<String> _selectedCategoryIds;

  @override
  void initState() {
    super.initState();
    _selectedCategoryIds = List.from(ref.read(selectedCategoryIdsProvider));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoryManagementProvider);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.category_management,
                    style: theme.textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      // 초기화 버튼
                      if (_selectedCategoryIds.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategoryIds.clear();
                            });
                          },
                          child: Text(l10n.common_delete),
                        ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceS),

              // 스크롤 가능한 영역
              Flexible(
                child: categoriesAsync.when(
                  data: (categories) {
                    if (categories.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizes.spaceL),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.label_off_outlined,
                                size: 48,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: AppSizes.spaceM),
                              Text(
                                l10n.category_empty,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // 그룹별로 카테고리 분류
                    final personalCategories =
                        categories.where((c) => c.groupId == null).toList();
                    final Map<String, List<CategoryModel>> groupCategories = {};

                    for (final group in widget.groups) {
                      final groupCats =
                          categories.where((c) => c.groupId == group.id).toList();
                      if (groupCats.isNotEmpty) {
                        groupCategories[group.id] = groupCats;
                      }
                    }

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 개인 카테고리
                          if (personalCategories.isNotEmpty) ...[
                            _buildSectionHeader(
                              theme,
                              l10n.schedule_personal,
                              Icons.person,
                              null,
                            ),
                            ...personalCategories.map(
                              (category) => _buildCategoryTile(category),
                            ),
                            const SizedBox(height: AppSizes.spaceM),
                          ],

                          // 그룹별 카테고리
                          ...widget.groups.map((group) {
                            final groupCats = groupCategories[group.id];
                            if (groupCats == null || groupCats.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader(
                                  theme,
                                  group.name,
                                  Icons.group,
                                  _parseColor(group.defaultColor),
                                ),
                                ...groupCats.map(
                                  (category) => _buildCategoryTile(category),
                                ),
                                const SizedBox(height: AppSizes.spaceM),
                              ],
                            );
                          }),
                        ],
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Center(
                    child: Text(
                      l10n.common_error,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.spaceM),

              // 적용 버튼
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _applyFilter,
                  child: Text(l10n.common_confirm),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    ThemeData theme,
    String title,
    IconData icon,
    Color? color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color ?? theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(CategoryModel category) {
    final isSelected = _selectedCategoryIds.contains(category.id);
    return CheckboxListTile(
      value: isSelected,
      onChanged: (value) {
        setState(() {
          if (value == true) {
            _selectedCategoryIds.add(category.id);
          } else {
            _selectedCategoryIds.remove(category.id);
          }
        });
      },
      title: Row(
        children: [
          if (category.emoji != null) ...[
            Text(category.emoji!, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: AppSizes.spaceS),
          ] else ...[
            Icon(
              Icons.label,
              size: 20,
              color: _parseColor(category.color),
            ),
            const SizedBox(width: AppSizes.spaceS),
          ],
          Expanded(
            child: Text(
              category.name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  void _applyFilter() {
    ref.read(selectedCategoryIdsProvider.notifier).state = _selectedCategoryIds;
    Navigator.pop(context);
  }

  Color? _parseColor(String? colorHex) {
    if (colorHex == null) return null;
    return Color(
      int.parse('FF${colorHex.replaceFirst('#', '')}', radix: 16),
    );
  }
}
