import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/features/main/child_points/data/repositories/childcare_repository.dart';
import 'package:family_planner/features/main/child_points/presentation/widgets/shop_item_list_item.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 포인트 상점 탭
class ShopTab extends ConsumerWidget {
  const ShopTab({super.key, this.demoItems, this.demoShopKey});

  final List<ChildcareShopItem>? demoItems;
  final GlobalKey? demoShopKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // 데모 모드: 샘플 아이템 렌더링
    if (demoItems != null) {
      return Scaffold(
        body: ListView(
          children: [
            const ShopGuide(hasItems: true),
            Column(
              key: demoShopKey,
              mainAxisSize: MainAxisSize.min,
              children: demoItems!.map(
                (item) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShopItemListItem(item: item),
                    const Divider(height: 1),
                  ],
                ),
              ).toList(),
            ),
          ],
        ),
      );
    }

    final account = ref.watch(selectedChildAccountProvider);
    final shopAsync = ref.watch(childcareShopItemsProvider);

    if (account == null) {
      final childrenAsync = ref.watch(childcareChildrenProvider);
      return childrenAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.childcare_no_child)),
        data: (_) => Center(child: Text(l10n.childcare_no_child)),
      );
    }

    return Scaffold(
      body: shopAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const ShopGuide(hasItems: false);
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(childcareShopItemsProvider.notifier).refresh(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: const ShopGuide(hasItems: true),
                ),
                SliverReorderableList(
                  itemCount: items.length,
                  onReorderItem: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) newIndex++;
                    final updated = [...items];
                    final moved = updated.removeAt(oldIndex);
                    updated.insert(newIndex, moved);
                    ref
                        .read(childcareManagementProvider.notifier)
                        .reorderShopItems(account.id, updated);
                  },
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ReorderableDragStartListener(
                      key: ValueKey(item.id),
                      index: index,
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ShopItemListItem(
                              item: item,
                              onUse: () => _confirmUseItem(
                                  context, ref, account.id, item),
                              onEdit: () => _showShopItemForm(context, ref,
                                  accountId: account.id, item: item),
                              onDelete: () =>
                                  _confirmDeleteItem(context, ref, account.id, item),
                              onToggleActive: () => ref
                                  .read(childcareManagementProvider.notifier)
                                  .updateShopItem(
                                    account.id,
                                    item.id,
                                    UpdateShopItemDto(isActive: !item.isActive),
                                  ),
                            ),
                            const Divider(height: 1),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.paddingOf(context).bottom + 80,
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const ShopGuide(hasItems: false),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showShopItemForm(context, ref, accountId: account.id),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmUseItem(
    BuildContext context,
    WidgetRef ref,
    String accountId,
    ChildcareShopItem item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('아이템 사용'),
        content: Text(
          '"${item.name}"\n${item.points}P를 사용합니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('사용'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final result = await ref.read(childcareManagementProvider.notifier).addTransaction(
          accountId,
          CreateTransactionDto.byShopItem(item.id),
        );

    if (!context.mounted) return;
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사용에 실패했습니다. 잠시 후 다시 시도해주세요.')),
      );
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('"${item.name}" 사용되었습니다')));
  }

  Future<void> _showShopItemForm(
    BuildContext context,
    WidgetRef ref, {
    required String accountId,
    ChildcareShopItem? item,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => ShopItemFormDialog(
        accountId: accountId,
        item: item,
        ref: ref,
      ),
    );
  }

  Future<void> _confirmDeleteItem(
    BuildContext context,
    WidgetRef ref,
    String accountId,
    ChildcareShopItem item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('아이템 삭제'),
        content: Text('"${item.name}"을(를) 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final success = await ref
        .read(childcareManagementProvider.notifier)
        .deleteShopItem(accountId, item.id);
    if (!context.mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('삭제에 실패했습니다. 잠시 후 다시 시도해주세요.')),
      );
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('삭제되었습니다')));
  }
}

// ── 상점 아이템 폼 다이얼로그 ─────────────────────────────────────────────────────

