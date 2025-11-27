import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/providers/bottom_navigation_settings_provider.dart';

/// 하단 네비게이션 설정 화면
class BottomNavigationSettingsScreen extends ConsumerWidget {
  const BottomNavigationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(bottomNavigationSettingsProvider);
    final notifier = ref.read(bottomNavigationSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('하단 네비게이션 설정'),
        actions: [
          // 초기화 버튼
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '기본값으로 초기화',
            onPressed: () async {
              final shouldReset = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('초기화 확인'),
                  content: const Text('하단 네비게이션 설정을 기본값으로 초기화하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('초기화'),
                    ),
                  ],
                ),
              );

              if (shouldReset == true) {
                await notifier.resetToDefault();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('기본값으로 초기화되었습니다')),
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
                    '홈과 더보기는 고정입니다.\n중간 3개 슬롯을 탭하여 메뉴를 선택하세요.',
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
            '하단 네비게이션 미리보기',
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
                        '사용 방법',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  Text(
                    '• 슬롯 2, 3, 4를 탭하여 원하는 메뉴로 변경하세요.\n'
                    '• 슬롯 1(홈)과 슬롯 5(더보기)는 고정입니다.\n'
                    '• 하단 네비게이션에 없는 메뉴는 "더보기" 탭에 표시됩니다.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),

          // 사용 가능한 메뉴 목록
          Text(
            '사용 가능한 메뉴',
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
                          '슬롯 ${slotIndex + 2}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : const Text(
                        '미사용',
                        style: TextStyle(
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

          return AlertDialog(
            title: Text('슬롯 ${slotIndex + 2} 메뉴 선택'),
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
                            '다른 슬롯에서 사용 중 (선택 시 교체)',
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
                child: const Text('취소'),
              ),
            ],
          );
        },
      ),
    );
  }
}
