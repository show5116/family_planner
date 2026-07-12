import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 공유 그룹 목록 아이템 (해제 버튼 + 그룹원 현황 이동)
class RoutineShareGroupTile extends StatelessWidget {
  const RoutineShareGroupTile({
    super.key,
    required this.share,
    required this.onRemove,
    required this.onViewMembers,
  });

  final RoutineShare share;
  final VoidCallback onRemove;
  final VoidCallback onViewMembers;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: ListTile(
        leading: const Icon(Icons.group_outlined),
        title: Text(share.groupName),
        onTap: onViewMembers,
        trailing: IconButton(
          icon: const Icon(Icons.link_off),
          tooltip: l10n.routine_share_remove,
          onPressed: onRemove,
        ),
      ),
    );
  }
}
