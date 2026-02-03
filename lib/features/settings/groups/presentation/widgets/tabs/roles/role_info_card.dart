import 'package:flutter/material.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/common_widgets.dart';

/// 역할 정보 카드
class RoleInfoCard extends StatelessWidget {
  final bool isOwner;

  const RoleInfoCard({
    super.key,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: '안내',
      message: '',
      bulletPoints: [
        '공통 역할 (OWNER, ADMIN, MEMBER)은 모든 그룹에 기본으로 제공됩니다.',
        '커스텀 역할은 그룹 OWNER만 생성, 수정, 삭제할 수 있습니다.',
        if (!isOwner) '역할을 관리하려면 그룹 OWNER 권한이 필요합니다.',
      ],
      backgroundColor: Colors.blue[50],
      iconColor: Colors.blue[700],
      textColor: isOwner ? Colors.blue[900] : Colors.orange[900],
    );
  }
}
