import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/groups/models/join_request.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/utils/group_utils.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 내 그룹 가입 신청 목록 화면
class MyJoinRequestsScreen extends ConsumerStatefulWidget {
  const MyJoinRequestsScreen({super.key});

  @override
  ConsumerState<MyJoinRequestsScreen> createState() => _MyJoinRequestsScreenState();
}

class _MyJoinRequestsScreenState extends ConsumerState<MyJoinRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.group_myJoinRequests),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(myJoinRequestsProvider),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: l10n.group_joinRequestStatusAll),
            Tab(text: l10n.group_joinRequestStatusPending),
            Tab(text: l10n.group_joinRequestStatusDone),
          ],
        ),
      ),
      body: ref.watch(myJoinRequestsProvider).when(
        data: (requests) => TabBarView(
          controller: _tabController,
          children: [
            _RequestList(requests: requests),
            _RequestList(requests: requests.where((r) => r.isPending).toList()),
            _RequestList(
              requests: requests.where((r) => r.isAccepted || r.isRejected).toList(),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorState(
          error: error,
          title: l10n.error_unknown,
          onRetry: () => ref.invalidate(myJoinRequestsProvider),
        ),
      ),
    );
  }
}

class _RequestList extends StatelessWidget {
  final List<MyJoinRequest> requests;

  const _RequestList({required this.requests});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (requests.isEmpty) {
      return AppEmptyState(
        icon: Icons.inbox_outlined,
        message: l10n.group_noJoinRequests,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      itemCount: requests.length,
      itemBuilder: (context, index) => _MyJoinRequestCard(request: requests[index]),
    );
  }
}

class _MyJoinRequestCard extends StatelessWidget {
  final MyJoinRequest request;

  const _MyJoinRequestCard({required this.request});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final (statusLabel, statusColor, statusBg) = switch (request.status) {
      'PENDING' => (l10n.group_pending, Colors.orange[700]!, Colors.orange[50]!),
      'ACCEPTED' => (l10n.group_joinRequestAccepted, Colors.green[700]!, Colors.green[50]!),
      _ => (l10n.group_joinRequestRejected, Colors.red[700]!, Colors.red[50]!),
    };

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: statusBg,
              child: Icon(
                request.isPending
                    ? Icons.hourglass_empty
                    : request.isAccepted
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                color: statusColor,
              ),
            ),
            const SizedBox(width: AppSizes.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.group.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.group_requestedAt}: ${GroupUtils.formatDate(request.createdAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceS,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                statusLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
