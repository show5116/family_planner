import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/announcements/providers/announcement_provider.dart';
import 'package:family_planner/features/announcements/data/dto/announcement_dto.dart';
import 'package:family_planner/features/announcements/data/models/announcement_model.dart';
import 'package:family_planner/features/announcements/utils/announcement_category_helper.dart';
import 'package:family_planner/shared/widgets/rich_text_editor.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/services/storage_service.dart';

/// 공지사항 작성/수정 화면 (ADMIN 전용)
class AnnouncementFormScreen extends ConsumerStatefulWidget {
  /// null이면 작성, 값이 있으면 수정
  final String? announcementId;

  const AnnouncementFormScreen({
    super.key,
    this.announcementId,
  });

  @override
  ConsumerState<AnnouncementFormScreen> createState() =>
      _AnnouncementFormScreenState();
}

class _AnnouncementFormScreenState
    extends ConsumerState<AnnouncementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  AnnouncementCategory? _category;
  bool _isPinned = false;
  bool _isLoading = false;

  bool get _isEditMode => widget.announcementId != null;

  @override
  void initState() {
    super.initState();

    // 수정 모드인 경우 기존 데이터 로드
    if (_isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadAnnouncementData();
      });
    }
  }

  /// 기존 공지사항 데이터 로드 (수정 모드)
  Future<void> _loadAnnouncementData() async {
    final announcementAsync =
        ref.read(announcementDetailProvider(widget.announcementId!));

    announcementAsync.when(
      data: (announcement) {
        setState(() {
          _titleController.text = announcement.title;
          _contentController.text = announcement.content;
          _category = announcement.category;
          _isPinned = announcement.isPinned;
        });
      },
      loading: () {},
      error: (error, stack) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.announcement_loadError}: $error')),
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? l10n.announcement_edit : l10n.announcement_create),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(AppSizes.spaceM),
              child: SizedBox(
                width: AppSizes.iconMedium,
                height: AppSizes.iconMedium,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
              child: FilledButton(
                onPressed: _handleSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(_isEditMode ? l10n.common_edit : l10n.common_create),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.spaceL),
          children: [
            // 고정 여부 스위치
            Card(
              child: SwitchListTile(
                title: Text(l10n.announcement_pin),
                subtitle: Text(l10n.announcement_pinDescription),
                value: _isPinned,
                onChanged: (value) {
                  setState(() {
                    _isPinned = value;
                  });
                },
                secondary: Icon(
                  _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: _isPinned ? AppColors.primary : null,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceL),

            // 카테고리 선택
            DropdownButtonFormField<AnnouncementCategory>(
              initialValue: _category,
              decoration: InputDecoration(
                labelText: l10n.announcement_category,
                hintText: l10n.announcement_categoryHint,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem<AnnouncementCategory>(
                  value: null,
                  child: Text(l10n.announcement_category_none),
                ),
                ...AnnouncementCategory.values.map((category) {
                  return DropdownMenuItem<AnnouncementCategory>(
                    value: category,
                    child: Row(
                      children: [
                        Icon(
                          category.icon,
                          size: AppSizes.iconSmall,
                          color: category.color,
                        ),
                        const SizedBox(width: AppSizes.spaceS),
                        Text(category.displayName(l10n)),
                      ],
                    ),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _category = value;
                });
              },
            ),
            const SizedBox(height: AppSizes.spaceL),

            // 제목 입력
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.announcement_title,
                hintText: l10n.announcement_titleHint,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.announcement_titleRequired;
                }
                if (value.trim().length < 3) {
                  return l10n.announcement_titleMinLength;
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSizes.spaceL),

            // 내용 입력 - 리치 텍스트 에디터 사용
            RichTextEditor(
              controller: _contentController,
              labelText: l10n.announcement_content,
              hintText: l10n.announcement_contentHint,
              minLines: 15,
              maxLines: 30,
              imageUploadType: EditorImageType.announcements,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.announcement_contentRequired;
                }
                if (value.trim().length < 10) {
                  return l10n.announcement_contentMinLength;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 등록/수정 처리
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
    });

    try {
      final dto = CreateAnnouncementDto(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        category: _category,
        isPinned: _isPinned,
      );

      final notifier = ref.read(announcementManagementProvider.notifier);
      final result = _isEditMode
          ? await notifier.updateAnnouncement(widget.announcementId!, dto)
          : await notifier.createAnnouncement(dto);

      if (!mounted) return;

      if (result != null) {
        // 목록 새로고침
        ref.invalidate(announcementListProvider);

        // 수정 모드인 경우 상세 정보도 새로고침
        if (_isEditMode) {
          ref.invalidate(announcementDetailProvider(widget.announcementId!));
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode ? l10n.announcement_updateSuccess : l10n.announcement_createSuccess),
          ),
        );

        // 목록으로 이동
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode ? l10n.announcement_updateError : l10n.announcement_createError),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.common_error}: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
