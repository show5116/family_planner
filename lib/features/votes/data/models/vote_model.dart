/// 투표 상태 필터
enum VoteStatusFilter { all, ongoing, closed }

String voteStatusFilterToString(VoteStatusFilter filter) {
  switch (filter) {
    case VoteStatusFilter.all:
      return 'ALL';
    case VoteStatusFilter.ongoing:
      return 'ONGOING';
    case VoteStatusFilter.closed:
      return 'CLOSED';
  }
}

/// 투표 선택지
class VoteOptionModel {
  final String id;
  final String label;
  final int count;
  final bool isSelected;
  final List<String> voters;

  const VoteOptionModel({
    required this.id,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.voters,
  });

  factory VoteOptionModel.fromJson(Map<String, dynamic> json) {
    return VoteOptionModel(
      id: json['id'] as String,
      label: json['label'] as String,
      count: json['count'] as int,
      isSelected: json['isSelected'] as bool,
      voters: (json['voters'] as List).cast<String>(),
    );
  }

  VoteOptionModel copyWith({
    int? count,
    bool? isSelected,
    List<String>? voters,
  }) {
    return VoteOptionModel(
      id: id,
      label: label,
      count: count ?? this.count,
      isSelected: isSelected ?? this.isSelected,
      voters: voters ?? this.voters,
    );
  }
}

/// 투표 모델
class VoteModel {
  final String id;
  final String groupId;
  final String title;
  final String? description;
  final bool isMultiple;
  final bool isAnonymous;
  final DateTime? endsAt;
  final bool isOngoing;
  final int totalVoters;
  final bool hasVoted;
  final String creatorName;
  final DateTime createdAt;
  final List<VoteOptionModel> options;

  const VoteModel({
    required this.id,
    required this.groupId,
    required this.title,
    this.description,
    required this.isMultiple,
    required this.isAnonymous,
    this.endsAt,
    required this.isOngoing,
    required this.totalVoters,
    required this.hasVoted,
    required this.creatorName,
    required this.createdAt,
    required this.options,
  });

  factory VoteModel.fromJson(Map<String, dynamic> json) {
    return VoteModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isMultiple: json['isMultiple'] as bool,
      isAnonymous: json['isAnonymous'] as bool,
      endsAt: json['endsAt'] != null
          ? DateTime.parse(json['endsAt'] as String)
          : null,
      isOngoing: json['isOngoing'] as bool,
      totalVoters: json['totalVoters'] as int,
      hasVoted: json['hasVoted'] as bool,
      creatorName: json['creatorName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      options: (json['options'] as List)
          .map((e) => VoteOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  VoteModel copyWith({
    bool? isOngoing,
    int? totalVoters,
    bool? hasVoted,
    List<VoteOptionModel>? options,
  }) {
    return VoteModel(
      id: id,
      groupId: groupId,
      title: title,
      description: description,
      isMultiple: isMultiple,
      isAnonymous: isAnonymous,
      endsAt: endsAt,
      isOngoing: isOngoing ?? this.isOngoing,
      totalVoters: totalVoters ?? this.totalVoters,
      hasVoted: hasVoted ?? this.hasVoted,
      creatorName: creatorName,
      createdAt: createdAt,
      options: options ?? this.options,
    );
  }
}

/// 투표 목록 응답
class VoteListResponse {
  final List<VoteModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const VoteListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory VoteListResponse.fromJson(Map<String, dynamic> json) {
    return VoteListResponse(
      items: (json['items'] as List)
          .map((e) => VoteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}
