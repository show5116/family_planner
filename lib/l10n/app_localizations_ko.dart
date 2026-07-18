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
  String get common_confirm => '확인';

  @override
  String get common_save => '저장';

  @override
  String get common_delete => '삭제';

  @override
  String get common_edit => '수정';

  @override
  String get common_add => '추가';

  @override
  String get common_create => '생성';

  @override
  String get common_search => '검색';

  @override
  String get common_loading => '로딩 중...';

  @override
  String get common_optional => '선택';

  @override
  String get common_error => '오류';

  @override
  String get common_retry => '다시 시도';

  @override
  String get common_close => '닫기';

  @override
  String get common_done => '완료';

  @override
  String get common_undo => '되돌리기';

  @override
  String get common_add_to_list => '목록에 담기';

  @override
  String get common_view_all => '전체보기';

  @override
  String get memo_filter_personal_only => '개인 메모만';

  @override
  String get common_all_groups => '전체 그룹';

  @override
  String get schedule_filter_group_schedule => '그룹 일정';

  @override
  String common_date_format(int month, int day) {
    return '$month월 $day일';
  }

  @override
  String get cart_unsaved_changes => '저장되지 않은 변경사항이 있습니다';

  @override
  String get common_next => '다음';

  @override
  String get common_back => '이전';

  @override
  String get common_previous => '이전';

  @override
  String get common_all => '전체';

  @override
  String get common_apply => '적용';

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
  String get auth_testAccountLoginOwner => '테스트 계정으로 로그인 (그룹 소유자)';

  @override
  String get auth_testAccountLoginMember => '테스트 계정으로 로그인 (그룹 멤버)';

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
  String get auth_loginFailedInvalidCredentials => '이메일 또는 비밀번호가 올바르지 않습니다';

  @override
  String get auth_googleLoginFailed => 'Google 로그인 실패';

  @override
  String get auth_kakaoLoginFailed => 'Kakao 로그인 실패';

  @override
  String get auth_appleLoginFailed => 'Apple 로그인 실패';

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
  String get auth_signupEmailVerificationMessage =>
      '회원가입이 완료되었습니다. 이메일을 확인해주세요.';

  @override
  String get auth_signupNameLabel => '이름';

  @override
  String get auth_signupNameMinLengthError => '이름은 2자 이상이어야 합니다';

  @override
  String get auth_signupPasswordHelperText => '최소 8자 이상';

  @override
  String get auth_signupConfirmPasswordLabel => '비밀번호 확인';

  @override
  String get auth_signupConfirmPasswordError => '비밀번호를 다시 입력해주세요';

  @override
  String get auth_signupButton => '회원가입';

  @override
  String get auth_forgotPasswordTitle => '비밀번호 찾기';

  @override
  String get auth_setPasswordTitle => '비밀번호 설정';

  @override
  String get auth_forgotPasswordGuide => '가입하신 이메일 주소를 입력해주세요.\n인증 코드를 보내드립니다.';

  @override
  String get auth_forgotPasswordGuideWithCode =>
      '이메일로 전송된 인증 코드를 입력하고\n새 비밀번호를 설정해주세요.';

  @override
  String get auth_setPasswordGuide =>
      '계정 보안을 위해 비밀번호를 설정하세요.\n가입하신 이메일 주소를 입력하면\n인증 코드를 보내드립니다.';

  @override
  String get auth_setPasswordGuideWithCode =>
      '이메일로 전송된 인증 코드를 입력하고\n비밀번호를 설정해주세요.';

  @override
  String get auth_verificationCodeLabel => '인증 코드 (6자리)';

  @override
  String get auth_verificationCodeError => '인증 코드를 입력해주세요';

  @override
  String get auth_verificationCodeLengthError => '인증 코드는 6자리입니다';

  @override
  String get auth_codeSentMessage => '인증 코드가 이메일로 전송되었습니다';

  @override
  String get auth_codeSentError => '인증 코드 전송 실패';

  @override
  String get auth_passwordResetButton => '비밀번호 재설정';

  @override
  String get auth_passwordSetButton => '비밀번호 설정 완료';

  @override
  String get auth_resendCodeButton => '인증 코드 다시 받기';

  @override
  String get auth_passwordSetSuccess => '비밀번호가 설정되었습니다. 이제 로그인할 수 있습니다.';

  @override
  String get auth_passwordResetError => '비밀번호 재설정 실패';

  @override
  String get auth_rememberPassword => '비밀번호가 기억나셨나요?';

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
  String get nav_household => '가계관리';

  @override
  String get nav_childPoints => '육아포인트';

  @override
  String get nav_memo => '메모';

  @override
  String get nav_miniGames => '미니게임';

  @override
  String get nav_investmentIndicators => '투자 지표';

  @override
  String get nav_savings => '그룹 저금통';

  @override
  String get nav_votes => '투표';

  @override
  String get more_coach_groupDesc =>
      '가족, 연인, 친구 등 원하는 그룹을 만들고\n초대 코드로 구성원을 초대하세요.';

  @override
  String get more_coach_settingsDesc =>
      '테마, 언어, 알림, 하단 탭 구성 등\n앱을 원하는 대로 커스터마이징하세요.';

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
  String get settings_bottomNavigation => '하단 네비게이션';

  @override
  String get bottomNav_title => '하단 네비게이션 설정';

  @override
  String get bottomNav_reset => '기본값으로 초기화';

  @override
  String get bottomNav_resetConfirmTitle => '초기화 확인';

  @override
  String get bottomNav_resetConfirmMessage => '하단 네비게이션 설정을 기본값으로 초기화하시겠습니까?';

  @override
  String get bottomNav_resetSuccess => '기본값으로 초기화되었습니다';

  @override
  String get bottomNav_guideMessage =>
      '홈과 더보기는 고정입니다.\n중간 3개 슬롯을 탭하여 메뉴를 선택하세요.';

  @override
  String get bottomNav_preview => '하단 네비게이션 미리보기';

  @override
  String get bottomNav_howToUse => '사용 방법';

  @override
  String get bottomNav_instructions =>
      '• 슬롯 2, 3, 4를 탭하여 원하는 메뉴로 변경하세요.\n• 슬롯 1(홈)과 슬롯 5(더보기)는 고정입니다.\n• 하단 네비게이션에 없는 메뉴는 \"더보기\" 탭에 표시됩니다.';

  @override
  String get bottomNav_availableMenus => '사용 가능한 메뉴';

  @override
  String get bottomNav_slot => '슬롯';

  @override
  String get bottomNav_unused => '미사용';

  @override
  String bottomNav_selectMenuTitle(Object slot) {
    return '슬롯 $slot 메뉴 선택';
  }

  @override
  String get bottomNav_usedInOtherSlot => '다른 슬롯에서 사용 중 (선택 시 교체)';

  @override
  String get widgetSettings_saveSuccess => '설정이 저장되었습니다';

  @override
  String get widgetSettings_guide => '홈 화면에 표시할 위젯을 선택하고 순서를 변경하세요';

  @override
  String get widgetSettings_widgetOrder => '위젯 순서';

  @override
  String get widgetSettings_dragToReorder => '위젯을 길게 눌러 드래그하여 순서를 변경할 수 있습니다';

  @override
  String get widgetSettings_restoreDefaults => '기본 설정으로 복원';

  @override
  String get widgetSettings_todayScheduleDesc => '당일 일정을 표시합니다';

  @override
  String get widgetSettings_investmentSummaryDesc => '코스피, 나스닥, 환율 정보를 표시합니다';

  @override
  String get widgetSettings_todoSummaryDesc => '진행 중인 할일을 표시합니다';

  @override
  String get widgetSettings_assetSummaryDesc => '총 자산과 수익률을 표시합니다';

  @override
  String get widgetSettings_memoSummary => '메모 요약';

  @override
  String get widgetSettings_memoSummaryDesc => '최근 작성한 메모를 표시합니다';

  @override
  String get widgetSettings_householdSummary => '가계 현황';

  @override
  String get widgetSettings_householdSummaryDesc => '이번 달 지출 요약 및 예산 달성률';

  @override
  String get widgetSettings_childcareSummary => '육아 포인트';

  @override
  String get widgetSettings_childcareSummaryDesc => '자녀별 포인트 잔액 현황';

  @override
  String get widgetSettings_savingsSummary => '저금통';

  @override
  String get widgetSettings_savingsSummaryDesc => '그룹별 적립 목표 및 달성 현황';

  @override
  String get widgetSettings_fridgeSummary => '유통기한 임박';

  @override
  String get widgetSettings_fridgeSummaryDesc => '냉장고에서 유통기한이 얼마 남지 않은 식품 목록';

  @override
  String get widgetSettings_viewToday => '오늘';

  @override
  String get widgetSettings_viewWeek => '금주';

  @override
  String get widgetSettings_viewMonth => '이번달';

  @override
  String get widgetSettings_viewBudget => '전체 예산 보기';

  @override
  String get widgetSettings_viewCategory => '카테고리별 보기';

  @override
  String get widgetSettings_savingsEmpty => '등록된 저금통이 없습니다';

  @override
  String get widgetSettings_fridgeExpiryEmpty => '유통기한 임박 식품이 없어요';

  @override
  String get widgetSettings_scheduleWeek => '금주 일정';

  @override
  String get widgetSettings_scheduleMonth => '이번달 일정';

  @override
  String get widgetSettings_scheduleEmptyToday => '오늘 일정이 없습니다';

  @override
  String get widgetSettings_scheduleEmptyWeek => '이번 주 일정이 없습니다';

  @override
  String get widgetSettings_scheduleEmptyMonth => '이번 달 일정이 없습니다';

  @override
  String get widgetSettings_weather => '날씨';

  @override
  String get widgetSettings_weatherDesc => '현재 위치의 날씨 정보를 표시합니다';

  @override
  String get themeSettings_title => '테마 설정';

  @override
  String get themeSettings_selectTheme => '테마 선택';

  @override
  String get themeSettings_description =>
      '앱의 밝기 테마를 선택하세요. 시스템 설정을 따르거나 직접 선택할 수 있습니다.';

  @override
  String get themeSettings_lightMode => 'Light 모드';

  @override
  String get themeSettings_lightModeDesc => '밝은 테마를 사용합니다';

  @override
  String get themeSettings_darkMode => 'Dark 모드';

  @override
  String get themeSettings_darkModeDesc => '어두운 테마를 사용합니다';

  @override
  String get themeSettings_systemMode => '시스템 설정';

  @override
  String get themeSettings_systemModeDesc => '기기의 시스템 설정을 따릅니다';

  @override
  String get themeSettings_colorTitle => '컬러 테마';

  @override
  String get themeSettings_brightnessTitle => '밝기 모드';

  @override
  String get themeSettings_currentThemePreview => '현재 테마 미리보기';

  @override
  String get themeSettings_currentTheme => '현재 테마';

  @override
  String get profile_title => '프로필 설정';

  @override
  String get profile_save => '저장';

  @override
  String get profile_name => '이름';

  @override
  String get profile_nameRequired => '이름을 입력해주세요';

  @override
  String get profile_phoneNumber => '전화번호 (선택사항)';

  @override
  String get profile_phoneNumberHint => '예: 010-1234-5678';

  @override
  String get profile_uploadSuccess => '프로필 사진이 업로드되었습니다';

  @override
  String get profile_uploadFailed => '프로필 사진 업로드 실패';

  @override
  String get profile_changePassword => '비밀번호 변경';

  @override
  String get profile_currentPassword => '현재 비밀번호';

  @override
  String get profile_currentPasswordRequired => '현재 비밀번호를 입력해주세요';

  @override
  String get profile_newPassword => '새 비밀번호';

  @override
  String get profile_newPasswordRequired => '새 비밀번호를 입력해주세요';

  @override
  String get profile_newPasswordMinLength => '비밀번호는 6자 이상이어야 합니다';

  @override
  String get profile_confirmNewPassword => '새 비밀번호 확인';

  @override
  String get profile_confirmNewPasswordRequired => '새 비밀번호 확인을 입력해주세요';

  @override
  String get profile_passwordsDoNotMatch => '비밀번호가 일치하지 않습니다';

  @override
  String get profile_updateSuccess => '프로필이 업데이트되었습니다';

  @override
  String get profile_updateFailed => '프로필 업데이트 실패';

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
  String get language_chinese => '중국어';

  @override
  String get language_selectDescription => '앱에서 사용할 언어를 선택하세요';

  @override
  String get language_useSystemLanguage => '시스템 언어 사용';

  @override
  String get language_useSystemLanguageDescription => '기기의 언어 설정을 따릅니다';

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
  String get settings_screenSettings => '화면 설정';

  @override
  String get settings_bottomNavigationTitle => '하단 네비게이션 설정';

  @override
  String get settings_bottomNavigationSubtitle => '하단 메뉴 순서와 표시/숨김을 설정하세요';

  @override
  String get settings_homeWidgetsTitle => '홈 위젯 설정';

  @override
  String get settings_homeWidgetsSubtitle => '홈 화면에 표시할 위젯을 선택하세요';

  @override
  String get settings_themeTitle => '테마 설정';

  @override
  String get settings_themeSubtitle => '라이트/다크 모드를 변경하세요';

  @override
  String get settings_languageTitle => '언어 설정';

  @override
  String get settings_languageSubtitle => '앱에서 사용할 언어를 변경하세요';

  @override
  String get settings_userSettings => '사용자 설정';

  @override
  String get settings_profileTitle => '프로필 설정';

  @override
  String get settings_profileSubtitle => '프로필 정보를 수정하세요';

  @override
  String get settings_groupManagementTitle => '그룹 관리';

  @override
  String get settings_groupManagementSubtitle => '그룹과 멤버를 관리하세요';

  @override
  String get settings_notificationSettings => '알림 설정';

  @override
  String get settings_notificationTitle => '알림 설정';

  @override
  String get settings_notificationSubtitle => '알림 수신 설정을 변경하세요';

  @override
  String get settings_information => '정보';

  @override
  String get settings_appInfoTitle => '앱 정보';

  @override
  String get settings_appInfoSubtitle => '버전 정보';

  @override
  String get settings_appDescription => '가족과 함께하는 일상 플래너';

  @override
  String get settings_termsOfServiceTitle => '서비스 이용약관';

  @override
  String get settings_termsOfServiceSubtitle => '서비스 이용 약관을 확인하세요';

  @override
  String get settings_privacyPolicyTitle => '개인정보 처리방침';

  @override
  String get settings_privacyPolicySubtitle => '개인정보 처리 방침을 확인하세요';

  @override
  String get settings_helpTitle => '도움말';

  @override
  String get settings_helpSubtitle => '사용법을 확인하세요';

  @override
  String get settings_user => '사용자';

  @override
  String get settings_logout => '로그아웃';

  @override
  String get settings_logoutConfirmTitle => '로그아웃';

  @override
  String get settings_logoutConfirmMessage => '로그아웃 하시겠습니까?';

  @override
  String get settings_passwordSetupRequired => '비밀번호 설정이 필요합니다';

  @override
  String get settings_passwordSetupMessage1 =>
      '소셜 로그인으로만 가입하셔서 아직 비밀번호가 설정되지 않았습니다.';

  @override
  String get settings_passwordSetupMessage2 =>
      '프로필을 수정하거나 계정 보안을 강화하려면 비밀번호를 설정하는 것을 권장합니다.';

  @override
  String get settings_passwordSetupMessage3 => '비밀번호 설정 화면으로 이동하시겠습니까?';

  @override
  String get settings_passwordSetupLater => '나중에';

  @override
  String get settings_passwordSetupNow => '비밀번호 설정하기';

  @override
  String get settings_adminMenu => '운영자 전용';

  @override
  String get settings_permissionManagementTitle => '권한 관리';

  @override
  String get settings_permissionManagementSubtitle => 'Role에 할당할 권한 종류를 관리하세요';

  @override
  String get permission_title => '권한 관리';

  @override
  String get permission_search => '권한 검색 (코드, 이름, 설명)';

  @override
  String get permission_allCategories => '전체';

  @override
  String get permission_create => '권한 생성';

  @override
  String get permission_code => '권한 코드';

  @override
  String get permission_category => '카테고리';

  @override
  String get permission_description => '설명';

  @override
  String get permission_status => '상태';

  @override
  String get permission_active => '활성';

  @override
  String get permission_inactive => '비활성';

  @override
  String get permission_count => '개';

  @override
  String get permission_noPermissions => '권한이 없습니다';

  @override
  String get permission_loadFailed => '권한 목록을 불러오는데 실패했습니다';

  @override
  String get permission_deleteConfirm => '권한 삭제';

  @override
  String permission_deleteMessage(String name) {
    return '$name 권한을 삭제하시겠습니까?';
  }

  @override
  String get permission_deleteSoftDescription => '소프트 삭제: 비활성화하지만 데이터는 유지됩니다';

  @override
  String get permission_deleteHardDescription =>
      '하드 삭제: 데이터베이스에서 완전히 삭제됩니다 (주의!)';

  @override
  String get permission_softDelete => '소프트 삭제';

  @override
  String get permission_hardDelete => '하드 삭제';

  @override
  String get permission_deleteSuccess => '권한이 삭제되었습니다';

  @override
  String get permission_deleteFailed => '권한 삭제 실패';

  @override
  String get permission_name => '권한 이름';

  @override
  String get permission_codeAndNameRequired => '권한 코드와 이름은 필수입니다';

  @override
  String get permission_createSuccess => '권한이 생성되었습니다';

  @override
  String get permission_createFailed => '권한 생성 실패';

  @override
  String get permission_updateSuccess => '권한이 수정되었습니다';

  @override
  String get permission_updateFailed => '권한 수정 실패';

  @override
  String get group_title => '그룹 관리';

  @override
  String get group_myGroups => '내 그룹';

  @override
  String get group_createGroup => '그룹 생성';

  @override
  String get group_joinGroup => '그룹 참여';

  @override
  String get group_groupName => '그룹 이름';

  @override
  String get group_groupDescription => '그룹 설명';

  @override
  String get group_groupColor => '그룹 색상';

  @override
  String get group_defaultColor => '기본 색상';

  @override
  String get group_customColor => '개인 색상';

  @override
  String get group_inviteCode => '초대 코드';

  @override
  String get group_members => '멤버';

  @override
  String get group_pending => '대기중';

  @override
  String get group_noPendingRequests => '대기 중인 가입 요청이 없습니다';

  @override
  String group_memberCount(int count) {
    return '$count명';
  }

  @override
  String get group_role => '역할';

  @override
  String get group_owner => '그룹장';

  @override
  String get group_admin => '관리자';

  @override
  String get group_member => '멤버';

  @override
  String get group_joinedAt => '가입일';

  @override
  String get group_createdAt => '생성일';

  @override
  String get group_settings => '그룹 설정';

  @override
  String get group_editGroup => '그룹 정보 수정';

  @override
  String get group_deleteGroup => '그룹 삭제';

  @override
  String get group_leaveGroup => '그룹 나가기';

  @override
  String get group_inviteMembers => '멤버 초대';

  @override
  String get group_manageMembers => '멤버 관리';

  @override
  String get group_regenerateCode => '초대 코드 재생성';

  @override
  String get group_copyCode => '코드 복사';

  @override
  String get group_enterInviteCode => '초대 코드 입력';

  @override
  String get group_inviteByEmail => '이메일로 초대';

  @override
  String get group_email => '이메일';

  @override
  String get group_send => '보내기';

  @override
  String get group_join => '참여하기';

  @override
  String get group_cancel => '취소';

  @override
  String get group_save => '저장';

  @override
  String get group_delete => '삭제';

  @override
  String get group_leave => '나가기';

  @override
  String get group_create => '생성';

  @override
  String get group_edit => '수정';

  @override
  String get group_confirm => '확인';

  @override
  String get group_accept => '승인';

  @override
  String get group_reject => '거부';

  @override
  String get group_requestedAt => '요청일';

  @override
  String get group_invitedAt => '초대일';

  @override
  String get group_acceptSuccess => '가입 요청이 승인되었습니다';

  @override
  String get group_rejectSuccess => '가입 요청이 거부되었습니다';

  @override
  String get group_rejectConfirmMessage => '정말로 이 가입 요청을 거부하시겠습니까?';

  @override
  String get group_groupNameRequired => '그룹 이름을 입력해주세요';

  @override
  String get group_inviteCodeRequired => '초대 코드를 입력해주세요';

  @override
  String get group_emailRequired => '이메일을 입력해주세요';

  @override
  String get group_deleteConfirmTitle => '그룹 삭제';

  @override
  String get group_deleteConfirmMessage =>
      '정말로 이 그룹을 삭제하시겠습니까?\n모든 데이터가 삭제되며 복구할 수 없습니다.';

  @override
  String get group_leaveConfirmTitle => '그룹 나가기';

  @override
  String get group_leaveConfirmMessage => '정말로 이 그룹을 나가시겠습니까?';

  @override
  String get group_ownerCannotLeave =>
      '그룹장은 그룹을 나갈 수 없습니다.\n그룹장 권한을 양도하거나 그룹을 삭제해주세요.';

  @override
  String get group_createSuccess => '그룹이 생성되었습니다';

  @override
  String get group_joinSuccess => '그룹에 참여했습니다';

  @override
  String get group_updateSuccess => '그룹 정보가 수정되었습니다';

  @override
  String get group_deleteSuccess => '그룹이 삭제되었습니다';

  @override
  String get group_leaveSuccess => '그룹에서 나갔습니다';

  @override
  String get group_inviteSent => '초대 이메일이 발송되었습니다';

  @override
  String get group_codeRegenerated => '초대 코드가 재생성되었습니다';

  @override
  String get group_codeCopied => '초대 코드가 복사되었습니다';

  @override
  String get group_codeExpired => '초대 코드가 만료되었습니다';

  @override
  String group_codeExpiresInDays(int count) {
    return '$count일 후 만료';
  }

  @override
  String group_codeExpiresInHours(int count) {
    return '$count시간 후 만료';
  }

  @override
  String group_codeExpiresInMinutes(int count) {
    return '$count분 후 만료';
  }

  @override
  String get group_noGroups => '참여 중인 그룹이 없습니다';

  @override
  String get group_noGroupsDescription => '새로운 그룹을 생성하거나\n초대 코드로 그룹에 참여하세요';

  @override
  String get group_myJoinRequests => '내 가입 신청 목록';

  @override
  String get group_noJoinRequests => '가입 신청 내역이 없습니다';

  @override
  String get group_joinRequestStatusAll => '전체';

  @override
  String get group_joinRequestStatusPending => '대기중';

  @override
  String get group_joinRequestStatusDone => '처리완료';

  @override
  String get group_joinRequestAccepted => '승인됨';

  @override
  String get group_joinRequestRejected => '거부됨';

  @override
  String get group_codeExpiredLabel => '초대 코드 만료됨';

  @override
  String get group_defaultGroupTooltip => '대표 그룹';

  @override
  String get group_setDefaultGroupTooltip => '대표 그룹으로 설정';

  @override
  String get group_unsetDefaultGroupTooltip => '대표 그룹 해제';

  @override
  String group_setDefaultSuccess(String name) {
    return '\'$name\'을(를) 대표 그룹으로 설정했습니다';
  }

  @override
  String get group_unsetDefaultSuccess => '대표 그룹을 해제했습니다';

  @override
  String get group_myColorTitle => '나만의 그룹 색상';

  @override
  String get group_myColorNotSet => '설정하지 않음 (그룹 기본 색상 사용)';

  @override
  String get group_myColorSet => '설정됨';

  @override
  String get group_myColorReset => '초기화';

  @override
  String get group_dangerZone => '위험 구역';

  @override
  String get group_dangerZoneDesc => '그룹을 삭제하면 모든 데이터가 영구적으로 삭제됩니다.';

  @override
  String get group_leaveTitle => '그룹 나가기';

  @override
  String get group_leaveDesc => '그룹을 나가면 더 이상 그룹의 데이터에 접근할 수 없습니다.';

  @override
  String group_leaveConfirmBody(String name) {
    return '정말로 \"$name\" 그룹을 나가시겠습니까?\n\n그룹을 나가면 더 이상 그룹의 데이터에 접근할 수 없으며, 다시 참여하려면 초대 코드가 필요합니다.';
  }

  @override
  String get group_leaveButton => '나가기';

  @override
  String get group_roleManagementTitle => '역할 관리';

  @override
  String get group_roleManagementDesc => '이 그룹의 역할 목록입니다.';

  @override
  String get group_roleEmpty => '역할이 없습니다';

  @override
  String get group_roleDefaultBadge => '기본 역할';

  @override
  String group_rolePermissionCount(int count) {
    return '권한: $count개';
  }

  @override
  String get group_roleEdit => '역할 수정';

  @override
  String get group_roleDelete => '역할 삭제';

  @override
  String get group_roleSortSaved => '정렬 순서가 저장되었습니다';

  @override
  String get group_roleLoadError => '역할 목록을 불러올 수 없습니다';

  @override
  String get group_roleInfoTitle => '안내';

  @override
  String get group_roleInfoBullet1 =>
      '공통 역할 (OWNER, ADMIN, MEMBER)은 모든 그룹에 기본으로 제공됩니다.';

  @override
  String get group_roleInfoBullet2 => '커스텀 역할은 그룹 OWNER만 생성, 수정, 삭제할 수 있습니다.';

  @override
  String get group_roleInfoBullet3 => '역할을 관리하려면 그룹 OWNER 권한이 필요합니다.';

  @override
  String get group_roleCreateTitle => '역할 생성';

  @override
  String get group_roleEditTitle => '역할 수정';

  @override
  String get group_roleDeleteTitle => '역할 삭제';

  @override
  String get group_roleNameLabel => '역할 이름';

  @override
  String get group_roleNameRequired => '역할 이름을 입력해주세요';

  @override
  String get group_roleDefaultSwitch => '기본 역할';

  @override
  String get group_roleDefaultSwitchSub => '새 멤버 가입 시 자동 부여';

  @override
  String get group_roleColorLabel => '역할 색상';

  @override
  String get group_rolePermissionsLabel => '권한 선택';

  @override
  String get group_rolePermissionsViewLabel => '권한 목록';

  @override
  String get group_rolePermissionNone => '권한이 없습니다';

  @override
  String get group_roleDefaultLabel => '기본 역할 (새 멤버 가입 시 자동 부여)';

  @override
  String group_roleDeleteConfirm(String name) {
    return '$name 역할을 삭제하시겠습니까?';
  }

  @override
  String get group_roleDeleteWarning => '⚠️ 이 역할을 사용 중인 멤버가 있으면 삭제할 수 없습니다.';

  @override
  String get group_roleCreateSuccess => '역할이 생성되었습니다';

  @override
  String group_roleCreateFail(String error) {
    return '역할 생성 실패: $error';
  }

  @override
  String get group_roleEditSuccess => '역할이 수정되었습니다';

  @override
  String group_roleEditFail(String error) {
    return '역할 수정 실패: $error';
  }

  @override
  String get group_roleDeleteSuccess => '역할이 삭제되었습니다';

  @override
  String group_roleDeleteFail(String error) {
    return '역할 삭제 실패: $error';
  }

  @override
  String get group_settings_groupManagementTitle => '그룹 관리';

  @override
  String get error_network => '네트워크 연결을 확인해주세요';

  @override
  String get error_server => '서버 오류가 발생했습니다';

  @override
  String get error_unknown => '알 수 없는 오류가 발생했습니다';

  @override
  String get common_comingSoon => '준비 중';

  @override
  String get common_logoutFailed => '로그아웃 실패';

  @override
  String get announcement_title => '공지사항';

  @override
  String get announcement_list => '공지사항 목록';

  @override
  String get announcement_detail => '공지사항 상세';

  @override
  String get announcement_create => '공지사항 작성';

  @override
  String get announcement_edit => '공지사항 수정';

  @override
  String get announcement_delete => '공지사항 삭제';

  @override
  String get announcement_pin => '상단 고정';

  @override
  String get announcement_unpin => '고정 해제';

  @override
  String get announcement_pinned => '고정 공지';

  @override
  String get announcement_pinDescription => '중요한 공지사항을 목록 상단에 고정합니다';

  @override
  String get announcement_category => '카테고리';

  @override
  String get announcement_category_none => '카테고리 없음';

  @override
  String get announcement_category_announcement => '공지';

  @override
  String get announcement_category_event => '이벤트';

  @override
  String get announcement_category_update => '업데이트';

  @override
  String get announcement_content => '내용';

  @override
  String get announcement_author => '작성자';

  @override
  String get announcement_createdAt => '작성일';

  @override
  String get announcement_updatedAt => '수정일';

  @override
  String announcement_readCount(int count) {
    return '$count명 읽음';
  }

  @override
  String get announcement_createSuccess => '공지사항이 등록되었습니다';

  @override
  String get announcement_createError => '공지사항 등록에 실패했습니다';

  @override
  String get announcement_updateSuccess => '공지사항이 수정되었습니다';

  @override
  String get announcement_updateError => '공지사항 수정에 실패했습니다';

  @override
  String get announcement_deleteSuccess => '공지사항이 삭제되었습니다';

  @override
  String get announcement_deleteError => '공지사항 삭제에 실패했습니다';

  @override
  String get announcement_deleteDialogTitle => '공지사항 삭제';

  @override
  String get announcement_deleteDialogMessage =>
      '이 공지사항을 삭제하시겠습니까?\n삭제된 공지사항은 복구할 수 없습니다.';

  @override
  String get announcement_pinSuccess => '공지사항이 고정되었습니다';

  @override
  String get announcement_unpinSuccess => '고정이 해제되었습니다';

  @override
  String get announcement_deleteConfirm =>
      '이 공지사항을 삭제하시겠습니까?\n삭제된 공지사항은 복구할 수 없습니다.';

  @override
  String get announcement_loadError => '공지사항을 불러올 수 없습니다';

  @override
  String get announcement_empty => '등록된 공지사항이 없습니다';

  @override
  String get announcement_titleHint => '공지사항 제목을 입력하세요';

  @override
  String get announcement_contentHint => '공지사항 내용을 입력하세요';

  @override
  String get announcement_categoryHint => '카테고리를 선택하세요 (선택사항)';

  @override
  String get announcement_titleRequired => '제목을 입력해주세요';

  @override
  String get announcement_titleMinLength => '제목은 최소 3자 이상 입력해주세요';

  @override
  String get announcement_contentRequired => '내용을 입력해주세요';

  @override
  String get announcement_contentMinLength => '내용은 최소 10자 이상 입력해주세요';

  @override
  String get announcement_attachmentComingSoon => '첨부파일 업로드 기능은 추후 업데이트 예정입니다';

  @override
  String get qna_title => 'Q&A';

  @override
  String get qna_publicQuestions => '공개 Q&A';

  @override
  String get qna_myQuestions => '내 질문';

  @override
  String get qna_askQuestion => '질문하기';

  @override
  String get qna_question => '질문';

  @override
  String get qna_answer => '답변';

  @override
  String get qna_category => '카테고리';

  @override
  String get qna_categoryFilter => '카테고리 필터';

  @override
  String get qna_categoryAll => '전체';

  @override
  String get qna_categoryNone => '카테고리 없음';

  @override
  String get qna_status => '상태';

  @override
  String get qna_statusAll => '전체';

  @override
  String get qna_statusPending => '답변 대기';

  @override
  String get qna_statusAnswered => '답변 완료';

  @override
  String get qna_statusResolved => '해결됨';

  @override
  String get qna_search => '질문 검색';

  @override
  String get qna_searchHint => '질문을 검색하세요';

  @override
  String get qna_questionTitle => '질문 제목';

  @override
  String get qna_questionTitleHint => '질문 제목을 입력하세요';

  @override
  String get qna_questionContent => '질문 내용';

  @override
  String get qna_questionContentHint => '질문 내용을 입력하세요';

  @override
  String get qna_answerContent => '답변 내용';

  @override
  String get qna_answerContentHint => '답변을 입력하세요';

  @override
  String get qna_isPublic => '공개 여부';

  @override
  String get qna_publicQuestion => '공개 질문';

  @override
  String get qna_privateQuestion => '비공개 질문';

  @override
  String get qna_author => '작성자';

  @override
  String get qna_answerer => '답변자';

  @override
  String get qna_createdAt => '작성일';

  @override
  String get qna_answeredAt => '답변일';

  @override
  String qna_viewCount(int count) {
    return '$count회 조회';
  }

  @override
  String qna_answerCount(int count) {
    return '$count개 답변';
  }

  @override
  String get qna_empty => '등록된 질문이 없습니다';

  @override
  String get qna_noAnswer => '아직 답변이 없습니다';

  @override
  String get qna_loadError => '질문을 불러올 수 없습니다';

  @override
  String get qna_createSuccess => '질문이 등록되었습니다';

  @override
  String get qna_createError => '질문 등록에 실패했습니다';

  @override
  String get qna_updateSuccess => '질문이 수정되었습니다';

  @override
  String get qna_updateError => '질문 수정에 실패했습니다';

  @override
  String get qna_deleteSuccess => '질문이 삭제되었습니다';

  @override
  String get qna_deleteError => '질문 삭제에 실패했습니다';

  @override
  String get qna_deleteDialogTitle => '질문 삭제';

  @override
  String get qna_deleteDialogMessage => '이 질문을 삭제하시겠습니까?\n삭제된 질문은 복구할 수 없습니다.';

  @override
  String get qna_answerSuccess => '답변이 등록되었습니다';

  @override
  String get qna_answerError => '답변 등록에 실패했습니다';

  @override
  String get qna_answerUpdateSuccess => '답변이 수정되었습니다';

  @override
  String get qna_answerUpdateError => '답변 수정에 실패했습니다';

  @override
  String get qna_answerDeleteSuccess => '답변이 삭제되었습니다';

  @override
  String get qna_answerDeleteError => '답변 삭제에 실패했습니다';

  @override
  String get qna_markResolved => '해결됨으로 표시';

  @override
  String get qna_markUnresolved => '미해결로 표시';

  @override
  String get qna_resolveSuccess => '질문이 해결됨으로 표시되었습니다';

  @override
  String get qna_resolveError => '상태 변경에 실패했습니다';

  @override
  String get qna_titleRequired => '제목을 입력해주세요';

  @override
  String get qna_titleMinLength => '제목은 최소 3자 이상 입력해주세요';

  @override
  String get qna_contentRequired => '내용을 입력해주세요';

  @override
  String get qna_contentMinLength => '내용은 최소 10자 이상 입력해주세요';

  @override
  String get qna_answerRequired => '답변을 입력해주세요';

  @override
  String get schedule_today => '오늘';

  @override
  String get schedule_add => '일정 추가';

  @override
  String get schedule_edit => '일정 수정';

  @override
  String get schedule_delete => '일정 삭제';

  @override
  String get schedule_detail => '일정 상세';

  @override
  String get schedule_allDay => '종일';

  @override
  String get schedule_loadError => '일정을 불러올 수 없습니다';

  @override
  String get schedule_empty => '등록된 일정이 없습니다';

  @override
  String get schedule_createSuccess => '일정이 등록되었습니다';

  @override
  String get schedule_createError => '일정 등록에 실패했습니다';

  @override
  String get schedule_updateSuccess => '일정이 수정되었습니다';

  @override
  String get schedule_updateError => '일정 수정에 실패했습니다';

  @override
  String get schedule_deleteSuccess => '일정이 삭제되었습니다';

  @override
  String get schedule_deleteError => '일정 삭제에 실패했습니다';

  @override
  String get schedule_deleteDialogTitle => '일정 삭제';

  @override
  String get schedule_deleteDialogMessage => '이 일정을 삭제하시겠습니까?';

  @override
  String get schedule_title => '제목';

  @override
  String get schedule_titleHint => '일정 제목을 입력하세요';

  @override
  String get schedule_titleRequired => '제목을 입력해주세요';

  @override
  String get schedule_description => '설명';

  @override
  String get schedule_descriptionHint => '일정 설명을 입력하세요 (선택)';

  @override
  String get schedule_location => '장소';

  @override
  String get schedule_locationHint => '장소를 입력하세요 (선택)';

  @override
  String get schedule_startDate => '시작일';

  @override
  String get schedule_endDate => '종료일';

  @override
  String get schedule_startTime => '시작 시간';

  @override
  String get schedule_endTime => '종료 시간';

  @override
  String get schedule_dueDate => '마감일 설정';

  @override
  String get schedule_dueDateSelect => '마감 날짜';

  @override
  String get schedule_dueTime => '마감 시간';

  @override
  String get schedule_color => '색상';

  @override
  String get schedule_share => '공유 설정';

  @override
  String get schedule_sharePrivate => '나만 보기';

  @override
  String get schedule_shareGroup => '특정 그룹';

  @override
  String get schedule_reminder => '알림';

  @override
  String get schedule_reminderNone => '없음';

  @override
  String get schedule_reminderAtTime => '정시';

  @override
  String get schedule_reminder5Min => '5분 전';

  @override
  String get schedule_reminder15Min => '15분 전';

  @override
  String get schedule_reminder30Min => '30분 전';

  @override
  String get schedule_reminder1Hour => '1시간 전';

  @override
  String get schedule_reminder1Day => '1일 전';

  @override
  String get schedule_recurrence => '반복';

  @override
  String get schedule_recurrenceNone => '반복 안함';

  @override
  String get schedule_recurrenceDaily => '매일';

  @override
  String get schedule_recurrenceWeekly => '매주';

  @override
  String get schedule_recurrenceMonthly => '매월';

  @override
  String get schedule_recurrenceYearly => '매년';

  @override
  String get schedule_personal => '개인 일정';

  @override
  String get schedule_group => '그룹';

  @override
  String get schedule_taskType => '일정 유형';

  @override
  String get schedule_taskTypeCalendarOnly => '단순 일정';

  @override
  String get schedule_taskTypeCalendarOnlyDesc => '캘린더에만 표시됩니다';

  @override
  String get schedule_taskTypeTodoLinked => '할일 연동';

  @override
  String get schedule_taskTypeTodoLinkedDesc => '캘린더와 할일 목록에 모두 표시됩니다';

  @override
  String get schedule_taskTypeTodoOnly => '할일 전용';

  @override
  String get schedule_taskTypeTodoOnlyDesc => '할일 목록에만 표시 (캘린더 제외)';

  @override
  String get schedule_priority => '우선순위';

  @override
  String get schedule_priorityLow => '낮음';

  @override
  String get schedule_priorityMedium => '보통';

  @override
  String get schedule_priorityHigh => '높음';

  @override
  String get schedule_priorityUrgent => '긴급';

  @override
  String get schedule_participants => '참가자';

  @override
  String get schedule_participantsHint => '이 일정에 참여할 그룹 멤버를 선택하세요';

  @override
  String get schedule_noMembers => '그룹 멤버가 없습니다';

  @override
  String get schedule_participantsLoadError => '멤버 목록을 불러올 수 없습니다';

  @override
  String get schedule_participantsSelectAll => '전체 선택';

  @override
  String get schedule_participantsDeselectAll => '전체 해제';

  @override
  String get schedule_reminderCustom => '직접 설정';

  @override
  String get schedule_reminderCustomTitle => '알림 시간 설정';

  @override
  String get schedule_reminderCustomHint => '일정 시작 전 알림받을 시간을 설정하세요';

  @override
  String get schedule_reminderDays => '일';

  @override
  String get schedule_reminderHours => '시간';

  @override
  String get schedule_reminderMinutes => '분';

  @override
  String schedule_reminderMinutesBefore(int minutes) {
    return '$minutes분 전';
  }

  @override
  String schedule_reminderHoursBefore(int hours) {
    return '$hours시간 전';
  }

  @override
  String schedule_reminderHoursMinutesBefore(int hours, int minutes) {
    return '$hours시간 $minutes분 전';
  }

  @override
  String schedule_reminderDaysBefore(int days) {
    return '$days일 전';
  }

  @override
  String schedule_reminderDaysHoursBefore(int days, int hours) {
    return '$days일 $hours시간 전';
  }

  @override
  String get category_management => '카테고리 관리';

  @override
  String get category_filter => '카테고리 필터';

  @override
  String get category_add => '카테고리 추가';

  @override
  String get category_edit => '카테고리 수정';

  @override
  String get category_empty => '카테고리가 없습니다';

  @override
  String get category_emptyHint => '카테고리를 추가하여 일정을 분류해보세요';

  @override
  String get category_loadError => '카테고리 로딩 실패';

  @override
  String get category_name => '카테고리 이름';

  @override
  String get category_nameHint => '예: 업무, 개인, 가족';

  @override
  String get category_nameRequired => '카테고리 이름을 입력해주세요';

  @override
  String get category_description => '설명';

  @override
  String get category_descriptionHint => '카테고리에 대한 설명 (선택)';

  @override
  String get category_emoji => '이모지';

  @override
  String get category_color => '색상';

  @override
  String get category_createSuccess => '카테고리가 생성되었습니다';

  @override
  String get category_createError => '카테고리 생성 실패';

  @override
  String get category_updateSuccess => '카테고리가 수정되었습니다';

  @override
  String get category_updateError => '카테고리 수정 실패';

  @override
  String get category_deleteSuccess => '카테고리가 삭제되었습니다';

  @override
  String get category_deleteError => '카테고리 삭제 실패';

  @override
  String get category_deleteDialogTitle => '카테고리 삭제';

  @override
  String get category_deleteDialogMessage =>
      '이 카테고리를 삭제하시겠습니까?\n연결된 일정이 있으면 삭제할 수 없습니다.';

  @override
  String get schedule_recurringEvery => '매';

  @override
  String get schedule_recurringIntervalDay => '일마다';

  @override
  String get schedule_recurringIntervalWeek => '주마다';

  @override
  String get schedule_recurringIntervalMonth => '개월마다';

  @override
  String get schedule_recurringIntervalYear => '년마다';

  @override
  String get schedule_recurringDaysOfWeek => '반복 요일';

  @override
  String get schedule_daySun => '일';

  @override
  String get schedule_dayMon => '월';

  @override
  String get schedule_dayTue => '화';

  @override
  String get schedule_dayWed => '수';

  @override
  String get schedule_dayThu => '목';

  @override
  String get schedule_dayFri => '금';

  @override
  String get schedule_daySat => '토';

  @override
  String get schedule_daySunday => '일요일';

  @override
  String get schedule_dayMonday => '월요일';

  @override
  String get schedule_dayTuesday => '화요일';

  @override
  String get schedule_dayWednesday => '수요일';

  @override
  String get schedule_dayThursday => '목요일';

  @override
  String get schedule_dayFriday => '금요일';

  @override
  String get schedule_daySaturday => '토요일';

  @override
  String get schedule_recurringMonthlyType => '월간 반복 방식';

  @override
  String get schedule_recurringMonthlyDayOfMonth => '날짜 기준';

  @override
  String get schedule_recurringMonthlyWeekOfMonth => '요일 기준';

  @override
  String get schedule_recurringMonthlyEveryMonth => '매월';

  @override
  String get schedule_recurringDay => '일';

  @override
  String get schedule_recurringWeek1 => '첫째 주';

  @override
  String get schedule_recurringWeek2 => '둘째 주';

  @override
  String get schedule_recurringWeek3 => '셋째 주';

  @override
  String get schedule_recurringWeek4 => '넷째 주';

  @override
  String get schedule_recurringWeekLast => '마지막 주';

  @override
  String get schedule_recurringYearlyType => '연간 반복 방식';

  @override
  String get schedule_recurringYearlyDayOfMonth => '날짜 기준';

  @override
  String get schedule_recurringYearlyWeekOfMonth => '요일 기준';

  @override
  String get schedule_recurringYearlyEveryYear => '매년';

  @override
  String get schedule_month1 => '1월';

  @override
  String get schedule_month2 => '2월';

  @override
  String get schedule_month3 => '3월';

  @override
  String get schedule_month4 => '4월';

  @override
  String get schedule_month5 => '5월';

  @override
  String get schedule_month6 => '6월';

  @override
  String get schedule_month7 => '7월';

  @override
  String get schedule_month8 => '8월';

  @override
  String get schedule_month9 => '9월';

  @override
  String get schedule_month10 => '10월';

  @override
  String get schedule_month11 => '11월';

  @override
  String get schedule_month12 => '12월';

  @override
  String get schedule_recurringEndCondition => '종료 조건';

  @override
  String get schedule_recurringEndNever => '종료 없음';

  @override
  String get schedule_recurringEndDate => '날짜까지';

  @override
  String get schedule_recurringEndCount => '횟수만큼';

  @override
  String get schedule_recurringCountTimes => '회 반복';

  @override
  String get schedule_searchHint => '제목, 설명, 장소로 검색';

  @override
  String get schedule_searchNoResults => '검색 결과가 없습니다';

  @override
  String schedule_searchResultCount(int count) {
    return '검색 결과 $count건';
  }

  @override
  String get todo_add => '할일 추가';

  @override
  String get todo_edit => '할일 수정';

  @override
  String get todo_delete => '할일 삭제';

  @override
  String get todo_detail => '할일 상세';

  @override
  String get todo_showCompleted => '완료 포함';

  @override
  String get todo_priority => '우선순위';

  @override
  String get todo_priorityLow => '낮음';

  @override
  String get todo_priorityMedium => '보통';

  @override
  String get todo_priorityHigh => '높음';

  @override
  String get todo_priorityUrgent => '긴급';

  @override
  String get todo_noTodos => '등록된 할일이 없습니다';

  @override
  String get todo_allCompleted => '모든 할일을 완료했습니다!';

  @override
  String get todo_loadError => '할일을 불러올 수 없습니다';

  @override
  String get todo_noDueDate => '마감일 없음';

  @override
  String get todo_viewKanban => '칸반 보드';

  @override
  String get todo_viewList => '리스트 보기';

  @override
  String get todo_statusPending => '대기중';

  @override
  String get todo_statusInProgress => '진행중';

  @override
  String get todo_statusCompleted => '완료';

  @override
  String get todo_statusHold => '보류';

  @override
  String get todo_statusDrop => '드롭';

  @override
  String get todo_statusFailed => '실패';

  @override
  String get todo_prevWeek => '이전 주';

  @override
  String get todo_nextWeek => '다음 주';

  @override
  String get todo_changeStatus => '상태 변경';

  @override
  String get todo_viewByDate => '날짜별 보기';

  @override
  String get todo_viewOverview => '모아 보기';

  @override
  String get todo_overviewOverdue => '지난 할일';

  @override
  String get todo_overviewToday => '오늘';

  @override
  String get todo_overviewTomorrow => '내일';

  @override
  String get todo_overviewThisWeek => '이번 주';

  @override
  String get todo_overviewNextWeek => '다음 주';

  @override
  String get todo_overviewLater => '그 이후';

  @override
  String get todo_overviewNoDueDate => '기한 없음';

  @override
  String get todo_filter => '필터';

  @override
  String get todo_filterAll => '전체';

  @override
  String get todo_filterStatus => '상태';

  @override
  String get todo_filterPriority => '우선순위';

  @override
  String get todo_sortBy => '정렬';

  @override
  String get todo_sortByStatus => '상태순';

  @override
  String get todo_sortByPriority => '우선순위순';

  @override
  String get todo_sortByDueDate => '마감일순';

  @override
  String get todo_sortByCreatedAt => '생성일순';

  @override
  String get todo_filterApplied => '필터 적용됨';

  @override
  String get todo_clearFilter => '필터 초기화';

  @override
  String get todo_filterTooltip => '할일 필터';

  @override
  String get todo_widgetTitleToday => '오늘의 할일';

  @override
  String get todo_widgetTitleWeek => '금주 할일';

  @override
  String get todo_widgetTitleMonth => '이번달 할일';

  @override
  String get todo_emptyToday => '오늘 할일이 없습니다';

  @override
  String get todo_emptyWeek => '이번 주 할일이 없습니다';

  @override
  String get todo_emptyMonth => '이번 달 할일이 없습니다';

  @override
  String get todo_searchHint => '할일 제목, 설명으로 검색';

  @override
  String get todo_searchNoResults => '검색 결과가 없습니다';

  @override
  String todo_searchResultCount(int count) {
    return '검색 결과 $count건';
  }

  @override
  String get memo_title => '메모';

  @override
  String get memo_list => '메모 목록';

  @override
  String get memo_detail => '메모 상세';

  @override
  String get memo_create => '메모 작성';

  @override
  String get memo_edit => '메모 수정';

  @override
  String get memo_delete => '메모 삭제';

  @override
  String get memo_content => '내용';

  @override
  String get memo_category => '카테고리';

  @override
  String get memo_categoryHint => '카테고리를 입력하세요 (선택사항)';

  @override
  String get memo_personal => '나만의 메모';

  @override
  String get memo_tags => '태그';

  @override
  String get memo_tagsHint => '태그를 추가하세요';

  @override
  String get memo_author => '작성자';

  @override
  String get memo_createdAt => '작성일';

  @override
  String get memo_updatedAt => '수정일';

  @override
  String get memo_createSuccess => '메모가 작성되었습니다';

  @override
  String get memo_createError => '메모 작성에 실패했습니다';

  @override
  String get memo_updateSuccess => '메모가 수정되었습니다';

  @override
  String get memo_updateError => '메모 수정에 실패했습니다';

  @override
  String get memo_deleteSuccess => '메모가 삭제되었습니다';

  @override
  String get memo_deleteError => '메모 삭제에 실패했습니다';

  @override
  String get memo_deleteDialogTitle => '메모 삭제';

  @override
  String get memo_deleteDialogMessage => '이 메모를 삭제하시겠습니까?\n삭제된 메모는 복구할 수 없습니다.';

  @override
  String get memo_loadError => '메모를 불러올 수 없습니다';

  @override
  String get memo_empty => '작성된 메모가 없습니다';

  @override
  String get memo_titleHint => '메모 제목을 입력하세요';

  @override
  String get memo_contentHint => '메모 내용을 입력하세요';

  @override
  String get memo_titleRequired => '제목을 입력해주세요';

  @override
  String get memo_titleMinLength => '제목은 최소 2자 이상 입력해주세요';

  @override
  String get memo_contentRequired => '내용을 입력해주세요';

  @override
  String get memo_searchHint => '제목, 내용으로 검색';

  @override
  String get memo_searchNoResults => '검색 결과가 없습니다';

  @override
  String get memo_tagAdd => '태그 추가';

  @override
  String get memo_tagName => '태그 이름';

  @override
  String get memo_tagNameHint => '태그 이름을 입력하세요';

  @override
  String get memo_visibility => '공개 범위';

  @override
  String get memo_visibilityPrivate => '나만 보기';

  @override
  String get memo_visibilityGroup => '특정 그룹';

  @override
  String get memo_groupSelect => '그룹 선택';

  @override
  String get memo_typeNote => '일반 메모';

  @override
  String get memo_typeChecklist => '체크리스트';

  @override
  String get memo_typeSelect => '메모 유형';

  @override
  String get memo_checklist => '체크리스트';

  @override
  String get memo_checklistAdd => '항목 추가';

  @override
  String get memo_checklistAddHint => '새 항목을 입력하세요';

  @override
  String get memo_checklistEmpty => '체크리스트 항목이 없습니다';

  @override
  String get memo_checklistReset => '전체 해제';

  @override
  String get memo_duplicate => '복사';

  @override
  String get memo_checklistSelectAll => '전체 선택';

  @override
  String get memo_checklistDeleteItem => '항목 삭제';

  @override
  String get memo_checklistEditItem => '항목 수정';

  @override
  String memo_checklistProgress(int checked, int total) {
    return '$checked/$total 완료';
  }

  @override
  String get household_title => '가계부';

  @override
  String get household_expense => '지출';

  @override
  String get household_no_group_selected => '그룹을 선택해주세요';

  @override
  String get household_personal_mode => '개인';

  @override
  String get household_add_expense => '지출 추가';

  @override
  String get household_view_shopping_history => '장보기 기록 보기';

  @override
  String get household_edit_expense => '지출 수정';

  @override
  String get household_refund => '환불 등록';

  @override
  String get household_refund_badge => '환불됨';

  @override
  String get household_refund_origin_badge => '환불';

  @override
  String get household_refund_amount_label => '환불 금액';

  @override
  String get household_refund_origin_label => '원본 지출';

  @override
  String get household_view_refund_origin => '원본 지출 보기';

  @override
  String get household_refund_total => '총 환불';

  @override
  String get household_delete_expense => '지출 삭제';

  @override
  String get household_delete_confirm => '지출을 삭제하시겠습니까?';

  @override
  String get household_amount => '금액';

  @override
  String get household_category => '카테고리';

  @override
  String get household_payment_method => '결제 수단';

  @override
  String get household_description => '내용';

  @override
  String get household_date => '날짜';

  @override
  String get household_recurring => '고정 지출';

  @override
  String get household_total_income => '총 입금';

  @override
  String get household_total_expense => '총 지출';

  @override
  String get household_balance => '잔액';

  @override
  String get household_carry_over => '이월';

  @override
  String get household_carry_over_title => '잔금 이월';

  @override
  String household_carry_over_desc(String amount) {
    return '이번 달 잔금 ₩$amount을 다음 달로 이월합니다.\n\n· 이번 달 말일에 \'잔금 이월\' (자산이동) 지출이 등록됩니다.\n· 다음 달 1일에 \'전월 이월\' 입금이 등록됩니다.';
  }

  @override
  String get household_carry_over_success => '이월이 완료되었습니다';

  @override
  String get household_carry_over_no_balance => '이월할 잔금이 없습니다';

  @override
  String get household_balance_transfer => '잔금 이동';

  @override
  String get household_carry_over_mode_next_month => '다음 달 이월';

  @override
  String get household_carry_over_mode_asset => '자산 계좌';

  @override
  String get household_carry_over_mode_savings => '저금통';

  @override
  String get household_carry_over_amount_label => '금액';

  @override
  String get household_carry_over_amount_exceeded => '잔금을 초과할 수 없습니다';

  @override
  String get household_carry_over_select_account => '계좌를 선택하세요';

  @override
  String get household_carry_over_select_savings => '저금통을 선택하세요';

  @override
  String get household_carry_over_no_accounts => '등록된 계좌가 없습니다';

  @override
  String get household_carry_over_no_savings => '등록된 저금통이 없습니다';

  @override
  String get household_transfer_success => '자산 이동이 완료되었습니다';

  @override
  String get household_income => '입금';

  @override
  String get household_revenue => '수입';

  @override
  String get household_type => '유형';

  @override
  String get household_total_budget => '총 예산';

  @override
  String get household_statistics => '통계';

  @override
  String get household_monthly_statistics => '월간 통계';

  @override
  String get household_no_expenses => '지출 내역이 없습니다';

  @override
  String get household_category_food => '식비';

  @override
  String get household_category_transport => '교통비';

  @override
  String get household_category_leisure => '여가비';

  @override
  String get household_category_living => '생활비';

  @override
  String get household_category_health => '의료비';

  @override
  String get household_category_education => '교육비';

  @override
  String get household_category_clothing => '의류비';

  @override
  String get household_category_allowance => '용돈';

  @override
  String get household_category_celebration => '경조사비';

  @override
  String get household_category_asset_transfer => '자산이동';

  @override
  String get household_category_carryover => '이월';

  @override
  String get household_category_childcare => '육아비';

  @override
  String get household_category_communication => '통신비';

  @override
  String get household_category_groceries => '장보기';

  @override
  String get household_category_other => '기타';

  @override
  String get household_income_category => '입금 종류';

  @override
  String get household_income_category_salary => '월급';

  @override
  String get household_income_category_allowance => '용돈';

  @override
  String get household_income_category_carryover => '이월';

  @override
  String get household_income_category_bonus => '상여금';

  @override
  String get household_income_category_interest => '이자 수익';

  @override
  String get household_income_category_rental => '임대 수익';

  @override
  String get household_income_category_side_income => '부업';

  @override
  String get household_income_category_transfer_in => '계좌이체';

  @override
  String get household_income_category_other => '기타 수입';

  @override
  String get household_payment_cash => '현금';

  @override
  String get household_payment_card => '카드';

  @override
  String get household_payment_transfer => '이체';

  @override
  String get household_payment_other => '기타';

  @override
  String get household_budget_settings => '예산 설정';

  @override
  String get household_budget_amount => '예산 금액';

  @override
  String get household_set_budget => '예산 설정';

  @override
  String get household_amount_hint => '금액을 입력하세요';

  @override
  String get household_description_hint => '내용을 입력하세요';

  @override
  String get household_amount_required => '금액을 입력해주세요';

  @override
  String get household_save_success => '저장되었습니다';

  @override
  String get household_delete_success => '삭제되었습니다';

  @override
  String get household_budget_saved => '예산이 설정되었습니다';

  @override
  String get household_recurring_expenses => '고정 지출';

  @override
  String get household_recurring_no_expenses => '고정 지출이 없습니다';

  @override
  String get household_recurring_total => '월 합계';

  @override
  String get household_recurring_count => '항목 수';

  @override
  String household_recurring_count_unit(int count) {
    return '$count건';
  }

  @override
  String get household_recurring_expense_total => '지출 합계';

  @override
  String get household_recurring_income_total => '수입 합계';

  @override
  String household_unpaid_recurring_expense(int count, String amount) {
    return '지출 $count건 · ₩$amount';
  }

  @override
  String household_unpaid_recurring_income(int count, String amount) {
    return '수입 $count건 · ₩$amount';
  }

  @override
  String get household_recurring_top_category => '카테고리별 분포';

  @override
  String get household_recurring_fixed => '고정';

  @override
  String get household_recurring_variable => '가변';

  @override
  String get household_recurring_type_label => '고정 지출 유형';

  @override
  String get household_recurring_type_none => '없음';

  @override
  String get household_recurring_type_fixed => '고정 금액';

  @override
  String get household_recurring_type_fixed_desc => '매월 동일한 금액이 반영됩니다';

  @override
  String get household_recurring_type_variable => '가변 금액';

  @override
  String get household_recurring_type_variable_desc =>
      '매월 발생하지만 금액이 달라집니다 (예: 관리비)';

  @override
  String get household_recurring_amount_variable_label => '기준 금액 (예상)';

  @override
  String get household_recurring_amount_variable_hint =>
      '매월 금액이 다를 수 있습니다. 실제 지출 발생 후 수정해 확정해주세요.';

  @override
  String get household_recurring_amount_fixed_hint => '매월 이 금액으로 자동 등록됩니다.';

  @override
  String get household_recurring_inactive => '비활성';

  @override
  String get household_recurring_add => '고정지출 추가';

  @override
  String get household_recurring_edit => '고정지출 수정';

  @override
  String get household_recurring_title => '고정 내역';

  @override
  String get household_recurring_add_title => '고정 내역 추가';

  @override
  String get household_recurring_edit_title => '고정 내역 수정';

  @override
  String get household_recurring_day_of_month => '매달 발생 일';

  @override
  String household_recurring_day_of_month_value(int day) {
    return '매월 $day일';
  }

  @override
  String get household_recurring_backfill_toggle => '이전 지출도 등록하기';

  @override
  String get household_recurring_backfill_hint =>
      '시작 월을 선택하면 오늘까지의 지출 내역이 함께 생성돼요';

  @override
  String get household_recurring_start_month => '시작 월';

  @override
  String get household_recurring_end_option => '반복 종료';

  @override
  String get household_recurring_end_indefinite => '무기한';

  @override
  String get household_recurring_end_fixed_months => '개월 수 지정';

  @override
  String get household_recurring_total_months_label => '총 개월 수';

  @override
  String get household_recurring_total_months_hint => '예: 24';

  @override
  String get household_recurring_total_months_required => '개월 수를 입력해주세요';

  @override
  String household_recurring_end_date_info(
    String endMonth,
    int current,
    int total,
  ) {
    return '$endMonth까지 ($current/$total개월차)';
  }

  @override
  String get household_recurring_indefinite => '무기한 반복';

  @override
  String get household_recurring_edit_backfill_notice =>
      '시작 월/개월 수를 변경해도 과거 지출은 다시 생성되지 않아요. 소급 생성은 등록 시에만 적용됩니다.';

  @override
  String get household_estimated_amount => '예상 금액';

  @override
  String get household_estimated_amount_hint => '이번 달 예상 금액을 입력하세요';

  @override
  String get household_estimated_amount_required => '예상 금액을 입력해주세요';

  @override
  String get household_variable_badge => '가변';

  @override
  String get household_unconfirmed_badge => '미확인';

  @override
  String get household_exclude_refunds => '환불 제외';

  @override
  String get household_exclude_carryover => '이월 제외';

  @override
  String get household_unpaid_recurring_title => '이번 달 남은 고정 내역';

  @override
  String household_unpaid_recurring_subtitle(int count, String amount) {
    return '$count건 · 예상 합계 ₩$amount';
  }

  @override
  String get household_merchants => '소비처 관리';

  @override
  String get household_merchants_my => '내 소비처';

  @override
  String get household_merchants_samples => '자주 쓰는 소비처';

  @override
  String get household_merchants_empty => '등록된 소비처가 없습니다';

  @override
  String get household_merchants_add => '소비처 추가';

  @override
  String get household_merchants_edit => '소비처 수정';

  @override
  String get household_merchants_name => '소비처 이름';

  @override
  String get household_merchants_delete => '소비처 삭제';

  @override
  String household_merchants_delete_confirm(String name) {
    return '\"$name\" 소비처를 삭제할까요?';
  }

  @override
  String get household_merchant_select => '소비처 선택';

  @override
  String get household_merchant_none => '없음';

  @override
  String get household_budget_set => '예산 설정';

  @override
  String get household_budget_total_label => '전체 예산';

  @override
  String get household_budget_category_label => '카테고리별 예산';

  @override
  String get household_budget_not_set => '미설정';

  @override
  String get household_budget_tab_monthly => '이번 달 예산';

  @override
  String get household_budget_tab_template => '매월 자동 예산';

  @override
  String get household_budget_template_info =>
      '매월 1일에 템플릿 기반으로 예산이 자동 설정됩니다. 해당 월에 이미 예산이 있으면 건너뜁니다.';

  @override
  String get household_budget_template_saved => '자동 예산 템플릿이 설정되었습니다';

  @override
  String get household_budget_template_delete_title => '템플릿 삭제';

  @override
  String get household_budget_template_delete_confirm =>
      '이 카테고리의 자동 예산 템플릿을 삭제하시겠습니까?';

  @override
  String get household_budget_template_deleted => '자동 예산 템플릿이 삭제되었습니다';

  @override
  String household_budget_category_sum_exceeds(String sum, String total) {
    return '카테고리 예산 합계(₩$sum)가 전체 예산(₩$total)을 초과합니다';
  }

  @override
  String household_budget_category_sum(String amount) {
    return '합계 ₩$amount';
  }

  @override
  String get asset_title => '자산관리';

  @override
  String get asset_statistics => '통계';

  @override
  String get asset_no_group_selected => '그룹을 선택해주세요';

  @override
  String get asset_no_accounts => '등록된 계좌가 없습니다';

  @override
  String get asset_total_balance => '총 잔액';

  @override
  String get asset_total_principal => '총 원금';

  @override
  String get asset_total_profit => '총 수익금';

  @override
  String get asset_profit_rate => '수익률';

  @override
  String get asset_account_name => '계좌명';

  @override
  String get asset_account_name_hint => '예) 주택청약';

  @override
  String get asset_account_name_required => '계좌명을 입력해주세요';

  @override
  String get asset_institution => '금융기관';

  @override
  String get asset_institution_hint => '예) 국민은행';

  @override
  String get asset_institution_required => '금융기관명을 입력해주세요';

  @override
  String get asset_account_number => '계좌번호 (선택)';

  @override
  String get asset_account_number_hint => '예) 123-456-789';

  @override
  String get asset_account_type => '계좌 유형';

  @override
  String get asset_type_savings => '적금';

  @override
  String get asset_type_deposit => '예금';

  @override
  String get asset_type_stock => '주식';

  @override
  String get asset_type_fund => '펀드';

  @override
  String get asset_type_real_estate => '부동산';

  @override
  String get asset_type_gold => '실물 금';

  @override
  String get asset_type_other => '기타';

  @override
  String get asset_gold_gram_weight => '보유 중량';

  @override
  String get asset_gold_gram_weight_hint => '예: 37.5';

  @override
  String get asset_gold_unit_gram => 'g (그램)';

  @override
  String get asset_gold_unit_don => '돈';

  @override
  String get asset_gold_don_hint => '예: 10';

  @override
  String get asset_gold_gram_converted => 'g 환산';

  @override
  String get asset_gold_estimated_principal => '예상 원금';

  @override
  String get asset_gold_gram_weight_required => '보유 중량을 입력해 주세요';

  @override
  String get asset_gold_gram_weight_invalid => '유효한 숫자를 입력해 주세요';

  @override
  String get asset_gold_current_price_label => '현재 금 시세';

  @override
  String get asset_gold_price_loading => '금 시세 조회 중…';

  @override
  String get asset_gold_price_error => '금 시세를 불러올 수 없습니다';

  @override
  String get asset_add_account => '계좌 추가';

  @override
  String get asset_edit_account => '계좌 수정';

  @override
  String get asset_delete_account => '계좌 삭제';

  @override
  String get asset_delete_account_confirm =>
      '이 계좌를 삭제하시겠습니까?\n관련된 모든 기록도 함께 삭제됩니다.';

  @override
  String get asset_delete_success => '삭제되었습니다';

  @override
  String get asset_save_success => '저장되었습니다';

  @override
  String get asset_account_detail => '계좌 상세';

  @override
  String get asset_records => '자산 기록';

  @override
  String get asset_holdings => '포트폴리오 비중';

  @override
  String get asset_holdings_empty => '등록된 종목이 없습니다';

  @override
  String get asset_holding_add => '종목 추가';

  @override
  String get asset_holding_edit => '종목 수정';

  @override
  String get asset_holding_delete => '종목 삭제';

  @override
  String get asset_holding_name => '종목명';

  @override
  String get asset_holding_name_hint => '예: 나스닥 ETF';

  @override
  String get asset_holding_name_required => '종목명을 입력해 주세요';

  @override
  String get asset_holding_ticker => '티커 (선택)';

  @override
  String get asset_holding_ticker_hint => '예: QQQ';

  @override
  String get asset_holding_ratio => '비율 (%)';

  @override
  String get asset_holding_ratio_hint => '예: 40';

  @override
  String get asset_holding_ratio_required => '비율을 입력해 주세요';

  @override
  String get asset_holding_ratio_invalid => '0.01 ~ 100 사이의 숫자를 입력해 주세요';

  @override
  String get asset_holding_ratio_exceeded => '비율 합계가 100%를 초과합니다';

  @override
  String get asset_holding_delete_confirm => '이 종목을 삭제하시겠습니까?';

  @override
  String get asset_holding_total_ratio => '합계';

  @override
  String get asset_gold_record_info_title => '금 계좌 자동 관리 안내';

  @override
  String get asset_gold_record_info_body =>
      '이 계좌는 실물 금(現物金) 계좌로, 아래와 같이 자동 관리됩니다.\n\n• 기록 추가 시 현재 금 현물 시세(GOLD_KRW_SPOT)를 기준으로 보유 중량 × 시세 = 잔액이 자동 계산됩니다.\n\n• 매달 1일, 최신 금 현물 시세를 반영하여 잔액·수익금·수익률이 자동으로 갱신됩니다.\n\n• 원금은 직접 수정할 수 있으며, 수정하지 않으면 처음 기록 시 계산된 값이 유지됩니다.';

  @override
  String get asset_no_records => '기록이 없습니다';

  @override
  String get asset_add_record => '기록 추가';

  @override
  String get asset_record_date => '기록 날짜';

  @override
  String get asset_balance => '잔액';

  @override
  String get asset_principal => '원금';

  @override
  String get asset_profit => '수익금';

  @override
  String get asset_note => '메모 (선택)';

  @override
  String get asset_note_hint => '예) 이자 입금';

  @override
  String get asset_amount_hint => '금액을 입력하세요';

  @override
  String get asset_amount_required => '금액을 입력해주세요';

  @override
  String get asset_record_date_required => '기록 날짜를 선택해주세요';

  @override
  String get asset_record_save_success => '기록이 저장되었습니다';

  @override
  String get asset_statistics_title => '자산 통계';

  @override
  String get asset_by_type => '유형별 현황';

  @override
  String asset_account_count(int count) {
    return '$count개 계좌';
  }

  @override
  String get asset_savings_total => '저금통 합계';

  @override
  String get asset_savings_goals => '연동된 저금통';

  @override
  String get asset_trend => '자산 추이';

  @override
  String get asset_trend_monthly => '월별';

  @override
  String get asset_trend_yearly => '연도별';

  @override
  String get asset_trend_balance => '잔액';

  @override
  String get asset_trend_profit_rate => '수익률';

  @override
  String get asset_trend_period_return => '기간별';

  @override
  String get asset_trend_no_data => '표시할 데이터가 없습니다';

  @override
  String asset_trend_year_label(String year) {
    return '$year년';
  }

  @override
  String get asset_input_mode => '입력 방식';

  @override
  String get asset_input_mode_manual => '직접 입력';

  @override
  String get asset_input_mode_auto => '자동 계산';

  @override
  String get asset_additional_principal => '추가 원금';

  @override
  String get asset_additional_principal_hint => '첫 기록이면 초기 원금 전체를 입력하세요';

  @override
  String get asset_current_balance => '현재 잔액';

  @override
  String get asset_duplicate_date_error => '해당 날짜에 이미 기록이 존재합니다';

  @override
  String get asset_delete_record => '기록 삭제';

  @override
  String get asset_delete_record_confirm => '이 기록을 삭제하시겠습니까?';

  @override
  String get asset_stat_account_filter => '계좌 필터';

  @override
  String get asset_stat_filter_all => '전체';

  @override
  String get asset_trend_principal => '원금';

  @override
  String get asset_trend_profit => '수익금';

  @override
  String get asset_pie_chart_title => '계좌별 비중';

  @override
  String get asset_pie_mode_type => '유형별';

  @override
  String get asset_pie_mode_account => '계좌별';

  @override
  String get asset_pie_mode_portfolio => '포트폴리오 합산';

  @override
  String get asset_pie_no_portfolio => '포트폴리오 데이터가 없습니다';

  @override
  String get asset_compare_my_asset => '내 자산';

  @override
  String get asset_compare_usd_label => '달러 환산';

  @override
  String get asset_compare_button => '비교';

  @override
  String get childcare_title => '육아포인트';

  @override
  String get childcare_accounts => '자녀 계정';

  @override
  String get childcare_add_account => '계정 추가';

  @override
  String get childcare_balance => '포인트 잔액';

  @override
  String get childcare_monthly_allowance => '월 용돈';

  @override
  String get childcare_savings_balance => '적금 잔액';

  @override
  String get childcare_savings_interest_rate => '적금 이자율';

  @override
  String get childcare_tab_points => '포인트';

  @override
  String get childcare_tab_rewards => '상점';

  @override
  String get childcare_tab_rules => '규칙';

  @override
  String get childcare_tab_history => '히스토리';

  @override
  String get childcare_add_transaction => '포인트 지급/차감';

  @override
  String get childcare_add_reward => '보상 추가';

  @override
  String get childcare_add_rule => '규칙 추가';

  @override
  String get childcare_transaction_type_earn => '포인트 적립';

  @override
  String get childcare_transaction_type_spend => '포인트 사용';

  @override
  String get childcare_transaction_type_penalty => '규칙 위반 차감';

  @override
  String get childcare_transaction_type_monthly => '월 용돈 지급';

  @override
  String get childcare_transaction_type_savings_deposit => '적금 입금';

  @override
  String get childcare_transaction_type_savings_withdraw => '적금 출금';

  @override
  String get childcare_transaction_type_interest => '이자 지급';

  @override
  String childcare_reward_points_cost(int points) {
    return '$points포인트';
  }

  @override
  String childcare_rule_penalty(int penalty) {
    return '차감 $penalty포인트';
  }

  @override
  String get childcare_savings_deposit => '적금 입금';

  @override
  String get childcare_savings_withdraw => '적금 출금';

  @override
  String get childcare_empty_accounts => '자녀 계정이 없습니다.\n계정을 추가해보세요.';

  @override
  String get childcare_empty_transactions => '거래 내역이 없습니다.';

  @override
  String get childcare_empty_rewards => '보상 항목이 없습니다.\n보상을 추가해보세요.';

  @override
  String get childcare_empty_rules => '규칙이 없습니다.\n규칙을 추가해보세요.';

  @override
  String get childcare_account_child_id => '자녀 ID';

  @override
  String get childcare_account_monthly_allowance => '월 용돈 포인트';

  @override
  String get childcare_account_savings_rate => '적금 이자율 (%)';

  @override
  String get childcare_transaction_amount => '포인트 금액';

  @override
  String get childcare_transaction_description => '설명';

  @override
  String get childcare_transaction_type => '거래 유형';

  @override
  String get childcare_reward_name => '보상 이름';

  @override
  String get childcare_reward_description => '보상 설명 (선택)';

  @override
  String get childcare_reward_points => '포인트 비용';

  @override
  String get childcare_rule_name => '규칙 이름';

  @override
  String get childcare_rule_description => '규칙 설명 (선택)';

  @override
  String get childcare_rule_penalty_points => '차감 포인트';

  @override
  String get childcare_savings_amount => '금액';

  @override
  String get childcare_delete_confirm => '삭제하시겠습니까?';

  @override
  String get childcare_select_group => '그룹을 선택해주세요';

  @override
  String get childcare_no_group => '그룹에 참여하면 육아포인트를 사용할 수 있습니다.';

  @override
  String get childcare_no_child => '등록된 자녀가 없습니다.\n오른쪽 상단 버튼으로 자녀를 등록해보세요.';

  @override
  String get household_settings_title => '가계부 설정';

  @override
  String get household_settings_group_section => '대표 그룹';

  @override
  String get household_settings_auto_section => '푸시 자동 등록';

  @override
  String get household_settings_auto_toggle => '결제 알림 자동 등록';

  @override
  String get household_settings_auto_toggle_desc =>
      '카드·은행 결제 알림을 감지해 가계부에 자동으로 기록합니다';

  @override
  String get household_settings_permission_required =>
      '알림 접근 권한이 필요합니다. \'허용\'을 눌러 설정 화면에서 권한을 부여해주세요.';

  @override
  String get household_settings_permission_grant => '허용';

  @override
  String get household_settings_privacy_section => '개인정보 처리방침';

  @override
  String get household_settings_privacy_title => '수집 정보 및 처리 방침 확인';

  @override
  String get household_settings_privacy_subtitle =>
      '푸시 자동 등록 기능이 수집하는 정보를 확인합니다';

  @override
  String get household_settings_privacy_dialog_title => '개인정보 처리방침';

  @override
  String get household_settings_auto_scope_notice =>
      '앱이 실행 중(포그라운드·백그라운드)일 때만 동작합니다. 앱을 완전히 종료하면 자동 등록이 중단됩니다.';

  @override
  String get household_settings_privacy_content =>
      '■ 수집하는 정보\n앱은 기기에 표시되는 알림 중 카드사·은행 앱에서 발송된 결제 완료 알림의 아래 정보를 일시적으로 읽습니다.\n  · 알림 제목 및 본문 텍스트 (예: \"KB카드 12,000원 승인\")\n  · 알림을 보낸 앱 패키지명 (예: com.kbcard.kbkookmincard)\n\n■ 수집 목적\n읽은 알림 텍스트에서 결제 금액·결제 수단·카테고리를 추출하여 가계부에 자동으로 기록하는 데에만 사용됩니다.\n\n■ 보관 및 파기\n알림 텍스트는 기기 내에서 즉시 파싱 후 파기되며, 원문은 서버로 전송되거나 저장되지 않습니다. 가계부 항목으로 변환된 데이터만 회원 계정에 저장됩니다.\n\n■ 제3자 제공\n수집한 알림 정보는 어떠한 제3자에게도 제공·판매·공유되지 않습니다.\n\n■ 권한 철회\n언제든지 본 설정 화면에서 자동 등록을 끄거나, 기기 설정 > 알림 접근 권한에서 Family Planner의 권한을 해제할 수 있습니다.';

  @override
  String get fridge_title => '냉장고';

  @override
  String get shopping_title => '장보기';

  @override
  String get fridge_tab_fridge => '냉장고';

  @override
  String get fridge_tab_cart => '장바구니';

  @override
  String get fridge_tab_frequent => '자주 사는 것';

  @override
  String get fridge_tab_history => '구매 이력';

  @override
  String get fridge_storage_add => '보관소 추가';

  @override
  String get fridge_storage_edit => '보관소 수정';

  @override
  String get fridge_storage_delete => '보관소 삭제';

  @override
  String get fridge_storage_delete_confirm =>
      '보관소를 삭제하면 안에 있는 모든 품목도 함께 삭제됩니다. 계속하시겠습니까?';

  @override
  String get fridge_storage_name_hint => '예: 우리집 냉장고';

  @override
  String get fridge_storage_type_fridge => '냉장';

  @override
  String get fridge_storage_type_freezer => '냉동';

  @override
  String get fridge_storage_type_pantry => '팬트리';

  @override
  String get fridge_item_add => '품목 추가';

  @override
  String get fridge_item_edit => '품목 수정';

  @override
  String get fridge_item_delete_title => '품목 삭제';

  @override
  String fridge_item_delete_confirm(String name) {
    return '$name을(를) 삭제하시겠습니까?';
  }

  @override
  String get fridge_item_name => '품목명';

  @override
  String get fridge_item_quantity => '수량';

  @override
  String get fridge_item_unit => '단위 (선택)';

  @override
  String get fridge_item_expires_at => '유통기한 (선택)';

  @override
  String fridge_item_alert_days(int days) {
    return '만료 $days일 전 알림';
  }

  @override
  String get fridge_item_memo => '메모 (선택)';

  @override
  String get fridge_item_dday_today => 'D-Day';

  @override
  String fridge_item_dday_expired(int days) {
    return 'D+$days';
  }

  @override
  String fridge_item_dday_remaining(int days) {
    return 'D-$days';
  }

  @override
  String get fridge_item_no_expiry => '유통기한 없음';

  @override
  String get fridge_empty_storage => '보관소가 없습니다. 추가해보세요.';

  @override
  String get fridge_empty_items => '품목이 없습니다';

  @override
  String get fridge_item_count => '개';

  @override
  String get fridge_sort_expiry => '유통기한순';

  @override
  String get fridge_sort_name => '이름순';

  @override
  String get fridge_sort_registered => '등록순';

  @override
  String get fridge_item_elapsed_days => '일';

  @override
  String get fridge_frequent_add => '항목 추가';

  @override
  String get fridge_frequent_auto_add => '소진 시 자동 장바구니';

  @override
  String get fridge_frequent_empty => '자주 사는 항목이 없습니다';

  @override
  String get fridge_frequent_add_to_cart => '장바구니에 추가';

  @override
  String fridge_frequent_added_snackbar(String name) {
    return '$name을(를) 장바구니에 추가했습니다';
  }

  @override
  String fridge_frequent_delete_confirm(String name) {
    return '$name을(를) 삭제하시겠습니까?';
  }

  @override
  String get fridge_frequent_autoAddInfo_title => '자동 추가란?';

  @override
  String get fridge_frequent_autoAddInfo_body =>
      '냉장고에서 이 품목의 수량이 0이 되면 장바구니에 자동으로 추가돼요.\n스위치를 켜두면 냉장고가 비었을 때 알아서 장보기 목록에 담아드립니다.';

  @override
  String get fridge_frequent_autoAddInfo_hint => '냉장고 탭에서 수량을 관리하면 연동됩니다';

  @override
  String get fridge_frequent_coach_fabTitle => '자주 사는 항목 추가';

  @override
  String get fridge_frequent_coach_fabDesc =>
      '자주 구매하는 품목을 등록해 두면\n다음 장보기 때 빠르게 담을 수 있어요.';

  @override
  String get fridge_frequent_coach_itemTitle => '항목 관리';

  @override
  String get fridge_frequent_coach_itemDesc =>
      '품목명·기본 단위를 설정할 수 있어요.\n탭하면 수정, 길게 누르면 삭제할 수 있습니다.';

  @override
  String get fridge_frequent_coach_autoAddTitle => '자동 추가';

  @override
  String get fridge_frequent_coach_autoAddDesc =>
      '냉장고에서 이 품목의 수량이 0이 되면\n장바구니에 자동으로 추가돼요.\n냉장고 탭과 연동되는 스마트 기능이에요.';

  @override
  String get fridge_frequent_coach_addToCartTitle => '장바구니에 바로 담기';

  @override
  String get fridge_frequent_coach_addToCartDesc =>
      '버튼 하나로 현재 장바구니에\n즉시 추가할 수 있어요.';

  @override
  String get fridge_frequent_coach_skip => '건너뛰기';

  @override
  String get fridge_coach_fabTitle => '보관소 추가';

  @override
  String get fridge_coach_fabDesc =>
      '냉장고, 냉동실, 팬트리 등 보관 장소를 추가할 수 있어요.\n+ 버튼을 눌러 보관소를 만들어 보세요.';

  @override
  String get fridge_coach_sectionTitle => '보관소';

  @override
  String get fridge_coach_sectionDesc =>
      '헤더를 탭해 펼치고 접을 수 있어요.\n우측 메뉴(⋮)로 보관소를 수정하거나 삭제할 수 있어요.';

  @override
  String get fridge_coach_itemTitle => '품목 관리';

  @override
  String get fridge_coach_itemDesc =>
      '• 탭하면 이름·유통기한·메모를 수정할 수 있어요\n• ± 버튼으로 수량을 조절하세요\n• 왼쪽으로 스와이프하면 삭제 표시돼요\n• 변경 후 저장 버튼을 눌러야 반영됩니다';

  @override
  String get fridge_coach_ddayTitle => '유통기한 알림';

  @override
  String get fridge_coach_ddayDesc =>
      '품목에 유통기한을 등록하면 남은 일수가 표시돼요.\n• 파란색: 여유 있음\n• 주황색: 3일 이내 임박\n• 빨간색: 오늘 또는 이미 지남\n설정한 알림일 전에 푸시 알림도 받을 수 있어요.';

  @override
  String get fridge_coach_addItemTitle => '품목 추가';

  @override
  String get fridge_coach_addItemDesc =>
      '보관소 우측 + 버튼으로 품목을 추가해요.\n여러 품목을 한 번에 등록할 수 있고,\n유통기한·수량·단위·메모도 함께 입력할 수 있어요.';

  @override
  String get fridge_coach_suggestionTitle => '유통기한 자동 추천';

  @override
  String get fridge_coach_suggestionDesc =>
      '품목명을 입력하면 유통기한을 자동으로 추천해줘요.\n설정 > 유통기한 프리셋 관리에서 품목별 기준일을\n직접 추가·수정해 자동화 규칙을 커스터마이징할 수 있어요.';

  @override
  String get fridge_coach_skip => '건너뛰기';

  @override
  String get fridge_cart_empty => '장바구니가 비어 있습니다';

  @override
  String get fridge_cart_add_item => '품목 추가';

  @override
  String get fridge_cart_complete => '장보기 완료';

  @override
  String get fridge_cart_complete_title => '장보기 완료';

  @override
  String get fridge_cart_complete_step2_title => '냉장고 이관 상세 입력';

  @override
  String get fridge_cart_complete_transfer_hint => '냉장고로 이관할 보관소를 선택하세요';

  @override
  String get fridge_cart_complete_add_expense => '가계부에 등록';

  @override
  String get fridge_cart_complete_amount => '총액 (항목 금액 입력 시 자동 계산)';

  @override
  String get fridge_cart_item_price => '금액 (선택)';

  @override
  String get fridge_cart_complete_description => '메모 (선택)';

  @override
  String get fridge_cart_skip_transfer => '이관 안 함';

  @override
  String get fridge_history_empty => '구매 이력이 없습니다';

  @override
  String fridge_history_items_count(int count) {
    return '$count개 품목';
  }

  @override
  String get fridge_history_linked_expense => '가계부 연결됨';

  @override
  String get fridge_history_view_expense => '가계부 보기';

  @override
  String get fridge_history_delete => '이력 삭제';

  @override
  String get fridge_history_delete_confirm_title => '구매 이력 삭제';

  @override
  String get fridge_history_delete_confirm_body => '이 구매 이력을 삭제할까요?';

  @override
  String get fridge_history_delete_expense_notice =>
      '가계부에 연동된 지출은 장보기 이력을 삭제해도 가계부에 그대로 남아 있어요.';

  @override
  String get fridge_group_selector_personal => '개인';

  @override
  String fridge_expiry_suggestion_label(
    String keyword,
    String storageType,
    int days,
  ) {
    return '$keyword 기준 · $storageType $days일 추천';
  }

  @override
  String get fridge_expiry_apply => '추천 적용';

  @override
  String get fridge_expiry_manual => '직접 입력';

  @override
  String get fridge_expiry_change_reference => '다른 품목 기준으로 설정';

  @override
  String get fridge_expiry_reference_title => '유통기한 기준 품목 선택';

  @override
  String get fridge_expiry_reference_search => '품목 검색';

  @override
  String fridge_expiry_reference_days(int days) {
    return '$days일';
  }

  @override
  String get fridge_expiry_reference_empty => '검색 결과가 없습니다';

  @override
  String get fridge_preset_management_title => '유통기한 프리셋 관리';

  @override
  String get fridge_preset_management_menu => '유통기한 프리셋 관리';

  @override
  String get fridge_preset_edit_shortcut => '프리셋 편집';

  @override
  String fridge_preset_days_label(int days) {
    return '$days일';
  }

  @override
  String get fridge_preset_custom_badge => '커스텀';

  @override
  String get fridge_preset_reset_confirm => '기본값으로 초기화하시겠습니까?';

  @override
  String get fridge_preset_edit_dialog_title => '유통기한 수정';

  @override
  String get fridge_preset_add_dialog_title => '새 프리셋 등록';

  @override
  String get fridge_preset_days_input_label => '유통기한 (일)';

  @override
  String get fridge_preset_category_input_label => '카테고리';

  @override
  String get fridge_preset_storage_type_label => '보관 방법';

  @override
  String get fridge_preset_delete_confirm => '커스텀 설정을 삭제하고 기본값으로 되돌리겠습니까?';

  @override
  String get fridge_preset_search_hint => '카테고리 또는 품목 검색';

  @override
  String get dashboard_greetingMorning => '좋은 아침입니다';

  @override
  String get dashboard_greetingAfternoon => '좋은 오후입니다';

  @override
  String get dashboard_greetingEvening => '좋은 저녁입니다';

  @override
  String get dashboard_greetingSubtitle => '오늘도 좋은 하루 되세요!';

  @override
  String get dashboard_emptyWidgets => '표시할 위젯이 없습니다';

  @override
  String get dashboard_emptyWidgetsHint => '설정에서 위젯을 활성화하세요';

  @override
  String get dashboard_widgetSettings => '위젯 설정';

  @override
  String get dashboard_notifications => '알림';

  @override
  String get weather_widgetTitle => '오늘 날씨';

  @override
  String get weather_refresh => '날씨 새로고침';

  @override
  String get weather_detail => '자세히';

  @override
  String get weather_errorMessage => '날씨 정보를 불러올 수 없습니다';

  @override
  String get weather_dustFine => '미세';

  @override
  String get weather_dustUltraFine => '초미세';

  @override
  String get investment_widgetTitle => '투자 지표';

  @override
  String get investment_errorMessage => '데이터를 불러올 수 없습니다';

  @override
  String get investment_emptyBookmarks => '즐겨찾기한 지표가 없습니다';

  @override
  String get investment_screenTitle => '투자 지표';

  @override
  String get investment_bookmarkSection => '즐겨찾기';

  @override
  String get investment_bookmarkReorderHint => '(길게 눌러 순서 변경)';

  @override
  String get investment_allSection => '전체 지표';

  @override
  String get investment_noData => '지표 데이터가 없습니다';

  @override
  String get investment_loadError => '데이터를 불러오지 못했습니다';

  @override
  String get investment_retry => '다시 시도';

  @override
  String get investment_adminTooltip => '과거 데이터 초기화 (관리자)';

  @override
  String get investment_briefingTitle => 'AI 시황 브리핑';

  @override
  String investment_briefingError(String error) {
    return 'AI 브리핑 오류: $error';
  }

  @override
  String get investment_briefingMacro => '매크로';

  @override
  String get investment_briefingDomestic => '국내 시장';

  @override
  String get investment_briefingGlobal => '글로벌 시장';

  @override
  String investment_briefingUpdatedAt(String time) {
    return '업데이트: $time';
  }

  @override
  String get investment_adminDialogTitle => '과거 데이터 초기화';

  @override
  String get investment_adminDialogDesc =>
      'Yahoo/CoinGecko/BOK에서 과거 시세를 수집해 DB에 저장합니다.\n시간이 걸릴 수 있습니다.';

  @override
  String get investment_adminDaysLabel => '수집 일수 (1~3650)';

  @override
  String get investment_adminDaysSuffix => '일';

  @override
  String get investment_adminExecute => '초기화 실행';

  @override
  String get investment_adminResultTitle => '초기화 완료';

  @override
  String get investment_adminResultYahoo => 'Yahoo (주가/환율/원자재)';

  @override
  String get investment_adminResultCrypto => '암호화폐 (BTC/KRW)';

  @override
  String get investment_adminResultBond => '한국 채권';

  @override
  String get investment_adminResultGold => '국내 금값';

  @override
  String investment_adminResultCount(int count) {
    return '$count건';
  }

  @override
  String investment_adminInitError(String error) {
    return '초기화 실패: $error';
  }

  @override
  String get investment_adminLoading => '과거 데이터를 수집 중입니다...';

  @override
  String get investment_prevPrice => '전일 종가';

  @override
  String investment_spreadBadge(String value) {
    return '이격률 $value%';
  }

  @override
  String get investment_spreadPremium => '국제 환산가 대비 프리미엄';

  @override
  String get investment_spreadDiscount => '국제 환산가 대비 디스카운트';

  @override
  String get investment_chartTitle => '시세 추이';

  @override
  String investment_chartDayChip(int days) {
    return '$days일';
  }

  @override
  String get investment_chartYearChip => '1년';

  @override
  String get investment_chartLoadError => '차트를 불러올 수 없습니다';

  @override
  String get investment_chartNoData => '데이터가 없습니다';

  @override
  String investment_marketClosed(String date) {
    return '휴장 중 · 마지막 거래일: $date';
  }

  @override
  String get investment_spreadChartTitle => '이격률 추이';

  @override
  String get investment_spreadChartSubtitle => '(국제 환산가 대비)';

  @override
  String investment_spreadSummaryLabel(String label) {
    return '현재 국제 환산가 대비 $label';
  }

  @override
  String get investment_spreadPremiumLabel => '프리미엄';

  @override
  String get investment_spreadDiscountLabel => '디스카운트';

  @override
  String get investment_coachIndicatorTitle => '투자 지표';

  @override
  String get investment_coachIndicatorDesc =>
      '주요 주가지수, 환율, 원자재, 암호화폐 등\n실시간 지표를 한눈에 확인할 수 있어요.\n탭하면 상세 차트와 과거 추이를 볼 수 있어요.';

  @override
  String get investment_coachBookmarkTitle => '즐겨찾기';

  @override
  String get investment_coachBookmarkDesc =>
      '별표를 눌러 즐겨찾기에 추가하세요.\n즐겨찾기한 지표는 목록 상단에 고정되고\n홈 화면 대시보드 위젯에서 바로 확인할 수 있어요.';

  @override
  String get householdWidget_groupTooltip => '그룹 선택';

  @override
  String householdWidget_incomeLabel(String month) {
    return '$month 입금';
  }

  @override
  String householdWidget_expenseLabel(String month) {
    return '$month 지출';
  }

  @override
  String get householdWidget_balance => '잔액';

  @override
  String householdWidget_budget(String amount) {
    return '예산 $amount';
  }

  @override
  String householdWidget_budgetUsed(int percent) {
    return '$percent% 사용';
  }

  @override
  String householdWidget_budgetOver(String amount) {
    return '$amount 초과';
  }

  @override
  String householdWidget_budgetRemaining(String amount) {
    return '$amount 남음';
  }

  @override
  String get householdWidget_filterTitle => '필터 선택';

  @override
  String get householdWidget_filterPersonal => '개인';

  @override
  String get householdWidget_filterPersonalSub => '그룹 없이 개인 지출만';

  @override
  String get householdWidget_applyButton => '적용';

  @override
  String get householdWidget_categoryTitle => '카테고리별 지출';

  @override
  String householdWidget_categoryOver(String amount) {
    return '$amount 초과';
  }

  @override
  String householdWidget_categoryUsed(int percent) {
    return '$percent% 사용';
  }

  @override
  String get householdWidget_catTransportation => '교통';

  @override
  String get householdWidget_catFood => '식비';

  @override
  String get householdWidget_catLeisure => '여가';

  @override
  String get householdWidget_catLiving => '생활';

  @override
  String get householdWidget_catMedical => '의료';

  @override
  String get householdWidget_catEducation => '교육';

  @override
  String get householdWidget_catAllowance => '용돈';

  @override
  String get householdWidget_catCelebration => '경조사비';

  @override
  String get householdWidget_catAssetTransfer => '자산이동';

  @override
  String get householdWidget_catChildcare => '육아비';

  @override
  String get householdWidget_catOther => '기타';

  @override
  String get assetWidget_title => '자산 현황';

  @override
  String assetWidget_groupTitle(String groupName) {
    return '$groupName 자산';
  }

  @override
  String get assetWidget_groupTooltip => '그룹 선택';

  @override
  String get assetWidget_totalAsset => '총 자산';

  @override
  String get assetWidget_totalProfit => '총 수익';

  @override
  String get assetWidget_profitRate => '수익률';

  @override
  String get assetWidget_distribution => '자산 분포';

  @override
  String get assetWidget_groupPickerTitle => '그룹 선택';

  @override
  String get assetWidget_applyButton => '적용';

  @override
  String get assetWidget_typeSavings => '적금';

  @override
  String get assetWidget_typeDeposit => '예금';

  @override
  String get assetWidget_typeStock => '주식';

  @override
  String get assetWidget_typeFund => '펀드';

  @override
  String get assetWidget_typeRealEstate => '부동산';

  @override
  String get assetWidget_typeGold => '실물 금';

  @override
  String get assetWidget_typeOther => '기타';

  @override
  String get legal_termsOfService => '서비스 이용약관';

  @override
  String get legal_privacyPolicy => '개인정보 처리방침';

  @override
  String get legal_termsLastUpdated => '시행일: 2026년 6월 1일';

  @override
  String get legal_termsContact => '문의: hmn.corp.dev@gmail.com';

  @override
  String get legal_agreeToTerms => '서비스 이용약관';

  @override
  String get legal_agreeToPrivacy => '개인정보 처리방침';

  @override
  String get legal_required => '(필수)';

  @override
  String get legal_agreeAll => '전체 동의';

  @override
  String get legal_mustAgreeTerms => '서비스 이용약관에 동의해 주세요.';

  @override
  String get legal_mustAgreePrivacy => '개인정보 처리방침에 동의해 주세요.';

  @override
  String get legal_agreeAgeVerification => '만 14세 이상입니다 (필수)';

  @override
  String get legal_mustAgreeAgeVerification => '만 14세 이상인지 확인해 주세요.';

  @override
  String legal_socialLoginConsent(String termsLink, String privacyLink) {
    return '계속하면 서비스 $termsLink 및 $privacyLink에 동의하는 것으로 간주합니다.';
  }

  @override
  String get legal_terms_section1_title => '제1조 (목적)';

  @override
  String get legal_terms_section1_body =>
      '본 약관은 에이치엠엔 코퍼레이션(HMN Corporation)이 제공하는 Family Planner 서비스(이하 \"서비스\")의 이용과 관련하여 회사와 회원 간의 권리, 의무 및 책임 사항을 규정함을 목적으로 합니다.';

  @override
  String get legal_terms_section2_title => '제2조 (서비스의 내용)';

  @override
  String get legal_terms_section2_body =>
      '회사는 회원에게 다음과 같은 서비스를 제공합니다.\n• 가족 그룹 기반의 캘린더 및 할 일 공유\n• 구성원 간 자산 관리 및 내역 공유\n• 육아 보상(칭찬 스티커 등) 관리 시스템\n• AI 에이전트를 통한 대화, 일정 관리, 거시 경제/시장 브리핑 서비스\n• 기타 회사가 추가로 개발하거나 제휴 계약 등을 통해 제공하는 서비스';

  @override
  String get legal_terms_section3_title => '제3조 (회원의 의무)';

  @override
  String get legal_terms_section3_body =>
      '• 회원은 본 서비스의 AI 에이전트에게 불법적이거나 타인에게 위해를 가할 수 있는 프롬프트를 입력해서는 안 됩니다.\n• 회원은 가족 그룹 초대 코드 및 계정 정보를 안전하게 관리할 책임이 있습니다.\n• 서비스 내 자산 관리 및 시장 브리핑 기능은 참고용 데이터 제공을 목적으로 하며, 회사는 이를 통한 투자 결과에 대해 법적 책임을 지지 않습니다.';

  @override
  String get legal_terms_section4_title => '제4조 (게시물의 저작권 및 관리)';

  @override
  String get legal_terms_section4_body =>
      '• 회원이 서비스 내에 게시한 정보(채팅, 일정, 자산 정보 등)의 저작권은 해당 회원에게 있습니다.\n• 회사는 회원의 게시물을 서비스 운영, 개선(AI 기능 고도화 등), 홍보의 목적으로만 활용하며, 개인을 식별할 수 없는 형태로 비식별화하여 사용합니다.';

  @override
  String get legal_terms_section5_title => '제5조 (서비스의 중단 및 변경)';

  @override
  String get legal_terms_section5_body =>
      '회사는 운영상, 기술상의 필요에 따라 제공하고 있는 서비스의 전부 또는 일부를 변경하거나 중단할 수 있으며, 이 경우 사전에 공지합니다.';

  @override
  String get legal_terms_section6_title => '제6조 (책임 제한)';

  @override
  String get legal_terms_section6_body =>
      '회사는 천재지변, 서버 제공 업체의 장애, 제3자 AI API 서비스의 장애 등 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다.';

  @override
  String get legal_terms_section7_title => '제7조 (시행일)';

  @override
  String get legal_terms_section7_body => '본 약관은 2026년 6월 1일부터 적용됩니다.';

  @override
  String get legal_privacy_section1_title => '1. 개인정보의 처리 목적';

  @override
  String get legal_privacy_section1_body =>
      '에이치엠엔 코퍼레이션(HMN Corporation)(이하 \'회사\')은 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.\n• 회원 가입 및 관리, 가족 그룹(초대 코드 등) 식별\n• 서비스 제공 (캘린더, 할 일, 자산 관리, 육아 보상 시스템 등)\n• AI 에이전트(챗봇, 브리핑 등) 서비스 제공 및 품질 향상\n• 신규 서비스 개발 및 맞춤 서비스 제공';

  @override
  String get legal_privacy_section2_title => '2. 처리하는 개인정보 항목';

  @override
  String get legal_privacy_section2_body =>
      '회사는 서비스 제공을 위해 다음의 개인정보 항목을 처리하고 있습니다.\n• 필수항목: 이메일 주소, 비밀번호, 이름(또는 닉네임), 프로필 이미지\n• 서비스 이용 과정에서 수집되는 정보: 캘린더 일정, 할 일 목록, 자산 데이터, 가족 그룹 정보, AI와의 채팅 내역, 서비스 이용 기록, 기기 정보';

  @override
  String get legal_privacy_section3_title => '3. 개인정보의 제3자 제공 및 위탁';

  @override
  String get legal_privacy_section3_body =>
      '회사는 원활한 AI 서비스 제공(문맥 분석, 브리핑 생성 등)을 위해 입력된 데이터의 일부를 외부 AI 모델 API(예: OpenAI, Anthropic, Google 등)에 전송할 수 있습니다.\n단, 이 데이터는 서비스 제공 목적으로만 활용되며 모델 학습에 사용되지 않도록 조치합니다.';

  @override
  String get legal_privacy_section4_title => '4. 개인정보의 파기';

  @override
  String get legal_privacy_section4_body =>
      '회사는 원칙적으로 개인정보 처리 목적이 달성된 경우에는 지체 없이 해당 개인정보를 파기합니다.\n• 파기절차: 이용자가 회원탈퇴를 요청하는 경우, 수집된 정보는 즉시 또는 법령에 따른 보존 기간 경과 후 파기됩니다.\n• 파기방법: 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다.';

  @override
  String get legal_privacy_section5_title => '5. 정보주체의 권리 및 행사 방법';

  @override
  String get legal_privacy_section5_body =>
      '이용자는 언제든지 자신의 개인정보를 조회하거나 수정할 수 있으며, 회원 탈퇴를 통해 개인정보의 수집 및 이용 동의를 철회할 수 있습니다.';

  @override
  String get legal_privacy_section6_title => '6. 개인정보 보호책임자';

  @override
  String get legal_privacy_section6_body =>
      '성명: 유영진\n이메일: hmn.corp.dev@gmail.com';

  @override
  String get legal_privacy_section7_title => '7. 시행일';

  @override
  String get legal_privacy_section7_body => '본 개인정보 처리방침은 2026년 6월 1일부터 적용됩니다.';

  @override
  String get legal_privacyLastUpdated => '시행일: 2026년 6월 1일';

  @override
  String get shopping_history_delete_title => '구매 이력 삭제';

  @override
  String get shopping_history_delete_body => '이 장보기 기록을 삭제하시겠습니까?';

  @override
  String get shopping_history_delete_notice =>
      '가계부 지출 내역과 냉장고 보관 품목은 삭제되지 않고 유지됩니다.';

  @override
  String get shopping_history_readd_all => '이 리스트 그대로 장바구니에 담기';

  @override
  String shopping_history_readd_all_snackbar(int count) {
    return '$count개 항목을 장바구니에 담았습니다.';
  }

  @override
  String shopping_history_readd_item_snackbar(String name) {
    return '$name을(를) 장바구니에 담았습니다.';
  }

  @override
  String get shopping_history_price_none => '가격 미입력';

  @override
  String get shopping_history_add_to_cart => '장바구니에 담기';

  @override
  String get shopping_history_fridge_transferred => '냉장고에 이관됨';

  @override
  String get shopping_history_fridge_not_transferred => '이관 안 함';

  @override
  String get shopping_complete_snackbar => '장보기가 완료되었습니다.';

  @override
  String get account_management_title => '계정 관리';

  @override
  String get account_delete_schedule_title => '계정 삭제 예약';

  @override
  String get account_delete_schedule_subtitle => '7일 유예 후 모든 데이터 삭제';

  @override
  String get account_delete_schedule_confirm_title => '계정 삭제를 예약하시겠습니까?';

  @override
  String get account_delete_schedule_confirm_body =>
      '7일 후 계정과 모든 데이터가 영구 삭제됩니다.\n유예 기간 중에는 취소할 수 있습니다.';

  @override
  String account_delete_schedule_success(String date) {
    return '계정 삭제가 예약되었습니다. $date에 삭제됩니다.';
  }

  @override
  String get account_cancel_delete_title => '계정 삭제 예약 취소';

  @override
  String get account_cancel_delete_subtitle => '예약된 계정 삭제를 취소합니다';

  @override
  String get account_cancel_delete_confirm_title => '계정 삭제 예약을 취소하시겠습니까?';

  @override
  String get account_cancel_delete_success => '계정 삭제 예약이 취소되었습니다';

  @override
  String get account_export_data_title => '내 데이터 내보내기';

  @override
  String get account_export_data_subtitle => '등록된 이메일로 데이터 사본을 보내드립니다';

  @override
  String get account_export_data_success => '요청이 완료되었습니다. 이메일을 확인해 주세요.';

  @override
  String account_action_failed(String error) {
    return '오류가 발생했습니다: $error';
  }

  @override
  String get subscription_free_label => '무료 플랜';

  @override
  String get subscription_free_sublabel => '광고가 표시됩니다';

  @override
  String get subscription_trial_label => '2주 무료 체험 중';

  @override
  String subscription_trial_sublabel_days(int days) {
    return '$days일 후 무료 플랜으로 전환됩니다';
  }

  @override
  String get subscription_trial_sublabel_today => '오늘 체험이 종료됩니다';

  @override
  String get subscription_ad_free_label => '광고 제거';

  @override
  String subscription_ad_free_sublabel_expires(String date) {
    return '$date 까지';
  }

  @override
  String get subscription_ad_free_sublabel_active => '광고 없이 이용 중';

  @override
  String get subscription_premium_label => 'Premium';

  @override
  String subscription_premium_sublabel_expires(String date) {
    return '$date 까지';
  }

  @override
  String get subscription_premium_sublabel_active => '모든 기능 이용 중';

  @override
  String get dashboard_trial_banner_title => '광고 없는 2주 무료 체험 중';

  @override
  String dashboard_trial_banner_sublabel_days(int days) {
    return '$days일 후 일반 플랜으로 전환됩니다';
  }

  @override
  String get dashboard_trial_banner_sublabel_today => '오늘 체험이 종료됩니다';

  @override
  String get anniversary_widgetTitle => '다가오는 기념일';

  @override
  String get anniversary_widgetEmpty => '등록된 기념일이 없습니다';

  @override
  String get widgetSettings_anniversarySummary => '기념일';

  @override
  String get widgetSettings_anniversarySummaryDesc => '다가오는 기념일과 D-day를 표시합니다';

  @override
  String get subscription_manage_title => '구독 관리';

  @override
  String get subscription_screen_title => '구독 관리';

  @override
  String get subscription_current_plan_label => '현재 플랜';

  @override
  String get subscription_active_status_label => '활성 여부';

  @override
  String get subscription_active => '활성';

  @override
  String get subscription_inactive => '비활성';

  @override
  String get subscription_expires_at_label => '만료일';

  @override
  String get subscription_products_section_title => '구독 상품';

  @override
  String get subscription_purchase_button => '구독하기';

  @override
  String get subscription_restore_button => '구독 복원';

  @override
  String get subscription_purchase_success => '구독이 완료되었습니다.';

  @override
  String get subscription_verify_failed_title => '구매 확인 실패';

  @override
  String get subscription_verify_failed_message =>
      '이미 사용된 구매이거나 검증에 실패했습니다. 문제가 지속되면 고객센터에 문의해주세요.';

  @override
  String get subscription_verify_network_error =>
      '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';

  @override
  String get subscription_restore_success => '구독이 복원되었습니다.';

  @override
  String get subscription_product_not_found =>
      '구독 상품을 준비 중입니다. 잠시 후 다시 시도해주세요.';

  @override
  String get routine_title => '루틴';

  @override
  String get routine_list_empty => '등록된 습관이 없습니다';

  @override
  String get routine_list_empty_subtitle =>
      '매일 반복하고 싶은 습관을 등록하고\n꾸준히 체크하며 스트릭을 쌓아보세요';

  @override
  String get routine_add => '습관 추가';

  @override
  String get routine_edit => '습관 수정';

  @override
  String get routine_delete => '습관 삭제';

  @override
  String get routine_delete_confirm => '이 습관을 삭제하시겠습니까?';

  @override
  String get routine_field_title => '제목';

  @override
  String get routine_field_title_hint => '예: 아침 스트레칭';

  @override
  String get routine_field_title_required => '제목을 입력해주세요';

  @override
  String get routine_field_title_too_long => '제목은 100자 이내로 입력해주세요';

  @override
  String get routine_field_emoji => '이모지';

  @override
  String get routine_field_emoji_custom => '직접 입력';

  @override
  String get routine_field_emoji_helper => '이모지 하나를 입력해주세요 (예: 🏃)';

  @override
  String get routine_field_color => '색상';

  @override
  String get routine_field_target_count => '주 목표 횟수';

  @override
  String get routine_field_start_date => '시작일';

  @override
  String get routine_field_end_date => '종료일 (선택)';

  @override
  String get routine_field_end_date_none => '무기한';

  @override
  String get routine_field_group => '소속 루틴';

  @override
  String get routine_field_group_none => '없음 (독립 습관)';

  @override
  String get routine_save => '저장';

  @override
  String get routine_check => '체크';

  @override
  String get routine_uncheck => '체크 취소';

  @override
  String get routine_check_already => '이미 체크했습니다';

  @override
  String get routine_check_future_date => '미래 날짜는 체크할 수 없습니다';

  @override
  String get routine_check_error => '체크에 실패했습니다';

  @override
  String routine_streak_celebration(int days) {
    return '🔥 $days일 연속 달성!';
  }

  @override
  String get routine_tab_heatmap => '달력';

  @override
  String get routine_tab_stats => '통계';

  @override
  String get routine_tab_share => '공유';

  @override
  String get routine_streak_current_days => '현재 연속 일수';

  @override
  String get routine_streak_longest_days => '최장 연속 일수';

  @override
  String get routine_streak_current_weeks => '현재 연속 주';

  @override
  String get routine_streak_longest_weeks => '최장 연속 주';

  @override
  String get routine_this_week_progress => '이번 주 진행';

  @override
  String get routine_weekly_strip_title => '최근 8주 달성 현황';

  @override
  String get routine_rate_period_week => '주';

  @override
  String get routine_rate_period_month => '월';

  @override
  String get routine_rate_period_custom => '기간 지정';

  @override
  String get routine_rate_achievement => '달성률';

  @override
  String get routine_share_title => '공유 그룹 관리';

  @override
  String get routine_share_add => '그룹에 공유';

  @override
  String get routine_share_remove => '공유 해제';

  @override
  String get routine_share_remove_confirm => '이 그룹과의 공유를 해제하시겠습니까?';

  @override
  String get routine_share_empty => '공유된 그룹이 없습니다';

  @override
  String get routine_share_select_group => '공유할 그룹 선택';

  @override
  String get routine_group_members_title => '그룹원 루틴 현황';

  @override
  String get routine_group_members_empty => '공유된 루틴이 없습니다';

  @override
  String get routine_shared_group_select => '공유 루틴 볼 그룹 선택';

  @override
  String get routine_shared_group_empty => '속한 그룹이 없습니다';

  @override
  String get routine_sort_order_updated => '순서가 변경되었습니다';

  @override
  String get routine_error_generic => '오류가 발생했습니다';

  @override
  String get widgetSettings_routineSummary => '오늘의 루틴';

  @override
  String get nav_routines => '루틴';

  @override
  String get routine_tab_badges => '배지';

  @override
  String get routine_badges_title => '내 배지';

  @override
  String get routine_badges_empty => '아직 획득한 배지가 없습니다';

  @override
  String get routine_badge_earned_title => '배지 획득!';

  @override
  String get routine_badge_earned_confirm => '확인';

  @override
  String get routine_leaderboard_title => '그룹 랭킹보드';

  @override
  String get routine_leaderboard_metric_checkCount => '체크 횟수';

  @override
  String get routine_leaderboard_metric_achievementRate => '달성률';

  @override
  String get routine_leaderboard_empty => '공유된 루틴이 있는 그룹원이 없습니다';

  @override
  String get routine_leaderboard_check_count_suffix => '회';

  @override
  String get routine_group_add => '루틴 추가';

  @override
  String get routine_group_edit => '루틴 수정';

  @override
  String get routine_group_delete => '루틴 삭제';

  @override
  String get routine_group_delete_confirm =>
      '이 루틴을 삭제하시겠습니까?\n소속된 습관은 삭제되지 않고 독립 습관으로 남습니다.';

  @override
  String get routine_group_field_title_hint => '예: 아침 루틴';

  @override
  String get routine_group_save => '저장';

  @override
  String get routine_group_standalone_section_title => '독립 습관';

  @override
  String get routine_group_error_generic => '오류가 발생했습니다';

  @override
  String get routine_field_memo => '메모';

  @override
  String get routine_field_memo_hint => '이 습관에 대한 설명을 남겨보세요';

  @override
  String get routine_field_importance => '중요도';

  @override
  String get routine_importance_low => '낮음';

  @override
  String get routine_importance_medium => '보통';

  @override
  String get routine_importance_high => '높음';

  @override
  String get routine_field_time_filter => '시간대';

  @override
  String get routine_time_filter_morning => '오전';

  @override
  String get routine_time_filter_afternoon => '오후';

  @override
  String get routine_time_filter_evening => '저녁';

  @override
  String get routine_time_filter_none => '지정 안 함';

  @override
  String get routine_field_category => '카테고리';

  @override
  String get routine_field_category_none => '미분류';

  @override
  String get routine_category_title => '카테고리';

  @override
  String get routine_category_add => '카테고리 추가';

  @override
  String get routine_category_edit => '카테고리 수정';

  @override
  String get routine_category_delete => '카테고리 삭제';

  @override
  String get routine_category_delete_confirm =>
      '이 카테고리를 삭제하시겠습니까?\n소속 습관은 삭제되지 않고 미분류로 남습니다.';

  @override
  String get routine_category_save => '저장';

  @override
  String get routine_category_field_title_hint => '예: 규칙적인 삶';

  @override
  String get routine_category_error_generic => '오류가 발생했습니다';

  @override
  String get routine_category_empty => '등록된 카테고리가 없습니다';

  @override
  String get routine_category_filter_all => '전체';

  @override
  String get routine_category_picker_title => '카테고리 선택';

  @override
  String get routine_category_edit_mode => '편집';

  @override
  String get routine_category_edit_mode_done => '완료';

  @override
  String get routine_category_reorder_hint => '길게 눌러 순서를 변경하세요';

  @override
  String get routine_category_select_done => '선택 완료';

  @override
  String get routine_category_none_selected => '카테고리 선택';

  @override
  String get routine_field_record_type => '기록 방식';

  @override
  String get routine_record_type_boolean => '단순 체크';

  @override
  String get routine_record_type_text => '텍스트';

  @override
  String get routine_record_type_time => '시각';

  @override
  String get routine_record_type_numeric => '수치';

  @override
  String get routine_record_type_readonly_hint => '기록 방식은 생성 후 변경할 수 없습니다';

  @override
  String get routine_check_dialog_title => '기록 입력';

  @override
  String get routine_check_dialog_text_label => '내용';

  @override
  String get routine_check_dialog_numeric_label => '수치';

  @override
  String get routine_check_dialog_time_label => '시각';

  @override
  String get routine_check_dialog_confirm => '체크';

  @override
  String get routine_check_dialog_cancel => '취소';

  @override
  String get routine_status_active => '활성';

  @override
  String get routine_status_paused => '일시정지';

  @override
  String get routine_status_ended => '종료';

  @override
  String get routine_pause => '일시정지';

  @override
  String get routine_pause_confirm => '이 습관을 일시정지하시겠습니까?\n일시정지 중에는 체크할 수 없습니다.';

  @override
  String get routine_resume => '재개';

  @override
  String get routine_resume_success => '재개되었습니다';

  @override
  String get routine_pause_error => '일시정지에 실패했습니다';

  @override
  String get routine_resume_error => '재개에 실패했습니다';

  @override
  String get routine_end => '종료';

  @override
  String get routine_end_confirm => '이 습관을 종료하시겠습니까?\n체크 기록은 보존됩니다.';

  @override
  String get routine_frequency_type_daily => '일간';

  @override
  String get routine_frequency_type_weekly => '주간';

  @override
  String get routine_frequency_type_monthly => '월간';

  @override
  String get routine_weekly_mode_count_only => '주 N회';

  @override
  String get routine_weekly_mode_fixed_days => '요일 지정';

  @override
  String get routine_field_target_days => '반복 요일';

  @override
  String get routine_day_sun => '일';

  @override
  String get routine_day_mon => '월';

  @override
  String get routine_day_tue => '화';

  @override
  String get routine_day_wed => '수';

  @override
  String get routine_day_thu => '목';

  @override
  String get routine_day_fri => '금';

  @override
  String get routine_day_sat => '토';

  @override
  String get routine_error_weekly_mode_required => '주 반복 방식을 선택해주세요';

  @override
  String get routine_error_weekly_target_required => '주 목표 횟수를 선택해주세요';

  @override
  String get routine_error_fixed_days_required => '반복할 요일을 1개 이상 선택해주세요';

  @override
  String get routine_error_monthly_target_required => '월 목표 횟수를 선택해주세요';

  @override
  String get emoji_picker_more => '더 많은 이모지';

  @override
  String get emoji_picker_custom_selected => '프리셋 외 이모지가 선택되었습니다';

  @override
  String get emoji_picker_search_hint => '이모지 검색';

  @override
  String get emoji_picker_no_result => '검색 결과가 없습니다';

  @override
  String get emoji_picker_category_recent => '최근 사용';

  @override
  String get emoji_picker_category_smileys => '표정';

  @override
  String get emoji_picker_category_animals => '동물';

  @override
  String get emoji_picker_category_foods => '음식';

  @override
  String get emoji_picker_category_travel => '여행';

  @override
  String get emoji_picker_category_activities => '활동';

  @override
  String get emoji_picker_category_objects => '사물';

  @override
  String get emoji_picker_category_symbols => '기호';

  @override
  String get emoji_picker_category_flags => '깃발';
}
