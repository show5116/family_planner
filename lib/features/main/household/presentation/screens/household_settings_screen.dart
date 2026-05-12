// TODO: 결제 알림 자동 등록 기능 — 앱 심사 통과 후 아래 주석 해제
// household_auto_settings_provider.dart, push_expense_listener_service.dart 주석도 함께 해제 필요
// app_routes.dart · main_routes.dart 의 householdSettings 라우트 주석도 해제 필요
// main.dart 의 householdAutoSettingsProvider.load() 호출 주석도 해제 필요

/*
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/household/data/services/push_expense_listener_service.dart';
import 'package:family_planner/features/main/household/providers/household_auto_settings_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 가계부 설정 화면
///
/// - 대표 그룹(자동 등록 시 사용할 그룹) 선택
/// - 푸시 자동 등록 on/off
/// - 개인정보 처리방침 안내
class HouseholdSettingsScreen extends ConsumerStatefulWidget {
  const HouseholdSettingsScreen({super.key});

  @override
  ConsumerState<HouseholdSettingsScreen> createState() =>
      _HouseholdSettingsScreenState();
}

class _HouseholdSettingsScreenState
    extends ConsumerState<HouseholdSettingsScreen> {
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkPermission());
  }

  Future<void> _checkPermission() async {
    final granted = await PushExpenseListenerService.isPermissionGranted();
    if (mounted) setState(() => _permissionGranted = granted);
  }

  bool get _isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(householdAutoSettingsProvider);
    final groupsAsync = ref.watch(myGroupsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.household_settings_title)),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        children: [
          // ── 대표 그룹 설정 ───────────────────────────────────────────
          _SectionHeader(label: l10n.household_settings_group_section),
          Card(
            child: groupsAsync.when(
              data: (groups) => _GroupSelector(
                groups: groups,
                selectedGroupId: settings.defaultGroupId,
                onChanged: (groupId) => ref
                    .read(householdAutoSettingsProvider.notifier)
                    .setDefaultGroupId(groupId),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSizes.spaceM),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => Padding(
                padding: const EdgeInsets.all(AppSizes.spaceM),
                child: Text(l10n.common_error),
              ),
            ),
          ),

          const SizedBox(height: AppSizes.spaceL),

          // ── 푸시 자동 등록 ───────────────────────────────────────────
          if (_isAndroid) ...[
            _SectionHeader(label: l10n.household_settings_auto_section),
            Card(
              child: Column(
                children: [
                  // 권한 상태 배너
                  if (!_permissionGranted)
                    _PermissionBanner(
                      onGrantTap: () async {
                        await PushExpenseListenerService.openPermissionSettings();
                        await _checkPermission();
                      },
                      l10n: l10n,
                    ),
                  // 자동 등록 토글
                  SwitchListTile(
                    value: settings.pushAutoRegisterEnabled,
                    onChanged: _permissionGranted
                        ? (val) => ref
                            .read(householdAutoSettingsProvider.notifier)
                            .setPushAutoRegister(enabled: val)
                        : null,
                    secondary: Icon(
                      Icons.notifications_active_outlined,
                      color: _permissionGranted
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                    ),
                    title: Text(l10n.household_settings_auto_toggle),
                    subtitle: Text(
                      _permissionGranted
                          ? l10n.household_settings_auto_toggle_desc
                          : l10n.household_settings_permission_required,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  // 동작 범위 안내
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.spaceM,
                      0,
                      AppSizes.spaceM,
                      AppSizes.spaceM,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(width: AppSizes.spaceXS),
                        Expanded(
                          child: Text(
                            l10n.household_settings_auto_scope_notice,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.spaceL),

            // ── 개인정보 처리방침 ──────────────────────────────────────
            _SectionHeader(label: l10n.household_settings_privacy_section),
            Card(
              child: ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: Text(l10n.household_settings_privacy_title),
                subtitle: Text(l10n.household_settings_privacy_subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showPrivacyDialog(context, l10n),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.household_settings_privacy_dialog_title),
        content: SingleChildScrollView(
          child: Text(
            _privacyContent(l10n),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.common_close),
          ),
        ],
      ),
    );
  }

  String _privacyContent(AppLocalizations l10n) => l10n.household_settings_privacy_content;
}

// ── 섹션 헤더 ─────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.spaceXS,
        bottom: AppSizes.spaceXS,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

// ── 그룹 선택 위젯 ────────────────────────────────────────────────────────────
class _GroupSelector extends StatelessWidget {
  final List<Group> groups;
  final String? selectedGroupId;
  final void Function(String? groupId) onChanged;

  const _GroupSelector({
    required this.groups,
    required this.selectedGroupId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const personalValue = '__personal__';
    final currentValue = selectedGroupId ?? personalValue;

    final items = <DropdownMenuItem<String>>[
      DropdownMenuItem(
        value: personalValue,
        child: Row(
          children: [
            const Icon(Icons.person_outline, size: 18),
            const SizedBox(width: AppSizes.spaceS),
            Text(AppLocalizations.of(context)!.household_personal_mode),
          ],
        ),
      ),
      ...groups.map(
        (g) => DropdownMenuItem(
          value: g.id,
          child: Row(
            children: [
              const Icon(Icons.group_outlined, size: 18),
              const SizedBox(width: AppSizes.spaceS),
              Text(g.name),
            ],
          ),
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentValue,
                isExpanded: true,
                items: items,
                onChanged: (val) {
                  onChanged(val == personalValue ? null : val);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 권한 안내 배너 ────────────────────────────────────────────────────────────
class _PermissionBanner extends StatelessWidget {
  final VoidCallback onGrantTap;
  final AppLocalizations l10n;

  const _PermissionBanner({
    required this.onGrantTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.spaceS),
      padding: const EdgeInsets.all(AppSizes.spaceM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Theme.of(context).colorScheme.onErrorContainer,
            size: 20,
          ),
          const SizedBox(width: AppSizes.spaceS),
          Expanded(
            child: Text(
              l10n.household_settings_permission_required,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
          ),
          TextButton(
            onPressed: onGrantTap,
            child: Text(l10n.household_settings_permission_grant),
          ),
        ],
      ),
    );
  }
}
*/
