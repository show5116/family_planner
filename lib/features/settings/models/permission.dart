/// 권한 모델
/// Permission은 Role에 할당할 수 있는 권한의 종류(상수)를 정의합니다.
/// 예: GROUP_UPDATE, MEMBER_INVITE, SCHEDULE_CREATE 등
class Permission {
  final String id;
  final String code;
  final String name;
  final String? description;
  final String category;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Permission({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.category,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'category': category,
      'isActive': isActive,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  Permission copyWith({
    String? id,
    String? code,
    String? name,
    String? description,
    String? category,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Permission(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
