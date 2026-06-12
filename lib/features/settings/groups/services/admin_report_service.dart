import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/settings/groups/models/group_report.dart';

/// 어드민 신고 관리 서비스
class AdminReportService {
  final ApiClient _apiClient;

  AdminReportService(this._apiClient);

  /// 신고 목록 조회
  /// GET /groups/admin/reports?status=
  Future<List<AdminGroupReport>> getReports({ReportStatus? status}) async {
    try {
      final response = await _apiClient.get(
        '/groups/admin/reports',
        queryParameters: status != null ? {'status': status.toApiString()} : null,
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => AdminGroupReport.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// 신고 처리 (상태 변경)
  /// PATCH /groups/admin/reports/:reportId
  Future<AdminGroupReport> updateReport(
    String reportId, {
    required ReportStatus status,
    String? resolveNote,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/groups/admin/reports/$reportId',
        data: {
          'status': status.toApiString(),
          if (resolveNote != null && resolveNote.isNotEmpty) 'resolveNote': resolveNote,
        },
      );
      return AdminGroupReport.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
