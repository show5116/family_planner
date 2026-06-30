part of 'cart_tab.dart';

// ── 이관 상세 정보 (Step 2용) ──────────────────────────────────────────────────

class _TransferDetail {
  final CartItemModel cartItem;
  String storageId;
  final TextEditingController quantity;
  DateTime? expiresAt;
  int alertDays;

  _TransferDetail({
    required this.cartItem,
    required this.storageId,
  })  : quantity = TextEditingController(text: cartItem.quantity.toString()),
        alertDays = 3;

  void dispose() {
    quantity.dispose();
  }
}

// ── 장보기 완료 다이얼로그 ─────────────────────────────────────────────────────────

class _CompleteShoppingDialog extends ConsumerStatefulWidget {
  final List<CartItemModel> items;
  final Map<String, double> initialPrices; // cartItemId → price
  const _CompleteShoppingDialog({
    required this.items,
    this.initialPrices = const {},
  });

  @override
  ConsumerState<_CompleteShoppingDialog> createState() =>
      _CompleteShoppingDialogState();
}

class _CompleteShoppingDialogState
    extends ConsumerState<_CompleteShoppingDialog>
    with InterstitialAdMixin {
  // Step 1 상태
  final Map<String, String?> _transferMap = {}; // cartItemId → storageId | null
  final Set<String> _excludedSet = {}; // 이번 완료에서 제외할 cartItemId
  DateTime _completedAt = DateTime.now();
  bool _addExpense = false;
  final _amountController = TextEditingController();
  final _descController = TextEditingController(text: '마트 장보기');
  PaymentMethod _paymentMethod = PaymentMethod.card;
  String? _selectedMerchantId;

  // Step 2 상태
  bool _isStep2 = false;
  final List<_TransferDetail> _details = [];

  bool _loading = false;

  void _syncAmountFromPrices() {
    if (!_addExpense) return;
    final total = widget.items
        .where((item) => !_excludedSet.contains(item.id))
        .fold<double>(0, (sum, item) {
      return sum + (widget.initialPrices[item.id] ?? 0);
    });
    if (total > 0) {
      _amountController.text = total.toInt().toString();
    }
  }

  @override
  void initState() {
    super.initState();
    for (final item in widget.items) {
      _transferMap[item.id] = null;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    for (final d in _details) {
      d.dispose();
    }
    super.dispose();
  }

  void _goToStep2() {
    for (final d in _details) {
      d.dispose();
    }
    _details.clear();
    for (final item in widget.items) {
      if (_excludedSet.contains(item.id)) continue;
      final storageId = _transferMap[item.id];
      if (storageId != null) {
        _details.add(_TransferDetail(
          cartItem: item,
          storageId: storageId,
        ));
      }
    }
    setState(() => _isStep2 = true);
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      final groupId = ref.read(fridgeSelectedGroupIdProvider);

      final transfers = _isStep2
          ? _details
              .map((d) => TransferItemDto(
                    cartItemId: d.cartItem.id,
                    storageLocationId: d.storageId,
                    quantity: int.tryParse(d.quantity.text) ?? d.cartItem.quantity,
                    price: widget.initialPrices[d.cartItem.id],
                    expiresAt: d.expiresAt != null
                        ? DateFormat('yyyy-MM-dd').format(d.expiresAt!)
                        : null,
                    alertDaysBefore: d.expiresAt != null ? d.alertDays : null,
                  ))
              .toList()
          : _transferMap.entries
              .where((e) => e.value != null && !_excludedSet.contains(e.key))
              .map((e) => TransferItemDto(
                    cartItemId: e.key,
                    storageLocationId: e.value!,
                    price: widget.initialPrices[e.key],
                  ))
              .toList();

      ShoppingExpenseDto? expense;
      if (_addExpense) {
        // amount를 직접 입력하지 않으면 null → 백엔드가 품목별 price 합계로 자동 계산
        final amount = double.tryParse(
            _amountController.text.replaceAll(',', '').trim());
        expense = ShoppingExpenseDto(
          amount: (amount != null && amount > 0) ? amount : null,
          paymentMethod: _paymentMethod,
          date: DateFormat('yyyy-MM-dd').format(_completedAt),
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          category: ExpenseCategory.groceries,
          merchantId: _selectedMerchantId,
        );
      }

      await ref.read(cartProvider.notifier).complete(CompleteCartDto(
            groupId: groupId ?? '',
            completedAt: _completedAt.toUtc().toIso8601String(),
            transfers: transfers,
            excludes: _excludedSet.isEmpty ? null : _excludedSet.toList(),
            expense: expense,
          ));

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showInterstitialThenNavigate(() {
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.shopping_complete_snackbar)),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() => _loading = false);
      } else {
        _loading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final hasTransfer = _transferMap.values.any((v) => v != null);

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            // 핸들
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.spaceM, bottom: AppSizes.spaceS),
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
            // 제목
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceL),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _isStep2
                          ? l10n.fridge_cart_complete_step2_title
                          : l10n.fridge_cart_complete_title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _loading ? null : () => Navigator.pop(context),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // 콘텐츠 스크롤 영역
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.spaceL,
                  AppSizes.spaceM,
                  AppSizes.spaceL,
                  AppSizes.spaceL,
                ),
                child: _isStep2
                    ? _Step2Content(details: _details, l10n: l10n, completedAt: _completedAt)
                    : _Step1Content(
                        items: widget.items,
                        transferMap: _transferMap,
                        excludedSet: _excludedSet,
                        completedAt: _completedAt,
                        onCompletedAtChanged: (d) =>
                            setState(() => _completedAt = d),
                        addExpense: _addExpense,
                        selectedMerchantId: _selectedMerchantId,
                        amountController: _amountController,
                        descController: _descController,
                        paymentMethod: _paymentMethod,
                        onTransferChanged: (id, storageId) =>
                            setState(() => _transferMap[id] = storageId),
                        onExcludeToggled: (id) => setState(() {
                              if (_excludedSet.contains(id)) {
                                _excludedSet.remove(id);
                              } else {
                                _excludedSet.add(id);
                              }
                              _syncAmountFromPrices();
                            }),
                        onAddExpenseChanged: (v) => setState(() {
                              _addExpense = v;
                              if (v) _syncAmountFromPrices();
                            }),
                        onPaymentMethodChanged: (v) =>
                            setState(() => _paymentMethod = v),
                        onMerchantChanged: (id) =>
                            setState(() => _selectedMerchantId = id),
                        l10n: l10n,
                      ),
              ),
            ),
            // 하단 버튼 영역
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.spaceL,
                AppSizes.spaceS,
                AppSizes.spaceL,
                AppSizes.spaceM + bottomPadding,
              ),
              child: Row(
                children: [
                  if (_isStep2)
                    TextButton(
                      onPressed: _loading ? null : () => setState(() => _isStep2 = false),
                      child: Text(l10n.common_back),
                    ),
                  if (_isStep2) const SizedBox(width: AppSizes.spaceS),
                  Expanded(
                    child: FilledButton(
                      onPressed: _loading
                          ? null
                          : () {
                              if (!_isStep2 && hasTransfer) {
                                _goToStep2();
                              } else {
                                _submit();
                              }
                            },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : Text(_isStep2 || !hasTransfer
                              ? l10n.fridge_cart_complete
                              : l10n.common_next),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 1: 보관소 선택 + 가계부 ─────────────────────────────────────────────────

class _Step1Content extends ConsumerWidget {
  final List<CartItemModel> items;
  final Map<String, String?> transferMap;
  final Set<String> excludedSet;
  final DateTime completedAt;
  final ValueChanged<DateTime> onCompletedAtChanged;
  final bool addExpense;
  final String? selectedMerchantId;
  final TextEditingController amountController;
  final TextEditingController descController;
  final PaymentMethod paymentMethod;
  final void Function(String itemId, String? storageId) onTransferChanged;
  final ValueChanged<String> onExcludeToggled;
  final ValueChanged<bool> onAddExpenseChanged;
  final ValueChanged<PaymentMethod> onPaymentMethodChanged;
  final ValueChanged<String?> onMerchantChanged;
  final AppLocalizations l10n;

  const _Step1Content({
    required this.items,
    required this.transferMap,
    required this.excludedSet,
    required this.completedAt,
    required this.onCompletedAtChanged,
    required this.addExpense,
    required this.selectedMerchantId,
    required this.amountController,
    required this.descController,
    required this.paymentMethod,
    required this.onTransferChanged,
    required this.onExcludeToggled,
    required this.onAddExpenseChanged,
    required this.onPaymentMethodChanged,
    required this.onMerchantChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storages = ref.watch(storagesProvider).value ?? [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.fridge_cart_complete_transfer_hint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline)),
        const SizedBox(height: AppSizes.spaceS),
        ...items.map((item) => _TransferRow(
              item: item,
              storages: storages,
              selectedStorageId: transferMap[item.id],
              excluded: excludedSet.contains(item.id),
              onChanged: (id) => onTransferChanged(item.id, id),
              onExcludeToggled: () => onExcludeToggled(item.id),
              l10n: l10n,
            )),
        const Divider(height: AppSizes.spaceL),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('장보기 날짜',
              style: Theme.of(context).textTheme.bodyMedium),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('yyyy년 MM월 dd일').format(completedAt),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: AppSizes.spaceXS),
              const Icon(Icons.calendar_today_outlined, size: 18),
            ],
          ),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: completedAt,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now(),
            );
            if (picked != null) onCompletedAtChanged(picked);
          },
        ),
        const Divider(height: AppSizes.spaceL),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.fridge_cart_complete_add_expense),
          value: addExpense,
          onChanged: onAddExpenseChanged,
        ),
        if (addExpense) ...[
          TextField(
            controller: amountController,
            decoration:
                InputDecoration(labelText: l10n.fridge_cart_complete_amount),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSizes.spaceS),
          TextField(
            controller: descController,
            decoration: InputDecoration(
                labelText: l10n.fridge_cart_complete_description),
          ),
          const SizedBox(height: AppSizes.spaceS),
          _MerchantSelector(
            selectedId: selectedMerchantId,
            onChanged: onMerchantChanged,
          ),
          const SizedBox(height: AppSizes.spaceS),
          SegmentedButton<PaymentMethod>(
            segments: const [
              ButtonSegment(value: PaymentMethod.card, label: Text('카드')),
              ButtonSegment(value: PaymentMethod.cash, label: Text('현금')),
              ButtonSegment(
                  value: PaymentMethod.transfer, label: Text('이체')),
            ],
            selected: {paymentMethod},
            onSelectionChanged: (s) => onPaymentMethodChanged(s.first),
          ),
        ],
      ],
    );
  }
}

