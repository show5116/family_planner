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
  String get common_all => '전체';

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
  String get auth_loginFailedInvalidCredentials => '이메일 또는 비밀번호가 올바르지 않습니다';

  @override
  String get auth_googleLoginFailed => 'Google 로그인 실패';

  @override
  String get auth_kakaoLoginFailed => 'Kakao 로그인 실패';

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
  String get auth_signupPasswordHelperText => '최소 6자 이상';

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
  String get settings_appInfoSubtitle => '버전 1.0.0';

  @override
  String get settings_appDescription => '가족과 함께하는 일상 플래너';

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
  String get group_leaveSuccess => '그룹을 나갔습니다';

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
  String get schedule_shareFamily => '가족 전체';

  @override
  String get schedule_shareSpecific => '특정 멤버';

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
  String get category_management => '카테고리 관리';

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
}
