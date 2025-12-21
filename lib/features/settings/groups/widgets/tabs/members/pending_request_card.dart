import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/join_request.dart';
import 'package:family_planner/features/settings/groups/utils/group_utils.dart';

/// 대기 중인 가입 요청 카드 위젯
class PendingRequestCard extends StatelessWidget {
  final JoinRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback? onCancel;
  final VoidCallback? onResend;

  const PendingRequestCard({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onReject,
    this.onCancel,
    this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isInvite = request.type == 'INVITE';

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isInvite ? Colors.blue[100] : Colors.grey[200],
                  child: Icon(
                    isInvite ? Icons.email_outlined : Icons.person_add,
                    color: isInvite ? Colors.blue[700] : Colors.grey[700],
                  ),
                ),
                const SizedBox(width: AppSizes.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              request.email,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.spaceS,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isInvite ? Colors.blue[50] : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isInvite ? Colors.blue[200]! : Colors.grey[300]!,
                              ),
                            ),
                            child: Text(
                              isInvite ? '초대됨' : '가입 요청',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isInvite ? Colors.blue[700] : Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isInvite
                            ? '${l10n.group_invitedAt}: ${GroupUtils.formatDate(request.createdAt)}'
                            : '${l10n.group_requestedAt}: ${GroupUtils.formatDate(request.createdAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceM),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 초대됨(INVITE)인 경우: 초대 취소 및 재전송 버튼
                if (isInvite) ...[
                  if (onCancel != null)
                    TextButton(
                      onPressed: onCancel,
                      child: const Text('초대 취소'),
                    ),
                  if (onResend != null) ...[
                    const SizedBox(width: AppSizes.spaceS),
                    ElevatedButton.icon(
                      onPressed: onResend,
                      icon: const Icon(Icons.email_outlined, size: 18),
                      label: const Text('재전송'),
                    ),
                  ],
                ]
                // 일반 가입 요청(REQUEST)인 경우: 승인/거부 버튼
                else ...[
                  TextButton(
                    onPressed: onReject,
                    child: Text(l10n.group_reject),
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  ElevatedButton(
                    onPressed: onAccept,
                    child: Text(l10n.group_accept),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
