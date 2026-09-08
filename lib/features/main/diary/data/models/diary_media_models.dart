/// 다이어리 미디어 · 용량 한도 모델
///
/// 서버 API는 `docs/api/diaries.md`(Phase 2) 참고.
library;

/// 미디어 종류
enum MediaType {
  image,
  video;

  static MediaType fromJson(String? value) =>
      value == 'VIDEO' ? MediaType.video : MediaType.image;

  String toJson() => this == MediaType.video ? 'VIDEO' : 'IMAGE';

  bool get isVideo => this == MediaType.video;
}

/// 일기에 첨부된 미디어
class DiaryMedia {
  final String id;
  final MediaType type;
  final String url;
  final String? thumbnailUrl;
  final int? width;
  final int? height;
  final int? durationMs;
  final int sortOrder;

  const DiaryMedia({
    required this.id,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.durationMs,
    this.sortOrder = 0,
  });

  /// 썸네일이 없으면 원본을 쓴다 (이미지는 대개 원본으로도 충분하다)
  String get displayThumbnail => thumbnailUrl ?? url;

  /// 가로세로 비율 (모르면 1:1로 둔다 — 그리드가 무너지지 않도록)
  double get aspectRatio {
    if (width == null || height == null || height == 0) return 1;
    return width! / height!;
  }

