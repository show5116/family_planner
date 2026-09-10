import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/diary/data/models/diary_media_models.dart';
import 'package:family_planner/features/main/diary/data/repositories/diary_media_repository.dart';
import 'package:family_planner/features/main/diary/data/utils/diary_date.dart';
import 'package:family_planner/features/main/diary/data/utils/media_picker.dart';
import 'package:family_planner/features/main/diary/presentation/widgets/media_upload_sheet.dart';
import 'package:family_planner/features/main/diary/providers/media_quota_provider.dart';
import 'package:family_planner/features/main/diary/providers/media_upload_provider.dart';

/// 첨부 결과 — 올라간 미디어와 **실제로 붙인 날짜**
///
/// EXIF 촬영일 확인에서 사용자가 과거 날짜를 고를 수 있으므로, 호출한 쪽이
/// 이어지는 append도 같은 날짜로 보내야 사진과 글이 다른 날에 흩어지지 않는다.
class DiaryAttachResult {
  final List<DiaryMedia> media;
  final String date;

  const DiaryAttachResult({required this.media, required this.date});

  bool get isEmpty => media.isEmpty;

  List<String> get mediaIds => media.map((m) => m.id).toList();
}

/// 사진 첨부 한 벌 — 선택 → 촬영일 확인 → 압축 선택 → 예약·업로드·확정
///
/// 빠른 기록 바와 다듬기 화면이 같은 흐름을 쓴다. 두 곳에 복사하면 한쪽만
/// 고쳐지는 사고가 나므로 여기 하나로 묶는다.
///
/// [askCaptureDate]가 true면 EXIF 촬영일이 [date]와 다를 때 어느 날 일기에
/// 넣을지 물어본다. 다듬기 화면처럼 **날짜를 이미 정해놓고 들어온 곳**에서는
/// 묻지 않는다 — 사용자가 고른 날짜를 되묻는 셈이 된다.
Future<DiaryAttachResult> attachDiaryMedia(
  BuildContext context,
  WidgetRef ref, {
  String? diaryId,
  required String date,
  bool askCaptureDate = false,
}) async {
  var targetDate = date;
  final empty = DiaryAttachResult(media: const [], date: targetDate);

  final source = await _askSource(context);
  if (source == null || !context.mounted) return empty;

  final pickResult = source == _MediaSource.camera
      ? await DiaryMediaPicker.takePhoto()
      : await DiaryMediaPicker.pickImages();
  if (!context.mounted) return empty;

  // 못 올리는 형식은 선택 시점에 걸러진다. 조용히 빠지면 사용자는 3장을 골랐는데
  // 2장만 올라간 이유를 알 수 없으므로 여기서 알린다.
  if (pickResult.hasRejected) {
    _showRejected(context, pickResult.rejectedFileNames);
  }

  final picked = pickResult.items;
  if (picked.isEmpty) return empty;

  if (askCaptureDate) {
    final captured = _sharedCaptureDate(picked, targetDate);
    if (captured != null) {
      final chosen = await _askCaptureDate(context, captured, targetDate);
      if (!context.mounted) return empty;
      targetDate = chosen;
    }
  }

  // 한도는 사전 안내용이다 — 못 읽어도 업로드를 막지 않는다 (서버가 최종 판단)
  MediaQuota? quota;
  try {
    quota = await ref.read(mediaQuotaProvider.future);
  } catch (_) {
    quota = null;
  }
  if (!context.mounted) return DiaryAttachResult(media: const [], date: targetDate);

  final prepared = await MediaUploadSheet.show(
    context,
    picked: picked,
    quota: quota,
  );
  if (prepared == null || prepared.isEmpty) {
    return DiaryAttachResult(media: const [], date: targetDate);
  }

  final notifier = ref.read(mediaUploadProvider.notifier);
  final uploaded = <DiaryMedia>[];

  for (final item in prepared) {
    final queued = notifier.enqueuePrepared(item);
    final ok = await notifier.upload(
      queued.localId,
      diaryId: diaryId,
      date: targetDate,
    );

    if (ok) {
      final confirmed = ref
          .read(mediaUploadProvider)
          .items
          .where((i) => i.localId == queued.localId)
          .firstOrNull
          ?.uploaded;
      if (confirmed != null) uploaded.add(confirmed);
    }
  }

  // 확정분은 화면이 일기 첨부 목록으로 그린다 — 큐에 남기면 두 번 보인다
  notifier.clearCompleted();

  return DiaryAttachResult(media: uploaded, date: targetDate);
}

