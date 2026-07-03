import 'package:share_plus/share_plus.dart';

/// 딥링크 URL 공유 유틸리티
class ShareService {
  ShareService._();

  static const _baseUrl = 'https://familyplanner.hmncorp.org';

  /// 초대 링크 공유
  static Future<void> shareInviteLink({
    required String inviteCode,
    required String groupName,
  }) async {
    final url = '$_baseUrl/invite?code=$inviteCode';
    await Share.share('[$groupName] 가족 플래너에 초대합니다!\n$url');
  }

  /// 임의 경로 공유
  static Future<void> sharePath({
    required String path,
    String? text,
  }) async {
    final url = '$_baseUrl$path';
    await Share.share(text != null ? '$text\n$url' : url);
  }
}
