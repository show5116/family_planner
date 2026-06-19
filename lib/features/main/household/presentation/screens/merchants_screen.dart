import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/household/data/models/merchant_model.dart';
import 'package:family_planner/features/main/household/providers/merchant_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class MerchantsScreen extends ConsumerStatefulWidget {
  const MerchantsScreen({super.key});

  @override
  ConsumerState<MerchantsScreen> createState() => _MerchantsScreenState();
}

class _MerchantsScreenState extends ConsumerState<MerchantsScreen> {
  // dispose()에서 ref는 이미 무효화돼 있으므로 notifier를 미리 저장해둠
  Merchants? _notifier;

  @override
  void initState() {
    super.initState();
    // 화면이 열리는 순간 캐시 고정 — 통계 화면 등 다른 구독자가 없어도 데이터 유지
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _notifier = ref.read(merchantsProvider.notifier);
      _notifier!.keepAlive();
    });
  }

  @override
  void dispose() {
    // ref.read()는 dispose() 시점에 이미 무효화됨 → 저장된 notifier 참조로 직접 해제
    _notifier?.releaseKeepAlive();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final merchantsAsync = ref.watch(merchantsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.household_merchants)),
      body: merchantsAsync.when(
        data: (merchants) => _MerchantsList(merchants: merchants),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.common_error),
              const SizedBox(height: AppSizes.spaceS),
              ElevatedButton(
                onPressed: () => ref.invalidate(merchantsProvider),
                child: Text(l10n.common_retry),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context, l10n),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddSheet(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _MerchantFormSheet(
        onSave: (name) async {
          await ref.read(merchantsProvider.notifier).create(name);
        },
      ),
    );
  }
}

class _MerchantsList extends ConsumerWidget {
  final List<MerchantModel> merchants;

  const _MerchantsList({required this.merchants});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        // 샘플 소비처 섹션
        SliverToBoxAdapter(
          child: _SampleMerchantsSection(existingNames: merchants.map((m) => m.name).toSet()),
        ),
        // 내 소비처 섹션
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceS),
            child: Text(
              l10n.household_merchants_my,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ),
        if (merchants.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              child: Text(
                l10n.household_merchants_empty,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final merchant = merchants[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    child: Text(
                      merchant.name.characters.first,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
                    ),
                  ),
                  title: Text(merchant.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        iconSize: 20,
                        onPressed: () => _showEditSheet(context, ref, l10n, merchant),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        iconSize: 20,
                        color: Theme.of(context).colorScheme.error,
                        onPressed: () => _confirmDelete(context, ref, l10n, merchant),
                      ),
                    ],
                  ),
                );
              },
              childCount: merchants.length,
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  void _showEditSheet(BuildContext context, WidgetRef ref, AppLocalizations l10n, MerchantModel merchant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _MerchantFormSheet(
        initialName: merchant.name,
        onSave: (name) async {
          await ref.read(merchantsProvider.notifier).edit(merchant.id, name);
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, AppLocalizations l10n, MerchantModel merchant) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.household_merchants_delete),
        content: Text(l10n.household_merchants_delete_confirm(merchant.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.common_delete, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(merchantsProvider.notifier).remove(merchant.id);
  }
}

class _SampleMerchantsSection extends ConsumerWidget {
  final Set<String> existingNames;

  const _SampleMerchantsSection({required this.existingNames});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceS),
          child: Text(
            l10n.household_merchants_samples,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
            itemCount: kMerchantSamples.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSizes.spaceS),
            itemBuilder: (context, index) {
              final sample = kMerchantSamples[index];
              final already = existingNames.contains(sample.name);
              return _SampleMerchantChip(
                sample: sample,
                already: already,
                onAdd: already
                    ? null
                    : () async {
                        await ref.read(merchantsProvider.notifier).create(sample.name);
                      },
              );
            },
          ),
        ),
        const SizedBox(height: AppSizes.spaceS),
        const Divider(height: 1),
      ],
    );
  }
}

class _SampleMerchantChip extends StatelessWidget {
  final MerchantSample sample;
  final bool already;
  final VoidCallback? onAdd;

  const _SampleMerchantChip({
    required this.sample,
    required this.already,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              InkWell(
                onTap: already ? null : onAdd,
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: already
                        ? colorScheme.surfaceContainerHighest
                        : sample.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                    border: Border.all(
                      color: already ? colorScheme.outlineVariant : sample.color.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    sample.icon,
                    color: already ? colorScheme.outline : sample.color,
                    size: 24,
                  ),
                ),
              ),
              if (sample.hasAppLink)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () => sample.launchApp(),
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: colorScheme.surface, width: 1.5),
                      ),
                      child: Icon(Icons.open_in_new, size: 10, color: colorScheme.onPrimary),
                    ),
                  ),
                ),
              if (already)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, size: 10, color: colorScheme.onPrimary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            sample.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: already ? colorScheme.outline : colorScheme.onSurface,
                  fontSize: 10,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MerchantFormSheet extends StatefulWidget {
  final String? initialName;
  final Future<void> Function(String name) onSave;

  const _MerchantFormSheet({this.initialName, required this.onSave});

  @override
  State<_MerchantFormSheet> createState() => _MerchantFormSheetState();
}

class _MerchantFormSheetState extends State<_MerchantFormSheet> {
  late final TextEditingController _controller;
  bool _loading = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.initialName != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spaceM,
        AppSizes.spaceM,
        AppSizes.spaceM,
        MediaQuery.of(context).viewInsets.bottom + AppSizes.spaceM,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isEdit ? l10n.household_merchants_edit : l10n.household_merchants_add,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSizes.spaceM),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.household_merchants_name,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(l10n),
          ),
          if (_errorMsg != null) ...[
            const SizedBox(height: AppSizes.spaceXS),
            Text(
              _errorMsg!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
          const SizedBox(height: AppSizes.spaceM),
          FilledButton(
            onPressed: _loading ? null : () => _submit(l10n),
            child: _loading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.common_save),
          ),
        ],
      ),
    );
  }

  Future<void> _submit(AppLocalizations l10n) async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    setState(() => _loading = true);
    try {
      await widget.onSave(name);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _errorMsg = l10n.common_error;
        });
      }
    } finally {
      // _loading은 catch에서 이미 처리, 성공 시 pop으로 위젯 소멸
    }
  }
}
