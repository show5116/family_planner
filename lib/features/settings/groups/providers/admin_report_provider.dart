import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/settings/groups/models/group_report.dart';
import 'package:family_planner/features/settings/groups/services/admin_report_service.dart';

final adminReportServiceProvider = Provider<AdminReportService>((ref) {
  return AdminReportService(ApiClient.instance);
});

/// 어드민 신고 목록 Provider (status 필터)
final adminReportsProvider = FutureProvider.family<List<AdminGroupReport>, ReportStatus?>(
  (ref, status) async {
    final service = ref.watch(adminReportServiceProvider);
    return await service.getReports(status: status);
  },
);

/// 어드민 신고 처리 Notifier
class AdminReportNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminReportService _service;
  final Ref _ref;

  AdminReportNotifier(this._service, this._ref) : super(const AsyncValue.data(null));

  Future<AdminGroupReport> updateReport(
    String reportId, {
    required ReportStatus status,
    String? resolveNote,
  }) async {
    try {
      final updated = await _service.updateReport(
        reportId,
        status: status,
        resolveNote: resolveNote,
      );
      // 모든 필터 캐시 무효화
      for (final s in [null, ...ReportStatus.values]) {
        _ref.invalidate(adminReportsProvider(s));
      }
      return updated;
    } catch (e) {
      rethrow;
    }
  }
}

final adminReportNotifierProvider =
    StateNotifierProvider<AdminReportNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(adminReportServiceProvider);
  return AdminReportNotifier(service, ref);
});
