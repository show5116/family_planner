/// 미니게임 타입
enum MinigameType {
  ladder,
  roulette,
}

MinigameType minigameTypeFromString(String value) {
  switch (value.toUpperCase()) {
    case 'LADDER':
      return MinigameType.ladder;
    case 'ROULETTE':
      return MinigameType.roulette;
    default:
      return MinigameType.ladder;
  }
}

String minigameTypeToString(MinigameType type) {
  switch (type) {
    case MinigameType.ladder:
      return 'LADDER';
    case MinigameType.roulette:
      return 'ROULETTE';
  }
}

/// 사다리타기 결과 항목
class LadderAssignment {
  final String participant;
  final String option;

  const LadderAssignment({required this.participant, required this.option});

  factory LadderAssignment.fromJson(Map<String, dynamic> json) {
    return LadderAssignment(
      participant: json['participant'] as String,
      option: json['option'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'participant': participant,
        'option': option,
      };
}

/// 미니게임 결과 모델
class MinigameResult {
  final String id;
  final String groupId;
  final MinigameType gameType;
  final String title;
  final List<String> participants;
  final List<String> options;
  final Map<String, dynamic> result;
  final String createdBy;
  final DateTime createdAt;

  const MinigameResult({
    required this.id,
    required this.groupId,
    required this.gameType,
    required this.title,
    required this.participants,
    required this.options,
    required this.result,
    required this.createdBy,
    required this.createdAt,
  });

  factory MinigameResult.fromJson(Map<String, dynamic> json) {
    return MinigameResult(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      gameType: minigameTypeFromString(json['gameType'] as String),
      title: json['title'] as String,
      participants: (json['participants'] as List).cast<String>(),
      options: (json['options'] as List).cast<String>(),
      result: json['result'] as Map<String, dynamic>,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// LADDER 결과: assignments 목록
  List<LadderAssignment> get ladderAssignments {
    final assignments = result['assignments'] as List?;
    if (assignments == null) return [];
    return assignments
        .map((e) => LadderAssignment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// ROULETTE 결과: 당첨 항목
  String? get rouletteWinner => result['winner'] as String?;
}

/// 게임 이력 목록 응답
class MinigameResultsResponse {
  final List<MinigameResult> items;
  final int total;
  final bool hasMore;

  const MinigameResultsResponse({
    required this.items,
    required this.total,
    required this.hasMore,
  });

  factory MinigameResultsResponse.fromJson(Map<String, dynamic> json) {
    return MinigameResultsResponse(
      items: (json['items'] as List)
          .map((e) => MinigameResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      hasMore: json['hasMore'] as bool,
    );
  }
}
