import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/main/diary/data/models/diary_media_models.dart';
import 'package:family_planner/features/main/diary/data/repositories/diary_media_repository.dart';

/// 현재 사용자의 미디어 한도
///
/// 업로드·삭제 후 반드시 invalidate해서 게이지를 맞춘다.
final mediaQuotaProvider = FutureProvider<MediaQuota>((ref) async {
  return ref.read(diaryMediaRepositoryProvider).getQuota();
});

/// 저장공간 관리 화면 — 원본 업로드만 볼지 여부
final storageOnlyOriginalProvider = StateProvider<bool>((ref) => false);

/// 용량 큰 미디어 목록
final largeMediaProvider = FutureProvider<List<LargeMediaItem>>((ref) async {
  final onlyOriginal = ref.watch(storageOnlyOriginalProvider);
  return ref
      .read(diaryMediaRepositoryProvider)
      .getLargeMedia(onlyOriginal: onlyOriginal);
});