// ── Step 2: 이관 상세 입력 (아코디언) ────────────────────────────────────────────

class _Step2Content extends ConsumerStatefulWidget {
  final List<_TransferDetail> details;
  final AppLocalizations l10n;
  final DateTime completedAt;

  const _Step2Content({
    required this.details,
    required this.l10n,
    required this.completedAt,
  });

  @override
  ConsumerState<_Step2Content> createState() => _Step2ContentState();
}

class _Step2ContentState extends ConsumerState<_Step2Content> {
  // 펼쳐진 항목 ID 집합
  final Set<String> _expanded = {};
  // cartItemId → 추천 유통기한 일수
  final Map<String, int?> _suggestions = {};

  void _matchAll(List<ExpiryPresetModel> presets, List<StorageModel> storages) {
    if (presets.isEmpty) return;
    var changed = false;
    for (final d in widget.details) {
      if (_suggestions.containsKey(d.cartItem.id)) continue;
      final q = d.cartItem.name.trim().toLowerCase();
      final storageType = storages
          .where((s) => s.id == d.storageId)
          .map((s) => s.type)
          .firstOrNull;

      // 정확 일치 > 입력명이 keyword/category 포함 > keyword/category가 입력명 포함
      int score(ExpiryPresetModel p) {
        final kw = p.keyword.toLowerCase();
        final cat = p.category.toLowerCase();
        if (kw == q || cat == q) return 3;
        if (q.contains(kw) || q.contains(cat)) return 2;
        if (kw.contains(q) || cat.contains(q)) return 1;
        return 0;
      }

      bool hits(ExpiryPresetModel p) => score(p) > 0;

      ExpiryPresetModel? best(Iterable<ExpiryPresetModel> candidates) =>
          candidates.fold<ExpiryPresetModel?>(null, (b, p) {
            if (b == null) return p;
            final sb = score(b), sp = score(p);
            if (sp != sb) return sp > sb ? p : b;
            // 점수 같으면 keyword 길이 짧은 것 (더 구체적)
            return p.keyword.length < b.keyword.length ? p : b;
          });

      // storageType 일치 우선 → storageType null(무관) → 전체 fallback
      ExpiryPresetModel? match;
      if (storageType != null) {
        match = best(presets.where((p) => p.storageType == storageType && hits(p)));
      }
      match ??= best(presets.where((p) => p.storageType == null && hits(p)));
      match ??= best(presets.where(hits));

      if (match != null) {
        _suggestions[d.cartItem.id] = match.days;
        changed = true;
      }
    }
    if (changed && mounted) setState(() {});
  }

