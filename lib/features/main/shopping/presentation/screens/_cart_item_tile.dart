part of 'cart_tab.dart';

// ── 총합계 바 ───────────────────────────────────────────────────────────────────

class _TotalPriceBar extends StatelessWidget {
  final double total;
  final bool syncing;
  const _TotalPriceBar({required this.total, this.syncing = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fmt = NumberFormat('#,###');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceL, vertical: AppSizes.spaceS),
      color: colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            '합계',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const Spacer(),
          if (syncing)
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: colorScheme.outline,
              ),
            ),
          if (syncing) const SizedBox(width: AppSizes.spaceS),
          Text(
            total > 0 ? '${fmt.format(total.toInt())}원' : '-',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: total > 0 ? colorScheme.primary : colorScheme.outline,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

// ── 하단 고정 완료 버튼 바 ──────────────────────────────────────────────────────

class _CompleteBottomBar extends StatelessWidget {
  final bool syncing;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _CompleteBottomBar({
    super.key,
    required this.syncing,
    required this.onTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
          AppSizes.spaceM, AppSizes.spaceS, AppSizes.spaceM, AppSizes.spaceM),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: FilledButton.icon(
        onPressed: syncing ? null : onTap,
        icon: syncing
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.check_rounded, size: 18),
        label: Text(l10n.fridge_cart_complete),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  final AppLocalizations l10n;
  const _EmptyCart({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 64, color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: AppSizes.spaceM),
          Text(l10n.fridge_cart_empty,
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

// ── 장바구니 품목 타일 ───────────────────────────────────────────────────────────

class _CartItemTile extends StatefulWidget {
  final CartItemModel item;
  final _CartEditState editState;
  final bool isPending;
  final VoidCallback onChanged;
  final VoidCallback? onTapEdit;
  final VoidCallback? onRemove; // pending 항목 제거용

  const _CartItemTile({
    super.key,
    required this.item,
    required this.editState,
    this.isPending = false,
    required this.onChanged,
    this.onTapEdit,
    this.onRemove,
  });

  @override
  State<_CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<_CartItemTile> {
  late final TextEditingController _priceCtrl;
  // isUnitPrice는 State 로컬 — editState 재사용 시 컨트롤러 표시값과 불일치 방지
  bool _isUnitPrice = false;
  bool _ignoreListener = false;

  _CartEditState get _es => widget.editState;

  String _displayText() {
    if (_es.price == null) return '';
    if (_isUnitPrice && _es.quantity > 0) {
      return _fmtPrice(_es.price! / _es.quantity);
    }
    return _fmtPrice(_es.price!);
  }

  // 컨트롤러 표시값 → editState.price(총액) 동기화
  void _syncPrice() {
    if (_ignoreListener) return;
    // 콤마 제거 후 파싱
    final entered = _parsePrice(_priceCtrl.text);
    if (entered == null) {
      _es.price = _priceCtrl.text.replaceAll(',', '').trim().isEmpty ? null : _es.price;
    } else if (_isUnitPrice) {
      _es.price = entered * _es.quantity;
    } else {
      _es.price = entered;
    }
    // 입력 중 콤마 자동 포맷 적용
    _ignoreListener = true;
    _applyPriceFormat(_priceCtrl);
    _ignoreListener = false;
    widget.onChanged();
  }

  // 수량 변경 시 단가 모드라면 총액 재계산, 컨트롤러 표시값은 그대로 유지
  void _changeQuantity(int delta) {
    _es.quantity += delta;
    if (_es.quantity == 0) _es.markedForDelete = true;
    final raw = _parsePrice(_priceCtrl.text);
    if (raw != null && _isUnitPrice) {
      _es.price = raw * _es.quantity;
    }
    widget.onChanged();
  }

  // 모드 전환 시 컨트롤러 표시값 변환
  void _togglePriceMode() {
    setState(() {
      _ignoreListener = true;
      if (_isUnitPrice) {
        // 단가 → 총액
        _priceCtrl.text = _es.price != null ? _fmtPrice(_es.price!) : '';
        _isUnitPrice = false;
      } else {
        // 총액 → 단가
        if (_es.price != null && _es.quantity > 0) {
          _priceCtrl.text = _fmtPrice(_es.price! / _es.quantity);
        }
        _isUnitPrice = true;
      }
      _ignoreListener = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _priceCtrl = TextEditingController(text: _displayText());
    _priceCtrl.addListener(_syncPrice);
  }

  @override
  void didUpdateWidget(_CartItemTile old) {
    super.didUpdateWidget(old);
    if (old.editState != widget.editState) {
      _isUnitPrice = false;
      _ignoreListener = true;
      _priceCtrl.text = _displayText();
      _ignoreListener = false;
    }
  }

  @override
  void dispose() {
    _priceCtrl.removeListener(_syncPrice);
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final deleted = _es.markedForDelete;
    final colorScheme = Theme.of(context).colorScheme;

    // 단가 모드일 때 총액 미리보기 문자열
    String? priceHint;
    if (_isUnitPrice && _es.price != null && _es.quantity > 1) {
      final fmt = NumberFormat('#,###');
      priceHint = '합계 ${fmt.format(_es.price!.toInt())}원';
    }

    return Dismissible(
      key: ValueKey('cart_dismissible_${widget.item.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        if (widget.onRemove != null) {
          // pending 항목: 즉시 제거
          widget.onRemove!();
          return true;
        }
        // 서버 항목: 삭제 표시
        _es.markedForDelete = true;
        widget.onChanged();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.spaceL),
        color: colorScheme.errorContainer,
        child: Icon(Icons.delete_outline, color: colorScheme.onErrorContainer),
      ),
      child: AnimatedOpacity(
        opacity: deleted ? 0.38 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: deleted ? null : widget.onTapEdit,
              title: Text(
                _es.name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      decoration: deleted ? TextDecoration.lineThrough : null,
                    ),
              ),
              subtitle: () {
                final parts = <String>[];
                final u = _es.unit;
                if (u != null && u.isNotEmpty) parts.add(u);
                final m = _es.memo;
                if (m != null && m.isNotEmpty) parts.add(m);
                if (parts.isEmpty) return null;
                return Text(
                  parts.join('  ·  '),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                );
              }(),
              trailing: deleted
                  ? IconButton(
                      icon: Icon(Icons.undo, color: colorScheme.primary, size: 20),
                      tooltip: l10n.common_undo,
                      onPressed: () {
                        _es.markedForDelete = false;
                        if (_es.quantity == 0) _es.quantity = widget.item.quantity;
                        widget.onChanged();
                      },
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 18),
                          visualDensity: VisualDensity.compact,
                          onPressed: _es.quantity > 0
                              ? () => setState(() => _changeQuantity(-1))
                              : null,
                        ),
                        Text(
                          _es.quantity.toString(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 18),
                          visualDensity: VisualDensity.compact,
                          onPressed: () => setState(() => _changeQuantity(1)),
                        ),
                      ],
                    ),
            ),
            if (!deleted)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSizes.spaceM, 0, AppSizes.spaceM, AppSizes.spaceXS),
                child: Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextField(
                        controller: _priceCtrl,
                        decoration: InputDecoration(
                          hintText: _isUnitPrice ? '개당 금액 입력' : '총 금액 입력',
                          suffixText: _priceCtrl.text.isNotEmpty ? '원' : null,
                          helperText: priceHint,
                          helperStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                              ),
                          isDense: true,
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.outlineVariant,
                              width: 1,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    // 단가/총액 토글 — 둥근 텍스트 칩 (금액 입력 시에만 표시)
                    if (_priceCtrl.text.isNotEmpty || _isUnitPrice)
                      GestureDetector(
                        onTap: _togglePriceMode,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
              ),
          ],
        ),
      ),
    );
  }
}
