import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/diary/data/models/diary_media_models.dart';
import 'package:family_planner/features/main/diary/data/models/diary_models.dart';
import 'package:family_planner/features/main/diary/data/repositories/diary_media_repository.dart';
import 'package:family_planner/features/main/diary/data/utils/diary_date.dart';
import 'package:family_planner/features/main/diary/presentation/widgets/diary_media_grid.dart';
import 'package:family_planner/features/main/diary/presentation/widgets/diary_mood_selector.dart';
import 'package:family_planner/features/main/diary/presentation/widgets/media_attach_flow.dart';
import 'package:family_planner/features/main/diary/presentation/widgets/quota_indicator.dart';
import 'package:family_planner/features/main/diary/providers/diary_provider.dart';
import 'package:family_planner/features/main/diary/providers/media_quota_provider.dart';
import 'package:family_planner/features/main/diary/providers/media_upload_provider.dart';
import 'package:family_planner/features/memo/data/utils/memo_editor_converter.dart';
import 'package:family_planner/shared/widgets/form_bottom_bar.dart';

/// 일기 다듬기(작성/수정) 화면
///
/// 빠른 기록으로 던진 조각이 이미 본문에 들어있는 상태로 열린다.
/// "쓰는 곳"이 아니라 **"다듬는 곳"** 이라는 점이 이 화면의 성격이다.
class DiaryFormScreen extends ConsumerStatefulWidget {
  const DiaryFormScreen({super.key, this.diaryId, this.date});

  /// 수정할 일기 ID (없으면 신규 작성)
  final String? diaryId;

  /// 신규 작성 시 대상 날짜 ('YYYY-MM-DD'). 없으면 오늘.
  final String? date;

  @override
  ConsumerState<DiaryFormScreen> createState() => _DiaryFormScreenState();
}

class _DiaryFormScreenState extends ConsumerState<DiaryFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  QuillController _quillController = QuillController.basic();

  String _date = diaryToday();
  String? _mood;
  bool _isSaving = false;
  bool _isLoading = true;
  bool _metaExpanded = false;

  /// 이 화면이 보고 있는 첨부 목록 (표시·순서 변경의 기준)
  List<DiaryMedia> _media = [];

  /// 이 화면에서 새로 올린 첨부
  ///
  /// 신규 작성일 때는 아직 일기가 없어 서버가 연결하지 못하므로, 저장 요청에
  /// `mediaIds`로 함께 실어 보내야 고아 파일이 되지 않는다.
  final List<String> _newMediaIds = [];

  DiaryModel? _original;

  @override
  void initState() {
    super.initState();
    _date = widget.date ?? diaryToday();
    _load();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (widget.diaryId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final diary = await ref.read(diaryDetailProvider(widget.diaryId!).future);
      if (!mounted) return;

      setState(() {
        _original = diary;
        _date = diary.date;
        _mood = diary.mood;
        _media = [...diary.media];
        _titleController.text = diary.title ?? '';
        _quillController.dispose();
        _quillController = QuillController(
          document: diary.format == DiaryFormat.delta
              ? MemoEditorConverter.toDocument(diary.content)
              : (Document()..insert(0, diary.content)),
          selection: const TextSelection.collapsed(offset: 0),
        );
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('${AppLocalizations.of(context)!.diary_load_error}: $e');
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: parseDiaryDate(_date),
      firstDate: DateTime(2000),
      // 미래 날짜는 고를 수 없다 (하루 경계 반영)
      lastDate: parseDiaryDate(diaryToday()),
    );
    if (picked != null) {
      setState(() => _date = toDiaryDate(picked));
    }
  }

  /// 사진 첨부
  ///
  /// 수정 중이면 diaryId를 넘겨 서버가 곧바로 일기에 연결하게 한다.
  /// 신규 작성이면 날짜만 넘기고, 저장할 때 [_newMediaIds]로 연결한다.
  ///
  /// 이 화면은 날짜가 이미 정해진 상태라 EXIF 촬영일을 묻지 않는다
  /// (사용자가 고른 날짜를 되묻는 셈이 된다).
  Future<void> _attachMedia() async {
    final result = await attachDiaryMedia(
      context,
      ref,
      diaryId: _original?.id,
      date: _date,
    );

    if (!mounted) return;
    if (result.isEmpty) {
      showAttachFailureIfAny(context, ref);
      return;
    }

    setState(() {
      _media = [..._media, ...result.media];
      _newMediaIds.addAll(result.mediaIds);
    });
  }

  /// 첨부 삭제 — R2에서 즉시·영구 삭제된다
  Future<void> _deleteMedia(DiaryMedia media) async {
    // 응답을 기다리는 동안 지운 사진이 남아 있으면 두 번 누르게 된다
    setState(() {
      _media = _media.where((m) => m.id != media.id).toList();
      _newMediaIds.remove(media.id);
    });

    try {
      await ref.read(diaryMediaRepositoryProvider).delete(media.id);
      ref.invalidate(mediaQuotaProvider);
    } catch (e) {
      if (!mounted) return;
      // 서버에 남아 있으므로 화면도 되돌린다
      setState(() => _media = [..._media, media]..sort(
            (a, b) => a.sortOrder.compareTo(b.sortOrder),
          ));
      _showError('$e');
    }
  }

  /// 첨부 순서 변경 — 화면을 먼저 맞추고 서버에 반영한다
  Future<void> _reorderMedia(List<DiaryMedia> reordered) async {
    final previous = _media;
    setState(() => _media = reordered);

    try {
      await ref
          .read(diaryMediaRepositoryProvider)
          .reorder(reordered.map((m) => m.id).toList());
    } catch (e) {
      if (!mounted) return;
      setState(() => _media = previous);
      _showError('$e');
    }
  }

  Future<void> _save() async {
    if (_isSaving) return;

    final content = MemoEditorConverter.fromDocument(_quillController.document);
    final title = _titleController.text.trim();

    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(diaryManagementProvider.notifier);

      if (_original != null) {
        await notifier.edit(
          _original!.id,
          UpdateDiaryDto(
            title: title.isEmpty ? null : title,
            clearTitle: title.isEmpty,
            content: content,
            format: DiaryFormat.delta,
            mood: _mood,
            clearMood: _mood == null,
          ),
        );
      } else {
        await notifier.create(
          CreateDiaryDto(
            date: _date,
            title: title.isEmpty ? null : title,
            content: content,
            format: DiaryFormat.delta,
            mood: _mood,
            mediaIds: _newMediaIds,
          ),
        );
      }

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        _showError('${AppLocalizations.of(context)!.diary_save_failed}: $e');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isEditing = _original != null;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.diary_detail_title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.diary_polish : l10n.diary_write),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _MetaHeader(
              date: _date,
              mood: _mood,
              expanded: _metaExpanded,
              // 수정 중에는 날짜를 바꿀 수 없다 — 하루 1편이라 날짜가 곧 정체성이다
              onPickDate: isEditing ? null : _pickDate,
              onToggle: () => setState(() => _metaExpanded = !_metaExpanded),
              onMoodChanged: (mood) => setState(() => _mood = mood),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceS,
              ),
              child: TextField(
                controller: _titleController,
                style: theme.textTheme.titleMedium,
                decoration: InputDecoration(
                  hintText: l10n.diary_title_hint,
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            _MediaSection(
              media: _media,
              onAdd: _attachMedia,
              onDelete: _deleteMedia,
              onReorder: _reorderMedia,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM,
                ),
                child: QuillEditor.basic(
                  controller: _quillController,
                  config: QuillEditorConfig(
                    placeholder: l10n.diary_content_hint,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            QuillSimpleToolbar(
              controller: _quillController,
              config: const QuillSimpleToolbarConfig(
                showFontFamily: false,
                showFontSize: false,
                showSearchButton: false,
                multiRowsDisplay: false,
              ),
            ),
          ],
        ),
      ),
      // 키보드가 올라오면 저장 버튼을 접는다 — 에디터 툴바와 겹치면
      // Android에서 저장 버튼이 툴바 뒤로 들어간다 (vibe-verify 점검 항목)
      bottomNavigationBar: MediaQuery.viewInsetsOf(context).bottom > 0
          ? null
          : FormBottomBar(
              onPressed: _isSaving ? null : _save,
              isLoading: _isSaving,
            ),
    );
  }
}

