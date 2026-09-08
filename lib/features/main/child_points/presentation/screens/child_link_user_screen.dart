import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
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
        title: Text(
            l10n.childcare_link_title(child?.name ?? l10n.childcare_child)),
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
                            isLinked
                                ? l10n.childcare_link_linked
                                : l10n.childcare_link_unlinked,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (isLinked)
                            Text(
                              l10n.childcare_link_account_id(
                                  child!.userId!.substring(0, 8)),
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
                l10n.childcare_link_guide,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSizes.spaceS),
              _InfoItem(
                icon: Icons.child_care,
                text: l10n.childcare_link_guide1,
              ),
              _InfoItem(
                icon: Icons.manage_accounts,
                text: l10n.childcare_link_guide2,
              ),
              _InfoItem(
                icon: Icons.savings,
                text: l10n.childcare_link_guide3,
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
                      : Text(l10n.childcare_link_button),
                  onPressed: _isSubmitting ? null : _handleLinkUser,
                ),
              ),
            ] else ...[
              Text(
                l10n.childcare_link_info,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSizes.spaceS),
              _InfoItem(
                icon: Icons.check_circle_outline,
                text: l10n.childcare_link_info1,
              ),
              _InfoItem(
                icon: Icons.savings_outlined,
                text: l10n.childcare_link_info2,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleLinkUser() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isSubmitting = true);

    final result = await ref
        .read(childcareManagementProvider.notifier)
        .linkUser(widget.childId);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.childcare_link_done)),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.childcare_link_failed)),
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
