import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/storage_form_dialog.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/fridge_item_form_dialog.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/fridge_item_tile.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:intl/intl.dart';

// ── 온보딩용 샘플 데이터 ─────────────────────────────────────────────────────────

final _demoStorage1 = StorageModel(
  id: '__demo_storage_1__',
  groupId: '__demo__',
  name: '냉장고',
  type: StorageType.fridge,
  sortOrder: 0,
  createdAt: DateTime(2025, 1, 1),
);

final _demoStorage2 = StorageModel(
  id: '__demo_storage_2__',
  groupId: '__demo__',
  name: '냉동실',
  type: StorageType.freezer,
  sortOrder: 1,
  createdAt: DateTime(2025, 1, 1),
);

final _demoItems1 = [
  FridgeItemModel(
    id: '__demo_item_1__',
    groupId: '__demo__',
    storageLocationId: '__demo_storage_1__',
    name: '우유',
    quantity: 2,
    unit: '개',
    registeredAt: DateTime.now().subtract(const Duration(days: 2)),
    expiresAt: DateTime.now().add(const Duration(days: 3)),
    alertDaysBefore: 3,
    memo: null,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now(),
  ),
  FridgeItemModel(
    id: '__demo_item_2__',
    groupId: '__demo__',
    storageLocationId: '__demo_storage_1__',
    name: '계란',
    quantity: 10,
    unit: '개',
    registeredAt: DateTime.now().subtract(const Duration(days: 1)),
    expiresAt: DateTime.now().add(const Duration(days: 14)),
    alertDaysBefore: 3,
    memo: null,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now(),
  ),
];

final _demoSwis = [
  StorageWithItemsModel(storage: _demoStorage1, items: _demoItems1),
  StorageWithItemsModel(storage: _demoStorage2, items: []),
];

// ── 정렬 방식 ──────────────────────────────────────────────────────────────────

enum FridgeSortOrder { expiry, name, registeredAt }

extension FridgeSortOrderX on FridgeSortOrder {
  String label(AppLocalizations l10n) {
    switch (this) {
      case FridgeSortOrder.expiry:
        return l10n.fridge_sort_expiry;
      case FridgeSortOrder.name:
        return l10n.fridge_sort_name;
      case FridgeSortOrder.registeredAt:
        return l10n.fridge_sort_registered;
    }
  }

  List<FridgeItemModel> sort(List<FridgeItemModel> items) {
    final sorted = [...items];
    switch (this) {
      case FridgeSortOrder.expiry:
        sorted.sort((a, b) {
          if (a.expiresAt == null && b.expiresAt == null) return 0;
          if (a.expiresAt == null) return 1;
          if (b.expiresAt == null) return -1;
          return a.expiresAt!.compareTo(b.expiresAt!);
        });
      case FridgeSortOrder.name:
        sorted.sort((a, b) => a.name.compareTo(b.name));
      case FridgeSortOrder.registeredAt:
        sorted.sort((a, b) => b.registeredAt.compareTo(a.registeredAt));
    }
    return sorted;
  }
}

// ── 탭 메인 ────────────────────────────────────────────────────────────────────

class FridgeTab extends ConsumerStatefulWidget {
  const FridgeTab({super.key, this.onReplayOnboardingReady});

  /// FridgeScreen이 튜토리얼 다시보기 콜백을 받을 수 있도록 노출
  final void Function(VoidCallback replay)? onReplayOnboardingReady;

  @override
  ConsumerState<FridgeTab> createState() => _FridgeTabState();
}

class _FridgeTabState extends ConsumerState<FridgeTab> {
  FridgeSortOrder _sortOrder = FridgeSortOrder.expiry;
  bool _deletingStorage = false;