/// 첨부 영역 — 편집 스트립 + 한도 게이지
///
/// 게이지는 **첨부가 있을 때만** 보인다. 늘 띄워두면 아무것도 안 올린 사용자에게
/// 압박만 준다.
class _MediaSection extends ConsumerWidget {
  const _MediaSection({
    required this.media,
    required this.onAdd,
    required this.onDelete,
    required this.onReorder,
  });

  final List<DiaryMedia> media;
  final VoidCallback onAdd;
  final void Function(DiaryMedia media) onDelete;
  final void Function(List<DiaryMedia> reordered) onReorder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final uploadState = ref.watch(mediaUploadProvider);
    final quota = ref.watch(mediaQuotaProvider).valueOrNull;
    final hasAttachments = media.isNotEmpty || uploadState.items.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DiaryMediaEditor(
            existing: media,
            onAdd: onAdd,
            onDelete: onDelete,
            onReorder: onReorder,
          ),
          if (hasAttachments && quota != null) ...[
            QuotaIndicator(
              bucket: quota.monthly,
              label: l10n.diary_quota_monthly,
              pendingBytes: uploadState.pendingBytes,
              compact: true,
            ),
            const SizedBox(height: AppSizes.spaceS),
          ],
        ],
      ),
    );
  }
}

/// 접이식 메타 헤더 (날짜 · 기분)
///
/// 작성 화면 진입 직후 사용자가 원하는 건 "쓰기"다. 설정은 접어둔다.
class _MetaHeader extends StatelessWidget {
  const _MetaHeader({
    required this.date,
    required this.mood,
    required this.expanded,
    required this.onPickDate,
    required this.onToggle,
    required this.onMoodChanged,
  });

  final String date;
  final String? mood;
  final bool expanded;
  final VoidCallback? onPickDate;
  final VoidCallback onToggle;
  final ValueChanged<String?> onMoodChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();

    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: AppSizes.spaceS,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: AppSizes.iconSmall,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  DateFormat.yMMMMEEEEd(locale).format(parseDiaryDate(date)),
                  style: theme.textTheme.bodyMedium,
                ),
                if (mood != null) ...[
                  const SizedBox(width: AppSizes.spaceS),
                  Text(mood!, style: theme.textTheme.bodyMedium),
                ],
                const Spacer(),
                Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceM,
              0,
              AppSizes.spaceM,
              AppSizes.spaceS,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (onPickDate != null)
                  TextButton.icon(
                    onPressed: onPickDate,
                    icon: const Icon(Icons.edit_calendar_outlined),
                    label: Text(l10n.diary_change_date),
                  ),
                DiaryMoodSelector(
                  selected: mood,
                  onChanged: onMoodChanged,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
