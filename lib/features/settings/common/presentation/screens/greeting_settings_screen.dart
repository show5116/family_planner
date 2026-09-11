import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/greeting_presets.dart';
import 'package:family_planner/core/models/greeting_settings.dart';
import 'package:family_planner/core/providers/greeting_settings_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 대시보드 인사말 설정 화면
///
/// 기본 제공 문구 팩을 켜고 끄거나, 직접 문구를 등록한다.
/// 저장은 기기 로컬(SharedPreferences)에만 이뤄진다.
class GreetingSettingsScreen extends ConsumerWidget {
  const GreetingSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsAsync = ref.watch(greetingSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.greeting_settingsTitle)),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorState(
          error: error,
          title: l10n.common_error,
          onRetry: () => ref.invalidate(greetingSettingsProvider),
        ),
        data: (settings) => _GreetingSettingsBody(settings: settings),
      ),
    );
  }
}

class _GreetingSettingsBody extends ConsumerWidget {
  const _GreetingSettingsBody({required this.settings});

  final GreetingSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final notifier = ref.read(greetingSettingsProvider.notifier);

    return ListView(
      padding: EdgeInsets.only(
        left: AppSizes.spaceM,
        right: AppSizes.spaceM,
        top: AppSizes.spaceM,
        bottom: AppSizes.spaceM + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        // 안내 메시지
        Container(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: theme.colorScheme.primary),
              const SizedBox(width: AppSizes.spaceS),
              Expanded(
                child: Text(
                  l10n.greeting_guide,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.spaceL),

        // 오늘 표시될 문구 미리보기
        _PreviewCard(settings: settings),
        const SizedBox(height: AppSizes.spaceM),

        // 내 인사말 사용 여부
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.greeting_useCustom),
          subtitle: Text(l10n.greeting_useCustomDesc),
          value: settings.enabled,
          onChanged: notifier.setEnabled,
        ),
        const Divider(),

        // 기본 제공 문구 팩 (연령별 → 연령 무관 순)
        _SectionHeader(title: l10n.greeting_presetSection),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
          child: Text(
            l10n.greeting_presetSourceNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        // 팩이 14종이라 묶음별 소제목을 두고 나눠 보여준다
        ...GreetingPackIds.groups.indexed.expand(
          (entry) => [
            Padding(
              padding: const EdgeInsets.only(
                top: AppSizes.spaceM,
                bottom: AppSizes.spaceXS,
              ),
              child: Text(
                GreetingPresets.groupLabel(l10n, entry.$1),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...entry.$2.map(
              (packId) => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: Icon(GreetingPresets.packIcon(packId)),
                title: Text(GreetingPresets.packLabel(l10n, packId)),
                subtitle: Text(
                  l10n.greeting_packMessageCount(
                    GreetingPresets.messages(languageCode, packId).length,
                  ),
                ),
                value: settings.enabledPacks.contains(packId),
                onChanged: (value) => notifier.setPackEnabled(packId, value),
              ),
            ),
          ],
        ),
        const Divider(),

        // 내가 등록한 문구
        _SectionHeader(
          title: l10n.greeting_customSection,
          trailing: Text(
            l10n.greeting_customCount(
              settings.customMessages.length,
              GreetingSettings.maxCustomMessages,
            ),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        if (settings.customMessages.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceL),
            child: AppEmptyState(
              icon: Icons.chat_bubble_outline,
              message: l10n.greeting_emptyMessages,
              subtitle: l10n.greeting_emptyMessagesDesc,
            ),
          )
        else
          ...settings.customMessages.asMap().entries.map(
                (entry) => _MessageTile(index: entry.key, message: entry.value),
              ),
        const SizedBox(height: AppSizes.spaceM),
        OutlinedButton.icon(
          onPressed: () => _addMessage(context, ref),
          icon: const Icon(Icons.add),
          label: Text(l10n.greeting_addMessage),
        ),
      ],
    );
  }

  Future<void> _addMessage(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    if (settings.customMessages.length >= GreetingSettings.maxCustomMessages) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.greeting_maxReached(GreetingSettings.maxCustomMessages),
          ),
        ),
      );
      return;
    }

    final message = await showGreetingMessageDialog(context);
    if (message == null) return;

    final added =
        await ref.read(greetingSettingsProvider.notifier).addMessage(message);
    if (!added) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.greeting_duplicated)),
      );
    }
  }
}

/// 오늘 표시될 문구 미리보기 카드
class _PreviewCard extends ConsumerWidget {
  const _PreviewCard({required this.settings});

  final GreetingSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final rotation = ref.watch(greetingRotationProvider);
    final message = GreetingPresets.pickMessage(
      GreetingPresets.buildPool(
        Localizations.localeOf(context).languageCode,
        settings,
      ),
      date: DateTime.now(),
      rotation: rotation,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.format_quote,
              size: AppSizes.iconLarge,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: AppSizes.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.greeting_previewTitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceXS),
                  Text(
                    message ?? l10n.greeting_previewEmpty,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: message == null
                          ? theme.colorScheme.onSurfaceVariant
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 사용자가 등록한 문구 1건
class _MessageTile extends ConsumerWidget {
  const _MessageTile({required this.index, required this.message});

  final int index;
  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.chat_bubble_outline),
      title: Text(
        message,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        tooltip: l10n.common_delete,
        onPressed: () => _confirmDelete(context, ref),
      ),
      onTap: () => _edit(context, ref),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final edited = await showGreetingMessageDialog(context, initial: message);
    if (edited == null) return;
    await ref
        .read(greetingSettingsProvider.notifier)
        .updateMessage(index, edited);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.greeting_deleteConfirm),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(greetingSettingsProvider.notifier).removeMessage(index);
  }
}

/// 섹션 제목
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// 문구 입력 다이얼로그 (취소 시 null)
Future<String?> showGreetingMessageDialog(
  BuildContext context, {
  String? initial,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _MessageDialog(initial: initial),
  );
}

class _MessageDialog extends StatefulWidget {
  const _MessageDialog({this.initial});

  final String? initial;

  @override
  State<_MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<_MessageDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    Navigator.pop(context, text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        widget.initial == null
            ? l10n.greeting_addMessage
            : l10n.greeting_editMessage,
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        minLines: 1,
        maxLines: 3,
        maxLength: GreetingSettings.maxMessageLength,
        decoration: InputDecoration(hintText: l10n.greeting_messageHint),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.common_cancel),
        ),
        TextButton(
          onPressed: _submit,
          child: Text(l10n.common_save),
        ),
      ],
    );
  }
}
