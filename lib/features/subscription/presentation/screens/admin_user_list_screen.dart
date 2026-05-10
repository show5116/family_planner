import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/models/subscription_tier.dart';
import 'package:family_planner/features/subscription/data/models/admin_user_dto.dart';
import 'package:family_planner/features/subscription/providers/admin_subscription_provider.dart';
import 'package:family_planner/core/routes/app_routes.dart';

class AdminUserListScreen extends ConsumerStatefulWidget {
  const AdminUserListScreen({super.key});

  @override
  ConsumerState<AdminUserListScreen> createState() => _AdminUserListScreenState();
}

class _AdminUserListScreenState extends ConsumerState<AdminUserListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(adminUserListProvider.notifier).loadNextPage();
    }
  }

  void _onSearchChanged(String value) {
    ref.read(adminUserFilterProvider.notifier).update(
          (s) => s.copyWith(search: value),
        );
  }

  void _onTierFilterChanged(SubscriptionTier? tier) {
    ref.read(adminUserFilterProvider.notifier).update(
          (s) => tier == null
              ? s.copyWith(clearTier: true)
              : s.copyWith(tier: tier),
        );
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(adminUserListProvider);
    final filter = ref.watch(adminUserFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('사용자 관리'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(adminUserListProvider.notifier).refresh(),
            tooltip: '새로고침',
          ),
        ],
      ),
      body: Column(
        children: [
          _SearchFilterBar(
            controller: _searchController,
            selectedTier: filter.tier,
            onSearchChanged: _onSearchChanged,
            onTierChanged: _onTierFilterChanged,
          ),
          Expanded(
            child: listAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: AppSizes.spaceM),
                    Text('불러오기 실패: $e'),
                    const SizedBox(height: AppSizes.spaceM),
                    FilledButton(
                      onPressed: () =>
                          ref.read(adminUserListProvider.notifier).refresh(),
                      child: const Text('재시도'),
                    ),
                  ],
                ),
              ),
              data: (result) {
                if (result.items.isEmpty) {
                  return const Center(
                    child: Text('검색 결과가 없습니다.'),
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spaceM,
                        vertical: AppSizes.spaceXS,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '총 ${result.total}명',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        controller: _scrollController,
                        itemCount: result.hasMore
                            ? result.items.length + 1
                            : result.items.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          if (index >= result.items.length) {
                            return const Padding(
                              padding: EdgeInsets.all(AppSizes.spaceM),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return _UserListTile(
                            user: result.items[index],
                            onTap: () => context.push(
                              AppRoutes.adminUserDetail.replaceFirst(
                                ':userId',
                                result.items[index].id,
                              ),
                              extra: result.items[index],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── 검색 + 필터 바 ──────────────────────────────────────────

class _SearchFilterBar extends StatelessWidget {
  const _SearchFilterBar({
    required this.controller,
    required this.selectedTier,
    required this.onSearchChanged,
    required this.onTierChanged,
  });

  final TextEditingController controller;
  final SubscriptionTier? selectedTier;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<SubscriptionTier?> onTierChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spaceM,
        AppSizes.spaceM,
        AppSizes.spaceM,
        AppSizes.spaceS,
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: '이름 또는 이메일 검색',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.clear();
                        onSearchChanged('');
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceS,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _TierChip(
                  label: '전체',
                  selected: selectedTier == null,
                  onSelected: (_) => onTierChanged(null),
                ),
                const SizedBox(width: AppSizes.spaceXS),
                for (final tier in SubscriptionTier.values)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSizes.spaceXS),
                    child: _TierChip(
                      label: tier.displayName,
                      selected: selectedTier == tier,
                      color: tier.color,
                      onSelected: (_) => onTierChanged(tier),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TierChip extends StatelessWidget {
  const _TierChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.color,
  });

  final String label;
  final bool selected;
  final Color? color;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: (color ?? Theme.of(context).colorScheme.primary)
          .withValues(alpha: 0.2),
      checkmarkColor: color ?? Theme.of(context).colorScheme.primary,
      labelStyle: selected
          ? TextStyle(
              color: color ?? Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            )
          : null,
    );
  }
}

// ── 유저 목록 타일 ──────────────────────────────────────────

class _UserListTile extends StatelessWidget {
  const _UserListTile({required this.user, required this.onTap});

  final AdminUserDto user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: user.subscriptionTier.color.withValues(alpha: 0.15),
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
          style: TextStyle(
            color: user.subscriptionTier.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(user.name, style: textTheme.bodyLarge),
          ),
          const SizedBox(width: AppSizes.spaceXS),
          _TierBadge(tier: user.subscriptionTier),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user.email != null)
            Text(
              user.email!,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          if (user.subscriptionExpiresAt != null)
            Text(
              '만료: ${_formatDate(user.subscriptionExpiresAt!)}',
              style: textTheme.bodySmall?.copyWith(
                color: user.isSubscriptionActive
                    ? colorScheme.onSurfaceVariant
                    : Colors.red,
              ),
            ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')}';
  }
}

// ── Tier 뱃지 ───────────────────────────────────────────────

class _TierBadge extends StatelessWidget {
  const _TierBadge({required this.tier});
  final SubscriptionTier tier;

  @override
  Widget build(BuildContext context) {
    if (tier == SubscriptionTier.free) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: tier.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: tier.color.withValues(alpha: 0.4)),
      ),
      child: Text(
        tier.displayName,
        style: TextStyle(
          fontSize: 10,
          color: tier.color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