class ShopItemFormDialog extends StatefulWidget {
  const ShopItemFormDialog({
    super.key,
    required this.accountId,
    required this.item,
    required this.ref,
  });

  final String accountId;
  final ChildcareShopItem? item;
  final WidgetRef ref;

  @override
  State<ShopItemFormDialog> createState() => _ShopItemFormDialogState();
}

class _ShopItemFormDialogState extends State<ShopItemFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _pointsCtrl;
  bool _isSaving = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.item?.name ?? '');
    _descCtrl = TextEditingController(text: widget.item?.description ?? '');
    _pointsCtrl = TextEditingController(
      text: widget.item != null ? widget.item!.points.toString() : '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _pointsCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameCtrl.text.trim();
    final points = int.tryParse(_pointsCtrl.text.trim());
    if (name.isEmpty || points == null || points <= 0) return;

    setState(() => _isSaving = true);

    final desc = _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim();
    final notifier = widget.ref.read(childcareManagementProvider.notifier);

    final Object? result;
    if (widget.item == null) {
      result = await notifier.addShopItem(
        widget.accountId,
        CreateShopItemDto(name: name, description: desc, points: points),
      );
    } else {
      result = await notifier.updateShopItem(
        widget.accountId,
        widget.item!.id,
        UpdateShopItemDto(name: name, description: desc, points: points),
      );
    }

    if (!mounted) return;

    if (result == null) {
      setState(() {
        _isSaving = false;
        _errorMsg = '저장에 실패했습니다. 잠시 후 다시 시도해주세요.';
      });
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('저장되었습니다')));
  }

  @override
  Widget build(BuildContext context) {
    final isNew = widget.item == null;

    return AlertDialog(
      title: Text(isNew ? '상점 아이템 추가' : '상점 아이템 수정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: '아이템 이름',
              hintText: '예: TV 30분 더보기',
            ),
            autofocus: true,
          ),
          const SizedBox(height: AppSizes.spaceS),
          TextField(
            controller: _descCtrl,
            decoration: const InputDecoration(labelText: '설명 (선택)'),
          ),
          const SizedBox(height: AppSizes.spaceS),
          TextField(
            controller: _pointsCtrl,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: '포인트 비용', suffixText: 'P'),
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
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _handleSave,
          child: Text(isNew ? '추가' : '저장'),
        ),
      ],
    );
  }
}

// ── 포인트 상점 안내 카드 ─────────────────────────────────────────────────────

class ShopGuide extends StatefulWidget {
  const ShopGuide({super.key, required this.hasItems});

  final bool hasItems;

  @override
  State<ShopGuide> createState() => _ShopGuideState();
}

class _ShopGuideState extends State<ShopGuide> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = !widget.hasItems;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Card(
        margin: const EdgeInsets.all(AppSizes.spaceM),
        color: colorScheme.surfaceContainerHighest,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM,
                  vertical: AppSizes.spaceS,
                ),
                child: Row(
                  children: [
                    Icon(Icons.storefront_outlined,
                        size: 18, color: colorScheme.secondary),
                    const SizedBox(width: AppSizes.spaceS),
                    Expanded(
                      child: Text(
                        '포인트 상점이란?',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: colorScheme.secondary,
                            ),
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded) ...[
              Divider(height: 1, color: colorScheme.outlineVariant),
              Padding(
                padding: const EdgeInsets.all(AppSizes.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '아이가 모은 포인트로 구매할 수 있는 보상 목록입니다.\n원하는 것을 얻기 위해 스스로 포인트를 모으는 동기부여가 됩니다.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    Text(
                      '예시 아이템',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    ...const [
                      ('TV 30분 더보기', 10),
                      ('게임 1시간 하기', 20),
                      ('원하는 간식 고르기', 15),
                      ('늦게 자도 되는 날', 30),
                    ].map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 4),
                        child: Row(
                          children: [
                            Icon(Icons.storefront_outlined,
                                size: 14, color: colorScheme.secondary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                e.$1,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: colorScheme.onSurfaceVariant),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${e.$2}P',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    Text(
                      '아이템을 비활성화하면 목록에서 숨길 수 있습니다.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
