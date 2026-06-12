import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:family_planner/features/settings/groups/models/group_report.dart';
import 'package:family_planner/features/settings/groups/providers/admin_report_provider.dart';

/// 어드민 전용 신고 목록 화면
class AdminReportListScreen extends ConsumerStatefulWidget {
  const AdminReportListScreen({super.key});

  @override
  ConsumerState<AdminReportListScreen> createState() => _AdminReportListScreenState();
}

class _AdminReportListScreenState extends ConsumerState<AdminReportListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // null = 전체
  static const List<ReportStatus?> _tabs = [null, ...ReportStatus.values];

  static String _tabLabel(ReportStatus? status) {
    return status == null ? '전체' : status.label;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('신고 관리'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: _tabs.map((s) => Tab(text: _tabLabel(s))).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((status) => _ReportTab(status: status)).toList(),
      ),
    );
  }
}

class _ReportTab extends ConsumerWidget {
  final ReportStatus? status;

  const _ReportTab({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(adminReportsProvider(status));

    return reportsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('오류가 발생했습니다: $e')),
      data: (reports) {
        if (reports.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.flag_outlined, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text('신고 내역이 없습니다', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => ref.refresh(adminReportsProvider(status).future),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (_, index) => _AdminReportCard(report: reports[index]),
          ),
        );
      },
    );
  }
}

class _AdminReportCard extends ConsumerWidget {
  final AdminGroupReport report;

  const _AdminReportCard({required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(report.status);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showProcessDialog(context, ref),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      report.groupName,
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ),
                  _StatusBadge(status: report.status, color: statusColor),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                report.reason.label,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${report.reporterName} → ${report.reportedName}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              if (report.detail != null && report.detail!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  report.detail!,
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '신고일: ${DateFormat('yyyy.MM.dd HH:mm').format(report.createdAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  if (report.resolvedAt != null) ...[
                    const SizedBox(width: 12),
                    Text(
                      '처리일: ${DateFormat('yyyy.MM.dd').format(report.resolvedAt!)}',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ],
              ),
              if (report.resolveNote != null && report.resolveNote!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  '처리 메모: ${report.resolveNote}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(ReportStatus status) {
    return switch (status) {
      ReportStatus.pending => Colors.orange,
      ReportStatus.reviewing => Colors.blue,
      ReportStatus.resolved => Colors.green,
      ReportStatus.dismissed => Colors.grey,
    };
  }

  Future<void> _showProcessDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _ReportProcessDialog(report: report),
    );
  }
}

/// 신고 처리 다이얼로그
class _ReportProcessDialog extends ConsumerStatefulWidget {
  final AdminGroupReport report;

  const _ReportProcessDialog({required this.report});

  @override
  ConsumerState<_ReportProcessDialog> createState() => _ReportProcessDialogState();
}

class _ReportProcessDialogState extends ConsumerState<_ReportProcessDialog> {
  late ReportStatus _selectedStatus;
  final _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.report.status;
    _noteController.text = widget.report.resolveNote ?? '';
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(adminReportNotifierProvider.notifier).updateReport(
            widget.report.id,
            status: _selectedStatus,
            resolveNote: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
          );
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('신고가 처리되었습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('처리에 실패했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('신고 처리'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 신고 정보 요약
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.report.reason.label,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.report.reporterName} → ${widget.report.reportedName}',
                    style: theme.textTheme.bodySmall,
                  ),
                  if (widget.report.detail != null) ...[
                    const SizedBox(height: 4),
                    Text(widget.report.detail!, style: theme.textTheme.bodySmall),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('처리 상태', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            RadioGroup<ReportStatus>(
              groupValue: _selectedStatus,
              onChanged: (v) {
                if (v != null) setState(() => _selectedStatus = v);
              },
              child: Column(
                children: ReportStatus.values
                    .map(
                      (s) => RadioListTile<ReportStatus>(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(s.label),
                        value: s,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            Text('처리 메모 (선택)', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 3,
              maxLength: 300,
              decoration: const InputDecoration(
                hintText: '처리 내용을 입력하세요',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('처리 완료'),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ReportStatus status;
  final Color color;

  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Text(
        status.label,
        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