/// 고른 사진들이 **공통으로** 가리키는 촬영일 (물어볼 값이 없으면 null)
///
/// 하루 경계(새벽 4시)를 그대로 적용한다 — 새벽 3시에 찍은 사진은 전날 일기다.
///
/// 촬영일이 여러 날로 흩어져 있으면 묻지 않는다. 한 번 물어 전부에 적용하면
/// 일부가 엉뚱한 날에 들어가고, 장당 물으면 사진 열 장에 열 번 묻게 된다.
/// 한 행사에서 찍은 사진을 한꺼번에 올리는 것이 실제 사용 방식이므로,
/// **날짜가 하나로 모일 때만** 묻는다.
String? _sharedCaptureDate(List<PickedMedia> picked, String targetDate) {
  final dates = picked
      .map((p) => p.capturedAt)
      .whereType<DateTime>()
      .map(diaryToday)
      .toSet();

  if (dates.length != 1) return null;

  final captured = dates.first;
  if (captured == targetDate) return null;

  // 미래 날짜는 기기 시계가 틀어진 것이다 — 물어봐야 혼란만 준다
  if (isFutureDiaryDate(captured)) return null;

  return captured;
}

/// 촬영일과 오늘 중 어느 날 일기에 넣을지 물어본다
///
/// **자동으로 과거 날짜에 넣지 않는다.** 스크린샷·저장한 이미지가 오탐을 만들기
/// 때문에, EXIF는 제안까지만 하고 결정은 사용자가 한다.
Future<String> _askCaptureDate(
  BuildContext context,
  String capturedDate,
  String targetDate,
) async {
  final l10n = AppLocalizations.of(context)!;
  final locale = Localizations.localeOf(context).toLanguageTag();
  final capturedLabel =
      DateFormat.MMMMd(locale).format(parseDiaryDate(capturedDate));

  final chosen = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(l10n.diary_exif_date_question(capturedLabel)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, targetDate),
          child: Text(l10n.diary_exif_use_today),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, capturedDate),
          child: Text(l10n.diary_exif_use_captured(capturedLabel)),
        ),
      ],
    ),
  );

  // 다이얼로그를 밖을 눌러 닫으면 기본값(오늘)을 유지한다
  return chosen ?? targetDate;
}

/// 업로드 실패를 화면에 알린다
///
/// 큐에는 실패 항목이 남아 있으므로 재시도 경로는 첨부 스트립에 계속 떠 있다.
/// 여기서는 **왜 실패했는지**만 전한다 — 사유마다 사용자가 할 수 있는 일이 다르다.
void showAttachFailureIfAny(BuildContext context, WidgetRef ref) {
  final error = ref.read(mediaUploadProvider).firstError;
  if (error == null) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(_messageFor(context, error)),
      backgroundColor: AppColors.error,
    ),
  );
}

/// 업로드 실패 사유를 번역된 문구로 바꾼다
///
/// 예외 문자열을 그대로 띄우지 않는다 — 레포지토리가 만든 한국어 문장이라
/// 다른 언어 사용자에게 그대로 노출된다.
String _messageFor(BuildContext context, Object error) {
  final l10n = AppLocalizations.of(context)!;

  return switch (error) {
    QuotaExceededException() => l10n.diary_quota_exceeded_title,
    FileTooLargeException() => l10n.diary_file_too_large,
    MediaNotAllowedException() => l10n.diary_video_not_allowed,
    UnsupportedMediaException() => l10n.diary_unsupported_format,
    VideoTooLongException(:final maxDurationMs) when maxDurationMs != null =>
      l10n.diary_video_too_long((maxDurationMs / 1000).round()),
    VideoTooLongException() => l10n.diary_upload_failed,
    _ => l10n.diary_upload_failed,
  };
}

/// 형식을 바꾸지 못해 뺀 파일을 알린다
void _showRejected(BuildContext context, List<String> fileNames) {
  final l10n = AppLocalizations.of(context)!;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        l10n.diary_media_skipped(fileNames.length, fileNames.first),
      ),
      backgroundColor: AppColors.warning,
    ),
  );
}

enum _MediaSource { gallery, camera }

Future<_MediaSource?> _askSource(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return showModalBottomSheet<_MediaSource>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(l10n.diary_pick_gallery),
            onTap: () => Navigator.pop(context, _MediaSource.gallery),
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text(l10n.diary_pick_camera),
            onTap: () => Navigator.pop(context, _MediaSource.camera),
          ),
        ],
      ),
    ),
  );
}
