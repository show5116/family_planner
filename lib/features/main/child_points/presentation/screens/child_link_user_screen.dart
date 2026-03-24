import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';

/// 자녀 프로필과 앱 계정 연동 화면
class ChildLinkUserScreen extends ConsumerStatefulWidget {
  const ChildLinkUserScreen({super.key, required this.childId});

  final String childId;

  @override
  ConsumerState<ChildLinkUserScreen> createState() =>
      _ChildLinkUserScreenState();
}

class _ChildLinkUserScreenState extends ConsumerState<ChildLinkUserScreen> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final childrenAsync = ref.watch(childcareChildrenProvider);

    final child = childrenAsync.maybeWhen(
      data: (children) {
        try {
          return children.firstWhere((c) => c.id == widget.childId);
        } catch (_) {
          return null;
        }
      },
      orElse: () => null,
    );

    final isLinked = child?.userId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text('${child?.name ?? '자녀'} 계정 연동'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상태 카드
            Card(
              color: isLinked
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spaceM),
                child: Row(
                  children: [
                    Icon(
                      isLinked ? Icons.link : Icons.link_off,
                      color: isLinked
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLinked ? '앱 계정 연동됨' : '앱 계정 미연동',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (isLinked)
                            Text(
                              '연동된 계정 ID: ${child!.userId!.substring(0, 8)}...',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceL),

            if (!isLinked) ...[
              Text(
                '계정 연동 안내',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSizes.spaceS),
              const _InfoItem(
                icon: Icons.child_care,
                text: '자녀가 앱에 직접 가입해야 연동이 가능합니다.',
              ),
              const _InfoItem(
                icon: Icons.manage_accounts,
                text: '연동 후 자녀가 직접 포인트 현황을 확인할 수 있습니다.',
              ),
              const _InfoItem(
                icon: Icons.savings,
                text: '자녀 계정으로 적금 입금이 가능해집니다.',
              ),
              const SizedBox(height: AppSizes.spaceXL),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.link),
                  label: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('앱 계정 연동하기'),
                  onPressed: _isSubmitting ? null : _handleLinkUser,
                ),
              ),
            ] else ...[
              Text(
                '연동 정보',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSizes.spaceS),
              const _InfoItem(
                icon: Icons.check_circle_outline,
                text: '자녀가 앱으로 직접 포인트를 확인할 수 있습니다.',
              ),
              const _InfoItem(
                icon: Icons.savings_outlined,
                text: '자녀 계정으로 적금 입금이 가능합니다.',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleLinkUser() async {
    setState(() => _isSubmitting = true);

    final result = await ref
        .read(childcareManagementProvider.notifier)
        .linkUser(widget.childId);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('앱 계정이 연동되었습니다')),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('연동에 실패했습니다. 자녀가 앱에 가입되어 있는지 확인해주세요')),
      );
    }
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSizes.iconSmall,
              color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppSizes.spaceS),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
