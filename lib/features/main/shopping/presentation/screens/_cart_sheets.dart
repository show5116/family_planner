part of 'cart_tab.dart';

// ── 품목 수정 바텀시트 ────────────────────────────────────────────────────────────

class _EditCartItemSheet extends StatefulWidget {
  final CartItemModel item;
  final _CartEditState editState;
  final VoidCallback onSaved;

  const _EditCartItemSheet({
    required this.item,
    required this.editState,
    required this.onSaved,
  });

  @override
  State<_EditCartItemSheet> createState() => _EditCartItemSheetState();
}

class _EditCartItemSheetState extends State<_EditCartItemSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _unitCtrl;
  late final TextEditingController _memoCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.editState.name);
    _unitCtrl = TextEditingController(text: widget.editState.unit ?? '');
    _memoCtrl = TextEditingController(text: widget.editState.memo ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _unitCtrl.dispose();
    _memoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final mq = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.spaceL,
        right: AppSizes.spaceL,
        top: AppSizes.spaceL,
        bottom: mq.viewInsets.bottom + mq.padding.bottom + AppSizes.spaceL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.common_edit, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSizes.spaceM),
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(labelText: l10n.fridge_item_name),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _unitCtrl,
                  decoration: InputDecoration(labelText: l10n.fridge_item_unit),
                ),
              ),
              const SizedBox(width: AppSizes.spaceM),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _memoCtrl,
                  decoration: InputDecoration(labelText: l10n.fridge_item_memo),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceM),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.common_cancel),
              ),
              const SizedBox(width: AppSizes.spaceS),
              FilledButton(
                onPressed: () {
                  final es = widget.editState;
                  es.name = _nameCtrl.text.trim().isEmpty
                      ? widget.item.name
                      : _nameCtrl.text.trim();
                  es.unit = _unitCtrl.text.trim().isEmpty
                      ? null
                      : _unitCtrl.text.trim();
                  es.memo = _memoCtrl.text.trim().isEmpty
                      ? null
                      : _memoCtrl.text.trim();
                  widget.onSaved();
                  Navigator.pop(context);
                },
                child: Text(l10n.common_done),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── 품목 추가 바텀시트 ────────────────────────────────────────────────────────────

class _AddCartItemSheet extends ConsumerStatefulWidget {
  const _AddCartItemSheet();

  @override
  ConsumerState<_AddCartItemSheet> createState() => _AddCartItemSheetState();
}

class _AddCartItemSheetState extends ConsumerState<_AddCartItemSheet> {
  final _nameCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController(text: '1');
  final _unitCtrl = TextEditingController();
  final _memoCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  bool _isUnitPrice = false;
  bool _showExtra = false; // 단위·메모 확장 여부

  @override
  void dispose() {
    _nameCtrl.dispose();
    _quantityCtrl.dispose();
    _unitCtrl.dispose();
    _memoCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  double? _calcTotalPrice() {
    final raw = _parsePrice(_priceCtrl.text);
    if (raw == null) return null;
    final qty = int.tryParse(_quantityCtrl.text.trim()) ?? 1;
    return _isUnitPrice ? raw * qty : raw;
  }

  void _submit() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final entry = CartItemEntryDto(
      name: name,
      quantity: int.tryParse(_quantityCtrl.text.trim()) ?? 1,
      unit: _unitCtrl.text.trim().isEmpty ? null : _unitCtrl.text.trim(),
      memo: _memoCtrl.text.trim().isEmpty ? null : _memoCtrl.text.trim(),
      price: _calcTotalPrice(),
    );
    if (mounted) Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final canSubmit = _nameCtrl.text.trim().isNotEmpty;
    final qty = int.tryParse(_quantityCtrl.text.trim()) ?? 1;
    final unitPrice = _parsePrice(_priceCtrl.text);
    final showTotal = _isUnitPrice && unitPrice != null && qty > 1;
    final mq = MediaQuery.of(context);
    final keyboardHeight = mq.viewInsets.bottom;
    final bottomInset = mq.padding.bottom;

    return ConstrainedBox(
      // 화면 높이의 90% 까지만 올라옴
      constraints: BoxConstraints(
        maxHeight: mq.size.height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 핸들
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.spaceM),
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
          // 스크롤 가능 폼 영역
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppSizes.spaceL,
                right: AppSizes.spaceL,
                top: AppSizes.spaceM,
                bottom: keyboardHeight + bottomInset + AppSizes.spaceL,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.fridge_cart_add_item,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSizes.spaceM),

                  // ── 필수 필드 ──
                  ItemNameAutocomplete(
                    controller: _nameCtrl,
                    decoration: InputDecoration(labelText: l10n.fridge_item_name),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _submit(),
                    onSelected: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                  Row(
                    children: [
                      Text(l10n.fridge_item_quantity,
                          style: Theme.of(context).textTheme.bodyMedium),
                      const Spacer(),
                      _QtyButton(
                        icon: Icons.remove,
                        onPressed: qty > 1
                            ? () {
                                _quantityCtrl.text = '${qty - 1}';
                                setState(() {});
                              }
                            : null,
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '$qty',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      _QtyButton(
                        icon: Icons.add,
                        onPressed: () {
                          _quantityCtrl.text = '${qty + 1}';
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _priceCtrl,
                          decoration: InputDecoration(
                            labelText: _isUnitPrice ? '개당 금액' : '총 금액',
                            hintText: _isUnitPrice ? '개당 금액 입력' : '총 금액 입력',
                            suffixText: '원',
                            helperText: showTotal
                                ? '합계 ${NumberFormat('#,###').format((unitPrice * qty).toInt())}원'
                                : null,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (_) {
                            _applyPriceFormat(_priceCtrl);
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: AppSizes.spaceM),
                      GestureDetector(
                        onTap: () => setState(() => _isUnitPrice = !_isUnitPrice),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _isUnitPrice
                                ? colorScheme.primaryContainer
                                : colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _isUnitPrice
                                  ? colorScheme.primary
                                  : colorScheme.outlineVariant,
                            ),
                          ),
                          child: Text(
                            _isUnitPrice ? '개당' : '총액',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: _isUnitPrice
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── 선택 필드 (단위·메모) ──
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 200),
                    crossFadeState: _showExtra
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSizes.spaceM),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _unitCtrl,
                                decoration: InputDecoration(labelText: l10n.fridge_item_unit),
                              ),
                            ),
                            const SizedBox(width: AppSizes.spaceM),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: _memoCtrl,
                                decoration: InputDecoration(labelText: l10n.fridge_item_memo),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    secondChild: const SizedBox.shrink(),
                  ),

                  // 단위·메모 토글 버튼
                  const SizedBox(height: AppSizes.spaceS),
                  GestureDetector(
                    onTap: () => setState(() => _showExtra = !_showExtra),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _showExtra ? Icons.remove_circle_outline : Icons.add_circle_outline,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _showExtra ? '단위·메모 숨기기' : '단위·메모 추가',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.spaceL),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.common_cancel),
                        ),
                      ),
                      const SizedBox(width: AppSizes.spaceM),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: canSubmit ? _submit : null,
                          child: Text(l10n.fridge_cart_add_item),
                        ),
                      ),
                    ],
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

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  const _QtyButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20),
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      color: Theme.of(context).colorScheme.primary,
      disabledColor: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
