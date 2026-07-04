import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
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
  ConsumerState<InviteLandingScreen> createState() => _InviteLandingScreenState();
}

class _InviteLandingScreenState extends ConsumerState<InviteLandingScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

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
    });

    try {
      await ref.read(groupNotifierProvider.notifier).joinGroup(widget.inviteCode);
      ref.read(pendingInviteCodeProvider.notifier).state = null;
      if (mounted) setState(() => _isSuccess = true);
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
    final theme = Theme.of(context);
    final isAuthenticated = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      appBar: AppBar(title: const Text('그룹 초대')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: _buildBody(theme, isAuthenticated),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, bool? isAuthenticated) {
    if (_isLoading) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('그룹에 가입 중...'),
        ],
      );
    }

    if (_isSuccess) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text('그룹 가입 완료!', style: theme.textTheme.titleLarge),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('홈으로'),
          ),
        ],
      );
    }

    if (isAuthenticated != true) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.group_add_outlined, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text('그룹 초대', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '초대 코드: ${widget.inviteCode}',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
          ),
          const SizedBox(height: 8),
          const Text('로그인 후 그룹에 가입할 수 있어요.'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go(AppRoutes.login),
            child: const Text('로그인하기'),
          ),
        ],
      );
    }

    // 에러 상태
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
        const SizedBox(height: 16),
        Text('가입 실패', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(_errorMessage ?? '알 수 없는 오류가 발생했어요.', textAlign: TextAlign.center),
        const SizedBox(height: 24),
        FilledButton(onPressed: _joinGroup, child: const Text('다시 시도')),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => context.go(AppRoutes.home),
          child: const Text('홈으로'),
        ),
      ],
    );
  }
}
