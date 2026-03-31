import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/savings/data/models/savings_model.dart';
import 'package:family_planner/features/main/savings/data/repositories/savings_repository.dart';

class SavingsTransactionsScreen extends ConsumerStatefulWidget {
  const SavingsTransactionsScreen({
    super.key,
    required this.goalId,
    required this.goalName,
  });

  final String goalId;
  final String goalName;

  @override
  ConsumerState<SavingsTransactionsScreen> createState() =>
      _SavingsTransactionsScreenState();
}

class _SavingsTransactionsScreenState
    extends ConsumerState<SavingsTransactionsScreen> {
  SavingsType? _selectedType;
  final List<SavingsTransactionModel> _items = [];
  int _currentPage = 1;
  bool _hasMore = true;
  bool _loading = false;
  String? _error;

  static const int _pageSize = 20;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_loading &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ref.read(savingsRepositoryProvider).getTransactions(
            widget.goalId,
            type: _selectedType?.toApiString(),
            page: _currentPage,
            limit: _pageSize,
          );
      if (mounted) {
        setState(() {
          _items.addAll(result.items);
          _currentPage++;
          _hasMore = result.hasMore;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  void _onTypeChanged(SavingsType? type) {
    setState(() {
      _selectedType = type;
      _items.clear();
      _currentPage = 1;
      _hasMore = true;
      _error = null;
    });
    _loadMore();
  }

  Future<void> _refresh() async {
    setState(() {
      _items.clear();
      _currentPage = 1;
      _hasMore = true;
      _error = null;
    });
    await _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goalName),
      ),
      body: Column(
        children: [
          _TypeFilterBar(
            selectedType: _selectedType,
            onTypeChanged: _onTypeChanged,
          ),
          Expanded(
            child: _items.isEmpty && !_loading && _error == null
                ? const Center(
                    child: Text('거래 내역이 없습니다.',
                        style: TextStyle(color: AppColors.textSecondary)),
                  )
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.spaceS),
                      itemCount:
                          _items.length + (_loading || _error != null ? 1 : 0),
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        if (index == _items.length) {
                          if (_error != null) {
                            return Padding(
                              padding: const EdgeInsets.all(AppSizes.spaceM),
                              child: Column(
                                children: [
                                  Text('오류: $_error',
                                      style: const TextStyle(
                                          color: AppColors.error)),
                                  TextButton(
                                    onPressed: _loadMore,
                                    child: const Text('다시 시도'),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const Padding(
                            padding: EdgeInsets.all(AppSizes.spaceM),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return _TransactionTile(tx: _items[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── 타입 필터 바 ──────────────────────────────────────────────────────────────

class _TypeFilterBar extends StatelessWidget {
  const _TypeFilterBar({
    required this.selectedType,
    required this.onTypeChanged,
  });

  final SavingsType? selectedType;
  final ValueChanged<SavingsType?> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      child: Row(
        children: [
          _Chip(
            label: '전체',
            selected: selectedType == null,
            onTap: () => onTypeChanged(null),
          ),
          const SizedBox(width: AppSizes.spaceS),
          _Chip(
            label: '입금',
            selected: selectedType == SavingsType.deposit,
            onTap: () => onTypeChanged(SavingsType.deposit),
          ),
          const SizedBox(width: AppSizes.spaceS),
          _Chip(
            label: '출금',
            selected: selectedType == SavingsType.withdraw,
            onTap: () => onTypeChanged(SavingsType.withdraw),
          ),
          const SizedBox(width: AppSizes.spaceS),
          _Chip(
            label: '자동 적립',
            selected: selectedType == SavingsType.autoDeposit,
            onTap: () => onTypeChanged(SavingsType.autoDeposit),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.investment.withAlpha(40),
      checkmarkColor: AppColors.investment,
      labelStyle: TextStyle(
        color: selected ? AppColors.investment : AppColors.textSecondary,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

// ── 거래 내역 타일 ────────────────────────────────────────────────────────────

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.tx});

  final SavingsTransactionModel tx;

  String _formatAmount(double amount) {
    final intAmount = amount.toInt();
    final formatted = intAmount
        .toString()
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
    return '$formatted원';
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDeposit = tx.type == SavingsType.deposit ||
        tx.type == SavingsType.autoDeposit;
    final amountColor = isDeposit ? AppColors.success : AppColors.error;
    final amountPrefix = isDeposit ? '+' : '-';
    final icon = switch (tx.type) {
      SavingsType.deposit => Icons.arrow_downward,
      SavingsType.withdraw => Icons.arrow_upward,
      SavingsType.autoDeposit => Icons.autorenew,
    };

    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: amountColor.withAlpha(30),
        child: Icon(icon, size: AppSizes.iconSmall, color: amountColor),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              tx.type.toDisplayString(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            '$amountPrefix${_formatAmount(tx.amount)}',
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          if (tx.description != null && tx.description!.isNotEmpty)
            Expanded(
              child: Text(
                tx.description!,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          else
            const Expanded(child: SizedBox.shrink()),
          Text(
            _formatDate(tx.createdAt),
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