  void _toggle(String id) {
    setState(() {
      if (_expanded.contains(id)) {
        _expanded.remove(id);
      } else {
        // 다른 항목 모두 닫고 선택한 항목만 열기
        _expanded
          ..clear()
          ..add(id);
      }
    });
  }

  Future<void> _openReferenceSelector(
      _TransferDetail detail, List<StorageModel> storages) async {
    final storageType = storages
        .where((s) => s.id == detail.storageId)
        .map((s) => s.type)
        .firstOrNull;
    final result = await showModalBottomSheet<ExpiryReferenceResult>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ExpiryReferenceSelectorSheet(
        currentStorageType: storageType ?? StorageType.fridge,
        baseDate: widget.completedAt,
      ),
    );
    if (result == null || !mounted) return;
    setState(() => detail.expiresAt = result.suggestedExpiresAt);
  }

  Future<void> _pickDate(_TransferDetail detail) async {
    final base = widget.completedAt;
    final picked = await showDatePicker(
      context: context,
      initialDate: detail.expiresAt ?? base.add(const Duration(days: 7)),
      firstDate: base,
      lastDate: base.add(const Duration(days: 3650)),
    );
    if (picked != null) setState(() => detail.expiresAt = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;

    final storages = ref.watch(storagesProvider).value ?? [];

    ref.listen(expiryPresetsProvider, (_, next) {
      final presets = next.valueOrNull;
      if (presets != null) _matchAll(presets, storages);
    });

    // 이미 로드된 경우 즉시 매칭
    final loaded = ref.read(expiryPresetsProvider).valueOrNull;
    if (loaded != null && _suggestions.isEmpty) _matchAll(loaded, storages);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.details.map((d) {
        final id = d.cartItem.id;
        final isExpanded = _expanded.contains(id);

        // 요약 텍스트: 수량 + 유통기한(입력 시)
        final qty = int.tryParse(d.quantity.text) ?? d.cartItem.quantity;
        final unit = d.cartItem.unit ?? '';
        final expiryLabel = d.expiresAt != null
            ? '⏱ ${DateFormat('MM/dd').format(d.expiresAt!)}'
            : null;
        final subtitle = [
          '$qty$unit',
          if (expiryLabel != null) expiryLabel,
        ].join('  ·  ');

        return Card(
          margin: const EdgeInsets.only(bottom: AppSizes.spaceS),
          child: Column(
            children: [
              // ── 요약 행 (항상 표시) ──
              ListTile(
                onTap: () => _toggle(id),
                title: Text(d.cartItem.name,
                    style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                trailing: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20,
                ),
              ),
              // ── 펼침 폼 ──
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: isExpanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.spaceM,
                    0,
                    AppSizes.spaceM,
                    AppSizes.spaceM,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 1),
                      const SizedBox(height: AppSizes.spaceS),
                      TextField(
                        controller: d.quantity,
                        decoration: InputDecoration(
                            labelText: l10n.fridge_item_quantity,
                            isDense: true),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSizes.spaceS),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        subtitle: Text(
                          l10n.fridge_item_expires_at,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        title: Text(
                          d.expiresAt != null
                              ? DateFormat('yyyy-MM-dd').format(d.expiresAt!)
                              : '날짜 선택',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: d.expiresAt != null
                                        ? null
                                        : Theme.of(context)
                                            .colorScheme
                                            .outline,
                                  ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (d.expiresAt != null)
                              IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () =>
                                    setState(() => d.expiresAt = null),
                              ),
                            IconButton(
                              icon: const Icon(Icons.search, size: 18),
                              onPressed: () => _openReferenceSelector(d, storages),
                            ),
                            const Icon(Icons.calendar_today_outlined,
                                size: 18),
                          ],
                        ),
                        onTap: () => _pickDate(d),
                      ),
                      if (d.expiresAt == null && _suggestions[d.cartItem.id] != null)
                        _SuggestionChip(
                          days: _suggestions[d.cartItem.id]!,
                          onApply: () => setState(() {
                            d.expiresAt = widget.completedAt.add(
                                Duration(days: _suggestions[d.cartItem.id]!));
                          }),
                        ),
                      if (d.expiresAt != null)
                        Row(
                          children: [
                            Text(l10n.fridge_item_alert_days(d.alertDays),
                                style:
                                    Theme.of(context).textTheme.bodySmall),
                            Expanded(
                              child: Slider(
                                value: d.alertDays.toDouble(),
                                min: 1,
                                max: 14,
                                divisions: 13,
                                onChanged: (v) =>
                                    setState(() => d.alertDays = v.toInt()),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                secondChild: const SizedBox.shrink(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── 냉장고 이관 선택 행 ──────────────────────────────────────────────────────────

class _TransferRow extends StatelessWidget {
  final CartItemModel item;
  final List<StorageModel> storages;
  final String? selectedStorageId;
  final bool excluded;
  final ValueChanged<String?> onChanged;
  final VoidCallback onExcludeToggled;
  final AppLocalizations l10n;

  const _TransferRow({
    required this.item,
    required this.storages,
    required this.selectedStorageId,
    required this.excluded,
    required this.onChanged,
    required this.onExcludeToggled,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final priceText = item.price != null ? _fmtPrice(item.price!) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXS),
      child: Row(
        children: [
          Checkbox(
            value: !excluded,
            visualDensity: VisualDensity.compact,
            onChanged: (_) => onExcludeToggled(),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onExcludeToggled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.name} (${item.quantity}${item.unit ?? ''})',
                    style: textTheme.bodyMedium?.copyWith(
                      color: excluded ? colorScheme.outline : null,
                      decoration: excluded ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (priceText != null)
                    Text(
                      '$priceText원',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                        decoration: excluded ? TextDecoration.lineThrough : null,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!excluded)
            FocusDismissDropdown(
              child: DropdownButton<String?>(
                value: selectedStorageId,
                hint: Text(l10n.fridge_cart_skip_transfer,
                    style: textTheme.bodySmall),
                underline: const SizedBox.shrink(),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(l10n.fridge_cart_skip_transfer,
                        style: textTheme.bodySmall),
                  ),
                  ...storages.map((s) => DropdownMenuItem<String?>(
                        value: s.id,
                        child: Text(s.name, style: textTheme.bodySmall),
                      )),
                ],
                onChanged: onChanged,
              ),
            ),
        ],
      ),
    );
  }
}

// ── 소비처 선택 ───────────────────────────────────────────────────────────────────

// 장보기 그룹 기준으로 소비처를 가져오는 전용 provider (householdSelectedGroupIdProvider와 무관)
final _shoppingMerchantsProvider =
    FutureProvider.autoDispose.family<List<MerchantModel>, String>(
  (ref, groupId) =>
      ref.watch(householdRepositoryProvider).getMerchants(groupId: groupId),
);

class _MerchantSelector extends ConsumerWidget {
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const _MerchantSelector({required this.selectedId, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final groupId = ref.watch(fridgeSelectedGroupIdProvider);
    final merchantsAsync = groupId != null
        ? ref.watch(_shoppingMerchantsProvider(groupId))
        : ref.watch(merchantsProvider);

    return merchantsAsync.when(
      data: (merchants) => InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.household_merchant_select,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceS,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.storefront_outlined, size: 18),
            tooltip: l10n.household_merchants,
            onPressed: () => context.push(AppRoutes.householdMerchants),
          ),
        ),
        child: FocusDismissDropdown(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: merchants.any((m) => m.id == selectedId) ? selectedId : null,
              isExpanded: true,
              isDense: true,
              hint: Text(
                merchants.isEmpty
                    ? l10n.household_merchants_empty
                    : l10n.household_merchant_none,
              ),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.household_merchant_none),
                ),
                ...merchants.map(
                  (m) => DropdownMenuItem(value: m.id, child: Text(m.name)),
                ),
              ],
              onChanged: merchants.isEmpty ? null : onChanged,
            ),
          ),
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

// ── 유통기한 추천 칩 (장보기 완료 Step 2용) ─────────────────────────────────────────

class _SuggestionChip extends StatelessWidget {
  final int days;
  final VoidCallback onApply;

  const _SuggestionChip({required this.days, required this.onApply});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final suggestedDate = DateTime.now().add(Duration(days: days));
    final dateStr = DateFormat('MM/dd').format(suggestedDate);

    return GestureDetector(
      onTap: onApply,
      child: Container(
        margin: const EdgeInsets.only(top: AppSizes.spaceXS),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceS, vertical: AppSizes.spaceXS),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 14, color: colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              '$days일 추천  ·  $dateStr 까지  →  적용',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
