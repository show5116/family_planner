import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/main/diary/data/models/diary_models.dart';
import 'package:family_planner/features/main/diary/data/repositories/diary_repository.dart';
import 'package:family_planner/features/main/diary/data/utils/diary_date.dart';
import 'package:family_planner/features/main/diary/providers/diary_provider.dart';

/// 빠른 기록 상태
///
/// [failedText]는 전송에 실패한 입력이다. 조용히 날리지 않고 되돌려주기 위해
/// 보관한다 — 화면에서 입력창을 복원하고 재시도 버튼을 띄운다.
class QuickCaptureState {
  final bool isSending;
  final String? failedText;
  final String? errorMessage;

  const QuickCaptureState({
    this.isSending = false,
    this.failedText,
    this.errorMessage,
  });

  bool get hasFailure => failedText != null;

  QuickCaptureState copyWith({
    bool? isSending,
    String? failedText,
    String? errorMessage,
    bool clearFailure = false,
  }) {
    return QuickCaptureState(
      isSending: isSending ?? this.isSending,
      failedText: clearFailure ? null : (failedText ?? this.failedText),
      errorMessage: clearFailure ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final quickCaptureProvider =
    NotifierProvider<QuickCaptureNotifier, QuickCaptureState>(
        QuickCaptureNotifier.new);

class QuickCaptureNotifier extends Notifier<QuickCaptureState> {
  @override
  QuickCaptureState build() => const QuickCaptureState();

  /// 조각을 그날 일기에 던진다
  ///
  /// 성공하면 true. 실패하면 입력을 [QuickCaptureState.failedText]에 담아두고
  /// false를 반환한다 (화면이 입력창을 복원할 수 있도록).
  ///
  /// [date]를 주지 않으면 기기 로컬 기준 "오늘"(새벽 4시 경계)로 보낸다.
  Future<bool> send(
    String text, {
    String? date,
    DiaryVisibility? visibility,
    String? groupId,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return false;

    state = state.copyWith(isSending: true, clearFailure: true);

    try {
      final result = await ref.read(diaryRepositoryProvider).append(
            AppendDiaryDto(
              date: date ?? diaryToday(),
              text: trimmed,
              capturedAt: diaryCapturedAt(),
              visibility: visibility,
              groupId: groupId,
            ),
          );

      await _syncAfterAppend(result);

      state = const QuickCaptureState();
      return true;
    } catch (e) {
      state = QuickCaptureState(
        failedText: trimmed,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// 실패한 입력을 다시 보낸다
  Future<bool> retry({
    String? date,
    DiaryVisibility? visibility,
    String? groupId,
  }) async {
    final text = state.failedText;
    if (text == null) return false;
    return send(text, date: date, visibility: visibility, groupId: groupId);
  }

  /// 실패 상태를 버린다 (사용자가 입력을 직접 지웠을 때)
  void dismissFailure() {
    state = state.copyWith(clearFailure: true);
  }

  /// append 후 화면 상태를 맞춘다
  ///
  /// append 응답은 조각 정보만 주고 일기 전문을 주지 않는다. 목록 카드에 본문
  /// 미리보기를 보여줘야 하므로, 해당 날짜의 일기를 한 번 더 받아와 목록에 반영한다.
  /// 이 재조회가 실패해도 기록 자체는 성공한 것이므로 예외를 밖으로 던지지 않는다.
  Future<void> _syncAfterAppend(AppendResult result) async {
    ref.invalidate(todayDiaryProvider);
    ref.invalidate(diaryStreakProvider);
    ref.invalidate(diaryCalendarProvider);
    ref.invalidate(diaryDetailProvider(result.id));

    try {
      final diary =
          await ref.read(diaryRepositoryProvider).getDiaryByDate(result.date);
      if (diary != null) {
        ref.read(diaryListProvider.notifier).upsert(diary);
      }
    } catch (_) {
      // 목록 갱신 실패는 무시한다 — 당겨서 새로고침하면 맞춰진다
    }
  }
}
