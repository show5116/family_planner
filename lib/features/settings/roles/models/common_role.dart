/// 공통 역할 모델 (groupId = null)
/// 운영자가 관리하는 전역 역할
class CommonRole {
  final String id;
  final String name;
  final String? description;
  final bool isDefaultRole;
  final List<String> permissions; // 권한 코드 문자열 배열 (예: ["group:read", "group:update"])
  final DateTime createdAt;
  final DateTime updatedAt;

  CommonRole({
    required this.id,
    required this.name,
    this.description,
    required this.isDefaultRole,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommonRole.fromJson(Map<String, dynamic> json) {
    return CommonRole(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isDefaultRole: json['isDefaultRole'] as bool? ?? false,
      permissions: json['permissions'] != null
          ? (json['permissions'] as List<dynamic>)
              .map((p) => p as String)
              .toList()
          : [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isDefaultRole': isDefaultRole,
      'permissions': permissions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  CommonRole copyWith({
    String? id,
    String? name,
    String? description,
    bool? isDefaultRole,
    List<String>? permissions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommonRole(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isDefaultRole: isDefaultRole ?? this.isDefaultRole,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 권한 코드 목록 반환 (permissions와 동일)
  List<String> get permissionCodes => permissions;
}
