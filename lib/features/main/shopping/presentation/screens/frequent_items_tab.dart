import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';

part '_frequent_items_onboarding.dart';

// ── 탭 ─────────────────────────────────────────────────────────────────────────

class FrequentItemsTab extends ConsumerStatefulWidget {
  const FrequentItemsTab({
    super.key,
    this.onReplayOnboardingReady,
    this.tutorialTrigger,
    this.onOnboardingFinished,
  });

  final void Function(VoidCallback replay)? onReplayOnboardingReady;
  /// CartTab 온보딩 완료 후 ShoppingScreen이 이 탭의 튜토리얼을 시작할 때 사용.
  /// false→true 전환으로 트리거되므로 탭이 늦게 빌드되어도 initState에서 감지 가능.
  final ValueNotifier<bool>? tutorialTrigger;
  final VoidCallback? onOnboardingFinished;

  @override
  ConsumerState<FrequentItemsTab> createState() => _FrequentItemsTabState();
}

class _FrequentItemsTabState extends ConsumerState<FrequentItemsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final _showDemo = ValueNotifier<bool>(false);
  final _fabKey = GlobalKey();
  final _firstItemKey = GlobalKey();
  final _autoAddKey = GlobalKey();
  final _addToCartKey = GlobalKey();
  // 빌드 중 코치마크 중복 예약 방지 플래그
  bool _coachMarkScheduled = false;

  @override
  void initState() {
    super.initState();
    widget.onReplayOnboardingReady?.call(replayOnboarding);
    widget.tutorialTrigger?.addListener(_onTutorialTrigger);
    // 탭이 애니메이션 도중 늦게 빌드된 경우: 트리거가 이미 true이면 즉시 시작
    if (widget.tutorialTrigger?.value == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _startDemo();
      });
    }
  }

  @override
  void dispose() {
    widget.tutorialTrigger?.removeListener(_onTutorialTrigger);
    _showDemo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder<bool>(
      valueListenable: _showDemo,
      builder: (context, isDemo, _) {
        if (isDemo) {
          // 이 빌드에서 _OnboardingFrequentView가 렌더되므로,
          // 다음 프레임에서는 GlobalKey가 반드시 트리에 존재함.
          // 빌드 중 예약해야만 "키 빌드 → 코치마크" 순서가 보장됨.
          if (!_coachMarkScheduled) {
            _coachMarkScheduled = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _showCoachMark();
            });
          }
          return _OnboardingFrequentView(
            items: _demoFrequentItems,
            fabKey: _fabKey,
            firstItemKey: _firstItemKey,
            autoAddKey: _autoAddKey,
            addToCartKey: _addToCartKey,
          );
        }

        return _RealFrequentItemsView(
          onAdd: () => _showAddDialog(context),
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    _showFrequentItemSheet(context, null);
  }

  void _showFrequentItemSheet(BuildContext context, FrequentItemModel? item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _FrequentItemFormSheet(item: item),
    );
  }
}

// ── 자동 추가 안내 배너 ────────────────────────────────────────────────────────

class _AutoAddInfoBanner extends StatefulWidget {
  const _AutoAddInfoBanner();

  @override
  State<_AutoAddInfoBanner> createState() => _AutoAddInfoBannerState();
}

class _AutoAddInfoBannerState extends State<_AutoAddInfoBanner> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceM, 0),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.secondaryContainer),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.kitchen_outlined, size: 16, color: colorScheme.secondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.fridge_frequent_autoAddInfo_title,
                      style: textTheme.labelMedium?.copyWith(color: colorScheme.secondary),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: colorScheme.secondary,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.fridge_frequent_autoAddInfo_body,
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 12, color: colorScheme.outline),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)!.fridge_frequent_autoAddInfo_hint,
                      style: textTheme.labelSmall?.copyWith(color: colorScheme.outline),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── 실제 뷰 ────────────────────────────────────────────────────────────────────

