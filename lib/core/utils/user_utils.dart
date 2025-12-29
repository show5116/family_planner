import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';

/// 사용자가 ADMIN 역할인지 확인하는 Provider
///
/// 사용 예시:
/// ```dart
/// final isAdmin = ref.watch(isAdminProvider);
/// if (isAdmin) {
///   // 관리자 전용 UI 표시
/// }
/// ```
final isAdminProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  final user = authState.user;

  if (user == null) return false;

  // 사용자의 isAdmin 속성 확인
  final isAdmin = user['isAdmin'];
  return isAdmin == true;
});

/// 현재 로그인한 사용자가 관리자인지 확인하는 헬퍼 함수
///
/// 사용 예시:
/// ```dart
/// final user = authState.user;
/// if (isUserAdmin(user)) {
///   // 관리자 전용 로직
/// }
/// ```
bool isUserAdmin(Map<String, dynamic>? user) {
  if (user == null) return false;
  final isAdmin = user['isAdmin'];
  return isAdmin == true;
}