  factory DiaryMedia.fromJson(Map<String, dynamic> json) {
    return DiaryMedia(
      id: json['id'] as String,
      type: MediaType.fromJson(json['type'] as String?),
      url: json['url'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      durationMs: json['durationMs'] as int?,
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }
}

/// 한 종류의 한도 (월간 또는 누적)
class QuotaBucket {
  final int usedBytes;
  final int limitBytes;
  final int remainingBytes;

  /// 월간 한도에만 있다 (다음 리셋 시각)
  final DateTime? resetsAt;

  const QuotaBucket({
    required this.usedBytes,
    required this.limitBytes,
    required this.remainingBytes,
    this.resetsAt,
  });

  /// 사용률 0.0 ~ 1.0 (게이지 표시용)
  double get ratio {
    if (limitBytes <= 0) return 0;
    return (usedBytes / limitBytes).clamp(0.0, 1.0);
  }

  /// 잔여가 10% 미만인지 — 게이지 색을 바꾸는 기준
  bool get isRunningLow => ratio >= 0.9;

  bool get isExhausted => remainingBytes <= 0;

  factory QuotaBucket.fromJson(Map<String, dynamic> json) {
    return QuotaBucket(
      usedBytes: json['usedBytes'] as int? ?? 0,
      limitBytes: json['limitBytes'] as int? ?? 0,
      remainingBytes: json['remainingBytes'] as int? ?? 0,
      resetsAt: json['resetsAt'] != null
          ? DateTime.tryParse(json['resetsAt'] as String)?.toLocal()
          : null,
    );
  }

  static const zero = QuotaBucket(
    usedBytes: 0,
    limitBytes: 0,
    remainingBytes: 0,
  );
}

/// 현재 사용자의 미디어 한도 상태
class MediaQuota {
  final String tier;
  final QuotaBucket monthly;
  final QuotaBucket total;
  final int perFileLimitBytes;
  final bool videoAllowed;
  final int? maxVideoDurationMs;

  const MediaQuota({
    required this.tier,
    required this.monthly,
    required this.total,
    required this.perFileLimitBytes,
    this.videoAllowed = false,
    this.maxVideoDurationMs,
  });

  /// 이 크기의 파일을 올릴 수 있는지 (클라이언트 사전 확인용)
  ///
  /// 최종 판단은 서버가 한다. 여기서는 시트에서 "올리기"를 막고 사유를
  /// 미리 알려주기 위해서만 쓴다.
  bool canUpload(int bytes) =>
      bytes <= perFileLimitBytes &&
      bytes <= monthly.remainingBytes &&
      bytes <= total.remainingBytes;

  /// 업로드가 불가능한 사유 (가능하면 null)
  QuotaRejection? rejectionFor(int bytes, {bool isVideo = false}) {
    if (isVideo && !videoAllowed) return QuotaRejection.videoNotAllowed;
    if (bytes > perFileLimitBytes) return QuotaRejection.fileTooLarge;
    if (bytes > monthly.remainingBytes) return QuotaRejection.monthlyExhausted;
    if (bytes > total.remainingBytes) return QuotaRejection.totalExhausted;
    return null;
  }

  factory MediaQuota.fromJson(Map<String, dynamic> json) {
    return MediaQuota(
      tier: json['tier'] as String? ?? 'free',
      monthly: json['monthly'] != null
          ? QuotaBucket.fromJson(json['monthly'] as Map<String, dynamic>)
          : QuotaBucket.zero,
      total: json['total'] != null
          ? QuotaBucket.fromJson(json['total'] as Map<String, dynamic>)
          : QuotaBucket.zero,
      perFileLimitBytes: json['perFileLimitBytes'] as int? ?? 0,
      videoAllowed: json['videoAllowed'] as bool? ?? false,
      maxVideoDurationMs: json['maxVideoDurationMs'] as int?,
    );
  }
}

/// 업로드 거부 사유
///
/// 각 사유마다 사용자에게 제시할 대안이 다르다 — 결제만 있는 막다른 안내를
/// 만들지 않기 위해 사유를 구분한다.
enum QuotaRejection {
  /// 파일 1개 최대 크기 초과 → 압축을 권한다
  fileTooLarge,

  /// 이번 달 용량 소진 → 다음 달 리셋 안내 + 업그레이드
  monthlyExhausted,

  /// 계정 저장 공간 부족 → 저장공간 관리로 정리 유도
  totalExhausted,

  /// 영상 불가 등급 → 업그레이드
  videoNotAllowed,
}

/// 저장공간 관리 화면의 큰 파일 항목
class LargeMediaItem {
  final String id;
  final String diaryId;
  final String date;
  final MediaType type;
  final String fileName;
  final int fileSize;
  final int? originalSize;
  final bool isOriginal;
  final String? thumbnailUrl;
  final DateTime? uploadedAt;

  const LargeMediaItem({
    required this.id,
    required this.diaryId,
    required this.date,
    required this.type,
    required this.fileName,
    required this.fileSize,
    this.originalSize,
    this.isOriginal = false,
    this.thumbnailUrl,
    this.uploadedAt,
  });

  factory LargeMediaItem.fromJson(Map<String, dynamic> json) {
    return LargeMediaItem(
      id: json['id'] as String,
      diaryId: json['diaryId'] as String? ?? '',
      date: json['date'] as String? ?? '',
      type: MediaType.fromJson(json['type'] as String?),
      fileName: json['fileName'] as String? ?? '',
      fileSize: json['fileSize'] as int? ?? 0,
      originalSize: json['originalSize'] as int?,
      isOriginal: json['isOriginal'] as bool? ?? false,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.tryParse(json['uploadedAt'] as String)?.toLocal()
          : null,
    );
  }
}

/// 업로드 예약 결과 (reserve 응답)
class MediaReservation {
  final String mediaId;
  final String uploadUrl;
  final String storageKey;

  /// presigned URL 유효 시간 (초)
  final int expiresIn;

  const MediaReservation({
    required this.mediaId,
    required this.uploadUrl,
    required this.storageKey,
    this.expiresIn = 600,
  });

  factory MediaReservation.fromJson(Map<String, dynamic> json) {
    return MediaReservation(
      mediaId: json['mediaId'] as String,
      uploadUrl: json['uploadUrl'] as String,
      storageKey: json['storageKey'] as String? ?? '',
      expiresIn: json['expiresIn'] as int? ?? 600,
    );
  }
}

/// 업로드 예약 요청
class ReserveMediaDto {
  final String? diaryId;
  final String? date;
  final MediaType type;
  final String fileName;
  final String mimeType;
  final int declaredSize;
  final bool isOriginal;
  final int? width;
  final int? height;
  final int? durationMs;

  const ReserveMediaDto({
    this.diaryId,
    this.date,
    required this.type,
    required this.fileName,
    required this.mimeType,
    required this.declaredSize,
    this.isOriginal = false,
    this.width,
    this.height,
    this.durationMs,
  });

  Map<String, dynamic> toJson() => {
        if (diaryId != null) 'diaryId': diaryId,
        if (date != null) 'date': date,
        'type': type.toJson(),
        'fileName': fileName,
        'mimeType': mimeType,
        'declaredSize': declaredSize,
        'isOriginal': isOriginal,
        if (width != null) 'width': width,
        if (height != null) 'height': height,
        if (durationMs != null) 'durationMs': durationMs,
      };
}

/// confirm 응답 — 확정된 미디어와 갱신된 한도
class MediaConfirmResult {
  final DiaryMedia media;
  final MediaQuota? quota;

  const MediaConfirmResult({required this.media, this.quota});

  factory MediaConfirmResult.fromJson(Map<String, dynamic> json) {
    // 서버가 media를 중첩해 주는 경우와 평평하게 주는 경우 둘 다 받는다
    final mediaJson = json['media'] as Map<String, dynamic>? ?? json;
    return MediaConfirmResult(
      media: DiaryMedia.fromJson(mediaJson),
      quota: json['quota'] != null
          ? MediaQuota.fromJson(json['quota'] as Map<String, dynamic>)
          : null,
    );
  }
}