  // ValueNotifier: setState 없이 온보딩 on/off — 코치마크 콜백 내 build 충돌 방지
  final _showDemo = ValueNotifier<bool>(false);
  final _fabKey = GlobalKey();
  final _firstSectionKey = GlobalKey();
  final _firstItemKey = GlobalKey();
  final _addItemKey = GlobalKey();
  final _ddayChipKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.onReplayOnboardingReady?.call(replayOnboarding);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartOnboarding());
  }

  @override
  void dispose() {
    _showDemo.dispose();
    super.dispose();
  }

  Future<void> _maybeStartOnboarding() async {
    final completed = await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.fridge);
    if (completed || !mounted) return;
    _startDemo();
  }

  void replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.fridge).then((_) {
      if (mounted) _startDemo();
    });
  }

  void _startDemo() {
    _showDemo.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCoachMark());
  }

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;

    final fabPos = _keyToPosition(_fabKey);
    final sectionPos = _keyToPosition(_firstSectionKey);
    final itemPos = _keyToPosition(_firstItemKey);
    final addItemPos = _keyToPosition(_addItemKey);
    final ddayPos = _keyToPosition(_ddayChipKey);

    final targets = <TargetFocus>[
      // 1. 보관소 추가 FAB
      TargetFocus(
        identify: 'fridge_fab',
        targetPosition: fabPos,
        keyTarget: fabPos == null ? _fabKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '보관소 추가',
              description: '냉장고, 냉동실, 팬트리 등 보관 장소를 추가할 수 있어요.\n+ 버튼을 눌러 보관소를 만들어 보세요.',
              icon: Icons.add,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      // 2. 보관소 섹션 헤더
      TargetFocus(
        identify: 'fridge_section',
        targetPosition: sectionPos,
        keyTarget: sectionPos == null ? _firstSectionKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '보관소',
              description: '헤더를 탭해 펼치고 접을 수 있어요.\n우측 메뉴(⋮)로 보관소를 수정하거나 삭제할 수 있어요.',
              icon: Icons.kitchen_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      // 3. 첫 번째 품목 타일
      TargetFocus(
        identify: 'fridge_item',
        targetPosition: itemPos,
        keyTarget: itemPos == null ? _firstItemKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '품목 관리',
              description: '• 탭하면 이름·유통기한·메모를 수정할 수 있어요\n• ± 버튼으로 수량을 조절하세요\n• 왼쪽으로 스와이프하면 삭제 표시돼요\n• 변경 후 저장 버튼을 눌러야 반영됩니다',
              icon: Icons.edit_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      // 4. D-day 유통기한 칩
      TargetFocus(
        identify: 'fridge_dday',
        targetPosition: ddayPos,
        keyTarget: ddayPos == null ? _ddayChipKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '유통기한 알림',
              description: '품목에 유통기한을 등록하면 남은 일수가 표시돼요.\n• 파란색: 여유 있음\n• 주황색: 3일 이내 임박\n• 빨간색: 오늘 또는 이미 지남\n설정한 알림일 전에 푸시 알림도 받을 수 있어요.',
              icon: Icons.notifications_outlined,
              color: Colors.orange,
            ),
          ),
        ],
      ),
      // 5. 품목 추가 버튼
      TargetFocus(
        identify: 'fridge_add_item',
        targetPosition: addItemPos,
        keyTarget: addItemPos == null ? _addItemKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '품목 추가',
              description: '보관소 우측 + 버튼으로 품목을 추가해요.\n여러 품목을 한 번에 등록할 수 있고,\n유통기한·수량·단위·메모도 함께 입력할 수 있어요.',
              icon: Icons.add_circle_outline,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    ];

    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;

    TutorialCoachMark(
      targets: targets,
      colorShadow: AppColors.textPrimary,
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.topRight,
      skipWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: const Text(
          '건너뛰기',
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      onFinish: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.fridge);
        _showDemo.value = false;
      },
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.fridge);
        _showDemo.value = false;
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  void _setDeletingStorage(bool value) {
    if (mounted) setState(() => _deletingStorage = value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<bool>(
      valueListenable: _showDemo,
      builder: (context, isDemo, _) {
        final swisAsync = ref.watch(storagesWithItemsProvider);

        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            key: _fabKey,
            heroTag: 'fridge_add_storage',
            onPressed: isDemo
                ? null
                : () => showDialog<void>(
                      context: context,
                      builder: (_) => const StorageFormDialog(),
                    ),
            child: const Icon(Icons.add),
          ),
          body: isDemo
              ? _OnboardingFridgeView(
                  swis: _demoSwis,
                  sortOrder: _sortOrder,
                  firstSectionKey: _firstSectionKey,
                  firstItemKey: _firstItemKey,
                  addItemKey: _addItemKey,
                  ddayChipKey: _ddayChipKey,
                )
              : AbsorbPointer(
                  absorbing: _deletingStorage,
                  child: swisAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text(e.toString())),
                    data: (swis) {
                      if (swis.isEmpty) {
                        return _EmptyStorageView(l10n: l10n);
                      }
                      return Column(
                        children: [
                          if (_deletingStorage)
                            const LinearProgressIndicator(),
                          _SortBar(
                            current: _sortOrder,
                            onChanged: (v) =>
                                setState(() => _sortOrder = v),
                            l10n: l10n,
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.only(bottom: 80),
                              itemCount: swis.length,
                              itemBuilder: (context, index) =>
                                  _StorageSection(
                                swi: swis[index],
                                sortOrder: _sortOrder,
                                onDeletingChanged: _setDeletingStorage,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}

// ── 정렬 바 ────────────────────────────────────────────────────────────────────

class _SortBar extends StatelessWidget {
  final FridgeSortOrder current;
  final ValueChanged<FridgeSortOrder> onChanged;
  final AppLocalizations l10n;

  const _SortBar({
    required this.current,
    required this.onChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.spaceM, AppSizes.spaceS, AppSizes.spaceS, 0),
      child: Row(
        children: [
          Icon(Icons.sort,
              size: 16, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: AppSizes.spaceS),
          ...FridgeSortOrder.values.map((order) => Padding(
                padding: const EdgeInsets.only(right: AppSizes.spaceXS),
                child: FilterChip(
                  label: Text(order.label(l10n)),
                  selected: order == current,
                  onSelected: (_) => onChanged(order),
                  visualDensity: VisualDensity.compact,
                ),
              )),
        ],
      ),
    );
  }
}

// ── 보관소 섹션 (접기/펼치기) ──────────────────────────────────────────────────

class _StorageSection extends ConsumerStatefulWidget {
  final StorageWithItemsModel swi;
  final FridgeSortOrder sortOrder;
  final ValueChanged<bool> onDeletingChanged;

  const _StorageSection({
    required this.swi,
    required this.sortOrder,
    required this.onDeletingChanged,
  });

  @override
  ConsumerState<_StorageSection> createState() => _StorageSectionState();
}

class _StorageSectionState extends ConsumerState<_StorageSection> {
  bool _expanded = true;
  bool _saving = false;
  final Map<String, FridgeItemEditState> _edits = {};

  StorageModel get storage => widget.swi.storage;

  @override
  void initState() {
    super.initState();
    _syncEdits(widget.swi.items);
  }

  @override
  void didUpdateWidget(_StorageSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncEdits(widget.swi.items);
  }

  void _syncEdits(List<FridgeItemModel> items) {
    final incoming = {for (final i in items) i.id: i};
    _edits.removeWhere((id, _) => !incoming.containsKey(id));
    for (final item in items) {
      _edits.putIfAbsent(item.id, () => FridgeItemEditState(item));
    }
  }

  bool get _hasChanges =>
      widget.swi.items.any((item) => _edits[item.id]?.hasChanges(item) == true);

  void _cancelChanges() {
    for (final item in widget.swi.items) {
      _edits[item.id] = FridgeItemEditState(item);
    }
    setState(() {});
  }

  Future<void> _save(List<FridgeItemModel> items) async {
    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    if (groupId == null) return;

    final updates = <FridgeItemUpdateEntryDto>[];
    final deletes = <String>[];

    for (final item in items) {
      final es = _edits[item.id];
      if (es == null || !es.hasChanges(item)) continue;
      if (es.markedForDelete) {
        deletes.add(item.id);
      } else {
        updates.add(FridgeItemUpdateEntryDto(
          id: item.id,
          name: es.name.isEmpty ? null : es.name,
          quantity: es.quantity,
          unit: es.unit?.isEmpty == true ? null : es.unit,
          expiresAt: es.expiresAt,
          alertDaysBefore: es.alertDaysBefore,
          memo: es.memo?.isEmpty == true ? null : es.memo,
        ));
      }
    }

    setState(() => _saving = true);
    try {
      await ref.read(storagesWithItemsProvider.notifier).bulkUpdate(
            BulkUpdateFridgeItemDto(
              groupId: groupId,
              updates: updates.isEmpty ? null : updates,
              deletes: deletes.isEmpty ? null : deletes,
            ),
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // 탭 → 바텀 시트로 상세 편집
  Future<void> _showEditBottomSheet(
      BuildContext context, FridgeItemModel item, FridgeItemEditState es) async {
    final l10n = AppLocalizations.of(context)!;

    // 바텀 시트용 임시 컨트롤러 (기존 es 값으로 초기화)
    final nameCtrl = TextEditingController(text: es.name);
    final unitCtrl = TextEditingController(text: es.unit ?? '');
    final memoCtrl = TextEditingController(text: es.memo ?? '');
    DateTime? expiresAt = es.expiresAt != null
        ? DateTime.tryParse(es.expiresAt!)
        : null;
    int alertDays = es.alertDaysBefore;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setInner) {
          return Padding(
            padding: EdgeInsets.only(
              left: AppSizes.spaceL,
              right: AppSizes.spaceL,
              top: AppSizes.spaceL,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSizes.spaceL,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.fridge_item_edit,
                    style: Theme.of(ctx).textTheme.titleMedium),
                const SizedBox(height: AppSizes.spaceM),
                TextField(
                  controller: nameCtrl,
                  decoration:
                      InputDecoration(labelText: l10n.fridge_item_name),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: AppSizes.spaceS),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: unitCtrl,
                        decoration:
                            InputDecoration(labelText: l10n.fridge_item_unit),
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceM),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: memoCtrl,
                        decoration:
                            InputDecoration(labelText: l10n.fridge_item_memo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceS),
                // 유통기한 선택
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    expiresAt != null
                        ? DateFormat('yyyy-MM-dd').format(expiresAt!)
                        : l10n.fridge_item_expires_at,
                    style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          color: expiresAt != null
                              ? null
                              : Theme.of(ctx).colorScheme.outline,
                        ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (expiresAt != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setInner(() => expiresAt = null),
                        ),
                      const Icon(Icons.calendar_today_outlined, size: 18),
                    ],
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: expiresAt ??
                          DateTime.now().add(const Duration(days: 7)),
                      firstDate: DateTime.now(),
                      lastDate:
                          DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (picked != null) setInner(() => expiresAt = picked);
                  },
                ),
                if (expiresAt != null)
                  Row(
                    children: [
                      Text(l10n.fridge_item_alert_days(alertDays),
                          style: Theme.of(ctx).textTheme.bodySmall),
                      Expanded(
                        child: Slider(
                          value: alertDays.toDouble(),
                          min: 1,
                          max: 14,
                          divisions: 13,
                          onChanged: (v) =>
                              setInner(() => alertDays = v.toInt()),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: AppSizes.spaceM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(l10n.common_cancel),
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    FilledButton(
                      onPressed: () {
                        // es에 바텀 시트 값 반영
                        es.name = nameCtrl.text.trim().isEmpty
                            ? item.name
                            : nameCtrl.text.trim();
                        es.unit = unitCtrl.text.trim().isEmpty
                            ? null
                            : unitCtrl.text.trim();
                        es.memo = memoCtrl.text.trim().isEmpty
                            ? null
                            : memoCtrl.text.trim();
                        es.expiresAt = expiresAt != null
                            ? DateFormat('yyyy-MM-dd').format(expiresAt!)
                            : null;
                        es.alertDaysBefore = alertDays;
                        setState(() {});
                        Navigator.pop(ctx);
                      },
                      child: Text(l10n.common_done),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    nameCtrl.dispose();
    unitCtrl.dispose();
    memoCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = widget.sortOrder.sort(widget.swi.items);
    final hasChanges = _hasChanges;

    return AbsorbPointer(
      absorbing: _saving,
      child: Card(
        margin: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_saving) const LinearProgressIndicator(),
            ListTile(
              leading: Icon(_storageIcon(storage.type)),
              title: Text(storage.name,
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(
                '${_storageTypeLabel(l10n, storage.type)}  ·  ${items.length}${l10n.fridge_item_count}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    tooltip: l10n.fridge_item_add,
                    onPressed: () => _showAddItemDialog(context, storage.id),
                  ),
                  IconButton(
                    icon: Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _expanded = !_expanded),
                  ),
                  PopupMenuButton<_StorageAction>(
                    onSelected: _handleStorageAction,
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: _StorageAction.edit,
                        child: Text(l10n.fridge_storage_edit),
                      ),
                      PopupMenuItem(
                        value: _StorageAction.delete,
                        child: Text(l10n.fridge_storage_delete,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _expanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Column(
                children: [
                  if (items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSizes.spaceL, 0, AppSizes.spaceM, AppSizes.spaceM),
                      child: Text(l10n.fridge_empty_items,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.outline)),
                    )
                  else
                    ...items.map((item) {
                      final es = _edits[item.id];
                      if (es == null) return const SizedBox.shrink();
                      return FridgeItemTile(
                        key: ValueKey(item.id),
                        item: item,
                        editState: es,
                        onChanged: () => setState(() {}),
                        onTapEdit: () =>
                            _showEditBottomSheet(context, item, es),
                      );
                    }),
                  // 변경사항 저장/취소 바
                  if (hasChanges)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spaceM,
                          vertical: AppSizes.spaceS),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(AppSizes.radiusMedium),
                          bottomRight: Radius.circular(AppSizes.radiusMedium),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.cart_unsaved_changes,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          TextButton(
                            onPressed: _cancelChanges,
                            child: Text(l10n.common_cancel),
                          ),
                          const SizedBox(width: AppSizes.spaceXS),
                          FilledButton(
                            onPressed: () => _save(items),
                            child: Text(l10n.common_save),
                          ),
                        ],
                      ),
                    ),
                  if (!hasChanges) const SizedBox(height: AppSizes.spaceS),
                ],
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  IconData _storageIcon(StorageType type) {
    switch (type) {
      case StorageType.fridge:
        return Icons.kitchen_outlined;
      case StorageType.freezer:
        return Icons.ac_unit_outlined;
      case StorageType.pantry:
        return Icons.shelves;
    }
  }

  String _storageTypeLabel(AppLocalizations l10n, StorageType type) {
    switch (type) {
      case StorageType.fridge:
        return l10n.fridge_storage_type_fridge;
      case StorageType.freezer:
        return l10n.fridge_storage_type_freezer;
      case StorageType.pantry:
        return l10n.fridge_storage_type_pantry;
    }
  }

  void _showAddItemDialog(BuildContext context, String storageId) {
    showDialog<void>(
      context: context,
      builder: (_) => FridgeItemFormDialog(storageId: storageId),
    );
  }

  Future<void> _handleStorageAction(_StorageAction action) async {
    final l10n = AppLocalizations.of(context)!;
    switch (action) {
      case _StorageAction.edit:
        await showDialog<void>(
          context: context,
          builder: (_) => StorageFormDialog(storage: storage),
        );
      case _StorageAction.delete:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.fridge_storage_delete),
            content: Text(l10n.fridge_storage_delete_confirm),
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
        if (confirmed != true) return;
        widget.onDeletingChanged(true);
        try {
          await ref.read(storagesProvider.notifier).delete(storage.id);
        } finally {
          widget.onDeletingChanged(false);
        }
    }
  }
}

// ── 온보딩 전용 뷰 (샘플 데이터, 탭/수정 불가) ──────────────────────────────────

class _OnboardingFridgeView extends StatelessWidget {
  final List<StorageWithItemsModel> swis;
  final FridgeSortOrder sortOrder;
  final GlobalKey firstSectionKey;
  final GlobalKey firstItemKey;
  final GlobalKey addItemKey;
  final GlobalKey ddayChipKey;

  const _OnboardingFridgeView({
    required this.swis,
    required this.sortOrder,
    required this.firstSectionKey,
    required this.firstItemKey,
    required this.addItemKey,
    required this.ddayChipKey,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: swis.length,
      itemBuilder: (context, sectionIndex) {
        final swi = swis[sectionIndex];
        final items = sortOrder.sort(swi.items);
        final isFirstSection = sectionIndex == 0;
        return Card(
          margin: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                key: isFirstSection ? firstSectionKey : null,
                leading: Icon(_sectionIcon(swi.storage.type)),
                title: Text(swi.storage.name,
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(
                  '${swi.items.length}개',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 품목 추가 버튼 — 첫 번째 보관소에만 키 부착
                    IconButton(
                      key: isFirstSection ? addItemKey : null,
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: null,
                    ),
                    const Icon(Icons.keyboard_arrow_up, size: 20),
                  ],
                ),
              ),
              ...items.asMap().entries.map((entry) {
                final isFirstItem = isFirstSection && entry.key == 0;
                final item = entry.value;
                final dday = item.daysUntilExpiry;
                return AbsorbPointer(
                  child: ListTile(
                    key: isFirstItem ? firstItemKey : null,
                    contentPadding: const EdgeInsets.only(
                        left: AppSizes.spaceL, right: AppSizes.spaceXS),
                    title: Row(
                      children: [
                        Expanded(child: Text(item.name)),
                        if (dday != null) ...[
                          const SizedBox(width: AppSizes.spaceS),
                          _DemoExpiryChip(
                            key: isFirstItem ? ddayChipKey : null,
                            days: dday,
                          ),
                        ],
                      ],
                    ),
                    subtitle: Text(
                      item.unit ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.remove, size: 18),
                        const SizedBox(width: 4),
                        Text('${item.quantity}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        const Icon(Icons.add, size: 18),
                      ],
                    ),
                  ),
                );
              }),
              if (items.isEmpty) const SizedBox(height: AppSizes.spaceS),
            ],
          ),
        );
      },
    );
  }

  IconData _sectionIcon(StorageType type) {
    switch (type) {
      case StorageType.fridge:
        return Icons.kitchen_outlined;
      case StorageType.freezer:
        return Icons.ac_unit_outlined;
      case StorageType.pantry:
        return Icons.shelves;
    }
  }
}

class _DemoExpiryChip extends StatelessWidget {
  final int days;
  const _DemoExpiryChip({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;
    if (days <= 0) {
      color = Theme.of(context).colorScheme.error;
      label = 'D+${-days}';
    } else if (days <= 3) {
      color = Colors.orange;
      label = 'D-$days';
    } else {
      color = Theme.of(context).colorScheme.primary;
      label = 'D-$days';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color, fontWeight: FontWeight.bold)),
    );
  }
}

// ── 빈 상태 ────────────────────────────────────────────────────────────────────

class _EmptyStorageView extends StatelessWidget {
  final AppLocalizations l10n;
  const _EmptyStorageView({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.kitchen_outlined,
              size: 64, color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: AppSizes.spaceM),
          Text(l10n.fridge_empty_storage,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSizes.spaceL),
          FilledButton.icon(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => const StorageFormDialog(),
            ),
            icon: const Icon(Icons.add),
            label: Text(l10n.fridge_storage_add),
          ),
        ],
      ),
    );
  }
}

enum _StorageAction { edit, delete }
