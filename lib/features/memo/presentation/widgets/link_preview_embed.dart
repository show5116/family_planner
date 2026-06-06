import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/memo/data/models/link_preview_model.dart';

/// Delta 임베드 키
const kLinkPreviewEmbedKey = 'link-preview';

/// 링크 프리뷰 임베드 빌더 (에디터 + 뷰어 공용)
class LinkPreviewEmbedBuilder extends EmbedBuilder {
  final bool readOnly;
  /// embedData: 삭제할 임베드의 원본 JSON 문자열 (Delta 내 embed 값과 동일)
  final void Function(String embedData)? onDelete;

  LinkPreviewEmbedBuilder({this.readOnly = false, this.onDelete});

  @override
  String get key => kLinkPreviewEmbedKey;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final raw = embedContext.node.value.data;
    final rawStr = raw is String ? raw : jsonEncode(raw);
    LinkPreviewModel? preview;
    try {
      final map = jsonDecode(rawStr) as Map<String, dynamic>;
      preview = LinkPreviewModel.fromJson(map);
    } catch (_) {
      return const SizedBox.shrink();
    }

    return _LinkPreviewCard(
      preview: preview,
      readOnly: readOnly,
      onDelete: onDelete != null ? () => onDelete!(rawStr) : null,
    );
  }
}

class _LinkPreviewCard extends StatelessWidget {
  final LinkPreviewModel preview;
  final bool readOnly;
  final VoidCallback? onDelete;

  const _LinkPreviewCard({
    required this.preview,
    required this.readOnly,
    this.onDelete,
  });

  Future<void> _launch() async {
    final uri = Uri.tryParse(preview.url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
      child: Stack(
        children: [
          GestureDetector(
            onTap: _launch,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
              ),
              clipBehavior: Clip.antiAlias,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 좌측 액센트 바
                    Container(
                      width: 4,
                      color: AppColors.primary,
                    ),

                    // 텍스트 영역
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.spaceM),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 사이트명
                            if (preview.siteName != null)
                              Text(
                                preview.siteName!,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(color: AppColors.primary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (preview.siteName != null)
                              const SizedBox(height: 2),

                            // 제목
                            Text(
                              preview.title ?? preview.url,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            // 설명
                            if (preview.description != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                preview.description!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],

                            // URL
                            const SizedBox(height: 4),
                            Text(
                              preview.url,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 썸네일 이미지
                    if (preview.image != null)
                      SizedBox(
                        width: 90,
                        child: Image.network(
                          preview.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const SizedBox.shrink(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // 에디터 모드: 삭제 버튼
          if (!readOnly && onDelete != null)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.all(AppSizes.spaceS),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.close, size: 14, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
