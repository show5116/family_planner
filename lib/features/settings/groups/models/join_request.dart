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
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
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