class _RealFrequentItemsView extends ConsumerWidget {
  final VoidCallback onAdd;
  const _RealFrequentItemsView({required this.onAdd});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final itemsAsync = ref.watch(frequentItemsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (items) {
          if (items.isEmpty) {
            return Column(
              children: [
                const _AutoAddInfoBanner(),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.outlineVariant),
                        const SizedBox(height: AppSizes.spaceM),
                        Text(l10n.fridge_frequent_empty,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: items.length + 1,
            itemBuilder: (_, i) {
              if (i == 0) return const _AutoAddInfoBanner();
              return _FrequentItemTile(item: items[i - 1]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'frequent_add',
        onPressed: onAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── 항목 타일 ──────────────────────────────────────────────────────────────────

class _FrequentItemTile extends ConsumerWidget {
  final FrequentItemModel item;
  const _FrequentItemTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(item.name),
      subtitle: item.defaultUnit != null ? Text(item.defaultUnit!) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.fridge_frequent_auto_add,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: item.autoAdd
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                    ),
              ),
              SizedBox(
                height: 28,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Switch(
                    value: item.autoAdd,
                    onChanged: (v) => ref
                        .read(frequentItemsProvider.notifier)
                        .toggleAutoAdd(item.id, v),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart_outlined, size: 20),
            tooltip: l10n.fridge_frequent_add_to_cart,
            onPressed: () => _addToCart(context, ref),
          ),
          PopupMenuButton<_Action>(
            onSelected: (a) => _handleAction(context, ref, a),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _Action.edit,
                child: Text(l10n.common_edit),
              ),
              PopupMenuItem(
                value: _Action.delete,
                child: Text(l10n.common_delete,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, WidgetRef ref) {
    final current = ref.read(cartPendingInsertsProvider);
    ref.read(cartPendingInsertsProvider.notifier).state = [
      ...current,
      CartItemEntryDto(
        name: item.name,
        quantity: 1,
        unit: item.defaultUnit,
      ),
    ];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!
            .fridge_frequent_added_snackbar(item.name)),
      ),
    );
  }

  Future<void> _handleAction(
      BuildContext context, WidgetRef ref, _Action action) async {
    final l10n = AppLocalizations.of(context)!;
    switch (action) {
      case _Action.edit:
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => _FrequentItemFormSheet(item: item),
        );
      case _Action.delete:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            content: Text(l10n.fridge_frequent_delete_confirm(item.name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.common_cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.common_delete,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error)),
              ),
            ],
          ),
        );
        if (confirmed == true && context.mounted) {
          await ref.read(frequentItemsProvider.notifier).delete(item.id);
        }
    }
  }
}

enum _Action { edit, delete }

// ── 자주 사는 항목 폼 바텀 시트 ──────────────────────────────────────────────────

class _FrequentItemFormSheet extends ConsumerStatefulWidget {
  final FrequentItemModel? item;
  const _FrequentItemFormSheet({this.item});

  @override
  ConsumerState<_FrequentItemFormSheet> createState() =>
      _FrequentItemFormSheetState();
}

class _FrequentItemFormSheetState
    extends ConsumerState<_FrequentItemFormSheet> {
  final _nameController = TextEditingController();
  final _unitController = TextEditingController();
  bool _autoAdd = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _unitController.text = widget.item!.defaultUnit ?? '';
      _autoAdd = widget.item!.autoAdd;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final unit =
        _unitController.text.trim().isEmpty ? null : _unitController.text.trim();

    setState(() => _loading = true);
    try {
      final notifier = ref.read(frequentItemsProvider.notifier);
      if (widget.item == null) {
        final groupId = ref.read(fridgeSelectedGroupIdProvider);
        await notifier.create(CreateFrequentItemDto(
          groupId: groupId ?? '',
          name: name,
          defaultUnit: unit,
          autoAdd: _autoAdd,
        ));
      } else {
        await notifier.edit(
          widget.item!.id,
          UpdateFrequentItemDto(name: name, defaultUnit: unit, autoAdd: _autoAdd),
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.item != null;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, scrollController) => Column(
        children: [
          // 드래그 핸들
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // 타이틀
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSizes.spaceL, 0, AppSizes.spaceS, AppSizes.spaceM),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isEdit ? l10n.common_edit : l10n.fridge_frequent_add,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // 폼
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.fromLTRB(
                AppSizes.spaceL,
                0,
                AppSizes.spaceL,
                AppSizes.spaceL + bottomInset,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: l10n.fridge_item_name),
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: widget.item == null,
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                  TextField(
                    controller: _unitController,
                    decoration: InputDecoration(labelText: l10n.fridge_item_unit),
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.fridge_frequent_auto_add,
                        style: Theme.of(context).textTheme.bodyMedium),
                    value: _autoAdd,
                    onChanged: (v) => setState(() => _autoAdd = v),
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                  FilledButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(isEdit ? l10n.common_save : l10n.common_add),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
