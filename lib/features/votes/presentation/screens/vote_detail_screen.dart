import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/votes/data/models/vote_model.dart';
import 'package:family_planner/features/votes/providers/vote_detail_provider.dart';
import 'package:family_planner/features/votes/providers/vote_list_provider.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

class VoteDetailScreen extends ConsumerWidget {
  final String groupId;
  final String voteId;

  const VoteDetailScreen({
    super.key,
    required this.groupId,
    required this.voteId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voteAsync =
        ref.watch(voteDetailProvider(groupId: groupId, voteId: voteId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('투표'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          voteAsync.whenOrNull(
            data: (vote) => _DeleteButton(vote: vote, ref: ref),
          ) ?? const SizedBox.shrink(),
        ],
      ),
      body: voteAsync.when(
        data: (vote) => _VoteDetailBody(vote: vote),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorState(
          error: e,
          title: '투표를 불러오지 못했습니다',
          onRetry: () => ref.invalidate(
              voteDetailProvider(groupId: groupId, voteId: voteId)),
        ),
      ),
    );
  }
}

// ─── 삭제 버튼 (작성자/관리자 전용) ──────────────────────────────────────────

class _DeleteButton extends ConsumerWidget {
  final VoteModel vote;
  final WidgetRef ref;

  const _DeleteButton({required this.vote, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.delete_outline),
      tooltip: '투표 삭제',
      onPressed: () => _confirmDelete(context, ref),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('투표 삭제'),
        content: const Text('이 투표를 삭제하시겠습니까?\n삭제된 투표는 복구할 수 없습니다.'),
        actions: [
          TextButton(
              onPressed: () => ctx.pop(false), child: const Text('취소')),
          TextButton(
            onPressed: () => ctx.pop(true),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(ctx).colorScheme.error),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final success = await ref.read(voteManagementProvider.notifier).deleteVote(
          groupId: vote.groupId,
          voteId: vote.id,
        );

    if (!context.mounted) return;
    if (success) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('삭제에 실패했습니다')),
      );
    }
  }
}

// ─── 투표 상세 본문 ───────────────────────────────────────────────────────────

class _VoteDetailBody extends ConsumerStatefulWidget {
  final VoteModel vote;

  const _VoteDetailBody({required this.vote});

  @override
  ConsumerState<_VoteDetailBody> createState() => _VoteDetailBodyState();
}

class _VoteDetailBodyState extends ConsumerState<_VoteDetailBody> {
  late Set<String> _selectedOptionIds;

  @override
  void initState() {
    super.initState();
    _selectedOptionIds = widget.vote.options
        .where((o) => o.isSelected)
        .map((o) => o.id)
        .toSet();
  }

