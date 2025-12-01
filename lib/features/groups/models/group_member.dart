/// 그룹 멤버 모델
class GroupMember {
  final String id;
  final String groupId;
  final String userId;
  final String roleId;
  final String? customColor;
  final DateTime joinedAt;
  final User? user; // 사용자 정보 (조인된 경우)
  final Role? role; // 역할 정보 (조인된 경우)

  GroupMember({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.roleId,
    this.customColor,
    required this.joinedAt,
    this.user,
    this.role,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      id: json['id'] as String? ?? '',
      groupId: json['groupId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      roleId: json['roleId'] as String? ?? '',
      customColor: json['customColor'] as String?,
      joinedAt: json['joinedAt'] != null
          ? DateTime.parse(json['joinedAt'] as String)
          : DateTime.now(),
      user: json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null,
      role: json['role'] != null ? Role.fromJson(json['role'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'userId': userId,
      'roleId': roleId,
      'customColor': customColor,
      'joinedAt': joinedAt.toIso8601String(),
      'user': user?.toJson(),
      'role': role?.toJson(),
    };
  }

  /// 표시할 색상 (customColor가 있으면 customColor, 없으면 그룹 defaultColor)
  String? getDisplayColor(String? groupDefaultColor) {
    return customColor ?? groupDefaultColor;
  }
}

/// 사용자 정보 (간단 버전)
class User {
  final String id;
  final String email;
  final String name;
  final String? profileImage;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImage': profileImage,
    };
  }
}

/// 역할 정보
class Role {
  final String id;
  final String name;
  final String? groupId;
  final bool isDefaultRole;

  Role({
    required this.id,
    required this.name,
    this.groupId,
    required this.isDefaultRole,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'MEMBER',
      groupId: json['groupId'] as String?,
      isDefaultRole: json['isDefaultRole'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'groupId': groupId,
      'isDefaultRole': isDefaultRole,
    };
  }
}
