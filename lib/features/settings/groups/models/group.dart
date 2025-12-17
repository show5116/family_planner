import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:flutter/rendering.dart';

/// 그룹 모델
class Group {
  final String id;
  final String name;
  final String? description;
  final String inviteCode;
  final String? defaultColor;
  final String? myColor; // 현재 사용자의 개인 색상 (customColor)
  final Role? myRole; // 현재 사용자의 역할 및 권한
  final DateTime createdAt;
  final DateTime updatedAt;

  Group({
    required this.id,
    required this.name,
    this.description,
    required this.inviteCode,
    this.defaultColor,
    this.myColor,
    this.myRole,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    debugPrint('[Group.fromJson] Parsing JSON: $json');
    debugPrint('[Group.fromJson] myRole field: ${json['myRole']}');
    debugPrint('[Group.fromJson] myRole type: ${json['myRole'].runtimeType}');

    final parsedMyRole = json['myRole'] != null
        ? Role.fromJson(json['myRole'] as Map<String, dynamic>)
        : null;

    debugPrint('[Group.fromJson] Parsed myRole: $parsedMyRole');
    debugPrint('[Group.fromJson] Parsed myRole.permissions: ${parsedMyRole?.permissions}');

    return Group(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      inviteCode: json['inviteCode'] as String,
      defaultColor: json['defaultColor'] as String?,
      myColor: json['myColor'] as String?,
      myRole: parsedMyRole,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'inviteCode': inviteCode,
      'defaultColor': defaultColor,
      'myColor': myColor,
      'myRole': myRole?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Group copyWith({
    String? id,
    String? name,
    String? description,
    String? inviteCode,
    String? defaultColor,
    String? myColor,
    Role? myRole,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      inviteCode: inviteCode ?? this.inviteCode,
      defaultColor: defaultColor ?? this.defaultColor,
      myColor: myColor ?? this.myColor,
      myRole: myRole ?? this.myRole,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 현재 사용자가 특정 권한을 가지고 있는지 확인
  bool hasPermission(String permission) {
    debugPrint(myRole.toString());
    debugPrint(myRole?.permissions.toString());
    return myRole?.hasPermission(permission) ?? false;
  }
}