  @override
  void didUpdateWidget(_VoteDetailBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.vote != widget.vote) {
      _selectedOptionIds = widget.vote.options
          .where((o) => o.isSelected)
          .map((o) => o.id)
          .toSet();
    }
  }

  void _toggleOption(String optionId) {
    if (!widget.vote.isOngoing) return;
    setState(() {
      if (widget.vote.isMultiple) {
        if (_selectedOptionIds.contains(optionId)) {
          _selectedOptionIds.remove(optionId);
        } else {
          _selectedOptionIds.add(optionId);
        }
      } else {
        _selectedOptionIds = {optionId};
      }
    });
  }

  Future<void> _castBallot() async {
    if (_selectedOptionIds.isEmpty) return;
    final ballotState = ref.read(voteBallotProvider);
    if (ballotState.isLoading) return;

    final success = await ref.read(voteBallotProvider.notifier).castBallot(
          groupId: widget.vote.groupId,
          voteId: widget.vote.id,
          optionIds: _selectedOptionIds.toList(),
        );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? '투표가 완료되었습니다' : '투표에 실패했습니다')),
    );
  }


  Set<String> get _originalOptionIds => widget.vote.options
      .where((o) => o.isSelected)
      .map((o) => o.id)
      .toSet();

  bool get _hasChanged =>
      !_selectedOptionIds.containsAll(_originalOptionIds) ||
      !_originalOptionIds.containsAll(_selectedOptionIds);

  @override
  Widget build(BuildContext context) {
    final vote = widget.vote;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ballotState = ref.watch(voteBallotProvider);
    final isLoading = ballotState.isLoading;
    final totalVotes =
        vote.options.fold(0, (sum, o) => sum + o.count);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 제목 + 상태
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  vote.title,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: AppSizes.spaceS),
              _StatusBadge(isOngoing: vote.isOngoing),
            ],
          ),
          const SizedBox(height: AppSizes.spaceS),
          // 메타 정보
          Wrap(
            spacing: AppSizes.spaceM,
            children: [
              _MetaChip(icon: Icons.person_outline, label: vote.creatorName),
              _MetaChip(
                  icon: Icons.how_to_vote_outlined,
                  label: '${vote.totalVoters}명 참여'),
              if (vote.isMultiple)
                _MetaChip(icon: Icons.checklist, label: '복수 선택'),
              if (vote.isAnonymous)
                _MetaChip(icon: Icons.visibility_off_outlined, label: '익명'),
              if (vote.endsAt != null)
                _MetaChip(
                  icon: Icons.schedule,
                  label: _formatDeadline(vote.endsAt!),
                  color: vote.isOngoing ? null : colorScheme.error,
                ),
            ],
          ),
          if (vote.description != null && vote.description!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spaceM),
            Text(vote.description!,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant)),
          ],
          const SizedBox(height: AppSizes.spaceL),
          // 선택지 목록
          ...vote.options.map((option) {
            final isSelected = _selectedOptionIds.contains(option.id);
            final ratio = totalVotes > 0 ? option.count / totalVotes : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
              child: _OptionTile(
                option: option,
                isSelected: isSelected,
                ratio: ratio,
                showResult: vote.hasVoted || !vote.isOngoing,
                isOngoing: vote.isOngoing,
                isAnonymous: vote.isAnonymous,
                onTap: vote.isOngoing && !isLoading
                    ? () => _toggleOption(option.id)
                    : null,
              ),
            );
          }),
          const SizedBox(height: AppSizes.spaceL),
          // 투표/재투표 버튼
          if (vote.isOngoing)
            FilledButton(
              onPressed: isLoading ||
                      _selectedOptionIds.isEmpty ||
                      (vote.hasVoted && !_hasChanged)
                  ? null
                  : _castBallot,
              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(vote.hasVoted ? '재투표하기' : '투표하기'),
            ),
        ],
      ),
    );
  }

  String _formatDeadline(DateTime endsAt) {
    final now = DateTime.now();
    final diff = endsAt.difference(now);
    if (diff.isNegative) return '마감됨';
    if (diff.inDays > 0) return '${diff.inDays}일 후 마감';
    if (diff.inHours > 0) return '${diff.inHours}시간 후 마감';
    return '${diff.inMinutes}분 후 마감';
  }
}

// ─── 선택지 타일 ──────────────────────────────────────────────────────────────

class _OptionTile extends StatelessWidget {
  final VoteOptionModel option;
  final bool isSelected;
  final double ratio;
  final bool showResult;
  final bool isOngoing;
  final bool isAnonymous;
  final VoidCallback? onTap;

  const _OptionTile({
    required this.option,
    required this.isSelected,
    required this.ratio,
    required this.showResult,
    required this.isOngoing,
    required this.isAnonymous,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Material(
      color: isSelected
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isOngoing)
                    Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 20,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  if (isOngoing) const SizedBox(width: AppSizes.spaceS),
                  Expanded(
                    child: Text(
                      option.label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (showResult)
                    Text(
                      '${option.count}표 (${(ratio * 100).toStringAsFixed(0)}%)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              if (showResult) ...[
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 6,
                    backgroundColor:
                        colorScheme.outline.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation(
                      isSelected
                          ? colorScheme.primary
                          : colorScheme.secondary,
                    ),
                  ),
                ),
                if (!isAnonymous && option.voters.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    option.voters.join(', '),
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── 공통 위젯 ────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final bool isOngoing;
  const _StatusBadge({required this.isOngoing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isOngoing
            ? Colors.green.withValues(alpha: 0.15)
            : Colors.grey.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isOngoing ? '진행중' : '종료',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isOngoing ? Colors.green[700] : Colors.grey[600],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _MetaChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: c),
        const SizedBox(width: 3),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: c)),
      ],
    );
  }
}
