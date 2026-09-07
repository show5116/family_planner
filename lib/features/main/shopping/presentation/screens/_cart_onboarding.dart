part of 'cart_tab.dart';

// ── 장보기 완료 기능 안내 다이얼로그 (온보딩용) ──────────────────────────────────────

class _DemoCompleteDialog extends StatelessWidget {
  final Key? dialogKey;
  const _DemoCompleteDialog({this.dialogKey});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Dialog + 내부 Container에 key 적용 — AlertDialog는 내부에서 full-screen Align을
    // 최상위 RenderObject로 반환하므로 key를 AlertDialog에 붙이면 화면 전체 크기를 잡음
    return Dialog(
      child: Container(
        key: dialogKey,
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle_outline, color: colorScheme.primary, size: 22),
                  const SizedBox(width: 8),
                  Text(l10n.coach_cart_complete, style: textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.coach_cart_complete_desc,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
              ),
              const SizedBox(height: 16),
              _DemoInfoCard(
                icon: Icons.kitchen_outlined,
                color: colorScheme.primary,
                title: l10n.coach_cart_to_fridge,
                description: l10n.coach_cart_to_fridge_desc,
                preview: Column(
                  children: [
                    _DemoTransferRow(name: l10n.demo_milk, qty: '2개', storage: l10n.demo_fridge),
                    _DemoTransferRow(name: l10n.demo_eggs, qty: '1판', storage: l10n.demo_fridge),
                    _DemoTransferRow(name: l10n.demo_tofu, qty: '1개', storage: l10n.coach_cart_no_transfer),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _DemoInfoCard(
                icon: Icons.account_balance_wallet_outlined,
                color: colorScheme.tertiary,
                title: l10n.coach_cart_to_expense,
                description: l10n.coach_cart_to_expense_desc,
                preview: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 16, color: colorScheme.outline),
                          const SizedBox(width: 6),
                          Text(l10n.cart_default_description, style: textTheme.bodySmall),
                          const Spacer(),
                          Text('32,500원', style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.credit_card_outlined, size: 14, color: colorScheme.outline),
                          const SizedBox(width: 4),
                          Text(l10n.household_payment_card, style: textTheme.labelSmall?.copyWith(color: colorScheme.outline)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoInfoCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final Widget preview;

  const _DemoInfoCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(title, style: textTheme.titleSmall?.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: 6),
          Text(description, style: textTheme.bodySmall?.copyWith(color: colorScheme.outline)),
          const SizedBox(height: 10),
          preview,
        ],
      ),
    );
  }
}

class _DemoTransferRow extends StatelessWidget {
  final String name;
  final String qty;
  final String storage;

  const _DemoTransferRow({
    required this.name,
    required this.qty,
    required this.storage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSkipped = storage == l10n.coach_cart_no_transfer;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            isSkipped ? Icons.remove_circle_outline : Icons.kitchen_outlined,
            size: 14,
            color: isSkipped ? colorScheme.outline : colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text('$name ($qty)', style: textTheme.bodySmall),
          ),
          Text(
            storage,
            style: textTheme.labelSmall?.copyWith(
              color: isSkipped ? colorScheme.outline : colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── 온보딩 전용 뷰 (샘플 데이터, 탭/수정 불가) ──────────────────────────────────

class _OnboardingCartView extends StatelessWidget {
  final List<CartItemModel> items;
  final GlobalKey addFabKey;
  final GlobalKey completeFabKey;
  final GlobalKey firstItemKey;

  const _OnboardingCartView({
    required this.items,
    required this.addFabKey,
    required this.completeFabKey,
    required this.firstItemKey,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AbsorbPointer(
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final item = items[i];
            final isFirst = i == 0;

            return ListTile(
              key: isFirst ? firstItemKey : null,
              title: Text(item.name,
                  style: Theme.of(context).textTheme.bodyLarge),
              subtitle: () {
                final parts = <String>[];
                if (item.unit != null && item.unit!.isNotEmpty) {
                  parts.add(item.unit!);
                }
                if (item.memo != null && item.memo!.isNotEmpty) {
                  parts.add(item.memo!);
                }
                if (parts.isEmpty) return null;
                return Text(
                  parts.join('  ·  '),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                );
              }(),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.remove, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${item.quantity}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Icon(Icons.add, size: 18),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            key: addFabKey,
            heroTag: 'cart_demo_add',
            onPressed: null,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: AppSizes.spaceS),
          FloatingActionButton.extended(
            key: completeFabKey,
            heroTag: 'cart_demo_complete',
            onPressed: null,
            icon: const Icon(Icons.check),
            label: Text(l10n.fridge_cart_complete),
          ),
        ],
      ),
    );
  }
}
