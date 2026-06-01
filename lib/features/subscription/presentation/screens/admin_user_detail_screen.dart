import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/models/subscription_tier.dart';
import 'package:family_planner/features/subscription/data/models/admin_user_dto.dart';
import 'package:family_planner/features/subscription/providers/admin_subscription_provider.dart';

class AdminUserDetailScreen extends ConsumerWidget {
  const AdminUserDetailScreen({super.key, required this.user});

  final AdminUserDto user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 목록에서 해당 유저가 수정됐을 경우 최신 상태 반영
    final listAsync = ref.watch(adminUserListProvider);
    final current = listAsync.valueOrNull?.items
            .where((u) => u.id == user.id)
            .firstOrNull ??
        user;

    return Scaffold(
      appBar: AppBar(title: const Text('사용자 상세')),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        children: [
          _ProfileCard(user: current),
          const SizedBox(height: AppSizes.spaceM),
          _SubscriptionCard(user: current),
          const SizedBox(height: AppSizes.spaceM),
          _AccountManagementCard(user: current),
          const SizedBox(height: AppSizes.spaceM),
          _ActivityCard(user: current),
        ],
      ),
    );
  }
}

// ── 프로필 카드 ──────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.user});
  final AdminUserDto user;

  @override
  Widget build(BuildContext context) {
    final isPending = user.isPendingDelete;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: isPending
                  ? Colors.orange.withValues(alpha: 0.15)
                  : user.subscriptionTier.color.withValues(alpha: 0.15),
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 22,
                  color: isPending ? Colors.orange : user.subscriptionTier.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (user.isAdmin) ...[
                        const SizedBox(width: AppSizes.spaceXS),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '운영자',
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      if (isPending) ...[
                        const SizedBox(width: AppSizes.spaceXS),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '삭제 유예',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (user.email != null)
                    Text(
                      user.email!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${user.id}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 10,
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

// ── 구독 카드 ────────────────────────────────────────────────

class _SubscriptionCard extends ConsumerWidget {
  const _SubscriptionCard({required this.user});
  final AdminUserDto user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editState = ref.watch(adminSubscriptionEditProvider);
    final isLoading = editState is AsyncLoading;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.workspace_premium_outlined),
                const SizedBox(width: AppSizes.spaceS),
                Text('구독 정보',
                    style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                _TierBadge(tier: user.subscriptionTier),
              ],
            ),
            const Divider(height: AppSizes.spaceL),
            _InfoRow(
              label: '구독 단계',
              value: user.subscriptionTier.displayName,
              valueColor: user.subscriptionTier.color,
            ),
            const SizedBox(height: AppSizes.spaceS),
            _InfoRow(
              label: '활성 여부',
              value: user.isSubscriptionActive ? '활성' : '비활성',
              valueColor:
                  user.isSubscriptionActive ? Colors.green : Colors.red,
            ),
            const SizedBox(height: AppSizes.spaceS),
            _InfoRow(
              label: '만료일',
              value: user.subscriptionExpiresAt != null
                  ? _formatDateTime(user.subscriptionExpiresAt!)
                  : '무제한',
            ),
            const SizedBox(height: AppSizes.spaceL),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isLoading
                    ? null
                    : () => _showEditDialog(context, ref),
                icon: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.edit_outlined),
                label: const Text('구독 직접 수정'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => _EditSubscriptionDialog(user: user, ref: ref),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ── 계정 관리 카드 ───────────────────────────────────────────

class _AccountManagementCard extends ConsumerWidget {
  const _AccountManagementCard({required this.user});
  final AdminUserDto user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteState = ref.watch(adminUserDeleteProvider);
    final isLoading = deleteState is AsyncLoading;
    final isPending = user.isPendingDelete;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.manage_accounts_outlined,
                  color: isPending ? Colors.orange : null,
                ),
                const SizedBox(width: AppSizes.spaceS),
                Text('계정 관리',
                    style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            const Divider(height: AppSizes.spaceL),
            if (isPending) ...[
              // 삭제 유예 상태일 때
              _InfoRow(
                label: '삭제 예정일',
                value: _formatDate(user.deletedAt!),
                valueColor: Colors.orange,
              ),
              const SizedBox(height: AppSizes.spaceL),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => _onCancelDelete(context, ref),
                      icon: const Icon(Icons.restore_outlined),
                      label: const Text('삭제 취소'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => _onForceDelete(context, ref),
                      icon: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.delete_forever_outlined),
                      label: const Text('즉시 삭제'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // 정상 계정일 때
              Text(
                '계정 삭제 예약 시 7일의 유예 기간이 부여됩니다.\n유예 기간 중 삭제를 취소하거나 즉시 삭제할 수 있습니다.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppSizes.spaceL),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () => _onScheduleDelete(context, ref),
                  icon: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.schedule_outlined),
                  label: const Text('계정 삭제 예약 (7일 유예)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _onScheduleDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('계정 삭제 예약'),
        content: Text(
          '${user.name} 계정을 삭제 예약하시겠습니까?\n7일 후 자동으로 완전 삭제됩니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('삭제 예약'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final scheduledAt = await ref
        .read(adminUserDeleteProvider.notifier)
        .scheduleDelete(user.id);

    if (!context.mounted) return;
    if (scheduledAt != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '삭제가 예약되었습니다. 삭제 예정일: ${_formatDate(scheduledAt)}',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('삭제 예약 실패. 다시 시도해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _onCancelDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('삭제 예약 취소'),
        content: Text('${user.name} 계정의 삭제 예약을 취소하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('닫기'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('취소 확인'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final success = await ref
        .read(adminUserDeleteProvider.notifier)
        .cancelDelete(user.id);

    if (!context.mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('삭제 예약이 취소되었습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('취소 실패. 다시 시도해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _onForceDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('즉시 완전 삭제'),
        content: Text(
          '${user.name} 계정을 즉시 완전 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('즉시 삭제'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final success = await ref
        .read(adminUserDeleteProvider.notifier)
        .forceDelete(user.id);

    if (!context.mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('계정이 즉시 삭제되었습니다.')),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('삭제 실패. 다시 시도해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')}';
  }
}

// ── 활동 카드 ────────────────────────────────────────────────

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.user});
  final AdminUserDto user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.history_outlined),
                const SizedBox(width: AppSizes.spaceS),
                Text('활동 정보',
                    style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            const Divider(height: AppSizes.spaceL),
            _InfoRow(
              label: '가입일',
              value: _formatDate(user.createdAt),
            ),
            const SizedBox(height: AppSizes.spaceS),
            _InfoRow(
              label: '마지막 로그인',
              value: user.lastLoginAt != null
                  ? _formatDate(user.lastLoginAt!)
                  : '없음',
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')}';
  }
}

// ── 구독 수정 다이얼로그 ──────────────────────────────────────

class _EditSubscriptionDialog extends StatefulWidget {
  const _EditSubscriptionDialog({required this.user, required this.ref});

  final AdminUserDto user;
  final WidgetRef ref;

  @override
  State<_EditSubscriptionDialog> createState() =>
      _EditSubscriptionDialogState();
}

class _EditSubscriptionDialogState extends State<_EditSubscriptionDialog> {
  late SubscriptionTier _selectedTier;
  DateTime? _expiresAt;
  bool _noExpiry = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _selectedTier = widget.user.subscriptionTier;
    _expiresAt = widget.user.subscriptionExpiresAt;
    _noExpiry = widget.user.subscriptionExpiresAt == null &&
        widget.user.subscriptionTier != SubscriptionTier.free;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiresAt ?? now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      setState(() {
        _expiresAt = DateTime(picked.year, picked.month, picked.day, 23, 59, 59);
        _noExpiry = false;
      });
    }
  }

  Future<void> _submit() async {
    final result = await widget.ref
        .read(adminSubscriptionEditProvider.notifier)
        .updateSubscription(
          userId: widget.user.id,
          tier: _selectedTier,
          expiresAt: _noExpiry ? null : _expiresAt,
        );

    if (!mounted) return;
    if (result != null) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('구독 정보가 수정되었습니다.')),
      );
    } else {
      setState(() => _errorMsg = '수정 실패. 다시 시도해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        widget.ref.watch(adminSubscriptionEditProvider) is AsyncLoading;

    return AlertDialog(
      title: Text('${widget.user.name} 구독 수정'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('구독 단계',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: AppSizes.spaceS),
            RadioGroup<SubscriptionTier>(
              groupValue: _selectedTier,
              onChanged: (v) {
                if (v != null) setState(() => _selectedTier = v);
              },
              child: Column(
                children: SubscriptionTier.values.map(
                  (tier) => RadioListTile<SubscriptionTier>(
                    title: Row(
                      children: [
                        Text(tier.displayName),
                        const SizedBox(width: AppSizes.spaceXS),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: tier.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    value: tier,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ).toList(),
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text('만료일', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: AppSizes.spaceS),
            CheckboxListTile(
              title: const Text('무제한 (만료일 없음)'),
              value: _noExpiry,
              onChanged: _selectedTier == SubscriptionTier.free
                  ? null
                  : (v) => setState(() {
                        _noExpiry = v ?? false;
                        if (_noExpiry) _expiresAt = null;
                      }),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            if (!_noExpiry) ...[
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(
                  _expiresAt != null
                      ? '${_expiresAt!.year}.${_expiresAt!.month.toString().padLeft(2, '0')}.${_expiresAt!.day.toString().padLeft(2, '0')}'
                      : '날짜 선택',
                ),
              ),
            ],
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
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: isLoading ? null : _submit,
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('저장'),
        ),
      ],
    );
  }
}

// ── 공통 위젯 ────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor,
                fontWeight:
                    valueColor != null ? FontWeight.bold : null,
              ),
        ),
      ],
    );
  }
}

class _TierBadge extends StatelessWidget {
  const _TierBadge({required this.tier});
  final SubscriptionTier tier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: tier.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: tier.color.withValues(alpha: 0.4)),
      ),
      child: Text(
        tier.displayName,
        style: TextStyle(
          fontSize: 11,
          color: tier.color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
