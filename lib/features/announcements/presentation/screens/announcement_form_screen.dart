import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/announcements/providers/announcement_provider.dart';
import 'package:family_planner/features/announcements/data/dto/announcement_dto.dart';
import 'package:family_planner/shared/widgets/markdown_editor.dart';

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
          _isPinned = announcement.isPinned;
        });
      },
      loading: () {},
      error: (error, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('공지사항을 불러올 수 없습니다: $error')),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? '공지사항 수정' : '공지사항 작성'),
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
                child: Text(_isEditMode ? '수정' : '등록'),
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
                title: const Text('상단 고정'),
                subtitle: const Text('중요한 공지사항을 목록 상단에 고정합니다'),
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

            // 제목 입력
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '제목',
                hintText: '공지사항 제목을 입력하세요',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '제목을 입력해주세요';
                }
                if (value.trim().length < 3) {
                  return '제목은 최소 3자 이상 입력해주세요';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSizes.spaceL),

            // 내용 입력 - 마크다운 에디터 사용
            MarkdownEditor(
              controller: _contentController,
              labelText: '내용',
              hintText: '공지사항 내용을 입력하세요\n\n마크다운 형식을 지원합니다.',
              minLines: 15,
              maxLines: 30,
              showPreview: true,
              showToolbar: true,
              showGuide: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '내용을 입력해주세요';
                }
                if (value.trim().length < 10) {
                  return '내용은 최소 10자 이상 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSizes.spaceL),

            // 첨부파일 안내 (향후 구현)
            Card(
              color: AppColors.warning.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spaceM),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: AppSizes.iconSmall,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    Expanded(
                      child: Text(
                        '첨부파일 업로드 기능은 추후 업데이트 예정입니다',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.warning,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
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

    setState(() {
      _isLoading = true;
    });

    try {
      final dto = CreateAnnouncementDto(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        isPinned: _isPinned,
      );

      final notifier = ref.read(announcementManagementProvider.notifier);
      final result = _isEditMode
          ? await notifier.updateAnnouncement(widget.announcementId!, dto)
          : await notifier.createAnnouncement(dto);

      if (!mounted) return;

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode ? '공지사항이 수정되었습니다' : '공지사항이 등록되었습니다'),
          ),
        );

        // 목록으로 이동
        if (_isEditMode) {
          context.pop(); // 상세 화면으로 돌아가기
        } else {
          context.go('/announcements'); // 목록으로 이동
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode ? '공지사항 수정에 실패했습니다' : '공지사항 등록에 실패했습니다'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류가 발생했습니다: $e')),
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
