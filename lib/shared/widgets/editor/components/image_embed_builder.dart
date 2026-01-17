import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:family_planner/core/constants/app_sizes.dart';

/// 이미지 임베드 빌더
///
/// QuillEditor에서 이미지를 렌더링하는 커스텀 빌더입니다.
/// 네트워크 이미지를 로딩 상태와 에러 처리와 함께 표시합니다.
class ImageEmbedBuilder extends EmbedBuilder {
  @override
  String get key => BlockEmbed.imageType;

  @override
  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  ) {
    final imageUrl = embedContext.node.value.data;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
      constraints: const BoxConstraints(maxWidth: double.infinity),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200,
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 100,
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }
}
