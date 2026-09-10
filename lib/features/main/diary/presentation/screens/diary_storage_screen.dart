import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/format_utils.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/diary/data/models/diary_media_models.dart';
import 'package:family_planner/features/main/diary/data/repositories/diary_media_repository.dart';
import 'package:family_planner/features/main/diary/presentation/widgets/quota_indicator.dart';
import 'package:family_planner/features/main/diary/providers/media_quota_provider.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 저장 공간 관리
///
/// 한도제에서 사용자가 가장 답답해하는 건 "뭐가 용량을 잡아먹는지 모르는 것"이다.
/// 게이지만 두지 않고 **무엇을 지우면 되는지**까지 보여주는 것이 이 화면의 역할이다.
class DiaryStorageScreen extends ConsumerWidget {
  const DiaryStorageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final quota = ref.watch(mediaQuotaProvider);
    final largeMedia = ref.watch(largeMediaProvider);
    final onlyOriginal = ref.watch(storageOnlyOriginalProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.diary_storage_manage)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(mediaQuotaProvider);
          ref.invalidate(largeMediaProvider);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSizes.spaceM),
          children: [
            quota.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.spaceL),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => AppErrorState(
                error: error,
                title: l10n.diary_load_error,
                onRetry: () => ref.invalidate(mediaQuotaProvider),
              ),
              data: (data) => QuotaSummaryCard(
                quota: data,
                // 프리미엄이 아닐 때만 업그레이드를 권한다
                onUpgrade: data.tier == 'premium'
                    ? null
                    : () => context.push(AppRoutes.subscription),
              ),
            ),
            const SizedBox(height: AppSizes.spaceL),
            Row(
              children: [
                Text(
                  l10n.diary_storage_large_files,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                Text(
                  l10n.diary_storage_only_original,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Switch(
                  value: onlyOriginal,
                  onChanged: (value) => ref
                      .read(storageOnlyOriginalProvider.notifier)
                      .state = value,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            largeMedia.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.spaceL),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => AppErrorState(
                error: error,
                title: l10n.diary_load_error,
                onRetry: () => ref.invalidate(largeMediaProvider),
              ),
              data: (items) => items.isEmpty
                  ? AppEmptyState(
                      icon: Icons.cleaning_services_outlined,
                      message: l10n.diary_storage_empty,
                    )
                  : Column(
                      children: [
                        for (final item in items)
                          _LargeMediaTile(item: item),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LargeMediaTile extends ConsumerWidget {
  const _LargeMediaTile({required this.item});

  final LargeMediaItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: SizedBox(
          width: 48,
          height: 48,
          child: item.thumbnailUrl != null
              ? CachedNetworkImage(
                  imageUrl: item.thumbnailUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    color: colorScheme.surfaceContainerHighest,
                  ),
                  errorWidget: (_, _, _) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: colorScheme.onSurfaceVariant,
                      size: AppSizes.iconSmall,
                    ),
                  ),
                )
              : Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_outlined,
                    color: colorScheme.onSurfaceVariant,
                    size: AppSizes.iconSmall,
                  ),
                ),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              item.fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          if (item.isOriginal) ...[
            const SizedBox(width: AppSizes.spaceXS),
            _OriginalBadge(label: l10n.diary_media_original_badge),
          ],
        ],
      ),
      subtitle: Text(
        item.date.isEmpty
            ? formatBytes(item.fileSize)
            : '${item.date} · ${formatBytes(item.fileSize)}',
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        color: AppColors.error,
        tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
        onPressed: () => _confirmDelete(context, ref),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.diary_media_delete_confirm),
        content: Text(l10n.diary_media_delete_permanent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(MaterialLocalizations.of(context).deleteButtonTooltip),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(diaryMediaRepositoryProvider).delete(item.id);
      ref.invalidate(mediaQuotaProvider);
      ref.invalidate(largeMediaProvider);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'), backgroundColor: AppColors.error),
      );
    }
  }
}

class _OriginalBadge extends StatelessWidget {
  const _OriginalBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
