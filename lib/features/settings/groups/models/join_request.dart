/// 내 그룹 가입 신청 목록 모델 (GET /groups/my-join-requests)
class MyJoinRequest {
  final String id;
  final MyJoinRequestGroup group;
  final String status; // 'PENDING', 'ACCEPTED', 'REJECTED'
  final DateTime createdAt;
  final DateTime updatedAt;

  MyJoinRequest({
    required this.id,
    required this.group,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MyJoinRequest.fromJson(Map<String, dynamic> json) {
    return MyJoinRequest(
      id: json['id'] as String,
      group: MyJoinRequestGroup.fromJson(json['group'] as Map<String, dynamic>),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }

  bool get isPending => status == 'PENDING';
  bool get isAccepted => status == 'ACCEPTED';
  bool get isRejected => status == 'REJECTED';
}

class MyJoinRequestGroup {
  final String id;
  final String name;

  MyJoinRequestGroup({required this.id, required this.name});

  factory MyJoinRequestGroup.fromJson(Map<String, dynamic> json) {
    return MyJoinRequestGroup(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

/// 그룹 가입 요청 모델
class JoinRequest {
  final String id;
  final String groupId;
  final String type; // 'INVITE' 또는 'REQUEST'
  final String email;
  final String status; // 'PENDING', 'ACCEPTED', 'REJECTED'
  final DateTime createdAt;
  final DateTime updatedAt;

  JoinRequest({
    required this.id,
    required this.groupId,
    required this.type,
    required this.email,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JoinRequest.fromJson(Map<String, dynamic> json) {
    return JoinRequest(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      type: json['type'] as String,
      email: json['email'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'type': type,
      'email': email,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  JoinRequest copyWith({
    String? id,
    String? groupId,
    String? type,
    String? email,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JoinRequest(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      type: type ?? this.type,
      email: email ?? this.email,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isPending => status == 'PENDING';
  bool get isAccepted => status == 'ACCEPTED';
  bool get isRejected => status == 'REJECTED';
}
