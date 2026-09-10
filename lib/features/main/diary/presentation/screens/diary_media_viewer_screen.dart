import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/diary/data/models/diary_media_models.dart';

/// 전체화면 미디어 뷰어
///
/// 좌우 스와이프로 넘기고, 핀치로 확대한다. 확대 중에는 페이지 스와이프를 막아
/// (`InteractiveViewer`의 팬과 `PageView`가 서로 먹지 않도록) 조작이 엉키지 않게 한다.
///
/// 영상 재생은 Phase 3(`video_player`)에서 붙인다 — 지금은 썸네일만 보여준다.
class DiaryMediaViewerScreen extends StatefulWidget {
  const DiaryMediaViewerScreen({
    super.key,
    required this.media,
    this.initialIndex = 0,
  });

  final List<DiaryMedia> media;
  final int initialIndex;

  static Future<void> open(
    BuildContext context, {
    required List<DiaryMedia> media,
    int initialIndex = 0,
  }) {
    if (media.isEmpty) return Future.value();
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => DiaryMediaViewerScreen(
          media: media,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  State<DiaryMediaViewerScreen> createState() => _DiaryMediaViewerScreenState();
}

class _DiaryMediaViewerScreenState extends State<DiaryMediaViewerScreen> {
  late final PageController _controller;
  late int _index;

  /// 확대 중이면 페이지 스와이프를 잠근다
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.media.length - 1);
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        // 앱바 배경을 검게 깔았으므로 전경색을 명시하지 않으면 아이콘이 보이지 않는다
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '${_index + 1} / ${widget.media.length}',
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        controller: _controller,
        physics: _isZoomed
            ? const NeverScrollableScrollPhysics()
            : const PageScrollPhysics(),
        onPageChanged: (i) => setState(() => _index = i),
        itemCount: widget.media.length,
        itemBuilder: (context, index) => _ZoomableMedia(
          media: widget.media[index],
          onZoomChanged: (zoomed) {
            if (zoomed != _isZoomed) setState(() => _isZoomed = zoomed);
          },
        ),
      ),
    );
  }
}

class _ZoomableMedia extends StatefulWidget {
  const _ZoomableMedia({required this.media, required this.onZoomChanged});

  final DiaryMedia media;
  final ValueChanged<bool> onZoomChanged;

  @override
  State<_ZoomableMedia> createState() => _ZoomableMediaState();
}

class _ZoomableMediaState extends State<_ZoomableMedia> {
  final TransformationController _transformation = TransformationController();

  @override
  void initState() {
    super.initState();
    _transformation.addListener(_onTransform);
  }

  @override
  void dispose() {
    _transformation.removeListener(_onTransform);
    _transformation.dispose();
    super.dispose();
  }

  void _onTransform() {
    // 배율이 1을 넘으면 확대 상태로 본다 (부동소수 오차를 감안해 여유를 둔다)
    widget.onZoomChanged(_transformation.value.getMaxScaleOnAxis() > 1.01);
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformation,
      minScale: 1,
      maxScale: 4,
      child: Center(
        child: CachedNetworkImage(
          imageUrl: widget.media.url,
          fit: BoxFit.contain,
          placeholder: (_, _) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          errorWidget: (_, _, _) => const Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: Colors.white54,
              size: AppSizes.iconXLarge,
            ),
          ),
        ),
      ),
    );
  }
}
