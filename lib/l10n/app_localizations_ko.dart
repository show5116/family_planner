// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Family Planner';

  @override
  String get appDescription => '가족과 함께하는 일상 관리 플래너';

  @override
  String get common_ok => '확인';

  @override
  String get common_cancel => '취소';

  @override
  String get common_save => '저장';

  @override
  String get common_delete => '삭제';

  @override
  String get common_edit => '수정';

  @override
  String get common_add => '추가';

  @override
  String get common_search => '검색';

  @override
  String get common_loading => '로딩 중...';

  @override
  String get common_error => '오류';

  @override
  String get common_retry => '다시 시도';

  @override
  String get common_close => '닫기';

  @override
  String get common_done => '완료';

  @override
  String get common_next => '다음';

  @override
  String get common_previous => '이전';

  @override
  String get auth_login => '로그인';

  @override
  String get auth_signup => '회원가입';

  @override
  String get auth_logout => '로그아웃';

  @override
  String get auth_email => '이메일';

  @override
  String get auth_password => '비밀번호';

  @override
  String get auth_passwordConfirm => '비밀번호 확인';

  @override
  String get auth_name => '이름';

  @override
  String get auth_forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get auth_noAccount => '계정이 없으신가요?';

  @override
  String get auth_haveAccount => '이미 계정이 있으신가요?';

  @override
  String get auth_continueWithGoogle => 'Google로 계속하기';

  @override
  String get auth_continueWithKakao => 'Kakao로 계속하기';

  @override
  String get auth_continueWithApple => 'Apple로 계속하기';

  @override
  String get auth_or => '또는';

  @override
  String get auth_emailHint => '이메일을 입력해주세요';

  @override
  String get auth_passwordHint => '비밀번호를 입력해주세요';

  @override
  String get auth_nameHint => '이름을 입력해주세요';

  @override
  String get auth_emailError => '올바른 이메일 형식이 아닙니다';

  @override
  String get auth_passwordError => '비밀번호는 6자 이상이어야 합니다';

  @override
  String get auth_passwordMismatch => '비밀번호가 일치하지 않습니다';

  @override
  String get auth_nameError => '이름을 입력해주세요';

  @override
  String get auth_loginSuccess => '로그인 성공';

  @override
  String get auth_loginFailed => '로그인 실패';

  @override
  String get auth_signupSuccess => '회원가입 성공';

  @override
  String get auth_signupFailed => '회원가입 실패';

  @override
  String get auth_logoutSuccess => '로그아웃 되었습니다';

  @override
  String get auth_emailVerification => '이메일 인증';

  @override
  String get auth_emailVerificationMessage => '가입하신 이메일로 인증 코드가 전송되었습니다.';

  @override
  String get auth_verificationCode => '인증 코드';

  @override
  String get auth_verificationCodeHint => '인증 코드를 입력해주세요';

  @override
  String get auth_resendCode => '인증 코드 재전송';

  @override
  String get auth_verify => '인증하기';

  @override
  String get auth_resetPassword => '비밀번호 재설정';

  @override
  String get auth_resetPasswordMessage =>
      '가입하신 이메일 주소를 입력해주세요.\n인증 코드를 보내드립니다.';

  @override
  String get auth_newPassword => '새 비밀번호';

  @override
  String get auth_sendCode => '인증 코드 받기';

  @override
  String get auth_resetPasswordSuccess => '비밀번호가 재설정되었습니다. 로그인해주세요.';

  @override
  String get nav_home => '홈';

  @override
  String get nav_assets => '자산';

  @override
  String get nav_calendar => '일정';

  @override
  String get nav_todo => '할일';

  @override
  String get nav_more => '더보기';

  @override
  String get home_greeting_morning => '좋은 아침이에요!';

  @override
  String get home_greeting_afternoon => '좋은 오후에요!';

  @override
  String get home_greeting_evening => '좋은 저녁이에요!';

  @override
  String get home_greeting_night => '늦은 시간이네요!';

  @override
  String get home_todaySchedule => '오늘의 일정';

  @override
  String get home_noSchedule => '등록된 일정이 없습니다';

  @override
  String get home_investmentSummary => '투자 지표 요약';

  @override
  String get home_todoSummary => '할일 요약';

  @override
  String get home_assetSummary => '자산 요약';

  @override
  String get settings_title => '설정';

  @override
  String get settings_theme => '테마 설정';

  @override
  String get settings_language => '언어 설정';

  @override
  String get settings_homeWidgets => '홈 위젯 설정';

  @override
  String get settings_profile => '프로필 설정';

  @override
  String get settings_family => '가족 관리';

  @override
  String get settings_notifications => '알림 설정';

  @override
  String get settings_about => '앱 정보';

  @override
  String get theme_light => '라이트 모드';

  @override
  String get theme_dark => '다크 모드';

  @override
  String get theme_system => '시스템 설정';

  @override
  String get language_korean => '한국어';

  @override
  String get language_english => 'English';

  @override
  String get language_japanese => '日本語';

  @override
  String get widgetSettings_title => '홈 위젯 설정';

  @override
  String get widgetSettings_description => '홈 화면에 표시할 위젯을 선택하세요';

  @override
  String get widgetSettings_todaySchedule => '오늘의 일정';

  @override
  String get widgetSettings_investmentSummary => '투자 지표 요약';

  @override
  String get widgetSettings_todoSummary => '할일 요약';

  @override
  String get widgetSettings_assetSummary => '자산 요약';

  @override
  String get error_network => '네트워크 연결을 확인해주세요';

  @override
  String get error_server => '서버 오류가 발생했습니다';

  @override
  String get error_unknown => '알 수 없는 오류가 발생했습니다';
}
