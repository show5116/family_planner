import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/user_utils.dart';
import 'package:family_planner/features/ai_chat/presentation/widgets/ai_chat_bottom_sheet.dart';

/// 공통 AppBar 더보기 메뉴
///
/// 모든 화면에 일관된 더보기(⋮) 버튼을 제공합니다.
/// - AI 어시스턴트 (운영자 전용, 일반 사용자에게는 준비 중 안내)
/// - 도움말 (온보딩 다시보기 / 가이드 홈페이지)
/// - 화면별 추가 항목 [extraItems]
class AppBarMoreMenu extends ConsumerWidget {
  const AppBarMoreMenu({
    super.key,
    this.onReplayOnboarding,
    this.extraItems = const [],
    this.guideUrl = _defaultGuideUrl,
  });

  /// 눌렸을 때 튜토리얼을 즉시 재실행하는 콜백 (null이면 메뉴 항목 미표시)
  final VoidCallback? onReplayOnboarding;

  /// 화면별 추가 메뉴 항목 (AI·도움말 위에 표시)
  final List<MoreMenuItem> extraItems;

  /// 사용 가이드 링크 (화면별로 다르게 지정 가능)
  final String guideUrl;

  static const _defaultGuideUrl =
      'https://show5116.tistory.com/category/Family%20Planner/%EC%82%AC%EC%9A%A9%20%EA%B0%80%EC%9D%B4%EB%93%9C';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);

    return PopupMenuButton<_MenuAction>(
      icon: const Icon(Icons.more_vert),
      tooltip: '더보기',
      onSelected: (action) => _handleAction(context, action, isAdmin),
      itemBuilder: (context) => [
        // 화면별 고유 항목
        for (final item in extraItems) ...[
          PopupMenuItem<_MenuAction>(
            value: _MenuAction.extra(item.id),
            child: _MenuRow(icon: item.icon, label: item.label),
          ),
        ],
        if (extraItems.isNotEmpty)
          const PopupMenuDivider(),

        // AI 어시스턴트 (비운영자에게는 잠금 아이콘 표시)
        PopupMenuItem<_MenuAction>(
          value: _MenuAction.aiChat,
          child: _MenuRow(
            icon: Icons.auto_awesome,
            label: 'AI 어시스턴트',
            trailingIcon: isAdmin ? null : Icons.lock_outline,
          ),
        ),

        // 도움말 서브메뉴 헤더 (탭 불가 — 구분선 역할)
        const PopupMenuDivider(),
        PopupMenuItem<_MenuAction>(
          enabled: false,
          height: 24,
          child: Text(
            '도움말',
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.outline,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // 튜토리얼 다시 보기 (콜백이 있을 때만)
        if (onReplayOnboarding != null)
          const PopupMenuItem<_MenuAction>(
            value: _MenuAction.replayOnboarding,
            child: _MenuRow(icon: Icons.help_outline, label: '튜토리얼 다시 보기'),
          ),

        // 가이드 홈페이지
        const PopupMenuItem<_MenuAction>(
          value: _MenuAction.guide,
          child: _MenuRow(icon: Icons.open_in_new, label: '사용 가이드'),
        ),
      ],
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    _MenuAction action,
    bool isAdmin,
  ) async {
    switch (action.type) {
      case _MenuActionType.aiChat:
        if (!context.mounted) return;
        if (isAdmin) {
          AiChatBottomSheet.show(context);
        } else {
          _showComingSoonSheet(context);
        }
      case _MenuActionType.replayOnboarding:
        onReplayOnboarding?.call();
      case _MenuActionType.guide:
        final uri = Uri.parse(guideUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      case _MenuActionType.extra:
        if (!context.mounted) return;
        final item = extraItems.where((e) => e.id == action.extraId).firstOrNull;
        item?.onTap(context);
    }
  }

  void _showComingSoonSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => const _AiComingSoonSheet(),
    );
  }
}

/// 비운영자에게 표시되는 AI 어시스턴트 준비 중 안내 시트
class _AiComingSoonSheet extends StatelessWidget {
  const _AiComingSoonSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceXL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 핸들
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.spaceS),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceXL),

          // 아이콘
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: 36,
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spaceL),

          // 제목
          Text(
            'AI 어시스턴트',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.spaceS),

          // 설명
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXL),
            child: Text(
              '내년 출시될 프리미엄 구독 기능입니다.\n구독을 통해 AI 어시스턴트를 사용하실 수 있습니다.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),

          // 뱃지
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: AppSizes.spaceXS,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star_outline,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  '프리미엄 구독 출시 예정',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spaceXL),

          // 닫기 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXL),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 화면별 추가 메뉴 항목
class MoreMenuItem {
  const MoreMenuItem({
    required this.id,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String id;
  final IconData icon;
  final String label;
  final void Function(BuildContext context) onTap;
}

// ── 내부 액션 타입 ────────────────────────────────────────────────────────────

enum _MenuActionType { aiChat, replayOnboarding, guide, extra }

class _MenuAction {
  const _MenuAction._(this.type, {this.extraId});

  static const aiChat = _MenuAction._(_MenuActionType.aiChat);
  static const replayOnboarding = _MenuAction._(_MenuActionType.replayOnboarding);
  static const guide = _MenuAction._(_MenuActionType.guide);
  static _MenuAction extra(String id) =>
      _MenuAction._(_MenuActionType.extra, extraId: id);

  final _MenuActionType type;
  final String? extraId;
}

// ── 공통 메뉴 행 위젯 ─────────────────────────────────────────────────────────

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    this.trailingIcon,
  });

  final IconData icon;
  final String label;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurface),
        const SizedBox(width: 12),
        Text(label),
        if (trailingIcon != null) ...[
          const Spacer(),
          Icon(
            trailingIcon,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ],
    );
  }
}
