import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/settings/groups/models/group_quota.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/group_quota_dialog.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

/// 딥링크 초대 코드 처리 화면
///
/// https://familyplanner.hmncorp.org/invite?code=ABC123 진입 시 표시
/// - 로그인 상태: 자동으로 그룹 가입 시도
/// - 비로그인 상태: 코드를 저장하고 로그인 유도
class InviteLandingScreen extends ConsumerStatefulWidget {
  final String inviteCode;

  const InviteLandingScreen({super.key, required this.inviteCode});

  @override
  ConsumerState<InviteLandingScreen> createState() =>
      _InviteLandingScreenState();
}

class _InviteLandingScreenState extends ConsumerState<InviteLandingScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  /// 그룹 개수 한도 초과(402) — 재시도해도 같은 결과라 별도 안내로 갈라 놓는다
  GroupQuotaExceededException? _quotaError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isAuthenticated = ref.read(authProvider).isAuthenticated;
      if (isAuthenticated == true) {
        _joinGroup();
      } else {
        // 로그인 후 재진입을 위해 코드 저장
        ref.read(pendingInviteCodeProvider.notifier).state = widget.inviteCode;
      }
    });
  }

  Future<void> _joinGroup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _quotaError = null;
    });

    try {
      await ref
          .read(groupNotifierProvider.notifier)
          .joinGroup(widget.inviteCode);
      ref.read(pendingInviteCodeProvider.notifier).state = null;
      if (mounted) setState(() => _isSuccess = true);
    } on GroupQuotaExceededException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _quotaError = e;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.invite_title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: _buildBody(theme, isAuthenticated),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, bool? isAuthenticated) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(l10n.invite_joining),
        ],
      );
    }

    if (_isSuccess) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(l10n.invite_joined, style: theme.textTheme.titleLarge),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go(AppRoutes.home),
            child: Text(l10n.invite_go_home),
          ),
        ],
      );
    }

    if (isAuthenticated != true) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.group_add_outlined,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(l10n.invite_title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            l10n.invite_code_label(widget.inviteCode),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(l10n.invite_login_required),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go(AppRoutes.login),
            child: Text(l10n.invite_login),
          ),
        ],
      );
    }

    if (_quotaError != null) return _buildQuotaState(theme, _quotaError!);

    // 에러 상태
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
        const SizedBox(height: 16),
        Text(l10n.invite_failed, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          _errorMessage ?? l10n.invite_unknown_error,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton(onPressed: _joinGroup, child: Text(l10n.common_retry)),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => context.go(AppRoutes.home),
          child: Text(l10n.invite_go_home),
        ),
      ],
    );
  }

  /// 그룹 개수 한도 초과 안내
  ///
  /// 재시도 버튼을 주지 않는다 — 한도가 그대로인 한 결과도 그대로다.
  Widget _buildQuotaState(
    ThemeData theme,
    GroupQuotaExceededException error,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final canUpgrade = GroupQuotaDialog.canUpgradeFrom(error);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.workspace_premium_outlined,
          size: 64,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          GroupQuotaDialog.titleFor(l10n, GroupQuotaAction.join, false),
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          GroupQuotaDialog.bodyFor(l10n, error),
          textAlign: TextAlign.center,
        ),
        if (!canUpgrade) ...[
          const SizedBox(height: 8),
          Text(
            l10n.groupQuota_leaveHint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 24),
        if (canUpgrade)
          FilledButton(
            onPressed: () => context.push(AppRoutes.subscription),
            child: Text(l10n.groupQuota_upgrade),
          ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => context.go(AppRoutes.home),
          child: Text(l10n.invite_go_home),
        ),
      ],
    );
  }
}
