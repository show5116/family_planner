import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/format_utils.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/diary/data/models/diary_media_models.dart';
import 'package:family_planner/features/main/diary/data/utils/media_compressor.dart';
import 'package:family_planner/features/main/diary/data/utils/media_picker.dart';
import 'package:family_planner/features/main/diary/providers/media_upload_provider.dart';

/// 압축 선택 시트
///
/// 파일을 고른 직후, 올리기 전에 뜬다. **압축 후 크기는 추정하지 않고 실제로
/// 압축해본 결과**를 보여준다 — 추정치가 어긋나면 게이지 전체의 신뢰를 잃는다.
class MediaUploadSheet extends StatefulWidget {
  const MediaUploadSheet({
    super.key,
    required this.picked,
    required this.quota,
  });

  final List<PickedMedia> picked;

  /// 남은 용량 안내와 "올리기" 비활성화 판단에 쓴다 (최종 판단은 서버).
  final MediaQuota? quota;

  /// 시트를 띄우고 사용자가 고른 결과를 돌려준다 (취소하면 null)
  static Future<List<PreparedMedia>?> show(
    BuildContext context, {
    required List<PickedMedia> picked,
    required MediaQuota? quota,
  }) {
    return showModalBottomSheet<List<PreparedMedia>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => MediaUploadSheet(picked: picked, quota: quota),
    );
  }

  @override
  State<MediaUploadSheet> createState() => _MediaUploadSheetState();
}

class _MediaUploadSheetState extends State<MediaUploadSheet> {
  /// 각 파일의 압축 결과 (picked와 같은 순서)
  ///
  /// "원본으로 올리기"는 [PickedMedia.bytes]를 그대로 쓴다 — 선택 시점에 이미
  /// 서버가 받아주는 형식으로 정규화돼 있어서, 여기서 더 손댈 것이 없다.
  List<CompressionResult>? _compressed;

  bool _keepOriginal = false;

  @override
  void initState() {
    super.initState();
    _compressAll();
  }

  Future<void> _compressAll() async {
    final results = <CompressionResult>[];
    for (final item in widget.picked) {
      results.add(await MediaCompressor.compressImage(item.bytes));
    }
    if (!mounted) return;
    setState(() => _compressed = results);
  }

  int get _originalTotal =>
      widget.picked.fold(0, (sum, item) => sum + item.size);

  int get _compressedTotal =>
      _compressed?.fold<int>(0, (sum, r) => sum + r.size) ?? _originalTotal;

  int get _selectedTotal => _keepOriginal ? _originalTotal : _compressedTotal;

  /// 고른 모드에서 파일 1개의 최대 크기
  int get _selectedLargestFile {
    if (_keepOriginal || _compressed == null) {
      return widget.picked.fold(0, (max, i) => i.size > max ? i.size : max);
    }
    return _compressed!.fold(0, (max, r) => r.size > max ? r.size : max);
  }

  /// 올릴 수 없는 사유 (없으면 null)
  QuotaRejection? get _rejection {
    final quota = widget.quota;
    if (quota == null) return null;

    if (quota.perFileLimitBytes > 0 &&
        _selectedLargestFile > quota.perFileLimitBytes) {
      return QuotaRejection.fileTooLarge;
    }
    if (_selectedTotal > quota.monthly.remainingBytes) {
      return QuotaRejection.monthlyExhausted;
    }
    if (_selectedTotal > quota.total.remainingBytes) {
      return QuotaRejection.totalExhausted;
    }
    return null;
  }

  void _submit() {
    final compressed = _compressed;
    if (compressed == null) return;

    final prepared = <PreparedMedia>[];
    for (var i = 0; i < widget.picked.length; i++) {
      final item = widget.picked[i];
      final result = compressed[i];
      final useOriginal = _keepOriginal || !result.compressed;

      prepared.add(PreparedMedia(
        bytes: useOriginal ? item.bytes : result.bytes,
        fileName: item.fileName,
        // 파일명에서 추측한 값이 아니라 **실제로 올릴 바이트에서 읽어낸** 형식이다
        mimeType: useOriginal ? item.mimeType : result.mimeType,
        type: item.type,
        originalSize: item.size,
        isOriginal: useOriginal,
        width: item.width,
        height: item.height,
      ));
    }

    Navigator.pop(context, prepared);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isReady = _compressed != null;
    final rejection = _rejection;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spaceM,
        AppSizes.spaceS,
        AppSizes.spaceM,
        AppSizes.spaceM,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            l10n.diary_upload_sheet_title(widget.picked.length),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSizes.spaceM),

          if (!isReady)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSizes.spaceL),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            _ModeTile(
              value: false,
              groupValue: _keepOriginal,
              title: l10n.diary_upload_compressed,
              subtitle: _compressedTotal < _originalTotal
                  ? l10n.diary_upload_saved(
                      formatBytes(_originalTotal),
                      formatBytes(_compressedTotal),
                      _savedPercent,
                    )
                  : formatBytes(_compressedTotal),
              onChanged: (v) => setState(() => _keepOriginal = v),
            ),
            _ModeTile(
              value: true,
              groupValue: _keepOriginal,
              title: l10n.diary_upload_original,
              subtitle: formatBytes(_originalTotal),
              onChanged: (v) => setState(() => _keepOriginal = v),
            ),
          ],

          if (widget.quota != null) ...[
            const SizedBox(height: AppSizes.spaceS),
            Text(
              l10n.diary_quota_remaining(
                formatBytes(widget.quota!.monthly.remainingBytes),
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],

          if (rejection != null) ...[
            const SizedBox(height: AppSizes.spaceS),
            _RejectionNotice(rejection: rejection),
          ],

          const SizedBox(height: AppSizes.spaceM),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  MaterialLocalizations.of(context).cancelButtonLabel,
                ),
              ),
              const SizedBox(width: AppSizes.spaceS),
              FilledButton(
                onPressed: isReady && rejection == null ? _submit : null,
                child: Text(l10n.diary_upload_start),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int get _savedPercent {
    if (_originalTotal <= 0) return 0;
    return ((_originalTotal - _compressedTotal) / _originalTotal * 100).round();
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.value,
    required this.groupValue,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  final bool value;
  final bool groupValue;
  final String title;
  final String subtitle;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSizes.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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

/// 올릴 수 없는 사유 안내
///
/// 사유마다 제시하는 대안이 다르다. 결제 버튼만 있는 막다른 안내를 만들지 않는다.
class _RejectionNotice extends StatelessWidget {
  const _RejectionNotice({required this.rejection});

  final QuotaRejection rejection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final (title, hint) = switch (rejection) {
      QuotaRejection.fileTooLarge => (
          l10n.diary_file_too_large,
          l10n.diary_file_too_large_hint,
        ),
      QuotaRejection.monthlyExhausted => (
          l10n.diary_quota_exceeded_title,
          l10n.diary_quota_exceeded_options,
        ),
      QuotaRejection.totalExhausted => (
          l10n.diary_quota_total_exceeded_title,
          l10n.diary_quota_exceeded_options,
        ),
      QuotaRejection.videoNotAllowed => (
          l10n.diary_video_not_allowed,
          l10n.diary_quota_exceeded_options,
        ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spaceS),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            hint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
