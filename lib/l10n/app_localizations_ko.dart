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
  String get common_refresh => '새로고침';

  @override
  String get investment_bookmarkAdd => '즐겨찾기 추가';

  @override
  String get investment_bookmarkRemove => '즐겨찾기 해제';

  @override
  String get vote_create => '투표 만들기';

  @override
  String get cart_item_add => '품목 추가';

  @override
  String get savings_goal_add => '저금통 추가';

  @override
  String get household_expense_add => '내역 추가';

  @override
  String get household_recurring_add => '고정지출 추가';

  @override
  String get asset_account_add => '계좌 추가';

  @override
  String get group_role_add => '역할 추가';

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
  String get announcement_markdownImport => '마크다운 가져오기';

  @override
  String get announcement_markdownImportTitle => '마크다운 붙여넣기';

  @override
  String get announcement_markdownImportDescription =>
      '마크다운 원문을 붙여넣으면 서식이 적용된 내용으로 변환됩니다.';

  @override
  String get announcement_markdownImportHint => '# 제목\n- 목록 항목\n**굵게**';

  @override
  String get announcement_markdownImportEmpty => '변환할 마크다운을 입력해주세요';

  @override
  String get announcement_markdownImportFailed => '마크다운 변환에 실패했습니다';

  @override
  String get announcement_markdownImportReplace => '기존 내용 대체';

  @override
  String get announcement_markdownImportReplaceDescription =>
      '끄면 커서 위치에 이어서 삽입합니다';

  @override
  String get announcement_markdownImportConvert => '변환';

  @override
  String get announcement_markdownImportSuccess => '마크다운을 변환했습니다';

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
  String get fridge_storage_name => '보관소 이름';

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
  String get dashboard_loadFailed => '불러오지 못했습니다';

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
  String get weather_fallbackLocationNotice =>
      '현재 위치를 가져오지 못해 서울 날씨를 표시하고 있습니다';

  @override
  String get weather_enableLocationAction => '위치 권한 허용하기';

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
  String get subscription_days_left_label => '남은 기간';

  @override
  String subscription_days_left_value(int days) {
    return '$days일';
  }

  @override
  String get subscription_days_left_today => '오늘 종료';

  @override
  String get subscription_trial_ends_at_label => '체험 종료일';

  @override
  String get subscription_period_end_label => '이용 기간 종료일';

  @override
  String get subscription_auto_renew_hint => '해지하지 않으면 이 날짜에 자동으로 갱신됩니다';

  @override
  String get subscription_next_renewal_label => '다음 갱신일';

  @override
  String get subscription_canceled_hint => '구독이 해지되어 이 날짜에 종료됩니다';

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
  String get subscription_ad_free_benefit => '앱 내 모든 광고가 표시되지 않습니다.';

  @override
  String get subscription_period_monthly => '월간 구독';

  @override
  String get subscription_auto_renew_notice =>
      '구독은 매월 자동으로 갱신되며, 현재 구독 기간이 끝나기 24시간 전까지 해지하지 않으면 동일한 금액이 결제됩니다. 구매 확정 시 스토어 계정으로 결제되며, 구독 관리 및 해지는 기기의 스토어 계정 설정에서 언제든지 할 수 있습니다.';

  @override
  String get subscription_manage_subscription_button => '구독 관리 및 해지';

  @override
  String get subscription_terms_button => '이용약관';

  @override
  String get subscription_privacy_button => '개인정보 처리방침';

  @override
  String get subscription_manage_launch_failed => '스토어 구독 관리 화면을 열 수 없습니다.';

  @override
  String get subscription_compare_title => '플랜 비교';

  @override
  String get subscription_plan_current => '이용 중';

  @override
  String get subscription_benefit_all_features => '모든 기능 이용';

  @override
  String get subscription_benefit_ads_shown => '광고가 표시됩니다';

  @override
  String get subscription_benefit_no_ads => '광고 없이 이용';

  @override
  String get subscription_benefit_no_reward_ads => '기능 사용 시 광고 시청 불필요';

  @override
  String get subscription_benefit_cancel_anytime => '언제든 해지 가능';

  @override
  String get subscription_free_plan_price => '₩0';

  @override
  String get routine_title => '루틴';

  @override
  String get routine_date_today => '오늘';

  @override
  String get routine_reorder => '순서변경';

  @override
  String get routine_reorder_done => '완료';

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
  String get routine_field_target_count_month => '월 목표 횟수';

  @override
  String get routine_this_month_progress => '이번 달 진행';

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
  String get routine_streak_current_days => '현재 연속 일수';

  @override
  String get routine_streak_longest_days => '최장 연속 일수';

  @override
  String get routine_streak_current_weeks => '현재 연속 주';

  @override
  String get routine_streak_longest_weeks => '최장 연속 주';

  @override
  String get routine_streak_current_months => '현재 연속 달';

  @override
  String get routine_streak_longest_months => '최장 연속 달';

  @override
  String get routine_this_month_progress_label => '이번 달 진행';

  @override
  String get routine_badges_goal_subtitle => '오늘의 목표를 달성하며 모은 배지예요';

  @override
  String get routine_daily_goal_included_badge => '오늘의 목표에 포함된 습관';

  @override
  String get routine_daily_goal_filter_on => '목표 습관만 보는 중';

  @override
  String get routine_daily_goal_filter_hint => '탭하면 목표 습관만 볼 수 있어요';

  @override
  String get routine_coach_add_title => '습관 만들기';

  @override
  String get routine_coach_add_desc =>
      '매일 반복하고 싶은 일을 습관으로 등록해보세요.\n여러 습관을 묶어 하나의 루틴으로 만들 수도 있어요.';

  @override
  String get routine_coach_goal_title => '오늘의 목표';

  @override
  String get routine_coach_goal_desc =>
      '습관을 전부 못 채워도 괜찮아요.\n정해둔 개수만 채우면 그날은 성공이에요.\n연속으로 달성하면 배지도 받을 수 있어요.';

  @override
  String get routine_coach_flag_title => '목표에 포함된 습관';

  @override
  String get routine_coach_flag_desc =>
      '깃발이 붙은 습관이 오늘의 목표에 들어가요.\n위의 목표 막대를 누르면 이 습관만 모아볼 수 있어요.';

  @override
  String get routine_coach_check_title => '체크하기';

  @override
  String get routine_coach_check_desc =>
      '동그라미를 눌러 완료 표시를 하세요.\n기록형 습관은 시간이나 횟수도 함께 남길 수 있어요.';

  @override
  String get routine_coach_demo_habit_1 => '아침 스트레칭';

  @override
  String get routine_coach_demo_habit_2 => '물 2L 마시기';

  @override
  String get routine_coach_demo_habit_3 => '책 30분 읽기';

  @override
  String get routine_coach_skip => '건너뛰기';

  @override
  String get routine_coach_together_title => '그룹과 함께하기';

  @override
  String get routine_coach_together_desc =>
      '가족이나 친구 그룹과 습관을 공유할 수 있어요.\n서로의 현황을 보고, 함께 챌린지도 할 수 있어요.';

  @override
  String get routine_together_coach_status_title => '그룹원 현황';

  @override
  String get routine_together_coach_status_desc =>
      '그룹원들이 오늘 어떤 습관을 했는지 볼 수 있어요.\n이름을 누르면 자세한 기록도 확인할 수 있어요.';

  @override
  String get routine_together_coach_tabs_title => '랭킹과 챌린지';

  @override
  String get routine_together_coach_tabs_desc =>
      '랭킹에서는 목표 달성률로 순위를 겨뤄요.\n챌린지는 기간을 정해 함께 목표에 도전하고,\n내기를 걸 수도 있어요.';

  @override
  String get routine_together_coach_settings_title => '공유 설정';

  @override
  String get routine_together_coach_settings_desc =>
      '어느 그룹에 내 습관을 보여줄지 정해요.\n숨기고 싶은 습관은 \'비공개\'로 표시하면\n그룹원에게 보이지 않아요.';

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
  String get routine_share_screen_desc => '선택한 그룹의 구성원이 내 습관과 달성 현황을 볼 수 있어요.';

  @override
  String get routine_share_private_note => '비공개로 표시한 습관은 공유되지 않아요.';

  @override
  String get routine_share_none => '아직 공유 중인 그룹이 없어요';

  @override
  String get routine_share_no_groups => '참여 중인 그룹이 없어요.\n그룹을 먼저 만들거나 참여해주세요.';

  @override
  String get routine_share_saved => '공유 설정을 저장했어요';

  @override
  String get routine_field_private => '비공개';

  @override
  String get routine_field_private_desc => '공유 그룹의 다른 사람에게 이 습관을 숨겨요';

  @override
  String get routine_private_badge => '비공개 습관';

  @override
  String get routine_share_select_group => '공유할 그룹 선택';

  @override
  String get routine_together_title => '함께하기';

  @override
  String get routine_together_tab_status => '현황';

  @override
  String get routine_together_tab_ranking => '랭킹';

  @override
  String get routine_together_tab_challenge => '챌린지';

  @override
  String get routine_challenge_create => '챌린지 만들기';

  @override
  String get routine_challenge_edit => '챌린지 수정';

  @override
  String get routine_challenge_empty => '아직 챌린지가 없어요.\n그룹과 함께할 목표를 만들어보세요.';

  @override
  String get routine_challenge_field_title => '챌린지 이름';

  @override
  String get routine_challenge_field_title_hint => '예: 이번 주 운동하기';

  @override
  String get routine_challenge_field_description => '설명';

  @override
  String get routine_challenge_field_period => '기간';

  @override
  String get routine_challenge_field_target => '목표 횟수';

  @override
  String routine_challenge_field_target_desc(int count) {
    return '기간 안에 $count번 체크하면 달성이에요';
  }

  @override
  String get routine_challenge_field_reward => '내기 · 벌칙';

  @override
  String get routine_challenge_field_reward_hint => '예: 진 사람이 치킨 쏘기';

  @override
  String get routine_challenge_status_upcoming => '시작 전';

  @override
  String get routine_challenge_status_ongoing => '진행 중';

  @override
  String get routine_challenge_status_ended => '종료';

  @override
  String routine_challenge_participants(int count) {
    return '참가자 $count명';
  }

  @override
  String get routine_challenge_join => '참가하기';

  @override
  String get routine_challenge_leave => '참가 취소';

  @override
  String get routine_challenge_leave_confirm => '이 챌린지에서 빠지시겠어요?';

  @override
  String get routine_challenge_delete_confirm =>
      '이 챌린지를 삭제하시겠어요?\n참가자들의 기록도 함께 사라져요.';

  @override
  String get routine_challenge_select_routine => '어떤 습관으로 참가할까요?';

  @override
  String get routine_challenge_select_routine_desc =>
      '이 챌린지에 연결할 내 습관을 골라주세요.\n비공개 습관은 참가할 수 없어요.';

  @override
  String get routine_challenge_no_routine =>
      '참가할 수 있는 습관이 없어요.\n먼저 습관을 만들어주세요.';

  @override
  String get routine_challenge_change_routine => '습관 바꾸기';

  @override
  String routine_challenge_progress(int checked, int target) {
    return '$checked / $target회';
  }

  @override
  String routine_challenge_days_left(int days) {
    return '$days일 남음';
  }

  @override
  String get routine_challenge_saved => '챌린지를 저장했어요';

  @override
  String get routine_challenge_joined => '챌린지에 참가했어요';

  @override
  String get routine_group_members_empty => '공유된 루틴이 없습니다';

  @override
  String get routine_sort_order_updated => '순서가 변경되었습니다';

  @override
  String get routine_error_generic => '오류가 발생했습니다';

  @override
  String get widgetSettings_routineSummary => '내 루틴';

  @override
  String get nav_routines => '루틴';

  @override
  String get routine_badges_title => '내 배지';

  @override
  String get routine_overview_title => '통계';

  @override
  String get routine_overview_heatmap_title => '전체 습관 달성 현황';

  @override
  String get routine_overview_previous_period => '이전 기간';

  @override
  String get routine_overview_next_period => '다음 기간';

  @override
  String get routine_overview_this_week => '금주로';

  @override
  String get routine_overview_this_month => '이번 달로';

  @override
  String get routine_overview_weekly_title => '이번 주 습관별 수행 현황';

  @override
  String get routine_overview_achieved => '달성';

  @override
  String get routine_overview_not_achieved => '미달성';

  @override
  String get routine_overview_total_checked => '총 체크';

  @override
  String get routine_daily_goal_title => '오늘의 목표';

  @override
  String get routine_daily_goal_setting => '오늘의 목표 설정';

  @override
  String routine_daily_goal_count_label(int total, int count) {
    return '습관 $total개 중 $count개';
  }

  @override
  String routine_daily_goal_encourage(int count) {
    return '하루 $count개면 성공이에요';
  }

  @override
  String get routine_daily_goal_exceeds_total =>
      '지금 등록된 습관보다 목표가 많아요. 습관을 더 추가하거나 목표를 낮춰보세요';

  @override
  String routine_daily_goal_today_progress(int checked, int target) {
    return '오늘 $checked / $target';
  }

  @override
  String get routine_daily_goal_achieved_today => '오늘 목표 달성!';

  @override
  String routine_daily_goal_bonus(int count) {
    return '보너스 +$count';
  }

  @override
  String routine_daily_goal_streak(int days) {
    return '$days일 연속 달성';
  }

  @override
  String routine_daily_goal_streak_longest(int days) {
    return '최장 $days일';
  }

  @override
  String get routine_daily_goal_rate => '목표 달성률';

  @override
  String routine_daily_goal_achieved_days(int achieved, int total) {
    return '$achieved일 / $total일 달성';
  }

  @override
  String get routine_daily_goal_saved => '목표를 저장했어요';

  @override
  String get routine_daily_goal_raise_title => '목표를 올려볼까요?';

  @override
  String routine_daily_goal_raise_body(
    int average,
    int current,
    int suggested,
  ) {
    return '최근 2주 동안 목표를 자주 넘었어요. 요즘 하루 평균 $average개를 하고 계세요.\n\n하루 목표를 $current개에서 $suggested개로 올려볼까요?';
  }

  @override
  String get routine_daily_goal_raise_accept => '올릴게요';

  @override
  String get routine_daily_goal_keep => '지금이 좋아요';

  @override
  String get routine_daily_goal_lower_title => '목표를 잠시 낮춰볼까요?';

  @override
  String routine_daily_goal_lower_body(int current, int suggested) {
    return '요즘 조금 바쁘신가요? 무리하지 않아도 괜찮아요.\n\n하루 목표를 $current개에서 $suggested개로 낮춰도 좋아요. 언제든 다시 올릴 수 있어요.';
  }

  @override
  String get routine_daily_goal_lower_accept => '낮출게요';

  @override
  String get routine_daily_goal_included_section => '목표에 포함할 습관';

  @override
  String routine_daily_goal_included_summary(int included) {
    return '습관 $included개가 목표 집계에 포함돼요';
  }

  @override
  String get routine_daily_goal_group_daily => '매일 하는 습관';

  @override
  String get routine_daily_goal_group_periodic => '주기적으로 하는 습관';

  @override
  String get routine_daily_goal_periodic_hint =>
      '켜면 매일 해야 하는 것으로 계산돼요. 주 3회 습관을 켜면 3회를 다 채운 뒤에도 남은 날에 미완료로 남아요';

  @override
  String get routine_daily_goal_freq_daily => '매일';

  @override
  String routine_daily_goal_freq_weekly_count(int count) {
    return '주 $count회';
  }

  @override
  String routine_daily_goal_freq_monthly_count(int count) {
    return '월 $count회';
  }

  @override
  String get routine_daily_goal_no_included => '목표에 포함된 습관이 없어요. 아래에서 습관을 켜주세요';

  @override
  String get routine_daily_goal_no_routines => '등록된 습관이 없어요';

  @override
  String routine_overview_total_routines(int count) {
    return '전체 습관 $count개 기준';
  }

  @override
  String get routine_badges_empty => '아직 획득한 배지가 없습니다';

  @override
  String get routine_badge_earned_title => '배지 획득!';

  @override
  String get routine_badge_earned_confirm => '확인';

  @override
  String get routine_leaderboard_metric_goalRate => '목표 달성률';

  @override
  String get routine_leaderboard_metric_goalStreak => '연속 달성';

  @override
  String routine_leaderboard_goal_days(int achieved, int total) {
    return '$achieved일 / $total일';
  }

  @override
  String routine_leaderboard_streak_days(int days) {
    return '$days일 연속';
  }

  @override
  String get routine_leaderboard_empty => '공유된 루틴이 있는 그룹원이 없습니다';

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
  String get routine_table_header_number => '번호';

  @override
  String get routine_table_header_habit => '습관';

  @override
  String get routine_table_header_check => '체크';

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
  String get routine_category_reorder_hint => '핸들을 눌러 순서를 변경하세요';

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

  @override
  String get memo_tag_filter_clear => '태그 필터 초기화';

  @override
  String get memo_section_pinned => '고정된 메모';

  @override
  String memo_pinned_expand(int count) {
    return '펼치기 ($count개 더)';
  }

  @override
  String get memo_pinned_collapse => '접기';

  @override
  String get memo_pin_add => '대시보드에 고정';

  @override
  String get memo_pin_remove => '핀 해제';

  @override
  String get memo_pin_error => '핀 설정에 실패했습니다';

  @override
  String get memo_pin_added => '메모가 상단에 고정되고, 대시보드에 추가되었습니다.';

  @override
  String get memo_pin_removed => '고정이 해제되었습니다.';

  @override
  String memo_duplicate_title(String title) {
    return '$title (복사본)';
  }

  @override
  String get memo_tag_input_hint => '태그 입력 후 추가';

  @override
  String get memo_editor_paste_failed => '클립보드 붙여넣기에 실패했습니다.';

  @override
  String get memo_editor_link_card_add => '링크 카드 추가';

  @override
  String get memo_editor_image => '이미지';

  @override
  String get memo_editor_paste_formatted => '서식 유지 붙여넣기';

  @override
  String get memo_editor_link_apply => '하이퍼링크 적용';

  @override
  String get memo_editor_link_select_first => '텍스트를 선택하세요';

  @override
  String get memo_editor_bold => '굵게';

  @override
  String get memo_editor_italic => '기울임';

  @override
  String get memo_editor_strikethrough => '취소선';

  @override
  String get memo_editor_heading1 => '제목 1';

  @override
  String get memo_editor_heading2 => '제목 2 (체크리스트 섹션)';

  @override
  String get memo_editor_bullet_list => '글머리 기호';

  @override
  String get memo_editor_numbered_list => '번호 목록';

  @override
  String get memo_editor_undo => '실행 취소';

  @override
  String get memo_editor_redo => '다시 실행';

  @override
  String get savings_title => '그룹 저금통';

  @override
  String get savings_select_group => '그룹을 선택해 주세요';

  @override
  String get savings_intro_title => '그룹과 함께 목표를 정해 돈을 모아요';

  @override
  String get savings_intro_body =>
      '여행 경비, 비상금, 가전 구매 등 원하는 목표를 만들고 매달 자동으로 적립하거나 수동으로 입금할 수 있어요.';

  @override
  String get savings_intro_tip =>
      '가족 외에도 친구, 동료 등 그룹이라면 누구든 \"계\" 처럼 활용할 수 있어요.';

  @override
  String get savings_list_empty => '저금통이 없습니다\n+ 버튼을 눌러 저금통을 추가하세요';

  @override
  String savings_achievement_rate(String rate) {
    return '$rate% 달성';
  }

  @override
  String get savings_deposit => '입금';

  @override
  String get savings_withdraw => '출금';

  @override
  String get savings_amount_label => '금액 (원)';

  @override
  String get savings_memo_label => '메모 (선택)';

  @override
  String get savings_withdraw_reason_label => '출금 사유 (필수)';

  @override
  String get savings_delete_title => '목표 삭제';

  @override
  String savings_delete_message(String name) {
    return '\'$name\'을(를) 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.';
  }

  @override
  String get savings_detail_title => '적립 목표';

  @override
  String get savings_goal_reached => '목표 금액 달성!';

  @override
  String savings_target_amount(String amount) {
    return '목표: $amount';
  }

  @override
  String get savings_auto_deposit => '자동 적립';

  @override
  String savings_auto_deposit_monthly(String amount) {
    return '월 $amount';
  }

  @override
  String get savings_auto_deposit_pause => '자동 적립 중지';

  @override
  String get savings_auto_deposit_resume => '자동 적립 재개';

  @override
  String get savings_recent_transactions => '최근 내역';

  @override
  String get savings_view_all => '전체 보기';

  @override
  String get savings_transactions_empty => '거래 내역이 없습니다.';

  @override
  String get savings_transactions_load_error => '내역을 불러오지 못했습니다';

  @override
  String get savings_filter_auto => '자동 적립';

  @override
  String get savings_form_title_add => '저금통 추가';

  @override
  String get savings_form_title_edit => '저금통 수정';

  @override
  String get savings_form_submit_edit => '수정 완료';

  @override
  String get savings_form_save_error => '저장하지 못했습니다';

  @override
  String get savings_field_name => '목표 이름 *';

  @override
  String get savings_field_name_required => '목표 이름을 입력해 주세요';

  @override
  String get savings_field_description => '설명 (선택)';

  @override
  String get savings_field_target => '목표 금액 (선택, 원)';

  @override
  String get savings_field_target_hint => '예: 1000000';

  @override
  String get savings_field_target_helper =>
      '목표 금액을 지정하지 않으면 비상금·계처럼 계속 모아서 사용할 수 있어요.';

  @override
  String get savings_field_amount_invalid => '올바른 금액을 입력해 주세요';

  @override
  String get savings_field_auto_deposit_desc => '매월 자동으로 적립합니다';

  @override
  String get savings_field_monthly_amount => '월 적립금 (원)';

  @override
  String get savings_field_monthly_amount_hint => '예: 100000';

  @override
  String get savings_field_monthly_amount_required => '월 적립금을 입력해 주세요';

  @override
  String get savings_field_deposit_day => '매달 적립일 (1~31일)';

  @override
  String get savings_field_deposit_day_hint => '예: 25';

  @override
  String get savings_field_deposit_day_helper => '해당 월에 날짜가 없으면 말일에 자동 처리돼요.';

  @override
  String get savings_field_deposit_day_invalid => '1~31 사이의 날짜를 입력해 주세요';

  @override
  String get savings_field_include_assets => '자산 통계에 포함';

  @override
  String get savings_field_include_assets_desc =>
      '자산 현황에서 적립금 잔액을 함께 확인할 수 있어요';

  @override
  String get vote_title => '투표';

  @override
  String get vote_filter_ongoing => '진행중';

  @override
  String get vote_filter_closed => '종료됨';

  @override
  String get vote_status_ongoing => '진행중';

  @override
  String get vote_status_closed => '종료';

  @override
  String get vote_select_group => '그룹을 선택하면 투표 목록이 표시됩니다';

  @override
  String get vote_list_empty => '아직 투표가 없습니다\n+ 버튼으로 새 투표를 만들어보세요';

  @override
  String get vote_list_load_error => '투표 목록을 불러오지 못했습니다';

  @override
  String get vote_detail_load_error => '투표를 불러오지 못했습니다';

  @override
  String vote_participants(int count) {
    return '$count명 참여';
  }

  @override
  String get vote_participated => '참여함';

  @override
  String get vote_deadline_passed => '마감됨';

  @override
  String vote_deadline_days(int days) {
    return '$days일 후 마감';
  }

  @override
  String vote_deadline_hours(int hours) {
    return '$hours시간 후 마감';
  }

  @override
  String vote_deadline_minutes(int minutes) {
    return '$minutes분 후 마감';
  }

  @override
  String get vote_delete => '투표 삭제';

  @override
  String get vote_delete_message => '이 투표를 삭제하시겠습니까?\n삭제된 투표는 복구할 수 없습니다.';

  @override
  String get vote_delete_failed => '삭제하지 못했습니다';

  @override
  String get vote_submit_success => '투표가 완료되었습니다';

  @override
  String get vote_submit_failed => '투표하지 못했습니다';

  @override
  String get vote_multiple_choice_badge => '복수 선택';

  @override
  String get vote_anonymous_badge => '익명';

  @override
  String get vote_submit => '투표하기';

  @override
  String get vote_revote => '재투표하기';

  @override
  String vote_option_result(int count, String percent) {
    return '$count표 ($percent%)';
  }

  @override
  String get vote_create_title => '새 투표 만들기';

  @override
  String get vote_field_title => '투표 제목 *';

  @override
  String get vote_field_title_required => '제목을 입력해주세요';

  @override
  String get vote_field_description => '설명 (선택)';

  @override
  String get vote_options_section => '선택지';

  @override
  String vote_option_hint(int index) {
    return '선택지 $index';
  }

  @override
  String get vote_options_min => '선택지를 2개 이상 입력해주세요';

  @override
  String get vote_create_failed => '투표를 만들지 못했습니다';

  @override
  String get vote_allow_multiple => '복수 선택 허용';

  @override
  String get vote_allow_multiple_desc => '여러 항목을 동시에 선택할 수 있습니다';

  @override
  String get vote_anonymous => '익명 투표';

  @override
  String get vote_anonymous_desc => '투표자 이름이 공개되지 않습니다';

  @override
  String get vote_deadline => '마감 시각';

  @override
  String get vote_deadline_none => '설정 안 함 (수동 종료)';

  @override
  String get todo_label_dueDate => '마감일';

  @override
  String get todo_label_category => '카테고리';

  @override
  String get todo_label_createdAt => '등록일';

  @override
  String get todo_label_completedAt => '완료일';

  @override
  String get todo_label_status => '상태';

  @override
  String get todo_drag_to_move => '드래그하여 이동';

  @override
  String get common_more => '더 보기';

  @override
  String get cart_total => '합계';

  @override
  String get cart_save_error => '저장 중 오류가 발생했습니다';

  @override
  String get cart_price_unit => '개당';

  @override
  String get cart_price_total => '총액';

  @override
  String get cart_price_unit_label => '개당 금액';

  @override
  String get cart_price_total_label => '총 금액';

  @override
  String get cart_price_unit_hint => '개당 금액 입력';

  @override
  String get cart_price_total_hint => '총 금액 입력';

  @override
  String get cart_extra_show => '단위·메모 추가';

  @override
  String get cart_extra_hide => '단위·메모 숨기기';

  @override
  String get cart_shopping_date => '장보기 날짜';

  @override
  String get cart_select_date => '날짜 선택';

  @override
  String get cart_default_description => '마트 장보기';

  @override
  String get settings_myReportsTitle => '내 신고 내역';

  @override
  String get settings_myReportsSubtitle => '내가 신고한 목록을 확인합니다';

  @override
  String get settings_commonRolesTitle => '공통 역할 관리';

  @override
  String get settings_commonRolesSubtitle => '시스템 전체에 적용되는 공통 역할 관리';

  @override
  String get settings_userAdminTitle => '사용자 및 계정 관리';

  @override
  String get settings_userAdminSubtitle => '구독 수정, 계정 삭제 예약 및 처리';

  @override
  String get settings_reportAdminTitle => '신고 관리';

  @override
  String get settings_reportAdminSubtitle => '그룹원 신고 접수 및 처리';

  @override
  String get settings_replayTutorial => '튜토리얼 다시 보기';

  @override
  String get settings_replayTutorialBody =>
      '앱 소개 슬라이드와 각 기능의 안내를\n처음부터 다시 볼 수 있습니다.';

  @override
  String get settings_replayTutorialConfirm => '다시 보기';

  @override
  String get settings_replayTutorialDone => '다음 앱 실행 시 튜토리얼이 표시됩니다.';

  @override
  String get settings_personalColor => '개인 색상';

  @override
  String get settings_personalColorPick => '개인 색상 선택';

  @override
  String get widgetSettings_addWidget => '위젯 추가하기';

  @override
  String get widgetSettings_addAnniversary => '기념일 추가';

  @override
  String get report_title => '신고하기';

  @override
  String get report_reason => '신고 사유';

  @override
  String get report_detail => '상세 내용 (선택)';

  @override
  String get report_detail_hint => '추가 설명을 입력하세요';

  @override
  String get report_submit => '신고 접수';

  @override
  String get report_submitted => '신고가 접수되었습니다.';

  @override
  String get report_submit_failed => '신고를 접수하지 못했습니다';

  @override
  String get report_empty => '신고 내역이 없습니다';

  @override
  String get report_admin_title => '신고 관리';

  @override
  String get report_handle_title => '신고 처리';

  @override
  String get report_handle_status => '처리 상태';

  @override
  String get report_handle_memo => '처리 메모 (선택)';

  @override
  String get report_handle_memo_hint => '처리 내용을 입력하세요';

  @override
  String get report_handle_done => '처리 완료';

  @override
  String get report_handled => '신고가 처리되었습니다.';

  @override
  String get report_handle_failed => '처리하지 못했습니다';

  @override
  String get group_invite_cancel => '초대 취소';

  @override
  String group_invite_cancel_message(String email) {
    return '$email에게 보낸 초대를 취소하시겠습니까?';
  }

  @override
  String get group_invite_canceled => '초대가 취소되었습니다';

  @override
  String group_invite_resent(String email) {
    return '$email에게 초대 이메일을 다시 보냈습니다';
  }

  @override
  String get group_invite_resend => '재전송';

  @override
  String get group_color_change_failed => '색상을 바꾸지 못했습니다';

  @override
  String get group_color_reset => '그룹 기본 색상으로 되돌렸습니다';

  @override
  String get group_color_reset_failed => '색상을 되돌리지 못했습니다';

  @override
  String get group_order_saved => '그룹 순서를 저장했습니다';

  @override
  String get group_members_empty => '멤버가 없습니다';

  @override
  String get group_member_remove => '멤버 탈퇴';

  @override
  String get group_member_removed => '멤버를 삭제했습니다';

  @override
  String get group_role_change => '역할 변경';

  @override
  String get group_role_changed => '역할을 변경했습니다';

  @override
  String get group_roles_load_error => '역할 목록을 불러올 수 없습니다';

  @override
  String get group_regenerate_code_message =>
      '초대 코드를 재생성하시겠습니까?\n기존 초대 코드는 사용할 수 없게 됩니다.';

  @override
  String get group_transfer_ownership => '그룹장 양도';

  @override
  String get group_transfer_confirm => '양도하기';

  @override
  String group_transfer_message(String name) {
    return '$name님에게 그룹장 권한을 넘기시겠습니까?';
  }

  @override
  String get group_transfer_failed => '그룹장을 넘기지 못했습니다';

  @override
  String get invite_title => '그룹 초대';

  @override
  String get invite_joining => '그룹에 가입 중...';

  @override
  String get invite_joined => '그룹 가입 완료!';

  @override
  String get invite_go_home => '홈으로';

  @override
  String get invite_login_required => '로그인 후 그룹에 가입할 수 있어요.';

  @override
  String get invite_login => '로그인하기';

  @override
  String get invite_failed => '가입 실패';

  @override
  String group_transfer_done(String name) {
    return '$name님에게 그룹장을 넘겼습니다';
  }

  @override
  String invite_code_label(String code) {
    return '초대 코드: $code';
  }

  @override
  String get invite_unknown_error => '알 수 없는 오류가 발생했어요.';

  @override
  String get common_unknownError => '알 수 없는 오류';

  @override
  String get common_sortOrderSaved => '정렬 순서를 저장했습니다';

  @override
  String get common_saveFailed => '저장하지 못했습니다';

  @override
  String get common_deleteFailed => '삭제하지 못했습니다';

  @override
  String get common_noSearchResults => '검색 결과가 없습니다';

  @override
  String get role_common_title => '공통 역할 관리';

  @override
  String get role_create => '역할 생성';

  @override
  String get role_list_load_error => '역할 목록을 불러오지 못했습니다';

  @override
  String get role_list_empty => '등록된 공통 역할이 없습니다';

  @override
  String get role_list_empty_subtitle => '+ 버튼을 눌러 새로운 역할을 만드세요';

  @override
  String get role_info_load_error => '역할 정보를 불러오지 못했습니다';

  @override
  String get role_not_found => '역할을 찾을 수 없습니다';

  @override
  String role_permissions_title(String name) {
    return '$name 권한 관리';
  }

  @override
  String get role_permission_search => '권한 검색';

  @override
  String get role_permissions_load_error => '권한 목록을 불러오지 못했습니다';

  @override
  String get role_permissions_saved => '권한을 저장했습니다';

  @override
  String get role_edit_title => '공통 역할 수정';

  @override
  String get role_create_title => '공통 역할 생성';

  @override
  String get role_created => '역할을 만들었습니다';

  @override
  String get role_updated => '역할을 수정했습니다';

  @override
  String get role_create_failed => '역할을 만들지 못했습니다';

  @override
  String get role_update_failed => '역할을 수정하지 못했습니다';

  @override
  String get role_field_name => '역할 이름';

  @override
  String get role_field_name_hint => '예: ADMIN, MEMBER';

  @override
  String get role_field_name_required => '역할 이름을 입력하세요';

  @override
  String get role_default => '기본 역할';

  @override
  String get role_default_desc => '신규 가입 시 자동으로 부여되는 역할';

  @override
  String get role_default_badge => '기본';

  @override
  String get role_color => '역할 색상';

  @override
  String get role_delete => '역할 삭제';

  @override
  String role_delete_message(String name) {
    return '$name 역할을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.';
  }

  @override
  String get role_deleted => '역할을 삭제했습니다';

  @override
  String get role_manage_permissions => '권한 관리';

  @override
  String get permission_name_hint => '예시 권한';

  @override
  String get permission_desc_hint => '이 권한에 대한 설명을 입력하세요';

  @override
  String get permission_category_custom => '+ 직접 입력';

  @override
  String get permission_category_new => '새 카테고리 이름';

  @override
  String get permission_category_required => '새 카테고리 이름을 입력해주세요';

  @override
  String get childcare_savings_plan => '적금 플랜';

  @override
  String get childcare_savings_ongoing => '진행 중';

  @override
  String get childcare_savings_matured => '만기 완료';

  @override
  String get childcare_interest_simple => '단리';

  @override
  String get childcare_interest_compound => '복리';

  @override
  String get childcare_interest_type => '이자 유형';

  @override
  String get childcare_monthly_deposit => '월 납입액';

  @override
  String get childcare_interest_rate => '이자율';

  @override
  String get childcare_period => '기간';

  @override
  String get childcare_savings_start => '적금 플랜 시작하기';

  @override
  String get childcare_savings_start_desc => '매월 자동으로 적금이 납입돼요';

  @override
  String get childcare_savings_cancel => '중도 해지';

  @override
  String get childcare_savings_cancel_title => '적금 중도 해지';

  @override
  String get childcare_savings_cancel_message =>
      '중도 해지 시 이자 없이 원금만 반환됩니다.\n정말 해지하시겠습니까?';

  @override
  String get childcare_savings_cancel_confirm => '해지';

  @override
  String get childcare_savings_canceled => '적금을 해지했습니다';

  @override
  String get childcare_savings_cancel_failed => '해지하지 못했습니다';

  @override
  String get childcare_savings_started => '적금 플랜을 시작했습니다';

  @override
  String get childcare_savings_create_title => '적금 플랜 만들기';

  @override
  String get childcare_savings_monthly_points => '월 납입 포인트';

  @override
  String get childcare_savings_annual_rate => '연 이자율';

  @override
  String childcare_savings_rate_helper(String rate) {
    return '현재 국고채 3년물 금리($rate%)를 참고해 기본값을 넣었어요';
  }

  @override
  String get childcare_savings_rate_loading => '국고채 3년물 금리를 불러오는 중...';

  @override
  String get childcare_start_date => '시작일';

  @override
  String get childcare_maturity_date => '만기일';

  @override
  String get childcare_total_deposit => '총 납입';

  @override
  String get childcare_expected_interest => '예상 이자';

  @override
  String get childcare_maturity_amount => '만기 수령';

  @override
  String childcare_months(int months) {
    return '$months개월';
  }

  @override
  String get childcare_start => '시작';

  @override
  String get childcare_allowance_missing => '용돈 플랜이 설정되지 않았습니다';

  @override
  String get childcare_allowance_missing_desc => '월 포인트, 지급일 등을 설정해보세요';

  @override
  String get childcare_negotiation_passed => '연봉 협상일이 지났습니다';

  @override
  String get childcare_negotiation_upcoming => '연봉 협상일이 다가오고 있습니다';

  @override
  String childcare_negotiation_passed_desc(int days, String date) {
    return '$days일 전($date)이었습니다. 용돈 플랜을 검토해보세요';
  }

  @override
  String childcare_negotiation_today(String date) {
    return '오늘이 연봉 협상일입니다! ($date)';
  }

  @override
  String get childcare_cashout => '포인트 현금화';

  @override
  String get childcare_cashout_button => '현금화';

  @override
  String get childcare_cashout_points => '현금화할 포인트';

  @override
  String get childcare_cashout_failed => '현금화하지 못했습니다. 잠시 후 다시 시도해주세요.';

  @override
  String childcare_cashout_description(String amount) {
    return '포인트 현금화 ($amount원)';
  }

  @override
  String childcare_cashout_done(String points, String amount) {
    return '${points}P를 $amount원으로 바꿨습니다';
  }

  @override
  String childcare_cashout_rate(String ratio, String balance) {
    return '1P = $ratio원 · 보유 ${balance}P';
  }

  @override
  String childcare_cashout_approx(String amount) {
    return '≈ $amount원';
  }

  @override
  String get childcare_rule_apply => '규칙 적용';

  @override
  String get childcare_rule_apply_penalty => '규칙 위반 적용';

  @override
  String childcare_rule_apply_plus_message(String name, String points) {
    return '\"$name\"\n${points}P를 지급합니다.';
  }

  @override
  String childcare_rule_apply_minus_message(String name, String points) {
    return '\"$name\" 위반으로\n${points}P를 차감합니다.';
  }

  @override
  String get childcare_rule_give => '지급';

  @override
  String get childcare_rule_deduct => '차감';

  @override
  String childcare_points_given(String points) {
    return '${points}P를 지급했습니다';
  }

  @override
  String childcare_points_deducted(String points) {
    return '${points}P를 차감했습니다';
  }

  @override
  String get childcare_rule_delete => '규칙 삭제';

  @override
  String childcare_rule_delete_message(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까?';
  }

  @override
  String get common_deleted => '삭제되었습니다';

  @override
  String get common_saved => '저장되었습니다';

  @override
  String get childcare_rule_type_plus => '+ 포인트 규칙';

  @override
  String get childcare_rule_type_minus => '- 포인트 규칙';

  @override
  String get childcare_rule_type_info => '일반 규칙';

  @override
  String get childcare_rule_help_title => '규칙이란 무엇인가요?';

  @override
  String get childcare_rule_help_body =>
      '규칙은 아이의 행동에 포인트를 연결하는 약속입니다.\n좋은 행동에는 포인트를 주고, 약속을 어겼을 때는 포인트를 차감해요.';

  @override
  String get childcare_rule_help_tip =>
      '규칙은 구체적이고 명확할수록 좋습니다.\n애매한 규칙은 아이와 불필요한 기싸움으로 이어질 수 있어요.\n아이와 함께 규칙을 정하면 신뢰가 쌓입니다.';

  @override
  String get childcare_rule_examples_plus => '+ 규칙 예시 (포인트 지급)';

  @override
  String get childcare_rule_examples_minus => '- 규칙 예시 (포인트 차감)';

  @override
  String get childcare_rule_examples_info => '일반 규칙 예시 (포인트 없음)';

  @override
  String get childcare_rule_example_plus1 => '학교 숙제를 혼자 힘으로 끝냈을 때  +10P';

  @override
  String get childcare_rule_example_plus2 => '저녁 9시 이전에 스스로 잠자리에 들었을 때  +5P';

  @override
  String get childcare_rule_example_plus3 => '밥 먹은 후 식기를 싱크대에 가져다 놓았을 때  +3P';

  @override
  String get childcare_rule_example_plus4 => '일주일 동안 지각 없이 등교했을 때  +20P';

  @override
  String get childcare_rule_example_minus1 => '평일에 스마트폰을 1시간 이상 사용했을 때  -10P';

  @override
  String get childcare_rule_example_minus2 => '저녁 10시가 넘도록 잠자리에 들지 않았을 때  -5P';

  @override
  String get childcare_rule_example_minus3 => '형제·자매에게 욕설을 했을 때  -15P';

  @override
  String get childcare_rule_example_minus4 => '약속된 귀가 시간인 오후 6시를 넘겼을 때  -10P';

  @override
  String get childcare_rule_example_info1 => '이달 포인트 현금 전환은 최대 50P까지만 가능';

  @override
  String get childcare_rule_example_info2 => '포인트 상점 아이템은 하루 1개만 사용 가능';

  @override
  String get childcare_rule_apply_note => '규칙을 적용하면 해당 포인트가 즉시 반영됩니다.';

  @override
  String get childcare_rule_add => '규칙 추가';

  @override
  String get childcare_rule_edit => '규칙 수정';

  @override
  String get childcare_rule_type => '규칙 유형';

  @override
  String get childcare_rule_type_plus_short => '+포인트';

  @override
  String get childcare_rule_type_minus_short => '-포인트';

  @override
  String get childcare_rule_type_info_short => '일반';

  @override
  String get childcare_rule_name_hint_plus => '예: 숙제를 스스로 했을 때';

  @override
  String get childcare_rule_name_hint_minus => '예: 스마트폰을 30분 이상 보았을 때';

  @override
  String get childcare_rule_name_hint_info => '예: 이달 현금 출금 한도';

  @override
  String get childcare_rule_points_give => '지급 포인트';

  @override
  String get childcare_rule_points_deduct => '차감 포인트';

  @override
  String get childcare_rule_points_give_hint => '좋은 행동 시 지급할 포인트';

  @override
  String get childcare_rule_points_deduct_hint => '규칙 위반 시 차감할 포인트';

  @override
  String get childcare_save_failed => '저장하지 못했습니다. 잠시 후 다시 시도해주세요.';

  @override
  String get childcare_child => '자녀';

  @override
  String childcare_allowance_plan_title(String name) {
    return '$name 용돈 플랜';
  }

  @override
  String get childcare_tab_settings => '설정';

  @override
  String get childcare_tab_change_history => '변경 히스토리';

  @override
  String get childcare_allowance_setup => '용돈 플랜 설정';

  @override
  String get childcare_allowance_edit => '용돈 플랜 수정';

  @override
  String get childcare_monthly_points => '월 지급 포인트';

  @override
  String get childcare_monthly_points_hint => '예: 100';

  @override
  String get childcare_monthly_points_required => '월 지급 포인트를 입력해주세요';

  @override
  String get childcare_number_required => '숫자를 입력해주세요';

  @override
  String get childcare_pay_day => '매달 지급일';

  @override
  String get childcare_day_unit => '일';

  @override
  String get childcare_pay_day_helper => '해당 월에 선택한 날짜가 없으면 말일에 지급됩니다';

  @override
  String childcare_day_value(String day) {
    return '$day일';
  }

  @override
  String get childcare_select_date => '날짜를 선택하세요';

  @override
  String get childcare_select_date_optional => '날짜를 선택하세요 (선택)';

  @override
  String get childcare_point_ratio => '1포인트 = N원';

  @override
  String get childcare_point_ratio_hint => '예: 10';

  @override
  String get childcare_point_ratio_helper => '아이와의 약속을 명확히 하기 위한 표시용입니다';

  @override
  String get childcare_min_one => '1 이상의 숫자를 입력해주세요';

  @override
  String get childcare_negotiation_date => '다음 연봉 협상일 (선택)';

  @override
  String get childcare_plan_save => '플랜 설정';

  @override
  String get childcare_plan_update => '플랜 수정';

  @override
  String get childcare_plan_saved => '용돈 플랜을 저장했습니다';

  @override
  String get childcare_current_plan => '현재 용돈 플랜';

  @override
  String get childcare_monthly_payout => '월 지급';

  @override
  String get childcare_payout_day => '지급일';

  @override
  String childcare_payout_day_value(String day) {
    return '매월 $day일';
  }

  @override
  String get childcare_next_negotiation => '다음 협상일';

  @override
  String get childcare_history_empty => '변경 히스토리가 없습니다';

  @override
  String get childcare_history_load_error => '히스토리를 불러오지 못했습니다';

  @override
  String childcare_history_entry(String points, String day) {
    return '${points}P / 매월 $day일';
  }

  @override
  String childcare_ratio_value(String amount) {
    return '1P = $amount원';
  }

  @override
  String childcare_negotiation_suffix(String date) {
    return '협상일 $date';
  }

  @override
  String childcare_monthly_day(String day) {
    return '매달 $day일';
  }

  @override
  String get childcare_item_use => '아이템 사용';

  @override
  String childcare_item_use_message(String name, String points) {
    return '\"$name\"\n${points}P를 사용합니다.';
  }

  @override
  String get childcare_item_use_confirm => '사용';

  @override
  String childcare_item_used(String name) {
    return '\"$name\"을(를) 사용했습니다';
  }

  @override
  String get childcare_item_use_failed => '사용하지 못했습니다. 잠시 후 다시 시도해주세요.';

  @override
  String get childcare_item_delete => '아이템 삭제';

  @override
  String childcare_item_delete_message(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까?';
  }

  @override
  String get childcare_delete_failed => '삭제하지 못했습니다. 잠시 후 다시 시도해주세요.';

  @override
  String get childcare_item_add => '상점 아이템 추가';

  @override
  String get childcare_item_edit => '상점 아이템 수정';

  @override
  String get childcare_item_name => '아이템 이름';

  @override
  String get childcare_item_name_hint => '예: TV 30분 더보기';

  @override
  String get childcare_item_points => '포인트 비용';

  @override
  String get childcare_shop_help_title => '포인트 상점이란?';

  @override
  String get childcare_shop_help_body =>
      '아이가 모은 포인트로 구매할 수 있는 보상 목록입니다.\n원하는 것을 얻기 위해 스스로 포인트를 모으는 동기부여가 됩니다.';

  @override
  String get childcare_shop_examples => '예시 아이템';

  @override
  String get childcare_shop_example1 => 'TV 30분 더보기';

  @override
  String get childcare_shop_example2 => '게임 1시간 하기';

  @override
  String get childcare_shop_example3 => '원하는 간식 고르기';

  @override
  String get childcare_shop_example4 => '늦게 자도 되는 날';

  @override
  String get childcare_shop_disable_note => '아이템을 비활성화하면 목록에서 숨길 수 있습니다.';

  @override
  String get childcare_period_monthly => '월별';

  @override
  String get childcare_period_yearly => '연도별';

  @override
  String get childcare_income => '수입';

  @override
  String get childcare_expense => '지출';

  @override
  String get childcare_net_change => '순변동';

  @override
  String get childcare_yearly_income => '연간 수입';

  @override
  String get childcare_yearly_expense => '연간 지출';

  @override
  String get childcare_balance_trend => '잔액 추이';

  @override
  String get childcare_monthly_status => '월별 현황';

  @override
  String get childcare_type_distribution => '유형별 분포';

  @override
  String childcare_month_unit(String month) {
    return '$month월';
  }

  @override
  String get childcare_no_income_this_month => '이번 달 수입 내역이 없습니다';

  @override
  String get childcare_no_expense_this_month => '이번 달 지출 내역이 없습니다';

  @override
  String get childcare_type_allowance => '용돈';

  @override
  String get childcare_type_reward => '보상';

  @override
  String get childcare_type_bonus => '보너스';

  @override
  String get childcare_type_interest => '이자';

  @override
  String get childcare_type_savings_withdraw => '적금 출금';

  @override
  String get childcare_type_penalty => '벌점';

  @override
  String get childcare_type_purchase => '상점';

  @override
  String get childcare_type_cashout => '현금화';

  @override
  String get childcare_type_savings_deposit => '적금';

  @override
  String get common_etc => '기타';

  @override
  String get childcare_profile_add => '자녀 프로필 등록';

  @override
  String get childcare_child_name => '자녀 이름';

  @override
  String get childcare_child_name_hint => '예: 김민준';

  @override
  String get childcare_child_name_required => '자녀 이름을 입력해주세요';

  @override
  String get childcare_birthdate => '생년월일';

  @override
  String get childcare_birthdate_required => '생년월일을 선택해주세요';

  @override
  String get childcare_profile_added => '자녀 프로필을 등록했습니다';

  @override
  String get childcare_profile_add_failed => '등록하지 못했습니다. 다시 시도해주세요';

  @override
  String childcare_date_full(String year, String month, String day) {
    return '$year년 $month월 $day일';
  }

  @override
  String childcare_year_unit(String year) {
    return '$year년';
  }

  @override
  String childcare_link_title(String name) {
    return '$name 계정 연동';
  }

  @override
  String get childcare_link_linked => '앱 계정 연동됨';

  @override
  String get childcare_link_unlinked => '앱 계정 미연동';

  @override
  String childcare_link_account_id(String id) {
    return '연동된 계정 ID: $id...';
  }

  @override
  String get childcare_link_guide => '계정 연동 안내';

  @override
  String get childcare_link_guide1 => '자녀가 앱에 직접 가입해야 연동이 가능합니다.';

  @override
  String get childcare_link_guide2 => '연동 후 자녀가 직접 포인트 현황을 확인할 수 있습니다.';

  @override
  String get childcare_link_guide3 => '자녀 계정으로 적금 입금이 가능해집니다.';

  @override
  String get childcare_link_button => '앱 계정 연동하기';

  @override
  String get childcare_link_info => '연동 정보';

  @override
  String get childcare_link_info1 => '자녀가 앱으로 직접 포인트를 확인할 수 있습니다.';

  @override
  String get childcare_link_info2 => '자녀 계정으로 적금 입금이 가능합니다.';

  @override
  String get childcare_link_done => '앱 계정을 연동했습니다';

  @override
  String get childcare_link_failed => '연동하지 못했습니다. 자녀가 앱에 가입되어 있는지 확인해주세요';

  @override
  String get childcare_bonus_give => '보너스 지급';

  @override
  String get childcare_child_register => '자녀 등록';

  @override
  String get childcare_allowance_setup_button => '용돈 플랜 설정';

  @override
  String get childcare_link_account => '앱 계정 연동';

  @override
  String get childcare_bonus_desc =>
      '아이에게 보너스 포인트를 지급합니다.\n규칙이나 상점 외에 특별히 칭찬하고 싶을 때 사용하세요.';

  @override
  String get childcare_bonus_points => '지급 포인트';

  @override
  String get childcare_bonus_points_required => '지급 포인트를 입력해주세요';

  @override
  String get childcare_bonus_points_positive => '1 이상의 포인트를 입력해주세요';

  @override
  String get childcare_bonus_reason => '지급 이유';

  @override
  String get childcare_bonus_reason_hint => '예: 방 청소를 스스로 해서';

  @override
  String get childcare_bonus_reason_required => '지급 이유를 입력해주세요';

  @override
  String get childcare_bonus_given => '보너스를 지급했습니다';

  @override
  String get common_deactivate => '비활성화';

  @override
  String get common_activate => '활성화';

  @override
  String childcare_approx_money(String amount) {
    return '≈ $amount원';
  }

  @override
  String get childcare_points_per_month => 'P/월';

  @override
  String childcare_plan_summary(String day, String amount) {
    return '매월 $day일 · 1P=$amount원';
  }

  @override
  String get task_recurring_guide => '반복 일정 안내';

  @override
  String get task_recurring_guide_body => '반복 일정은 아래 기준으로 자동 생성됩니다.';

  @override
  String get task_recurring_daily_weekly => '매일 / 매주';

  @override
  String get task_recurring_monthly_unit => '월 단위';

  @override
  String get task_recurring_yearly_unit => '연 단위';

  @override
  String get task_recurring_every_month => '매월 (1개월마다)';

  @override
  String get task_recurring_every_2months => '격월 (2개월마다)';

  @override
  String get task_recurring_every_3months => '3개월마다';

  @override
  String get task_recurring_every_year => '매년 (1년마다)';

  @override
  String get task_recurring_every_2years => '2년마다';

  @override
  String task_recurring_ahead_months(String months) {
    return '$months개월치';
  }

  @override
  String get task_recurring_ahead_3months => '3개월치 사전 생성';

  @override
  String get task_lunar => '음력';

  @override
  String get task_lunar_leap_prefix => '윤';

  @override
  String task_lunar_date(String prefix, String month, String day) {
    return '음력 $prefix$month월 $day일';
  }

  @override
  String get task_lunar_pick => '음력 날짜 선택';

  @override
  String get task_month => '월';

  @override
  String get task_day => '일';

  @override
  String task_month_value(String month) {
    return '$month월';
  }

  @override
  String task_day_value(String day) {
    return '$day일';
  }

  @override
  String get task_leap_month => '윤달';

  @override
  String get task_leap_month_desc => '윤달이 없는 해에는 해당 달의 같은 날로 처리됩니다';

  @override
  String get task_skip_settings => '건너뜀 설정';

  @override
  String get task_skip_weekend => '주말';

  @override
  String get task_skip_holiday => '공휴일';

  @override
  String get task_skip_when => '건너뛸 때';

  @override
  String get task_skip_do => '건너뜀';

  @override
  String get task_skip_next_weekday => '다음 평일로';

  @override
  String get anniversary_detail => '기념일 상세';

  @override
  String get anniversary_date => '기념일 날짜';

  @override
  String get anniversary_created_at => '등록일';

  @override
  String get anniversary_delete => '기념일 삭제';

  @override
  String anniversary_delete_message(String title) {
    return '\"$title\"을(를) 삭제하시겠습니까?';
  }

  @override
  String get anniversary_delete_linked => '연동된 기념일 일정도 함께 삭제';

  @override
  String get anniversary_delete_linked_desc => '체크 해제 시 일정은 유지됩니다';

  @override
  String get anniversary_delete_failed => '삭제하지 못했습니다';

  @override
  String get anniversary_days_elapsed => '경과일';

  @override
  String get anniversary_next => '다음 기념일';

  @override
  String get anniversary_upcoming => '예정된 기념일';

  @override
  String get anniversary_collapse => '접기';

  @override
  String anniversary_show_more(int count) {
    return '+ $count개 더 보기';
  }

  @override
  String get anniversary_every100 => '100일 단위 (D+100, D+200…)';

  @override
  String get anniversary_everyYear => '매년 주년 (1주년, 2주년…)';

  @override
  String get anniversary_auto_create => '기념일 알림 일정 자동 생성';

  @override
  String get anniversary_manage => '기념일 관리';

  @override
  String get anniversary_add => '기념일 추가';

  @override
  String get anniversary_edit => '기념일 수정';

  @override
  String get anniversary_load_failed => '기념일을 불러오지 못했습니다';

  @override
  String get anniversary_empty => '등록된 기념일이 없습니다';

  @override
  String get anniversary_name => '기념일 이름';

  @override
  String get anniversary_name_hint => '예: 결혼기념일';

  @override
  String get anniversary_name_required => '기념일 이름을 입력해 주세요';

  @override
  String get anniversary_create_failed => '만들지 못했습니다';

  @override
  String get anniversary_update_failed => '수정하지 못했습니다';

  @override
  String get common_date => '날짜';

  @override
  String get task_recurring_edit_title => '반복 일정을 수정하시겠습니까?';

  @override
  String get task_recurring_edit_this => '이 일정만 수정';

  @override
  String get task_recurring_edit_following => '이 일정 및 이후 일정 모두 수정';

  @override
  String get task_recurring_delete_title => '이 반복 일정을 삭제하시겠습니까?';

  @override
  String get task_recurring_delete_this => '이 일정만 삭제';

  @override
  String get task_recurring_delete_following => '이 일정 및 이후 일정 모두 삭제';

  @override
  String get task_recurring_delete_all => '모든 반복 일정 삭제';

  @override
  String get task_label_type => '유형';

  @override
  String get task_label_category => '카테고리';

  @override
  String get task_label_createdAt => '등록일';

  @override
  String get task_completed => '완료됨';

  @override
  String get task_inactive => '(비활성)';

  @override
  String task_start_at(String date, String time) {
    return '시작: $date $time';
  }

  @override
  String task_end_at(String date, String time) {
    return '종료: $date $time';
  }

  @override
  String task_end_time_only(String time) {
    return '종료: $time';
  }

  @override
  String get task_type_calendarOnly => '캘린더 전용';

  @override
  String get task_type_todoLinked => '할일 연동';

  @override
  String get task_type_todoOnly => '할일 전용';

  @override
  String get task_type_default => '일반 일정';

  @override
  String get task_coach_title_title => '일정 제목';

  @override
  String get task_coach_title_desc => '일정의 이름을 입력하세요.\n짧고 명확하게 적을수록 좋아요.';

  @override
  String get task_coach_date_title => '날짜 & 시간';

  @override
  String get task_coach_date_desc => '일정 시작일과 종료일,\n시간을 지정할 수 있어요.';

  @override
  String get task_coach_type_title => '일정 유형';

  @override
  String get task_coach_type_desc => '일반 일정, 할 일, 또는 둘 다로\n유형을 선택할 수 있어요.';

  @override
  String get task_coach_participants_title => '참가자';

  @override
  String get task_coach_participants_desc =>
      '그룹원을 이 일정에 초대할 수 있어요.\n참가자에게 알림이 전송돼요.';

  @override
  String get common_skip => '건너뛰기';

  @override
  String get task_place_search_hint => '장소명 또는 주소 검색';

  @override
  String get task_place_search_prompt => '장소를 검색해보세요';

  @override
  String get notif_settings => '알림 설정';

  @override
  String notif_hour_am(String hour) {
    return '오전 $hour시';
  }

  @override
  String get notif_hour_noon => '낮 12시';

  @override
  String notif_hour_pm(String hour) {
    return '오후 $hour시';
  }

  @override
  String get notif_task => '일정 알림';

  @override
  String get notif_task_desc => '일정 시작 전 알림을 받습니다';

  @override
  String get notif_todo => '할 일 알림';

  @override
  String get notif_todo_desc => '할 일 마감 기한 알림을 받습니다';

  @override
  String get notif_household => '가계부 알림';

  @override
  String get notif_household_desc => '가계부 관련 알림을 받습니다';

  @override
  String get notif_assets => '자산 알림';

  @override
  String get notif_assets_desc => '자산 변동 관련 알림을 받습니다';

  @override
  String get notif_childcare => '육아 알림';

  @override
  String get notif_childcare_desc => '육아 포인트 관련 알림을 받습니다';

  @override
  String get notif_group => '그룹 알림';

  @override
  String get notif_group_desc => '그룹 관련 알림을 받습니다';

  @override
  String get notif_savings => '적금 알림';

  @override
  String get notif_savings_desc => '적금 목표 및 납입 관련 알림을 받습니다';

  @override
  String get notif_system => '시스템 알림';

  @override
  String get notif_system_desc => '중요한 시스템 알림을 받습니다';

  @override
  String get notif_weather => '날씨 알림';

  @override
  String get notif_weather_desc => '비·눈 예보 또는 큰 기온 변화 시 알립니다';

  @override
  String get notif_weather_time => '날씨 알림 시간';

  @override
  String get notif_weather_time_desc => '앱 실행 시 설정 시간이 되면 알림을 보냅니다';

  @override
  String get notif_routine => '루틴 알림';

  @override
  String get notif_routine_desc => '미체크 루틴 리마인드, 배지 획득, 주간 요약을 받습니다';

  @override
  String get notif_routine_time => '루틴 리마인드 시간';

  @override
  String get notif_routine_time_desc => '설정 시간까지 오늘 미체크 루틴이 있으면 알림을 보냅니다';

  @override
  String get notif_unread => '읽지 않은 알림';

  @override
  String get notif_mark_all_read => '전체 읽음';

  @override
  String get notif_view_all => '전체보기';

  @override
  String get notif_mark_read => '읽음 처리';

  @override
  String get notif_action_failed => '알림을 처리하지 못했습니다';

  @override
  String notif_marked_read_count(int count) {
    return '알림 $count개를 읽음 처리했습니다';
  }

  @override
  String get notif_mark_all_failed => '전체 읽음 처리에 실패했습니다';

  @override
  String get notif_none_new => '새로운 알림이 없습니다';

  @override
  String get notif_load_failed => '알림을 불러오지 못했습니다';

  @override
  String get notif_permission => '알림 권한';

  @override
  String get notif_permission_granted => '알림 권한이 허용되었습니다';

  @override
  String get notif_permission_denied => '알림 권한이 거부되었습니다';

  @override
  String get notif_permission_on => '활성화됨';

  @override
  String get notif_permission_off => '비활성화됨';

  @override
  String get notif_permission_on_desc => '푸시 알림을 받을 수 있습니다.';

  @override
  String get notif_permission_off_desc => '알림을 받으려면 권한을 허용해주세요.';

  @override
  String get notif_permission_request => '권한 요청';

  @override
  String get notif_permission_settings => '설정에서 권한 허용';

  @override
  String get location_permission => '위치 권한';

  @override
  String get location_permission_granted => '위치 권한이 허용되었습니다';

  @override
  String get location_permission_denied => '위치 권한이 거부되었습니다';

  @override
  String get location_permission_on_desc => '날씨 알림 발송에 현재 위치가 사용됩니다.';

  @override
  String get location_permission_off_desc =>
      '날씨 알림을 받으려면 위치 권한을 허용해주세요.\n위치 정보는 날씨 알림 발송 목적으로만 사용되며 서버에 저장됩니다.';

  @override
  String get notif_delete => '알림 삭제';

  @override
  String get notif_delete_message => '이 알림을 삭제하시겠습니까?';

  @override
  String get notif_deleted => '알림을 삭제했습니다';

  @override
  String get notif_delete_failed => '알림을 삭제하지 못했습니다';

  @override
  String get notif_title => '알림';

  @override
  String get notif_empty => '알림이 없습니다';

  @override
  String get notif_history => '알림 히스토리';

  @override
  String get notif_history_desc => '받은 알림 목록을 확인합니다';

  @override
  String get notif_settings_load_failed => '알림 설정을 불러오지 못했습니다';

  @override
  String get notif_test_send => '테스트 알림 전송';

  @override
  String get notif_test_send_desc => '테스트 알림을 자신에게 전송합니다 (운영자 전용)';

  @override
  String get notif_test_sent => '테스트 알림을 보냈습니다';

  @override
  String get notif_test_failed => '테스트 알림을 보내지 못했습니다';

  @override
  String get common_anonymous => '익명';

  @override
  String get common_admin => '관리자';

  @override
  String get common_updateDone => '수정 완료';

  @override
  String get qna_myQuestionsOnly => '내 질문만';

  @override
  String get qna_allCategories => '전체 카테고리';

  @override
  String get qna_tab_pending => '대기중';

  @override
  String get qna_tab_answered => '답변완료';

  @override
  String get qna_tab_resolved => '해결완료';

  @override
  String qna_searchLabel(String query) {
    return '검색: $query';
  }

  @override
  String get qna_writeQuestion => '질문 작성';

  @override
  String get qna_editQuestion => '질문 수정';

  @override
  String get qna_searchByTitleOrContent => '제목 또는 내용으로 검색';

  @override
  String qna_emptyByStatus(String status) {
    return '$status 상태의 질문이 없습니다';
  }

  @override
  String qna_emptyByCategory(String category) {
    return '$category 카테고리의 질문이 없습니다';
  }

  @override
  String get qna_emptyMine => '아직 작성한 질문이 없습니다\n궁금한 점을 질문해보세요!';

  @override
  String get qna_listLoadError => '질문 목록을 불러오지 못했습니다';

  @override
  String get qna_contentLabel => '내용';

  @override
  String get qna_titleLabel => '제목';

  @override
  String get qna_contentHintDetailed =>
      '질문 내용을 자세히 작성해주세요. 스크린샷이 있으면 더 빠른 답변이 가능합니다.';

  @override
  String get qna_contentMaxLength => '내용은 5000자를 초과할 수 없습니다';

  @override
  String get qna_titleMin5 => '제목은 5자 이상 입력해주세요';

  @override
  String get qna_contentMin10 => '내용은 10자 이상 입력해주세요';

  @override
  String get qna_submitQuestion => '질문 등록';

  @override
  String get qna_writeGuide => '질문 작성 안내';

  @override
  String get qna_writeGuideBody =>
      '• 질문은 관리자가 확인 후 답변드립니다.\n• 답변은 알림으로 안내됩니다.\n• 대기 중 상태에서만 수정/삭제 가능합니다.';

  @override
  String get qna_visibility => '공개 설정';

  @override
  String get qna_createSuccessDetail => '질문이 등록되었습니다.\n답변은 알림으로 안내드립니다.';

  @override
  String get qna_questionDetail => '질문 상세';

  @override
  String get qna_cannotEditResolved => '해결 완료된 질문은 수정할 수 없습니다';

  @override
  String get qna_resolve => '해결완료';

  @override
  String get qna_attachments => '첨부파일';

  @override
  String get qna_downloadNotReady => '파일 다운로드는 아직 준비 중입니다';

  @override
  String qna_answersCount(int count) {
    return '답변 ($count)';
  }

  @override
  String get qna_resolveTitle => '해결완료 처리';

  @override
  String get qna_resolveMessage =>
      '이 질문을 해결완료로 처리하시겠습니까?\n해결완료 후에는 질문을 수정할 수 없습니다.';

  @override
  String get qna_editAnswer => '답변 수정';

  @override
  String get qna_deleteAnswer => '답변 삭제';

  @override
  String get qna_deleteAnswerMessage => '이 답변을 삭제하시겠습니까?\n삭제된 답변은 복구할 수 없습니다.';

  @override
  String get qna_writeAnswer => '답변 작성';

  @override
  String get qna_submitAnswer => '답변 등록';

  @override
  String get qna_submittingAnswer => '답변 등록 중...';

  @override
  String get qna_resolvedPrompt => '문제가 해결되셨나요?';

  @override
  String get qna_resolvedPromptBody =>
      '답변이 도움이 되셨다면 해결 완료로 변경해주세요.\n1주일간 상태를 변경하지 않으면 자동으로 해결 완료로 변경됩니다.';

  @override
  String get common_collapse => '접기';

  @override
  String get common_required_mark => '(필수)';

  @override
  String get common_errorOccurred => '오류가 발생했습니다';

  @override
  String get asset_account_order_saved => '계좌 순서를 저장했습니다';

  @override
  String get asset_management => '자산 관리';

  @override
  String get asset_management_placeholder => '자산 관리 기능이 여기에 표시됩니다';

  @override
  String get asset_record_reminder => '기록 알림';

  @override
  String get asset_record_reminder_desc => '매월 지정한 날짜에 자산 기록 입력 알림을 보내드립니다.';

  @override
  String get asset_reminder_day => '알림 날짜';

  @override
  String asset_monthly_day(String day) {
    return '매월 $day일';
  }

  @override
  String get asset_reminder_day_note => '29~31일은 해당 월에 없는 경우 말일에 발송됩니다.';

  @override
  String get asset_withdrawal_record => '출금 기록';

  @override
  String asset_withdrawal_date(String date) {
    return '출금 날짜: $date';
  }

  @override
  String get asset_withdrawal_type => '출금 유형';

  @override
  String get asset_withdrawal_type_desc =>
      '출금한 금액이 원금에서 나간 것인지, 수익에서 나간 것인지 선택해 주세요.';

  @override
  String get asset_withdrawal_type_required => '출금 유형을 선택해 주세요';

  @override
  String get asset_withdrawal_amount => '출금 금액';

  @override
  String get asset_amount_invalid => '유효한 금액을 입력해 주세요';

  @override
  String get asset_memo_optional => '메모 (선택)';

  @override
  String get asset_memo_hint => '예: 생활비, 수익 실현';

  @override
  String get asset_save_failed => '저장하지 못했습니다';

  @override
  String get asset_withdrawal_from_principal => '원금에서 차감 (생활비, 계좌 이동 등)';

  @override
  String get asset_holding_add => '종목 추가';

  @override
  String get asset_holding_edit => '종목 수정';

  @override
  String get asset_holding_name => '종목명';

  @override
  String get asset_holding_name_hint => '예: 나스닥 ETF, 삼성전자';

  @override
  String get asset_holding_name_required => '종목명을 입력해 주세요';

  @override
  String get asset_holding_ticker => '티커 (선택)';

  @override
  String get asset_holding_ticker_hint => '예: QQQ, 005930';

  @override
  String get asset_amount_label => '금액';

  @override
  String get asset_ratio_auto => '비율은 잔액 기준으로 자동 계산됩니다';

  @override
  String asset_date_full(String year, String month, String day) {
    return '$year년 $month월 $day일';
  }

  @override
  String get asset_coach_detail_title => '계좌 상세 정보';

  @override
  String get asset_coach_detail_desc =>
      '최신 잔액과 수익률을 확인하고,\n아래로 스크롤하면 자산 변화 차트와\n원금·수익금 통계를 볼 수 있어요.';

  @override
  String get asset_coach_record_title => '잔액 기록 추가';

  @override
  String get asset_coach_record_desc =>
      '잔액을 주기적으로 기록하면\n자산 변화 추이를 차트로 확인할 수 있어요.\n출금 기록도 함께 관리할 수 있습니다.';

  @override
  String get asset_coach_portfolio_title => '포트폴리오';

  @override
  String get asset_coach_portfolio_desc =>
      '날짜별로 보유 종목과 금액을 기록해\n자산 구성을 파이차트로 확인하세요.\n두 날짜를 비교해 변화도 볼 수 있어요.';

  @override
  String asset_view_all_records(int count) {
    return '전체 $count건 보기';
  }

  @override
  String get asset_balance_record => '잔액 기록';

  @override
  String get asset_balance_record_desc => '잔액·원금·수익을 기록합니다';

  @override
  String get asset_withdrawal => '출금';

  @override
  String get asset_withdrawal_desc => '원금 인출 또는 수익 실현을 기록합니다';

  @override
  String get asset_portfolio => '포트폴리오';

  @override
  String get asset_change => '변화';

  @override
  String get asset_total => '합계';

  @override
  String get asset_retry => '재시도';

  @override
  String get asset_reset_auto => '자동 계산으로 되돌리기';

  @override
  String get asset_withdrawal_delete => '출금 기록 삭제';

  @override
  String get asset_withdrawal_delete_message =>
      '삭제하면 출금일 이후 원금/수익이 원복됩니다. 계속하시겠어요?';

  @override
  String get asset_holding_add_button => '종목 추가';

  @override
  String get asset_compare => '비교';

  @override
  String get asset_record_first => '잔액 기록을 먼저 추가하면 포트폴리오를 기록할 수 있습니다.';

  @override
  String get asset_no_holdings => '이 날짜에 등록된 종목이 없습니다.';

  @override
  String get asset_cash => '현금';

  @override
  String get asset_holding_delete => '종목 삭제';

  @override
  String asset_holding_delete_message(String name) {
    return '$name 기록을 삭제할까요?';
  }

  @override
  String get asset_delete_failed => '삭제하지 못했습니다';

  @override
  String asset_others_count(int count) {
    return '기타 $count개';
  }

  @override
  String asset_fill_with_cash(String amount) {
    return '현금으로 채우기 ($amount)';
  }

  @override
  String asset_balance_value(String amount) {
    return '잔액: $amount';
  }

  @override
  String get asset_filter_min_one => '적어도 하나는 선택해 주세요';

  @override
  String get asset_withdrawal_type_desc_full =>
      '출금한 금액이 원금에서 나간 것인지, 수익에서 나간 것인지 선택해 주세요.\n잔액 기록 시 원금과 수익을 자동으로 재계산하는 데 사용됩니다.';

  @override
  String get asset_withdrawal_from_profit => '수익에서 차감 (세금, 수익 인출 등)';

  @override
  String get asset_filter_min_one_account => '적어도 한 개의 계좌를 선택해 주세요.';

  @override
  String asset_legend_more(int count) {
    return '+$count개 더보기';
  }

  @override
  String get asset_holdings_section => '포트폴리오';

  @override
  String asset_others_ratio(int count, String ratio) {
    return '기타 $count개  $ratio%';
  }

  @override
  String get asset_cumulative_return => '누적 수익률';

  @override
  String get asset_period_return => '기간 수익률';

  @override
  String get asset_tooltip_balance => '각 시점의 총 자산 잔액입니다.\n잔액 = 원금 + 수익금';

  @override
  String get asset_tooltip_principal =>
      '각 시점까지 실제로 입금한 누적 투자 원금입니다.\n수익·손실은 포함되지 않습니다.';

  @override
  String get asset_tooltip_profit => '각 시점의 누적 수익금입니다.\n수익금 = 잔액 − 원금';

  @override
  String get asset_tooltip_cumulative =>
      '각 시점의 누적 수익률입니다.\n누적 수익률 = 수익금 ÷ 원금 × 100';

  @override
  String get asset_tooltip_period =>
      '직전 시점 대비 해당 기간의 수익률입니다.\n원금 입·출금의 영향을 제거하고 순수한 수익 변화만 반영합니다.\n\n기간 수익률 = (이번 수익금 − 전 수익금) ÷ 전 원금 × 100';

  @override
  String asset_amount_won(String amount) {
    return '$amount원';
  }

  @override
  String asset_month_unit(String month) {
    return '$month월';
  }

  @override
  String asset_gold_price_per_gram(String amount) {
    return '$amount원/g';
  }

  @override
  String get asset_compare_usd => 'USD환산';

  @override
  String get minigame_title => '미니게임';

  @override
  String get minigame_coach_desc =>
      '사다리타기와 룰렛 게임을 즐길 수 있어요.\n공정한 결정이 필요할 때 활용해보세요!';

  @override
  String get minigame_coach_group => '그룹 선택';

  @override
  String get minigame_coach_group_desc =>
      '그룹을 선택하면 게임 결과가\n자동으로 저장돼요.\n그룹 멤버 누구나 이력을 확인할 수 있어요.';

  @override
  String get minigame_history => '게임 이력';

  @override
  String get minigame_coach_history_desc =>
      '지금까지 진행한 게임 결과를\n이곳에서 확인할 수 있어요.\n누가 어떤 결과를 받았는지 투명하게 공개됩니다.';

  @override
  String get minigame_ladder => '사다리타기';

  @override
  String get minigame_roulette => '룰렛';

  @override
  String get minigame_no_group => '그룹 없음 (이력 저장 안 함)';

  @override
  String get minigame_history_empty => '게임 이력이 없습니다';

  @override
  String get minigame_select_group_hint => '그룹을 선택하면\n게임 이력이 자동 저장됩니다';

  @override
  String get minigame_history_delete => '이력 삭제';

  @override
  String get minigame_history_delete_message => '이 게임 이력을 삭제하시겠습니까?';

  @override
  String minigame_winner(String name) {
    return '당첨: $name';
  }

  @override
  String get minigame_ladder_default_title => '사다리타기';

  @override
  String get minigame_roulette_default_title => '룰렛';

  @override
  String get minigame_game_title => '게임 제목';

  @override
  String get minigame_create_ladder => '사다리 생성';

  @override
  String get minigame_ladder_hint => '참여자 이름을 눌러 사다리를 타세요!';

  @override
  String get minigame_skip_all => '전체 스킵';

  @override
  String get minigame_reset => '다시 설정';

  @override
  String get minigame_participants => '참여자';

  @override
  String get minigame_final_result => '최종 결과';

  @override
  String get minigame_saved => '게임 결과를 저장했습니다';

  @override
  String get minigame_save_failed => '저장하지 못했습니다';

  @override
  String get minigame_result_items => '결과 항목';

  @override
  String minigame_item_hint(int index) {
    return '항목 $index';
  }

  @override
  String get minigame_add_item => '항목 추가';

  @override
  String minigame_count_mismatch(String total, String count) {
    return '수량 합계($total)가 참여자 수($count)와 같아야 합니다';
  }

  @override
  String get minigame_playing_with_group => '그룹으로 플레이 중';

  @override
  String get minigame_members_loading => '그룹 멤버를 불러오는 중입니다. 잠시 후 다시 시도해주세요.';

  @override
  String minigame_add_manually(String label) {
    return '$label 직접 추가';
  }

  @override
  String get minigame_select_members => '멤버 선택';

  @override
  String get minigame_select_group_members => '그룹 멤버 선택';

  @override
  String get minigame_unknown => '알 수 없음';

  @override
  String get minigame_already_added => '이미 추가됨';

  @override
  String minigame_add_count(int count) {
    return '추가 ($count)';
  }

  @override
  String get minigame_spin => '돌리기';

  @override
  String get minigame_need_two_items => '항목을 2개 이상 입력해주세요';

  @override
  String get minigame_result => '결과';

  @override
  String get minigame_item => '항목';

  @override
  String get minigame_ratio => '비율';

  @override
  String get common_filter => '필터';

  @override
  String get common_selectGroup => '그룹 선택';

  @override
  String get common_unknown => '알 수 없음';

  @override
  String home_delete_scheduled(String date, String days) {
    return '계정이 $date ($days일 후)에 삭제될 예정입니다.';
  }

  @override
  String get home_delete_cancel => '삭제 취소';

  @override
  String get home_delete_canceled => '계정 삭제 예약을 취소했습니다';

  @override
  String get home_coach_more => '더보기 탭에서 시작하세요';

  @override
  String get home_coach_group => '그룹 관리';

  @override
  String get home_coach_group_desc =>
      '가족, 연인, 친구 등 원하는 그룹을 만들고\n초대 코드로 구성원을 초대하세요.';

  @override
  String get home_coach_widget => '대시보드 위젯 커스터마이징';

  @override
  String get home_coach_widget_desc => '설정 → 홈 위젯 설정에서\n원하는 위젯만 골라 대시보드를 꾸미세요.';

  @override
  String get home_coach_tab => '하단 탭 커스터마이징';

  @override
  String get home_coach_tab_desc => '설정 → 하단 네비게이션 설정에서\n자주 쓰는 메뉴로 자유롭게 바꾸세요.';

  @override
  String get home_coach_tap_more => '탭을 눌러 더보기로 이동';

  @override
  String get home_period => '기간';

  @override
  String get home_personal_schedule => '개인 일정';

  @override
  String get home_personal_schedule_desc => '내 개인 일정 포함';

  @override
  String get home_view_mode => '보기 모드';

  @override
  String get home_pinned_memos => '고정된 메모';

  @override
  String get home_pinned_memos_empty => '고정된 메모가 없습니다';

  @override
  String home_checklist_progress(String checked, String total) {
    return '$checked/$total 완료';
  }

  @override
  String get home_no_expiry => '기한 없음';

  @override
  String home_expired_days(String days) {
    return '$days일 초과';
  }

  @override
  String get home_expires_today => '오늘 만료';

  @override
  String get home_total_savings => '총 적립액';

  @override
  String home_active_goals(int count) {
    return '$count개 진행 중';
  }

  @override
  String home_goal_amount(String amount) {
    return '목표 $amount';
  }

  @override
  String home_more_goals(int count) {
    return '외 $count개';
  }

  @override
  String get home_schedule_filter => '일정 필터';

  @override
  String get home_no_children => '등록된 자녀가 없습니다';

  @override
  String home_childcare_savings(String points) {
    return '적금 ${points}P';
  }

  @override
  String home_anniversary_more(int count) {
    return '+ $count개 더 보기';
  }

  @override
  String get auth_email_copied => '이메일 주소를 복사했습니다';

  @override
  String get auth_login_processing => '로그인 처리 중...';

  @override
  String get auth_please_wait => '잠시만 기다려주세요.';

  @override
  String get auth_login_failed => '로그인 실패';

  @override
  String get auth_back_to_login => '로그인 화면으로 돌아가기';

  @override
  String get auth_code_required => '인증 코드를 입력해주세요';

  @override
  String get auth_email_verified => '이메일 인증이 완료되었습니다. 로그인해주세요.';

  @override
  String get auth_email_resent => '인증 이메일을 다시 보냈습니다.';

  @override
  String get auth_email_verification => '이메일 인증';

  @override
  String get auth_check_email => '이메일을 확인해주세요';

  @override
  String auth_email_sent_to(String email) {
    return '$email\n으로 인증 이메일을 보냈습니다.';
  }

  @override
  String get auth_enter_code => '인증 코드 입력';

  @override
  String get auth_enter_code_desc => '이메일에 포함된 6자리 인증 코드를 입력해주세요.';

  @override
  String get auth_code_label => '인증 코드';

  @override
  String get auth_code_hint => '예: 123456';

  @override
  String get auth_no_email => '이메일을 받지 못하셨나요?';

  @override
  String get auth_resend_email => '인증 이메일 재전송';

  @override
  String get auth_verify_later => '나중에 인증하기 ';

  @override
  String get auth_back_to_signin => '로그인으로 돌아가기';

  @override
  String get auth_no_token => '인증 토큰이 없습니다. 다시 로그인해주세요.';

  @override
  String get auth_terms_title => '서비스 이용 동의';

  @override
  String get auth_terms_desc => '패밀리플래너 서비스 이용을\n위해 약관에 동의해 주세요';

  @override
  String get auth_agree_and_start => '동의하고 시작하기';

  @override
  String get ai_assistant => 'AI 어시스턴트';

  @override
  String get ai_premium_desc =>
      '내년 출시될 프리미엄 구독 기능입니다.\n구독을 통해 AI 어시스턴트를 사용하실 수 있습니다.';

  @override
  String get ai_premium_coming => '프리미엄 구독 출시 예정';

  @override
  String get ai_ask_anything => '무엇이든 물어보세요';

  @override
  String get ai_reset_chat => '대화 초기화';

  @override
  String get ai_greeting => '안녕하세요! 가족 플래너 AI입니다.';

  @override
  String get ai_greeting_desc => '아래 추천 질문을 눌러보거나\n직접 질문을 입력해보세요.';

  @override
  String get ai_new_chat => '새 대화를 시작했습니다';

  @override
  String get ai_message_hint => '메시지를 입력하세요...';

  @override
  String get ai_send => '전송';

  @override
  String get ai_suggest1 => '이번 달 지출 분석해줘';

  @override
  String get ai_suggest2 => '가족 일정 요약해줘';

  @override
  String get ai_suggest3 => '저축 목표 달성률 알려줘';

  @override
  String get ai_suggest4 => '미결 할 일 목록 보여줘';

  @override
  String get ai_suggest5 => '투자 포트폴리오 현황은?';

  @override
  String get ai_suggest6 => '이번 주 중요한 일정 뭐 있어?';

  @override
  String get weather_title => '날씨';

  @override
  String get weather_current_failed => '현재 날씨를 불러오지 못했습니다';

  @override
  String get weather_forecast_failed => '예보를 불러오지 못했습니다';

  @override
  String get weather_humidity => '습도';

  @override
  String get weather_wind => '풍속';

  @override
  String get weather_precipitation => '강수량';

  @override
  String get weather_air_quality => '대기질';

  @override
  String get weather_pm10 => '미세먼지';

  @override
  String get weather_pm25 => '초미세먼지';

  @override
  String weather_measured_at(String region) {
    return '측정 기준: $region';
  }

  @override
  String get weather_hourly => '시간별 예보';

  @override
  String get weather_hourly_empty => '시간별 예보 정보가 없습니다';

  @override
  String get weather_daily => '날짜별 예보';

  @override
  String weather_hour(String hour) {
    return '$hour시';
  }

  @override
  String get weather_today => '오늘';

  @override
  String get calendar_view_day => '일';

  @override
  String get calendar_view_week => '주';

  @override
  String get calendar_view_month => '월';

  @override
  String get calendar_view_year => '연도';

  @override
  String get calendar_manage_anniversary => '기념일 관리';

  @override
  String get calendar_select_view => '뷰 선택';

  @override
  String get calendar_allday => '종일';

  @override
  String calendar_lunar_label(String label) {
    return '음력 $label';
  }

  @override
  String calendar_hidden_count(int count) {
    return '+$count개';
  }

  @override
  String calendar_group_more(String name, int count) {
    return '$name 외 $count개';
  }

  @override
  String calendar_year_label(String year) {
    return '$year년';
  }

  @override
  String get calendar_task_added => '일정을 추가했습니다.';

  @override
  String get calendar_task_title_hint => '일정 제목';

  @override
  String get calendar_personal => '개인';

  @override
  String get calendar_type_event => '일정';

  @override
  String get calendar_type_todo => '할일';

  @override
  String get calendar_type_both => '일정+할일';

  @override
  String get calendar_more => '더 보기';

  @override
  String get calendar_remind_5m => '5분 전';

  @override
  String get calendar_remind_15m => '15분 전';

  @override
  String get calendar_remind_30m => '30분 전';

  @override
  String get calendar_remind_1h => '1시간 전';

  @override
  String get calendar_remind_1d => '1일 전';

  @override
  String household_year_label(String year) {
    return '$year년';
  }

  @override
  String get household_yearly_stats => '연간 통계';

  @override
  String get household_stats_exclude_note => '환불금 및 이월 입금은 통계에서 제외됩니다';

  @override
  String get household_by_category => '카테고리별';

  @override
  String get household_by_merchant => '소비처별';

  @override
  String get household_by_member => '멤버별';

  @override
  String get household_custom_filter => '직접 필터링';

  @override
  String get household_category_spending => '카테고리별 지출';

  @override
  String get household_merchant_spending => '소비처별 지출';

  @override
  String get household_member_spending => '멤버별 지출';

  @override
  String get household_no_merchant => '소비처 없음';

  @override
  String get household_unassigned => '미지정';

  @override
  String get household_member => '멤버';

  @override
  String get household_monthly_spending => '월별 지출';

  @override
  String get household_compare_last_month => '지난달 비교';

  @override
  String get household_cumulative_trend => '누적 지출 추이';

  @override
  String get household_variable => '가변';

  @override
  String get household_expected_amount => '예상금액';

  @override
  String get household_due_day => '발생일';

  @override
  String household_due_day_value(String day) {
    return '매월 $day일';
  }

  @override
  String get household_payee => '받는 사람';

  @override
  String get household_payer => '결제하는 사람';

  @override
  String get household_no_applied => '아직 적용된 내역이 없습니다';

  @override
  String get household_confirmed_avg => '확정 평균';

  @override
  String get household_min => '최솟값';

  @override
  String get household_max => '최댓값';

  @override
  String household_unconfirmed_suffix(String date) {
    return '$date  미확정';
  }

  @override
  String get asset_demo_nasdaq => '나스닥 ETF';

  @override
  String get asset_demo_samsung => '삼성전자';

  @override
  String get currency_won_unit => '원';

  @override
  String get household_auto_registered => '가계부 자동 등록 완료';

  @override
  String household_auto_registered_body(String amount) {
    return '$amount원이 가계부에 등록되었습니다.';
  }

  @override
  String get household_auto_service => '가계부 자동 등록';

  @override
  String get household_auto_service_desc => '결제 알림을 감지해 가계부에 자동 등록합니다';

  @override
  String get coach_calendar_shared => '공유 캘린더';

  @override
  String get coach_calendar_shared_desc =>
      '그룹 구성원의 일정을 한눈에 볼 수 있어요.\n날짜를 탭해 해당 날의 일정을 확인하세요.';

  @override
  String get coach_calendar_add => '일정 추가';

  @override
  String get coach_calendar_add_desc => '버튼을 눌러 새 일정을 만드세요.\n눌러서 생성 화면을 살펴보세요.';

  @override
  String get coach_group_create => '그룹 만들기';

  @override
  String get coach_group_create_desc => '가족, 연인, 친구, 팀 등\n원하는 그룹을 직접 만들어 보세요.';

  @override
  String get coach_group_join => '그룹 참여하기';

  @override
  String get coach_group_join_desc =>
      '초대 코드를 입력해 기존 그룹에 합류하세요.\n그룹원이 공유한 코드를 사용하면 돼요.';

  @override
  String get coach_group_requests => '신청 내역';

  @override
  String get coach_group_requests_desc =>
      '내가 참여 신청한 그룹 목록을 확인하고\n수락 여부를 여기서 확인할 수 있어요.';

  @override
  String get coach_savings_status => '적립 현황';

  @override
  String get coach_savings_status_desc =>
      '현재 적립금과 목표 금액,\n달성률을 상세하게 확인할 수 있어요.\n자동 적립 중일 때는 적립 상태도 표시돼요.';

  @override
  String get coach_savings_deposit => '입금 / 출금';

  @override
  String get coach_savings_deposit_desc =>
      '언제든지 직접 입금하거나 출금할 수 있어요.\n자동 적립과 함께 활용하면 더욱 편리해요.';

  @override
  String get coach_savings_goal => '저금통';

  @override
  String get coach_savings_goal_desc =>
      '목표 이름, 현재 적립금, 달성률을 한눈에 확인할 수 있어요.\n자동 적립을 켜두면 매달 자동으로 입금돼요.';

  @override
  String get coach_savings_demo_desc => '올해 여름 가족 여행 목표';

  @override
  String get coach_savings_demo_jeju => '제주도 여행';

  @override
  String get coach_savings_demo_emergency => '비상금';

  @override
  String get demo_milk => '우유';

  @override
  String get demo_eggs => '계란';

  @override
  String get demo_tofu => '두부';

  @override
  String get demo_unit_piece => '개';

  @override
  String get demo_unit_pack => '판';

  @override
  String get demo_fridge => '냉장고';

  @override
  String get demo_freezer => '냉동실';

  @override
  String get demo_bank_savings => '국민은행 적금';

  @override
  String get coach_ladder_participants => '참여자 입력';

  @override
  String get coach_ladder_participants_desc =>
      '사다리를 탈 참여자 이름을 입력해요.\n그룹 멤버 불러오기 버튼으로\n한 번에 추가할 수도 있어요.';

  @override
  String get coach_ladder_results => '결과 항목 입력';

  @override
  String get coach_ladder_results_desc =>
      '당첨될 결과 항목과 수량을 입력해요.\n수량의 합이 참여자 수와 같아야\n사다리를 생성할 수 있어요.';

  @override
  String get coach_ladder_create => '사다리 생성';

  @override
  String get coach_ladder_create_desc =>
      '버튼을 누르면 사다리가 생성돼요.\n참여자 이름을 탭하면 경로가 애니메이션으로\n표시되고 결과가 공개됩니다.';

  @override
  String get coach_roulette_items => '항목 입력';

  @override
  String get coach_roulette_items_desc =>
      '룰렛에 올릴 항목을 입력해요.\n비율을 조정하면 당첨 확률을\n다르게 설정할 수 있어요.';

  @override
  String get coach_roulette_wheel => '룰렛 원판';

  @override
  String get coach_roulette_wheel_desc =>
      '항목을 2개 이상 입력하면\n룰렛 원판이 나타나요.\n가운데 버튼을 눌러도 돌릴 수 있어요.';

  @override
  String get coach_roulette_spin => '돌리기';

  @override
  String get coach_roulette_spin_desc =>
      '버튼을 누르면 룰렛이 회전해요.\n결과는 자동으로 그룹 이력에\n저장되어 모두가 확인할 수 있어요.';

  @override
  String get coach_asset_card => '계좌 카드';

  @override
  String get coach_asset_card_desc =>
      '계좌명, 금융기관, 최신 잔액과 수익률을\n한눈에 확인할 수 있어요.\n탭하면 잔액 기록과 포트폴리오를 관리할 수 있습니다.';

  @override
  String get coach_asset_stats => '자산 통계';

  @override
  String get coach_asset_stats_desc =>
      '전체 자산의 합계, 수익률, 유형별 분포를\n차트로 한눈에 확인할 수 있어요.\nKOSPI·S&P500 등 지수와 비교도 가능합니다.';

  @override
  String get demo_bank_kb => '국민은행';

  @override
  String get coach_group_invite => '멤버를 초대해보세요';

  @override
  String get coach_group_invite_desc =>
      '설정 탭에서 초대 코드를 공유하거나\n이메일로 직접 멤버를 초대할 수 있어요.\n\n탭을 눌러 설정으로 이동하세요.';

  @override
  String get coach_group_invite_code => '초대 코드로 멤버 초대';

  @override
  String get coach_group_invite_code_desc =>
      '코드를 복사해 공유하거나\n이메일로 직접 초대장을 보낼 수 있어요.';

  @override
  String get coach_group_roles => '역할로 권한을 관리하세요';

  @override
  String get coach_group_roles_desc =>
      '역할 탭에서 새로운 역할을 만들고\n멤버별 권한을 세밀하게 설정할 수 있어요.\n\n탭을 눌러 역할 관리로 이동하세요.';

  @override
  String get coach_group_role_new => '새 역할 만들기';

  @override
  String get coach_group_role_new_desc =>
      '버튼을 눌러 역할을 만들고\n이름, 색상, 권한을 자유롭게 설정하세요.';

  @override
  String get coach_group_color => '나만의 그룹 색상을 설정하세요';

  @override
  String get coach_group_color_desc =>
      '설정 탭에서 이 그룹의 색상을 지정할 수 있어요.\n설정한 색상은 일정 등 다양한 메뉴에서\n이 그룹의 항목을 구분하는 데 사용돼요.\n\n탭을 눌러 설정으로 이동하세요.';

  @override
  String get coach_cart_complete => '장보기 완료 기능 안내';

  @override
  String get coach_cart_complete_desc =>
      '장보기 완료 버튼을 누르면 아래 두 가지를 한 번에 처리할 수 있어요.';

  @override
  String get coach_cart_to_fridge => '냉장고로 이관';

  @override
  String get coach_cart_to_fridge_desc =>
      '구매한 품목을 냉장고 보관소로 바로 옮길 수 있어요.\n수량·유통기한·알림일도 함께 설정할 수 있습니다.';

  @override
  String get coach_cart_to_expense => '가계부 자동 기록';

  @override
  String get coach_cart_to_expense_desc =>
      '지출 금액·결제 수단·메모를 입력하면\n가계부에 자동으로 기록돼요.';

  @override
  String get coach_cart_no_transfer => '이관 안 함';

  @override
  String get demo_todo_shopping => '장보기 목록 작성';

  @override
  String get demo_todo_shopping_desc => '이번 주 필요한 식재료 정리';

  @override
  String get demo_todo_trip => '가족 여행 계획';

  @override
  String get demo_todo_trip_desc => '여름 휴가 일정 및 숙소 예약';

  @override
  String get demo_todo_budget => '월간 가계부 정리';

  @override
  String get demo_todo_budget_desc => '지난달 수입·지출 확인';

  @override
  String get coach_todo_byDate => '날짜별 할 일';

  @override
  String get coach_todo_byDate_desc =>
      '날짜를 탭해 해당 날의 할 일을 확인하고\n그룹원과 역할을 나눠 보세요.';

  @override
  String get coach_todo_status => '상태 변경';

  @override
  String get coach_todo_status_desc =>
      '왼쪽 아이콘을 탭하면 할 일의 상태를\n대기 · 진행 중 · 완료 등으로 바꿀 수 있어요.';

  @override
  String get coach_todo_add => '할 일 추가';

  @override
  String get coach_todo_add_desc => '새로운 할 일을 추가하고\n담당자와 마감일을 지정해보세요.';

  @override
  String get demo_apple => '사과';

  @override
  String get coach_history_records => '구매 이력';

  @override
  String get coach_history_records_desc =>
      '장보기를 완료할 때마다 이력이 쌓여요.\n카드를 탭하면 품목별 상세 내역을\n확인할 수 있어요.';

  @override
  String get coach_history_expense => '가계부 연동';

  @override
  String get coach_history_expense_desc =>
      '장보기 완료 시 지출을 함께 기록하면\n이 배지가 표시돼요.\n가계부와 자동으로 연동되어 지출 관리가 편해져요.';

  @override
  String get demo_expense_salary => '6월 급여';

  @override
  String get demo_expense_dining => '저녁 외식';

  @override
  String get demo_expense_fuel => '주유';

  @override
  String get demo_expense_utility => '전기/가스 요금';

  @override
  String get coach_household_summary => '월간 요약';

  @override
  String get coach_household_summary_desc =>
      '이번 달 수입·지출·잔액을 한눈에 확인하고,\n예산 대비 사용량을 진척도 바로 볼 수 있어요.';

  @override
  String get coach_household_budget => '예산 설정';

  @override
  String get coach_household_budget_desc =>
      '여기 더보기 메뉴를 열면 월별 예산을\n카테고리별로 설정할 수 있어요.';

  @override
  String get coach_household_recurring => '고정 지출';

  @override
  String get coach_household_recurring_desc =>
      '월세, 구독료 등 매달 반복되는 지출을\n등록하면 자동으로 기록해 드려요.';

  @override
  String get coach_household_stats => '통계';

  @override
  String get coach_household_stats_desc =>
      '카테고리별 지출 비율과 월별 추이를\n차트로 확인할 수 있어요.';

  @override
  String get coach_household_add => '지출/수입 추가';

  @override
  String get coach_household_add_desc =>
      '새 지출이나 수입을 기록하세요.\n그룹별로 나눠서 관리할 수 있어요.';

  @override
  String get common_me => '나';

  @override
  String get demo_memo_trip => '제주도 여행 준비';

  @override
  String get demo_memo_trip_body =>
      '항공권 예약 완료\n숙소는 한림읍 게스트하우스로 결정.\n렌터카 예약 필요. 우도, 성산일출봉 방문 예정.';

  @override
  String get demo_tag_travel => '여행';

  @override
  String get demo_tag_jeju => '제주';

  @override
  String get demo_memo_packing => '외박 준비물';

  @override
  String get demo_check_passport => '여권 / 신분증';

  @override
  String get demo_check_toiletries => '세면도구';

  @override
  String get demo_check_clothes => '여벌 옷';

  @override
  String get demo_check_charger => '충전기';

  @override
  String get demo_check_meds => '상비약';

  @override
  String get coach_memo_richtext => '리치 텍스트 메모';

  @override
  String get coach_memo_richtext_desc =>
      '굵게, 기울임, 제목 등 서식을 자유롭게 적용할 수 있어요.\n태그로 분류하고 URL을 붙여넣으면\n링크 카드가 자동으로 생성됩니다.';

  @override
  String get coach_memo_checklist => '체크리스트';

  @override
  String get coach_memo_checklist_desc =>
      '메모 중간 어디에든 체크리스트를 삽입할 수 있어요.\n완료된 항목 수가 카드에 바로 표시되고\n상세 화면에서 탭해 체크할 수 있습니다.';

  @override
  String get coach_memo_progress => '진행률';

  @override
  String get coach_memo_progress_desc =>
      '완료된 항목 수를 한눈에 볼 수 있어요.\n전체 선택/초기화 버튼도 있습니다.';

  @override
  String get coach_memo_check => '항목 체크';

  @override
  String get coach_memo_check_desc =>
      '체크박스를 탭하면 완료 처리돼요.\n저장 버튼을 누르면 변경사항이 한 번에 저장됩니다.';

  @override
  String get coach_memo_edit => '수정 모드';

  @override
  String get coach_memo_edit_desc =>
      '수정 버튼을 누르면 에디터가 열려요.\n툴바의 체크리스트 버튼으로 항목을 자유롭게 추가·수정할 수 있습니다.';

  @override
  String get demo_vote_outing => '이번 주말 가족 나들이 장소';

  @override
  String get demo_vote_outing_desc => '다수결로 결정해요! 의견을 남겨주세요.';

  @override
  String get demo_vote_dinner => '저녁 메뉴 결정';

  @override
  String get demo_member_mom => '엄마';

  @override
  String get demo_member_dad => '아빠';

  @override
  String get demo_member_child => '민준';

  @override
  String get demo_place_hangang => '한강공원';

  @override
  String get demo_place_amusement => '놀이동산';

  @override
  String get demo_place_zoo => '동물원';

  @override
  String get demo_food_chicken => '치킨';

  @override
  String get demo_food_pizza => '피자';

  @override
  String get demo_food_pork => '삼겹살';

  @override
  String get demo_group_family => '우리 가족';

  @override
  String get coach_vote_group => '그룹 선택';

  @override
  String get coach_vote_group_desc =>
      '투표는 그룹 단위로 진행돼요.\n그룹을 선택하면 해당 그룹의\n투표 목록을 확인할 수 있어요.';

  @override
  String get coach_vote_filter => '상태 필터';

  @override
  String get coach_vote_filter_desc => '전체, 진행중, 종료된 투표를\n탭으로 쉽게 구분해서 볼 수 있어요.';

  @override
  String get coach_vote_card => '투표 카드';

  @override
  String get coach_vote_card_desc =>
      '카드를 탭하면 선택지에 투표할 수 있어요.\n그룹 멤버 모두가 참여할 수 있고\n결과는 실시간으로 확인할 수 있어요.';

  @override
  String get coach_vote_create => '새 투표 만들기';

  @override
  String get coach_vote_create_desc =>
      '+ 버튼을 눌러 새 투표를 만들어보세요.\n단일/복수 선택, 익명 투표,\n마감 시각 설정도 지원해요.';

  @override
  String get demo_shop_tv_desc => '저녁 식사 후 TV 30분 추가';

  @override
  String get demo_shop_game_desc => '주말에 게임 1시간';

  @override
  String get demo_rule_homework => '숙제를 스스로 끝냈을 때';

  @override
  String get demo_rule_phone => '스마트폰 1시간 이상 사용';

  @override
  String get demo_rule_cashout => '이달 현금 출금은 최대 50P';

  @override
  String get coach_child_register => '자녀 등록';

  @override
  String get coach_child_register_desc =>
      '먼저 자녀를 등록해요.\n이름과 생년월일을 입력하면\n포인트 계정이 자동으로 만들어져요.';

  @override
  String get coach_child_points => '포인트 현황';

  @override
  String get coach_child_points_desc =>
      '자녀의 현재 포인트 잔액과\n월 용돈 플랜을 한눈에 확인할 수 있어요.\n매월 설정한 날짜에 자동으로 포인트가 지급돼요.';

  @override
  String get coach_child_savings => '적금 플랜';

  @override
  String get coach_child_savings_desc =>
      '포인트 적금을 설정하면\n매월 자동으로 포인트가 적립되고\n이자도 받을 수 있어요.';

  @override
  String get coach_child_shop => '포인트 상점';

  @override
  String get coach_child_shop_desc =>
      '아이가 모은 포인트로 구매할 수 있는\n보상 목록이에요.\n원하는 것을 얻기 위해 스스로 포인트를\n모으는 동기부여가 됩니다.';

  @override
  String get coach_child_rule_plus_desc =>
      '좋은 행동을 했을 때 포인트를 지급해요.\n예: 숙제를 스스로 끝냈을 때 +10P';

  @override
  String get coach_child_rule_minus_desc =>
      '약속을 어겼을 때 포인트를 차감해요.\n예: 스마트폰을 1시간 이상 사용하면 -10P';

  @override
  String get coach_child_rule_info_desc =>
      '포인트 없이 약속만 기록해요.\n예: 이달 현금 출금은 최대 50P까지만 가능';

  @override
  String get intro_slide1_title => '우리만의 플래너';

  @override
  String get intro_slide1_subtitle => '가족, 연인, 친구, 팀까지';

  @override
  String get intro_slide1_desc =>
      '하나의 앱으로 여러 그룹을 관리하세요.\n관계마다 다른 공간에서 함께 계획할 수 있어요.';

  @override
  String get intro_slide2_title => '일정을 함께';

  @override
  String get intro_slide2_subtitle => '공유 캘린더';

  @override
  String get intro_slide2_desc => '그룹 구성원 모두의 일정을 한눈에.\n중요한 날을 절대 놓치지 않아요.';

  @override
  String get intro_slide3_title => '할 일 관리';

  @override
  String get intro_slide3_subtitle => '공동 TodoList';

  @override
  String get intro_slide3_desc => '누가 무엇을 해야 하는지 명확하게.\n역할을 나누고 함께 완료해 나가세요.';

  @override
  String get intro_slide4_title => '가계를 한눈에';

  @override
  String get intro_slide4_subtitle => '공동 가계부';

  @override
  String get intro_slide4_desc => '수입과 지출을 함께 기록하고 분석하세요.\n재정 목표를 그룹과 함께 달성해요.';

  @override
  String get intro_slide5_title => '그 외 다양한 기능';

  @override
  String get intro_slide5_subtitle => '자산·메모·적금·투표 등';

  @override
  String get intro_slide5_desc => '일상에 필요한 모든 것을 한 곳에서.\n지금 바로 시작해보세요!';

  @override
  String get intro_start => '시작하기';

  @override
  String get intro_next => '다음';

  @override
  String get intro_preview_couple => '연인';

  @override
  String get intro_preview_friends => '친구 모임';

  @override
  String get intro_preview_team => '팀 프로젝트';

  @override
  String get intro_preview_mygroups => '내 그룹';

  @override
  String intro_preview_members(String count) {
    return '$count명';
  }

  @override
  String get intro_preview_dining => '가족 외식';

  @override
  String get intro_preview_hospital => '병원 예약';

  @override
  String get intro_preview_birthday => '생일 파티 🎂';

  @override
  String get intro_preview_todo1 => '마트 장보기';

  @override
  String get intro_preview_todo2 => '청소기 돌리기';

  @override
  String get intro_preview_todo3 => '보험 갱신 확인';

  @override
  String get intro_preview_todo4 => '가족사진 앨범 정리';

  @override
  String get intro_preview_todo5 => '아이 숙제 확인';

  @override
  String get intro_preview_today => '오늘';

  @override
  String get intro_preview_tomorrow => '내일';

  @override
  String get intro_preview_thisweek => '이번 주';

  @override
  String intro_preview_total(String count) {
    return '전체 $count';
  }

  @override
  String intro_preview_done(String count) {
    return '완료 $count';
  }

  @override
  String get intro_preview_mart => '마트';

  @override
  String get intro_preview_eatout => '외식';

  @override
  String get intro_preview_salary => '월급';

  @override
  String get intro_preview_transport => '교통비';

  @override
  String get intro_preview_assets => '자산 관리';

  @override
  String get intro_preview_savings => '적금 관리';

  @override
  String get demo_memo_domestic => '국산';

  @override
  String get coach_cart_add => '품목 추가';

  @override
  String get coach_cart_add_desc => '구매할 품목을 추가해요.\n추가하면 자동으로 저장됩니다.';

  @override
  String get coach_cart_manage => '품목 관리';

  @override
  String get coach_cart_manage_desc =>
      '• 탭하면 이름·수량·메모를 수정할 수 있어요\n• ± 버튼으로 수량을 조절하세요\n• 왼쪽으로 스와이프하면 삭제돼요\n• 변경하면 잠시 후 자동으로 저장됩니다';

  @override
  String get coach_cart_finish => '장보기 완료';

  @override
  String get coach_cart_finish_desc =>
      '쇼핑을 마치면 여기를 눌러요.\n다음 화면에서 상세 기능을 확인해 보세요!';

  @override
  String get coach_cart_next => '탭하면 다음 기능으로 넘어가요!';

  @override
  String get coach_cart_next_desc => '자주 사는 물건 탭에서 더 많은 기능을 안내해 드릴게요.';

  @override
  String get household_carryover_out => '잔금 이월';

  @override
  String get household_carryover_in => '전월 이월';

  @override
  String household_transfer_asset(String name) {
    return '자산 이동 ($name)';
  }

  @override
  String household_transfer_savings(String name) {
    return '저금통 이동 ($name)';
  }

  @override
  String get household_transfer_from_ledger => '가계부 잔금 이동';

  @override
  String get diary_title => '다이어리';

  @override
  String get diary_empty => '아직 기록이 없어요';

  @override
  String get diary_empty_subtitle => '아래에 한 줄만 남겨보세요';

  @override
  String get diary_load_error => '일기를 불러오지 못했습니다';

  @override
  String get diary_capture_hint => '오늘 어땠나요?';

  @override
  String get diary_capture_hint_continue => '이어서 기록하기';

  @override
  String get diary_capture_send => '기록하기';

  @override
  String get diary_capture_failed => '기록을 저장하지 못했어요';

  @override
  String get diary_capture_retry => '다시 시도';

  @override
  String get diary_today => '오늘';

  @override
  String get diary_shared_badge => '공유됨';

  @override
  String diary_shared_by(String name) {
    return '$name · 그룹에 공유됨';
  }

  @override
  String get diary_detail_title => '일기';

  @override
  String get diary_polish => '다듬기';

  @override
  String get diary_write => '일기 쓰기';

  @override
  String get diary_delete_confirm_title => '일기를 삭제할까요?';

  @override
  String get diary_delete_confirm_message => '삭제한 일기는 30일 안에 복구할 수 있습니다.';

  @override
  String get diary_delete_failed => '삭제에 실패했습니다';

  @override
  String get diary_save_failed => '저장에 실패했습니다';

  @override
  String get diary_title_hint => '제목 (선택)';

  @override
  String get diary_content_hint => '오늘 하루를 정리해보세요';

  @override
  String get diary_change_date => '날짜 변경';

  @override
  String get diary_mood => '기분';

  @override
  String get diary_view_timeline => '타임라인';

  @override
  String get diary_view_calendar => '캘린더';

  @override
  String diary_streak_days(int count) {
    return '$count일 연속';
  }

  @override
  String diary_this_month_count(int count) {
    return '이번 달 $count일 기록';
  }

  @override
  String get diary_calendar_empty => '이 달에는 기록이 없어요';

  @override
  String get diary_onboarding_capture_title => '한 줄만 남겨보세요';

  @override
  String get diary_onboarding_capture_desc =>
      '화면을 옮기지 않아도 여기서 바로 기록됩니다. 하루에 여러 번 던져두면 그날 일기에 차곡차곡 쌓여요.';

  @override
  String get diary_onboarding_card_title => '하루에 한 편으로 모여요';

  @override
  String get diary_onboarding_card_desc =>
      '던진 기록은 날짜별로 묶입니다. 카드를 눌러 그날의 일기를 열고, 천천히 다듬을 수 있어요.';

  @override
  String get diary_onboarding_flashback_title => '지난 오늘이 찾아와요';

  @override
  String get diary_onboarding_flashback_desc =>
      '한 달 전, 일 년 전 오늘의 기록이 맨 위에 떠오릅니다. 쌓일수록 반가워져요.';

  @override
  String get diary_quota_monthly => '이번 달 업로드';

  @override
  String get diary_quota_total => '저장 공간';

  @override
  String diary_quota_remaining(String size) {
    return '$size 남음';
  }

  @override
  String diary_quota_resets_on(String date) {
    return '$date에 초기화됩니다';
  }

  @override
  String get diary_quota_monthly_note =>
      '사진을 지우면 저장 공간은 바로 돌아오지만, 이번 달 업로드 용량은 채워진 채로 남아요.';

  @override
  String get diary_quota_upgrade => '용량 늘리기';

  @override
  String get diary_quota_exceeded_title => '이번 달 무료 용량을 모두 사용했어요';

  @override
  String get diary_quota_total_exceeded_title => '저장 공간이 부족해요';

  @override
  String get diary_quota_exceeded_options =>
      '다음 달에 초기화되거나, 저장 공간을 정리하면 계속 올릴 수 있어요.';

  @override
  String get diary_file_too_large => '파일이 너무 커요';

  @override
  String get diary_file_too_large_hint => '압축해서 올리면 용량을 크게 줄일 수 있어요.';

  @override
  String get diary_video_not_allowed => '영상 첨부는 상위 요금제에서 이용할 수 있어요';

  @override
  String get diary_add_photo => '사진 추가';

  @override
  String diary_upload_sheet_title(int count) {
    return '$count장 추가';
  }

  @override
  String get diary_upload_compressed => '압축해서 올리기';

  @override
  String get diary_upload_original => '원본 그대로 올리기';

  @override
  String diary_upload_saved(String before, String after, int percent) {
    return '$before → $after ($percent% 절약)';
  }

  @override
  String get diary_upload_start => '올리기';

  @override
  String get diary_upload_failed => '올리지 못했어요';

  @override
  String get diary_upload_retry => '다시 시도';

  @override
  String get diary_media_delete_confirm => '이 사진을 삭제할까요?';

  @override
  String get diary_media_delete_permanent => '사진과 영상은 즉시 삭제되며 복구할 수 없습니다.';

  @override
  String get diary_storage_manage => '저장 공간 관리';

  @override
  String get diary_storage_large_files => '용량이 큰 항목';

  @override
  String get diary_storage_only_original => '원본으로 올린 것만';

  @override
  String get diary_storage_empty => '정리할 항목이 없어요';

  @override
  String get diary_media_original_badge => '원본';

  @override
  String get diary_view_photos => '사진';

  @override
  String get diary_photos_empty => '아직 사진이 없어요';

  @override
  String get diary_pick_gallery => '갤러리에서 고르기';

  @override
  String get diary_pick_camera => '사진 찍기';

  @override
  String get subscription_quota_section_title => '다이어리 첨부 용량';

  @override
  String subscription_quota_monthly(String size) {
    return '매월 $size 제공';
  }

  @override
  String subscription_quota_total(String size) {
    return '저장 공간 $size';
  }

  @override
  String subscription_quota_per_file(String size) {
    return '파일 1개 최대 $size';
  }

  @override
  String get subscription_quota_video_none => '사진 첨부';

  @override
  String get subscription_quota_video_supported => '영상 첨부';

  @override
  String subscription_quota_video_minutes(int minutes) {
    return '영상 최대 $minutes분';
  }

  @override
  String diary_exif_date_question(String date) {
    return '이 사진은 $date에 찍었어요. 어느 날 일기에 넣을까요?';
  }

  @override
  String diary_exif_use_captured(String date) {
    return '$date 일기에 넣기';
  }

  @override
  String get diary_exif_use_today => '오늘 일기에 넣기';

  @override
  String diary_flashback_months(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개월 전 오늘',
    );
    return '$_temp0';
  }

  @override
  String diary_flashback_years(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count년 전 오늘',
    );
    return '$_temp0';
  }

  @override
  String get diary_unsupported_format => '지원하지 않는 형식이에요';

  @override
  String diary_video_too_long(int seconds) {
    return '영상은 최대 $seconds초까지 올릴 수 있어요';
  }

  @override
  String diary_media_skipped(int count, String fileName) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$fileName 외 $count개는 지원하지 않는 형식이라 빼두었어요',
      one: '$fileName은 지원하지 않는 형식이라 빼두었어요',
    );
    return '$_temp0';
  }

  @override
  String get diary_search_hint => '제목, 내용으로 검색';

  @override
  String get diary_search_empty => '조건에 맞는 일기가 없어요';

  @override
  String get subscription_manage_on_device => '구독 관리와 결제는 모바일 앱에서 할 수 있어요';

  @override
  String get widgetSettings_routineFamily => '가족 루틴 보드';

  @override
  String get routineWidget_tabToday => '오늘';

  @override
  String get routineWidget_tabWeekly => '이번 주';

  @override
  String get routineWidget_viewToggleTooltip => '보기 전환';

  @override
  String get routineWidget_allDone => '오늘 목표 달성 🎉';

  @override
  String get routineWidget_noTargetToday => '오늘 대상 습관이 없어요';

  @override
  String routineWidget_moreCount(int count) {
    return '외 $count개';
  }

  @override
  String routineWidget_streakAtRisk(int days) {
    return '$days일 연속이 오늘 끊겨요';
  }

  @override
  String routineWidget_achievementRate(int rate) {
    return '달성률 $rate%';
  }

  @override
  String routineWidget_goalDays(int achieved, int total) {
    return '목표 달성 $achieved/$total일';
  }

  @override
  String routineWidget_nextBadge(String title, int days) {
    return '$title까지 $days일';
  }

  @override
  String get routineWidget_groupTooltip => '그룹 선택';

  @override
  String get routineWidget_familyNoGroup => '참여 중인 그룹이 없어요';

  @override
  String get routineWidget_familyEmpty => '공유된 루틴이 없어요';

  @override
  String get routineWidget_familyShareCta => '가족에게 공유하기';

  @override
  String routineWidget_familyRank(int rank) {
    return '오늘 $rank위';
  }

  @override
  String routineWidget_challengeDday(int days) {
    return 'D-$days';
  }

  @override
  String get routineWidget_challengeLastDay => '오늘 마감';

  @override
  String routineWidget_myChallengeProgress(int checked, int target) {
    return '내 진행 $checked/$target';
  }
}
