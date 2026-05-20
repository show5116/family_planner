import 'package:flutter/material.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/common_widgets.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 역할 정보 카드
class RoleInfoCard extends StatelessWidget {
  final bool isOwner;

  const RoleInfoCard({
    super.key,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InfoCard(
      title: l10n.group_roleInfoTitle,
      message: '',
      bulletPoints: [
        l10n.group_roleInfoBullet1,
        l10n.group_roleInfoBullet2,
        if (!isOwner) l10n.group_roleInfoBullet3,
      ],
      backgroundColor: Colors.blue[50],
      iconColor: Colors.blue[700],
      textColor: isOwner ? Colors.blue[900] : Colors.orange[900],
    );
  }
}
