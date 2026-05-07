import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:family_planner/features/ai_chat/presentation/widgets/ai_chat_bottom_sheet.dart';

/// 공통 AppBar 더보기 메뉴
///
/// 모든 화면에 일관된 더보기(⋮) 버튼을 제공합니다.
/// - AI 어시스턴트
/// - 도움말 (온보딩 다시보기 / 가이드 홈페이지)
/// - 화면별 추가 항목 [extraItems]
class AppBarMoreMenu extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuAction>(
      icon: const Icon(Icons.more_vert),
      tooltip: '더보기',
      onSelected: (action) => _handleAction(context, action),
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

        // AI 어시스턴트
        const PopupMenuItem<_MenuAction>(
          value: _MenuAction.aiChat,
          child: _MenuRow(icon: Icons.auto_awesome, label: 'AI 어시스턴트'),
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

  Future<void> _handleAction(BuildContext context, _MenuAction action) async {
    switch (action.type) {
      case _MenuActionType.aiChat:
        if (context.mounted) AiChatBottomSheet.show(context);
      case _MenuActionType.replayOnboarding:
        onReplayOnboarding?.call();
      case _MenuActionType.guide:
        final uri = Uri.parse(guideUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      case _MenuActionType.extra:
        // extraItems에서 해당 id의 onTap 호출
        final item = extraItems.where((e) => e.id == action.extraId).firstOrNull;
        item?.onTap(context);
    }
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
  const _MenuRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurface),
        const SizedBox(width: 12),
        Text(label),
      ],
    );
  }
}
