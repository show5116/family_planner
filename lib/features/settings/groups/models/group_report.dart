/// 신고 사유
enum ReportReason {
  spam,
  abuse,
  harassment,
  inappropriateContent,
  fakeIdentity,
  etc;

  static ReportReason fromString(String value) {
    return switch (value) {
      'SPAM' => ReportReason.spam,
      'ABUSE' => ReportReason.abuse,
      'HARASSMENT' => ReportReason.harassment,
      'INAPPROPRIATE_CONTENT' => ReportReason.inappropriateContent,
      'FAKE_IDENTITY' => ReportReason.fakeIdentity,
      _ => ReportReason.etc,
    };
  }

  String toApiString() {
    return switch (this) {
      ReportReason.spam => 'SPAM',
      ReportReason.abuse => 'ABUSE',
      ReportReason.harassment => 'HARASSMENT',
      ReportReason.inappropriateContent => 'INAPPROPRIATE_CONTENT',
      ReportReason.fakeIdentity => 'FAKE_IDENTITY',
      ReportReason.etc => 'ETC',
    };
  }

  String get label {
    return switch (this) {
      ReportReason.spam => '🗑️ 스팸',
      ReportReason.abuse => '🤬 욕설/비방',
      ReportReason.harassment => '😤 괴롭힘',
      ReportReason.inappropriateContent => '🔞 부적절한 콘텐츠',
      ReportReason.fakeIdentity => '🎭 사칭',
      ReportReason.etc => '📌 기타',
    };
  }
}

/// 신고 처리 상태
enum ReportStatus {
  pending,
  reviewing,
  resolved,
  dismissed;

  static ReportStatus fromString(String value) {
    return switch (value) {
      'PENDING' => ReportStatus.pending,
      'REVIEWING' => ReportStatus.reviewing,
      'RESOLVED' => ReportStatus.resolved,
      'DISMISSED' => ReportStatus.dismissed,
      _ => ReportStatus.pending,
    };
  }

  String toApiString() {
    return switch (this) {
      ReportStatus.pending => 'PENDING',
      ReportStatus.reviewing => 'REVIEWING',
      ReportStatus.resolved => 'RESOLVED',
      ReportStatus.dismissed => 'DISMISSED',
    };
  }

  String get label {
    return switch (this) {
      ReportStatus.pending => '접수됨',
      ReportStatus.reviewing => '검토 중',
      ReportStatus.resolved => '처리 완료',
      ReportStatus.dismissed => '기각',
    };
  }
}

/// 내가 신고한 내역 모델 (일반 유저용)
class GroupReport {
  final String id;
  final String groupId;
  final String reporterId;
  final String reportedId;
  final ReportReason reason;
  final String? detail;
  final ReportStatus status;
  final DateTime createdAt;

  GroupReport({
    required this.id,
    required this.groupId,
    required this.reporterId,
    required this.reportedId,
    required this.reason,
    this.detail,
    required this.status,
    required this.createdAt,
  });

  factory GroupReport.fromJson(Map<String, dynamic> json) {
    return GroupReport(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      reporterId: json['reporterId'] as String,
      reportedId: json['reportedId'] as String,
      reason: ReportReason.fromString(json['reason'] as String),
      detail: json['detail'] as String?,
      status: ReportStatus.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    );
  }
}

/// 어드민용 신고 내역 모델 (이름 포함)
class AdminGroupReport {
  final String id;
  final String groupId;
  final String groupName;
  final String reporterName;
  final String reportedName;
  final ReportReason reason;
  final String? detail;
  final ReportStatus status;
  final String? resolveNote;
  final DateTime? resolvedAt;
  final String? resolvedByName;
  final DateTime createdAt;

  AdminGroupReport({
    required this.id,
    required this.groupId,
    required this.groupName,
    required this.reporterName,
    required this.reportedName,
    required this.reason,
    this.detail,
    required this.status,
    this.resolveNote,
    this.resolvedAt,
    this.resolvedByName,
    required this.createdAt,
  });

  factory AdminGroupReport.fromJson(Map<String, dynamic> json) {
    return AdminGroupReport(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      groupName: json['groupName'] as String,
      reporterName: json['reporterName'] as String,
      reportedName: json['reportedName'] as String,
      reason: ReportReason.fromString(json['reason'] as String),
      detail: json['detail'] as String?,
      status: ReportStatus.fromString(json['status'] as String),
      resolveNote: json['resolveNote'] as String?,
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'] as String).toLocal()
          : null,
      resolvedByName: json['resolvedByName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    );
  }

  AdminGroupReport copyWith({
    ReportStatus? status,
    String? resolveNote,
    DateTime? resolvedAt,
    String? resolvedByName,
  }) {
    return AdminGroupReport(
      id: id,
      groupId: groupId,
      groupName: groupName,
      reporterName: reporterName,
      reportedName: reportedName,
      reason: reason,
      detail: detail,
      status: status ?? this.status,
      resolveNote: resolveNote ?? this.resolveNote,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolvedByName: resolvedByName ?? this.resolvedByName,
      createdAt: createdAt,
    );
  }
}
