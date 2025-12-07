import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/common/providers/bottom_navigation_settings_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 하단 네비게이션 설정 화면
class BottomNavigationSettingsScreen extends ConsumerWidget {
  const BottomNavigationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(bottomNavigationSettingsProvider);
    final notifier = ref.read(bottomNavigationSettingsProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bottomNav_title),
        actions: [
          // 초기화 버튼
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.bottomNav_reset,
            onPressed: () async {
              final shouldReset = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.bottomNav_resetConfirmTitle),
                  content: Text(l10n.bottomNav_resetConfirmMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(l10n.common_cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(l10n.bottomNav_reset),
                    ),
                  ],
                ),
              );

              if (shouldReset == true) {
                await notifier.resetToDefault();
                if (context.mounted) {
                  final l10n = AppLocalizations.of(context)!;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.bottomNav_resetSuccess)),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        children: [
          // 안내 메시지
          Container(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: AppSizes.spaceS),
                Expanded(
                  child: Text(
                    l10n.bottomNav_guideMessage,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spaceL),

          // 하단 네비게이션 미리보기
          Text(
            l10n.bottomNav_preview,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSizes.spaceS),

          // 5개 슬롯 표시
          Row(
            children: [
              // 1. 고정: 홈
              Expanded(
                child: _buildSlotPreview(
                  context,
                  settings.fixedLeft,
                  '1',
                  isFixed: true,
                  onTap: null,
                ),
              ),
              const SizedBox(width: AppSizes.spaceXS),
              // 2-4. 가변 슬롯
              ...List.generate(3, (index) {
                final menuId = settings.middleSlots[index];
                final item = notifier.availableItems[menuId]!;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index < 2 ? AppSizes.spaceXS : 0,
                    ),
                    child: _buildSlotPreview(
                      context,
                      item,
                      '${index + 2}',
                      isFixed: false,
                      onTap: () => _showMenuSelectionDialog(context, index, notifier),
                    ),
                  ),
                );
              }),
              const SizedBox(width: AppSizes.spaceXS),
              // 5. 고정: 더보기
              Expanded(
                child: _buildSlotPreview(
                  context,
                  settings.fixedRight,
                  '5',
                  isFixed: true,
                  onTap: null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceL),

          // 설명
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: AppSizes.spaceS),
                      Text(
                        l10n.bottomNav_howToUse,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  Text(
                    l10n.bottomNav_instructions,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),

          // 사용 가능한 메뉴 목록
          Text(
            l10n.bottomNav_availableMenus,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          ...notifier.availableItems.entries.map((entry) {
            final item = entry.value;
            final isUsed = settings.middleSlots.contains(entry.key);
            final slotIndex = settings.middleSlots.indexOf(entry.key);

            return Card(
              elevation: 1,
              margin: const EdgeInsets.only(bottom: AppSizes.spaceXS),
              child: ListTile(
                leading: Icon(
                  item.selectedIcon,
                  color: isUsed
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                title: Text(
                  item.label,
                  style: TextStyle(
                    fontWeight: isUsed ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isUsed
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${l10n.bottomNav_slot} ${slotIndex + 2}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Text(
                        l10n.bottomNav_unused,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 슬롯 미리보기 위젯
  Widget _buildSlotPreview(
    BuildContext context,
    NavigationItem item,
    String slotNumber, {
    required bool isFixed,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
        decoration: BoxDecoration(
          border: Border.all(
            color: isFixed
                ? Colors.grey.shade300
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            width: isFixed ? 1 : 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isFixed
              ? Colors.grey.shade50
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.selectedIcon,
              size: 24,
              color: isFixed
                  ? Colors.grey
                  : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSizes.spaceXS),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isFixed ? FontWeight.normal : FontWeight.bold,
                color: isFixed ? Colors.grey : null,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              slotNumber,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
            if (isFixed)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.lock_outline,
                  size: 12,
                  color: Colors.grey.shade400,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 메뉴 선택 다이얼로그
  Future<void> _showMenuSelectionDialog(
    BuildContext context,
    int slotIndex,
    BottomNavigationSettingsNotifier notifier,
  ) async {
    final availableItems = notifier.availableItems;

    await showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final currentSettings = ref.watch(bottomNavigationSettingsProvider);

          final l10n = AppLocalizations.of(context)!;

          return AlertDialog(
            title: Text('${l10n.bottomNav_slot} ${slotIndex + 2} ${l10n.bottomNav_selectMenuTitle}'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: availableItems.length,
                itemBuilder: (context, index) {
                  final entry = availableItems.entries.elementAt(index);
                  final menuId = entry.key;
                  final item = entry.value;
                  final isCurrentlySelected = currentSettings.middleSlots[slotIndex] == menuId;
                  final isUsedInOtherSlot = currentSettings.middleSlots.contains(menuId) &&
                      currentSettings.middleSlots[slotIndex] != menuId;

                  return ListTile(
                    leading: Icon(
                      item.selectedIcon,
                      color: isCurrentlySelected
                          ? Theme.of(context).colorScheme.primary
                          : (isUsedInOtherSlot ? Colors.grey : null),
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        fontWeight: isCurrentlySelected ? FontWeight.bold : null,
                        color: isUsedInOtherSlot ? Colors.grey : null,
                      ),
                    ),
                    subtitle: isUsedInOtherSlot
                        ? Text(
                            l10n.bottomNav_usedInOtherSlot,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          )
                        : null,
                    trailing: isCurrentlySelected
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      notifier.changeSlotMenu(slotIndex, menuId);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.common_cancel),
              ),
            ],
          );
        },
      ),
    );
  }
}
