import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
  ];

  /// 애플리케이션 이름
  ///
  /// In ko, this message translates to:
  /// **'Family Planner'**
  String get appTitle;

  /// 애플리케이션 설명
  ///
  /// In ko, this message translates to:
  /// **'가족과 함께하는 일상 관리 플래너'**
  String get appDescription;

  /// No description provided for @common_ok.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get common_ok;

  /// No description provided for @common_cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get common_cancel;

  /// No description provided for @common_confirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get common_confirm;

  /// No description provided for @common_save.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get common_save;

  /// No description provided for @common_delete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get common_delete;

  /// No description provided for @common_edit.
  ///
  /// In ko, this message translates to:
  /// **'수정'**
  String get common_edit;

  /// No description provided for @common_add.
  ///
  /// In ko, this message translates to:
  /// **'추가'**
  String get common_add;

  /// No description provided for @common_create.
  ///
  /// In ko, this message translates to:
  /// **'생성'**
  String get common_create;

  /// No description provided for @common_search.
  ///
  /// In ko, this message translates to:
  /// **'검색'**
  String get common_search;

  /// No description provided for @common_loading.
  ///
  /// In ko, this message translates to:
  /// **'로딩 중...'**
  String get common_loading;

  /// 선택 항목 표시 레이블
  ///
  /// In ko, this message translates to:
  /// **'선택'**
  String get common_optional;

  /// No description provided for @common_error.
  ///
  /// In ko, this message translates to:
  /// **'오류'**
  String get common_error;

  /// No description provided for @common_retry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get common_retry;

  /// No description provided for @common_close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get common_close;

  /// No description provided for @common_done.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get common_done;

  /// No description provided for @common_undo.
  ///
  /// In ko, this message translates to:
  /// **'되돌리기'**
  String get common_undo;

  /// 목록에 담기 버튼
  ///
  /// In ko, this message translates to:
  /// **'목록에 담기'**
  String get common_add_to_list;

  /// 전체보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'전체보기'**
  String get common_view_all;

  /// 메모 필터: 개인 메모만 보기
  ///
  /// In ko, this message translates to:
  /// **'개인 메모만'**
  String get memo_filter_personal_only;

  /// 전체 그룹 선택 옵션
  ///
  /// In ko, this message translates to:
  /// **'전체 그룹'**
  String get common_all_groups;

  /// 일정/할일 필터 시트의 그룹 일정 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'그룹 일정'**
  String get schedule_filter_group_schedule;

  /// 날짜 표시 형식 (월, 일)
  ///
  /// In ko, this message translates to:
  /// **'{month}월 {day}일'**
  String common_date_format(int month, int day);

  /// No description provided for @cart_unsaved_changes.
  ///
  /// In ko, this message translates to:
  /// **'저장되지 않은 변경사항이 있습니다'**
  String get cart_unsaved_changes;

  /// No description provided for @common_next.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get common_next;

  /// No description provided for @common_back.
  ///
  /// In ko, this message translates to:
  /// **'이전'**
  String get common_back;

  /// No description provided for @common_previous.
  ///
  /// In ko, this message translates to:
  /// **'이전'**
  String get common_previous;

  /// No description provided for @common_all.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get common_all;

  /// 적용 버튼
  ///
  /// In ko, this message translates to:
  /// **'적용'**
  String get common_apply;

  /// No description provided for @auth_login.
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get auth_login;

  /// No description provided for @auth_signup.
  ///
  /// In ko, this message translates to:
  /// **'회원가입'**
  String get auth_signup;

  /// No description provided for @auth_logout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get auth_logout;

  /// No description provided for @auth_email.
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get auth_email;

  /// No description provided for @auth_password.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호'**
  String get auth_password;

  /// No description provided for @auth_passwordConfirm.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 확인'**
  String get auth_passwordConfirm;

  /// No description provided for @auth_name.
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get auth_name;

  /// No description provided for @auth_forgotPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 잊으셨나요?'**
  String get auth_forgotPassword;

  /// No description provided for @auth_noAccount.
  ///
  /// In ko, this message translates to:
  /// **'계정이 없으신가요?'**
  String get auth_noAccount;

  /// No description provided for @auth_haveAccount.
  ///
  /// In ko, this message translates to:
  /// **'이미 계정이 있으신가요?'**
  String get auth_haveAccount;

  /// No description provided for @auth_continueWithGoogle.
  ///
  /// In ko, this message translates to:
  /// **'Google로 계속하기'**
  String get auth_continueWithGoogle;

  /// No description provided for @auth_continueWithKakao.
  ///
  /// In ko, this message translates to:
  /// **'Kakao로 계속하기'**
  String get auth_continueWithKakao;

  /// No description provided for @auth_continueWithApple.
  ///
  /// In ko, this message translates to:
  /// **'Apple로 계속하기'**
  String get auth_continueWithApple;

  /// No description provided for @auth_or.
  ///
  /// In ko, this message translates to:
  /// **'또는'**
  String get auth_or;

  /// No description provided for @auth_emailHint.
  ///
  /// In ko, this message translates to:
  /// **'이메일을 입력해주세요'**
  String get auth_emailHint;

  /// No description provided for @auth_passwordHint.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 입력해주세요'**
  String get auth_passwordHint;

  /// No description provided for @auth_nameHint.
  ///
  /// In ko, this message translates to:
  /// **'이름을 입력해주세요'**
  String get auth_nameHint;

  /// No description provided for @auth_emailError.
  ///
  /// In ko, this message translates to:
  /// **'올바른 이메일 형식이 아닙니다'**
  String get auth_emailError;

  /// No description provided for @auth_passwordError.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호는 6자 이상이어야 합니다'**
  String get auth_passwordError;

  /// No description provided for @auth_passwordMismatch.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 일치하지 않습니다'**
  String get auth_passwordMismatch;

  /// No description provided for @auth_nameError.
  ///
  /// In ko, this message translates to:
  /// **'이름을 입력해주세요'**
  String get auth_nameError;

  /// No description provided for @auth_loginSuccess.
  ///
  /// In ko, this message translates to:
  /// **'로그인 성공'**
  String get auth_loginSuccess;

  /// No description provided for @auth_loginFailed.
  ///
  /// In ko, this message translates to:
  /// **'로그인 실패'**
  String get auth_loginFailed;

  /// No description provided for @auth_loginFailedInvalidCredentials.
  ///
  /// In ko, this message translates to:
  /// **'이메일 또는 비밀번호가 올바르지 않습니다'**
  String get auth_loginFailedInvalidCredentials;

  /// No description provided for @auth_googleLoginFailed.
  ///
  /// In ko, this message translates to:
  /// **'Google 로그인 실패'**
  String get auth_googleLoginFailed;

  /// No description provided for @auth_kakaoLoginFailed.
  ///
  /// In ko, this message translates to:
  /// **'Kakao 로그인 실패'**
  String get auth_kakaoLoginFailed;

  /// No description provided for @auth_signupSuccess.
  ///
  /// In ko, this message translates to:
  /// **'회원가입 성공'**
  String get auth_signupSuccess;

  /// No description provided for @auth_signupFailed.
  ///
  /// In ko, this message translates to:
  /// **'회원가입 실패'**
  String get auth_signupFailed;

  /// No description provided for @auth_logoutSuccess.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃 되었습니다'**
  String get auth_logoutSuccess;

  /// No description provided for @auth_emailVerification.
  ///
  /// In ko, this message translates to:
  /// **'이메일 인증'**
  String get auth_emailVerification;

  /// No description provided for @auth_emailVerificationMessage.
  ///
  /// In ko, this message translates to:
  /// **'가입하신 이메일로 인증 코드가 전송되었습니다.'**
  String get auth_emailVerificationMessage;

  /// No description provided for @auth_verificationCode.
  ///
  /// In ko, this message translates to:
  /// **'인증 코드'**
  String get auth_verificationCode;

  /// No description provided for @auth_verificationCodeHint.
  ///
  /// In ko, this message translates to:
  /// **'인증 코드를 입력해주세요'**
  String get auth_verificationCodeHint;

  /// No description provided for @auth_resendCode.
  ///
  /// In ko, this message translates to:
  /// **'인증 코드 재전송'**
  String get auth_resendCode;

  /// No description provided for @auth_verify.
  ///
  /// In ko, this message translates to:
  /// **'인증하기'**
  String get auth_verify;

  /// No description provided for @auth_resetPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 재설정'**
  String get auth_resetPassword;

  /// No description provided for @auth_resetPasswordMessage.
  ///
  /// In ko, this message translates to:
  /// **'가입하신 이메일 주소를 입력해주세요.\n인증 코드를 보내드립니다.'**
  String get auth_resetPasswordMessage;

  /// No description provided for @auth_newPassword.
  ///
  /// In ko, this message translates to:
  /// **'새 비밀번호'**
  String get auth_newPassword;

  /// No description provided for @auth_sendCode.
  ///
  /// In ko, this message translates to:
  /// **'인증 코드 받기'**
  String get auth_sendCode;

  /// No description provided for @auth_resetPasswordSuccess.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 재설정되었습니다. 로그인해주세요.'**
  String get auth_resetPasswordSuccess;

  /// No description provided for @auth_signupEmailVerificationMessage.
  ///
  /// In ko, this message translates to:
  /// **'회원가입이 완료되었습니다. 이메일을 확인해주세요.'**
  String get auth_signupEmailVerificationMessage;

  /// No description provided for @auth_signupNameLabel.
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get auth_signupNameLabel;

  /// No description provided for @auth_signupNameMinLengthError.
  ///
  /// In ko, this message translates to:
  /// **'이름은 2자 이상이어야 합니다'**
  String get auth_signupNameMinLengthError;

  /// No description provided for @auth_signupPasswordHelperText.
  ///
  /// In ko, this message translates to:
  /// **'최소 8자 이상'**
  String get auth_signupPasswordHelperText;

  /// No description provided for @auth_signupConfirmPasswordLabel.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 확인'**
  String get auth_signupConfirmPasswordLabel;

  /// No description provided for @auth_signupConfirmPasswordError.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 다시 입력해주세요'**
  String get auth_signupConfirmPasswordError;

  /// No description provided for @auth_signupButton.
  ///
  /// In ko, this message translates to:
  /// **'회원가입'**
  String get auth_signupButton;

  /// No description provided for @auth_forgotPasswordTitle.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 찾기'**
  String get auth_forgotPasswordTitle;

  /// No description provided for @auth_setPasswordTitle.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 설정'**
  String get auth_setPasswordTitle;

  /// No description provided for @auth_forgotPasswordGuide.
  ///
  /// In ko, this message translates to:
  /// **'가입하신 이메일 주소를 입력해주세요.\n인증 코드를 보내드립니다.'**
  String get auth_forgotPasswordGuide;

  /// No description provided for @auth_forgotPasswordGuideWithCode.
  ///
  /// In ko, this message translates to:
  /// **'이메일로 전송된 인증 코드를 입력하고\n새 비밀번호를 설정해주세요.'**
  String get auth_forgotPasswordGuideWithCode;

  /// No description provided for @auth_setPasswordGuide.
  ///
  /// In ko, this message translates to:
  /// **'계정 보안을 위해 비밀번호를 설정하세요.\n가입하신 이메일 주소를 입력하면\n인증 코드를 보내드립니다.'**
  String get auth_setPasswordGuide;

  /// No description provided for @auth_setPasswordGuideWithCode.
  ///
  /// In ko, this message translates to:
  /// **'이메일로 전송된 인증 코드를 입력하고\n비밀번호를 설정해주세요.'**
  String get auth_setPasswordGuideWithCode;

  /// No description provided for @auth_verificationCodeLabel.
  ///
  /// In ko, this message translates to:
  /// **'인증 코드 (6자리)'**
  String get auth_verificationCodeLabel;

  /// No description provided for @auth_verificationCodeError.
  ///
  /// In ko, this message translates to:
  /// **'인증 코드를 입력해주세요'**
  String get auth_verificationCodeError;

  /// No description provided for @auth_verificationCodeLengthError.
  ///
  /// In ko, this message translates to:
  /// **'인증 코드는 6자리입니다'**
  String get auth_verificationCodeLengthError;

  /// No description provided for @auth_codeSentMessage.
  ///
  /// In ko, this message translates to:
  /// **'인증 코드가 이메일로 전송되었습니다'**
  String get auth_codeSentMessage;

  /// No description provided for @auth_codeSentError.
  ///
  /// In ko, this message translates to:
  /// **'인증 코드 전송 실패'**
  String get auth_codeSentError;

  /// No description provided for @auth_passwordResetButton.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 재설정'**
  String get auth_passwordResetButton;

  /// No description provided for @auth_passwordSetButton.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 설정 완료'**
  String get auth_passwordSetButton;

  /// No description provided for @auth_resendCodeButton.
  ///
  /// In ko, this message translates to:
  /// **'인증 코드 다시 받기'**
  String get auth_resendCodeButton;

  /// No description provided for @auth_passwordSetSuccess.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 설정되었습니다. 이제 로그인할 수 있습니다.'**
  String get auth_passwordSetSuccess;

  /// No description provided for @auth_passwordResetError.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 재설정 실패'**
  String get auth_passwordResetError;

  /// No description provided for @auth_rememberPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 기억나셨나요?'**
  String get auth_rememberPassword;

  /// No description provided for @nav_home.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get nav_home;

  /// No description provided for @nav_assets.
  ///
  /// In ko, this message translates to:
  /// **'자산'**
  String get nav_assets;

  /// No description provided for @nav_calendar.
  ///
  /// In ko, this message translates to:
  /// **'일정'**
  String get nav_calendar;

  /// No description provided for @nav_todo.
  ///
  /// In ko, this message translates to:
  /// **'할일'**
  String get nav_todo;

  /// No description provided for @nav_more.
  ///
  /// In ko, this message translates to:
  /// **'더보기'**
  String get nav_more;

  /// No description provided for @nav_household.
  ///
  /// In ko, this message translates to:
  /// **'가계관리'**
  String get nav_household;

  /// No description provided for @nav_childPoints.
  ///
  /// In ko, this message translates to:
  /// **'육아포인트'**
  String get nav_childPoints;

  /// No description provided for @nav_memo.
  ///
  /// In ko, this message translates to:
  /// **'메모'**
  String get nav_memo;

  /// No description provided for @nav_miniGames.
  ///
  /// In ko, this message translates to:
  /// **'미니게임'**
  String get nav_miniGames;

  /// No description provided for @nav_investmentIndicators.
  ///
  /// In ko, this message translates to:
  /// **'투자 지표'**
  String get nav_investmentIndicators;

  /// No description provided for @nav_savings.
  ///
  /// In ko, this message translates to:
  /// **'그룹 저금통'**
  String get nav_savings;

  /// No description provided for @nav_votes.
  ///
  /// In ko, this message translates to:
  /// **'투표'**
  String get nav_votes;

  /// No description provided for @more_coach_groupDesc.
  ///
  /// In ko, this message translates to:
  /// **'가족, 연인, 친구 등 원하는 그룹을 만들고\n초대 코드로 구성원을 초대하세요.'**
  String get more_coach_groupDesc;

  /// No description provided for @more_coach_settingsDesc.
  ///
  /// In ko, this message translates to:
  /// **'테마, 언어, 알림, 하단 탭 구성 등\n앱을 원하는 대로 커스터마이징하세요.'**
  String get more_coach_settingsDesc;

  /// No description provided for @home_greeting_morning.
  ///
  /// In ko, this message translates to:
  /// **'좋은 아침이에요!'**
  String get home_greeting_morning;

  /// No description provided for @home_greeting_afternoon.
  ///
  /// In ko, this message translates to:
  /// **'좋은 오후에요!'**
  String get home_greeting_afternoon;

  /// No description provided for @home_greeting_evening.
  ///
  /// In ko, this message translates to:
  /// **'좋은 저녁이에요!'**
  String get home_greeting_evening;

  /// No description provided for @home_greeting_night.
  ///
  /// In ko, this message translates to:
  /// **'늦은 시간이네요!'**
  String get home_greeting_night;

  /// No description provided for @home_todaySchedule.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 일정'**
  String get home_todaySchedule;

  /// No description provided for @home_noSchedule.
  ///
  /// In ko, this message translates to:
  /// **'등록된 일정이 없습니다'**
  String get home_noSchedule;

  /// No description provided for @home_investmentSummary.
  ///
  /// In ko, this message translates to:
  /// **'투자 지표 요약'**
  String get home_investmentSummary;

  /// No description provided for @home_todoSummary.
  ///
  /// In ko, this message translates to:
  /// **'할일 요약'**
  String get home_todoSummary;

  /// No description provided for @home_assetSummary.
  ///
  /// In ko, this message translates to:
  /// **'자산 요약'**
  String get home_assetSummary;

  /// No description provided for @settings_title.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings_title;

  /// No description provided for @settings_theme.
  ///
  /// In ko, this message translates to:
  /// **'테마 설정'**
  String get settings_theme;

  /// No description provided for @settings_language.
  ///
  /// In ko, this message translates to:
  /// **'언어 설정'**
  String get settings_language;

  /// No description provided for @settings_homeWidgets.
  ///
  /// In ko, this message translates to:
  /// **'홈 위젯 설정'**
  String get settings_homeWidgets;

  /// No description provided for @settings_profile.
  ///
  /// In ko, this message translates to:
  /// **'프로필 설정'**
  String get settings_profile;

  /// No description provided for @settings_family.
  ///
  /// In ko, this message translates to:
  /// **'가족 관리'**
  String get settings_family;

  /// No description provided for @settings_notifications.
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get settings_notifications;

  /// No description provided for @settings_about.
  ///
  /// In ko, this message translates to:
  /// **'앱 정보'**
  String get settings_about;

  /// No description provided for @settings_bottomNavigation.
  ///
  /// In ko, this message translates to:
  /// **'하단 네비게이션'**
  String get settings_bottomNavigation;

  /// No description provided for @bottomNav_title.
  ///
  /// In ko, this message translates to:
  /// **'하단 네비게이션 설정'**
  String get bottomNav_title;

  /// No description provided for @bottomNav_reset.
  ///
  /// In ko, this message translates to:
  /// **'기본값으로 초기화'**
  String get bottomNav_reset;

  /// No description provided for @bottomNav_resetConfirmTitle.
  ///
  /// In ko, this message translates to:
  /// **'초기화 확인'**
  String get bottomNav_resetConfirmTitle;

  /// No description provided for @bottomNav_resetConfirmMessage.
  ///
  /// In ko, this message translates to:
  /// **'하단 네비게이션 설정을 기본값으로 초기화하시겠습니까?'**
  String get bottomNav_resetConfirmMessage;

  /// No description provided for @bottomNav_resetSuccess.
  ///
  /// In ko, this message translates to:
  /// **'기본값으로 초기화되었습니다'**
  String get bottomNav_resetSuccess;

  /// No description provided for @bottomNav_guideMessage.
  ///
  /// In ko, this message translates to:
  /// **'홈과 더보기는 고정입니다.\n중간 3개 슬롯을 탭하여 메뉴를 선택하세요.'**
  String get bottomNav_guideMessage;

  /// No description provided for @bottomNav_preview.
  ///
  /// In ko, this message translates to:
  /// **'하단 네비게이션 미리보기'**
  String get bottomNav_preview;

  /// No description provided for @bottomNav_howToUse.
  ///
  /// In ko, this message translates to:
  /// **'사용 방법'**
  String get bottomNav_howToUse;

  /// No description provided for @bottomNav_instructions.
  ///
  /// In ko, this message translates to:
  /// **'• 슬롯 2, 3, 4를 탭하여 원하는 메뉴로 변경하세요.\n• 슬롯 1(홈)과 슬롯 5(더보기)는 고정입니다.\n• 하단 네비게이션에 없는 메뉴는 \"더보기\" 탭에 표시됩니다.'**
  String get bottomNav_instructions;

  /// No description provided for @bottomNav_availableMenus.
  ///
  /// In ko, this message translates to:
  /// **'사용 가능한 메뉴'**
  String get bottomNav_availableMenus;

  /// No description provided for @bottomNav_slot.
  ///
  /// In ko, this message translates to:
  /// **'슬롯'**
  String get bottomNav_slot;

  /// No description provided for @bottomNav_unused.
  ///
  /// In ko, this message translates to:
  /// **'미사용'**
  String get bottomNav_unused;

  /// No description provided for @bottomNav_selectMenuTitle.
  ///
  /// In ko, this message translates to:
  /// **'슬롯 {slot} 메뉴 선택'**
  String bottomNav_selectMenuTitle(Object slot);

  /// No description provided for @bottomNav_usedInOtherSlot.
  ///
  /// In ko, this message translates to:
  /// **'다른 슬롯에서 사용 중 (선택 시 교체)'**
  String get bottomNav_usedInOtherSlot;

  /// No description provided for @widgetSettings_saveSuccess.
  ///
  /// In ko, this message translates to:
  /// **'설정이 저장되었습니다'**
  String get widgetSettings_saveSuccess;

  /// No description provided for @widgetSettings_guide.
  ///
  /// In ko, this message translates to:
  /// **'홈 화면에 표시할 위젯을 선택하고 순서를 변경하세요'**
  String get widgetSettings_guide;

  /// No description provided for @widgetSettings_widgetOrder.
  ///
  /// In ko, this message translates to:
  /// **'위젯 순서'**
  String get widgetSettings_widgetOrder;

  /// No description provided for @widgetSettings_dragToReorder.
  ///
  /// In ko, this message translates to:
  /// **'위젯을 길게 눌러 드래그하여 순서를 변경할 수 있습니다'**
  String get widgetSettings_dragToReorder;

  /// No description provided for @widgetSettings_restoreDefaults.
  ///
  /// In ko, this message translates to:
  /// **'기본 설정으로 복원'**
  String get widgetSettings_restoreDefaults;

  /// No description provided for @widgetSettings_todayScheduleDesc.
  ///
  /// In ko, this message translates to:
  /// **'당일 일정을 표시합니다'**
  String get widgetSettings_todayScheduleDesc;

  /// No description provided for @widgetSettings_investmentSummaryDesc.
  ///
  /// In ko, this message translates to:
  /// **'코스피, 나스닥, 환율 정보를 표시합니다'**
  String get widgetSettings_investmentSummaryDesc;

  /// No description provided for @widgetSettings_todoSummaryDesc.
  ///
  /// In ko, this message translates to:
  /// **'진행 중인 할일을 표시합니다'**
  String get widgetSettings_todoSummaryDesc;

  /// No description provided for @widgetSettings_assetSummaryDesc.
  ///
  /// In ko, this message translates to:
  /// **'총 자산과 수익률을 표시합니다'**
  String get widgetSettings_assetSummaryDesc;

  /// No description provided for @widgetSettings_memoSummary.
  ///
  /// In ko, this message translates to:
  /// **'메모 요약'**
  String get widgetSettings_memoSummary;

  /// No description provided for @widgetSettings_memoSummaryDesc.
  ///
  /// In ko, this message translates to:
  /// **'최근 작성한 메모를 표시합니다'**
  String get widgetSettings_memoSummaryDesc;

  /// No description provided for @widgetSettings_householdSummary.
  ///
  /// In ko, this message translates to:
  /// **'가계 현황'**
  String get widgetSettings_householdSummary;

  /// No description provided for @widgetSettings_householdSummaryDesc.
  ///
  /// In ko, this message translates to:
  /// **'이번 달 지출 요약 및 예산 달성률'**
  String get widgetSettings_householdSummaryDesc;

  /// No description provided for @widgetSettings_childcareSummary.
  ///
  /// In ko, this message translates to:
  /// **'육아 포인트'**
  String get widgetSettings_childcareSummary;

  /// No description provided for @widgetSettings_childcareSummaryDesc.
  ///
  /// In ko, this message translates to:
  /// **'자녀별 포인트 잔액 현황'**
  String get widgetSettings_childcareSummaryDesc;

  /// No description provided for @widgetSettings_savingsSummary.
  ///
  /// In ko, this message translates to:
  /// **'저금통'**
  String get widgetSettings_savingsSummary;

  /// No description provided for @widgetSettings_savingsSummaryDesc.
  ///
  /// In ko, this message translates to:
  /// **'그룹별 적립 목표 및 달성 현황'**
  String get widgetSettings_savingsSummaryDesc;

  /// No description provided for @widgetSettings_fridgeSummary.
  ///
  /// In ko, this message translates to:
  /// **'유통기한 임박'**
  String get widgetSettings_fridgeSummary;

  /// No description provided for @widgetSettings_fridgeSummaryDesc.
  ///
  /// In ko, this message translates to:
  /// **'냉장고에서 유통기한이 얼마 남지 않은 식품 목록'**
  String get widgetSettings_fridgeSummaryDesc;

  /// No description provided for @widgetSettings_viewToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get widgetSettings_viewToday;

  /// No description provided for @widgetSettings_viewWeek.
  ///
  /// In ko, this message translates to:
  /// **'금주'**
  String get widgetSettings_viewWeek;

  /// No description provided for @widgetSettings_viewMonth.
  ///
  /// In ko, this message translates to:
  /// **'이번달'**
  String get widgetSettings_viewMonth;

  /// No description provided for @widgetSettings_viewBudget.
  ///
  /// In ko, this message translates to:
  /// **'전체 예산 보기'**
  String get widgetSettings_viewBudget;

  /// No description provided for @widgetSettings_viewCategory.
  ///
  /// In ko, this message translates to:
  /// **'카테고리별 보기'**
  String get widgetSettings_viewCategory;

  /// No description provided for @widgetSettings_savingsEmpty.
  ///
  /// In ko, this message translates to:
  /// **'등록된 저금통이 없습니다'**
  String get widgetSettings_savingsEmpty;

  /// No description provided for @widgetSettings_fridgeExpiryEmpty.
  ///
  /// In ko, this message translates to:
  /// **'유통기한 임박 식품이 없어요'**
  String get widgetSettings_fridgeExpiryEmpty;

  /// No description provided for @widgetSettings_scheduleWeek.
  ///
  /// In ko, this message translates to:
  /// **'금주 일정'**
  String get widgetSettings_scheduleWeek;

  /// No description provided for @widgetSettings_scheduleMonth.
  ///
  /// In ko, this message translates to:
  /// **'이번달 일정'**
  String get widgetSettings_scheduleMonth;

  /// No description provided for @widgetSettings_scheduleEmptyToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘 일정이 없습니다'**
  String get widgetSettings_scheduleEmptyToday;

  /// No description provided for @widgetSettings_scheduleEmptyWeek.
  ///
  /// In ko, this message translates to:
  /// **'이번 주 일정이 없습니다'**
  String get widgetSettings_scheduleEmptyWeek;

  /// No description provided for @widgetSettings_scheduleEmptyMonth.
  ///
  /// In ko, this message translates to:
  /// **'이번 달 일정이 없습니다'**
  String get widgetSettings_scheduleEmptyMonth;

  /// No description provided for @widgetSettings_weather.
  ///
  /// In ko, this message translates to:
  /// **'날씨'**
  String get widgetSettings_weather;

  /// No description provided for @widgetSettings_weatherDesc.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치의 날씨 정보를 표시합니다'**
  String get widgetSettings_weatherDesc;

  /// No description provided for @themeSettings_title.
  ///
  /// In ko, this message translates to:
  /// **'테마 설정'**
  String get themeSettings_title;

  /// No description provided for @themeSettings_selectTheme.
  ///
  /// In ko, this message translates to:
  /// **'테마 선택'**
  String get themeSettings_selectTheme;

  /// No description provided for @themeSettings_description.
  ///
  /// In ko, this message translates to:
  /// **'앱의 밝기 테마를 선택하세요. 시스템 설정을 따르거나 직접 선택할 수 있습니다.'**
  String get themeSettings_description;

  /// No description provided for @themeSettings_lightMode.
  ///
  /// In ko, this message translates to:
  /// **'Light 모드'**
  String get themeSettings_lightMode;

  /// No description provided for @themeSettings_lightModeDesc.
  ///
  /// In ko, this message translates to:
  /// **'밝은 테마를 사용합니다'**
  String get themeSettings_lightModeDesc;

  /// No description provided for @themeSettings_darkMode.
  ///
  /// In ko, this message translates to:
  /// **'Dark 모드'**
  String get themeSettings_darkMode;

  /// No description provided for @themeSettings_darkModeDesc.
  ///
  /// In ko, this message translates to:
  /// **'어두운 테마를 사용합니다'**
  String get themeSettings_darkModeDesc;

  /// No description provided for @themeSettings_systemMode.
  ///
  /// In ko, this message translates to:
  /// **'시스템 설정'**
  String get themeSettings_systemMode;

  /// No description provided for @themeSettings_systemModeDesc.
  ///
  /// In ko, this message translates to:
  /// **'기기의 시스템 설정을 따릅니다'**
  String get themeSettings_systemModeDesc;

  /// No description provided for @themeSettings_colorTitle.
  ///
  /// In ko, this message translates to:
  /// **'컬러 테마'**
  String get themeSettings_colorTitle;

  /// No description provided for @themeSettings_brightnessTitle.
  ///
  /// In ko, this message translates to:
  /// **'밝기 모드'**
  String get themeSettings_brightnessTitle;

  /// No description provided for @themeSettings_currentThemePreview.
  ///
  /// In ko, this message translates to:
  /// **'현재 테마 미리보기'**
  String get themeSettings_currentThemePreview;

  /// No description provided for @themeSettings_currentTheme.
  ///
  /// In ko, this message translates to:
  /// **'현재 테마'**
  String get themeSettings_currentTheme;

  /// No description provided for @profile_title.
  ///
  /// In ko, this message translates to:
  /// **'프로필 설정'**
  String get profile_title;

  /// No description provided for @profile_save.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get profile_save;

  /// No description provided for @profile_name.
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get profile_name;

  /// No description provided for @profile_nameRequired.
  ///
  /// In ko, this message translates to:
  /// **'이름을 입력해주세요'**
  String get profile_nameRequired;

  /// No description provided for @profile_phoneNumber.
  ///
  /// In ko, this message translates to:
  /// **'전화번호 (선택사항)'**
  String get profile_phoneNumber;

  /// No description provided for @profile_phoneNumberHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 010-1234-5678'**
  String get profile_phoneNumberHint;

  /// No description provided for @profile_uploadSuccess.
  ///
  /// In ko, this message translates to:
  /// **'프로필 사진이 업로드되었습니다'**
  String get profile_uploadSuccess;

  /// No description provided for @profile_uploadFailed.
  ///
  /// In ko, this message translates to:
  /// **'프로필 사진 업로드 실패'**
  String get profile_uploadFailed;

  /// No description provided for @profile_changePassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 변경'**
  String get profile_changePassword;

  /// No description provided for @profile_currentPassword.
  ///
  /// In ko, this message translates to:
  /// **'현재 비밀번호'**
  String get profile_currentPassword;

  /// No description provided for @profile_currentPasswordRequired.
  ///
  /// In ko, this message translates to:
  /// **'현재 비밀번호를 입력해주세요'**
  String get profile_currentPasswordRequired;

  /// No description provided for @profile_newPassword.
  ///
  /// In ko, this message translates to:
  /// **'새 비밀번호'**
  String get profile_newPassword;

  /// No description provided for @profile_newPasswordRequired.
  ///
  /// In ko, this message translates to:
  /// **'새 비밀번호를 입력해주세요'**
  String get profile_newPasswordRequired;

  /// No description provided for @profile_newPasswordMinLength.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호는 6자 이상이어야 합니다'**
  String get profile_newPasswordMinLength;

  /// No description provided for @profile_confirmNewPassword.
  ///
  /// In ko, this message translates to:
  /// **'새 비밀번호 확인'**
  String get profile_confirmNewPassword;

  /// No description provided for @profile_confirmNewPasswordRequired.
  ///
  /// In ko, this message translates to:
  /// **'새 비밀번호 확인을 입력해주세요'**
  String get profile_confirmNewPasswordRequired;

  /// No description provided for @profile_passwordsDoNotMatch.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 일치하지 않습니다'**
  String get profile_passwordsDoNotMatch;

  /// No description provided for @profile_updateSuccess.
  ///
  /// In ko, this message translates to:
  /// **'프로필이 업데이트되었습니다'**
  String get profile_updateSuccess;

  /// No description provided for @profile_updateFailed.
  ///
  /// In ko, this message translates to:
  /// **'프로필 업데이트 실패'**
  String get profile_updateFailed;

  /// No description provided for @theme_light.
  ///
  /// In ko, this message translates to:
  /// **'라이트 모드'**
  String get theme_light;

  /// No description provided for @theme_dark.
  ///
  /// In ko, this message translates to:
  /// **'다크 모드'**
  String get theme_dark;

  /// No description provided for @theme_system.
  ///
  /// In ko, this message translates to:
  /// **'시스템 설정'**
  String get theme_system;

  /// No description provided for @language_korean.
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get language_korean;

  /// No description provided for @language_english.
  ///
  /// In ko, this message translates to:
  /// **'English'**
  String get language_english;

  /// No description provided for @language_japanese.
  ///
  /// In ko, this message translates to:
  /// **'日本語'**
  String get language_japanese;

  /// No description provided for @language_chinese.
  ///
  /// In ko, this message translates to:
  /// **'중국어'**
  String get language_chinese;

  /// No description provided for @language_selectDescription.
  ///
  /// In ko, this message translates to:
  /// **'앱에서 사용할 언어를 선택하세요'**
  String get language_selectDescription;

  /// No description provided for @language_useSystemLanguage.
  ///
  /// In ko, this message translates to:
  /// **'시스템 언어 사용'**
  String get language_useSystemLanguage;

  /// No description provided for @language_useSystemLanguageDescription.
  ///
  /// In ko, this message translates to:
  /// **'기기의 언어 설정을 따릅니다'**
  String get language_useSystemLanguageDescription;

  /// No description provided for @widgetSettings_title.
  ///
  /// In ko, this message translates to:
  /// **'홈 위젯 설정'**
  String get widgetSettings_title;

  /// No description provided for @widgetSettings_description.
  ///
  /// In ko, this message translates to:
  /// **'홈 화면에 표시할 위젯을 선택하세요'**
  String get widgetSettings_description;

  /// No description provided for @widgetSettings_todaySchedule.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 일정'**
  String get widgetSettings_todaySchedule;

  /// No description provided for @widgetSettings_investmentSummary.
  ///
  /// In ko, this message translates to:
  /// **'투자 지표 요약'**
  String get widgetSettings_investmentSummary;

  /// No description provided for @widgetSettings_todoSummary.
  ///
  /// In ko, this message translates to:
  /// **'할일 요약'**
  String get widgetSettings_todoSummary;

  /// No description provided for @widgetSettings_assetSummary.
  ///
  /// In ko, this message translates to:
  /// **'자산 요약'**
  String get widgetSettings_assetSummary;

  /// No description provided for @settings_screenSettings.
  ///
  /// In ko, this message translates to:
  /// **'화면 설정'**
  String get settings_screenSettings;

  /// No description provided for @settings_bottomNavigationTitle.
  ///
  /// In ko, this message translates to:
  /// **'하단 네비게이션 설정'**
  String get settings_bottomNavigationTitle;

  /// No description provided for @settings_bottomNavigationSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'하단 메뉴 순서와 표시/숨김을 설정하세요'**
  String get settings_bottomNavigationSubtitle;

  /// No description provided for @settings_homeWidgetsTitle.
  ///
  /// In ko, this message translates to:
  /// **'홈 위젯 설정'**
  String get settings_homeWidgetsTitle;

  /// No description provided for @settings_homeWidgetsSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'홈 화면에 표시할 위젯을 선택하세요'**
  String get settings_homeWidgetsSubtitle;

  /// No description provided for @settings_themeTitle.
  ///
  /// In ko, this message translates to:
  /// **'테마 설정'**
  String get settings_themeTitle;

  /// No description provided for @settings_themeSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'라이트/다크 모드를 변경하세요'**
  String get settings_themeSubtitle;

  /// No description provided for @settings_languageTitle.
  ///
  /// In ko, this message translates to:
  /// **'언어 설정'**
  String get settings_languageTitle;

  /// No description provided for @settings_languageSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'앱에서 사용할 언어를 변경하세요'**
  String get settings_languageSubtitle;

  /// No description provided for @settings_userSettings.
  ///
  /// In ko, this message translates to:
  /// **'사용자 설정'**
  String get settings_userSettings;

  /// No description provided for @settings_profileTitle.
  ///
  /// In ko, this message translates to:
  /// **'프로필 설정'**
  String get settings_profileTitle;

  /// No description provided for @settings_profileSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'프로필 정보를 수정하세요'**
  String get settings_profileSubtitle;

  /// No description provided for @settings_groupManagementTitle.
  ///
  /// In ko, this message translates to:
  /// **'그룹 관리'**
  String get settings_groupManagementTitle;

  /// No description provided for @settings_groupManagementSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'그룹과 멤버를 관리하세요'**
  String get settings_groupManagementSubtitle;

  /// No description provided for @settings_notificationSettings.
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get settings_notificationSettings;

  /// No description provided for @settings_notificationTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get settings_notificationTitle;

  /// No description provided for @settings_notificationSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'알림 수신 설정을 변경하세요'**
  String get settings_notificationSubtitle;

  /// No description provided for @settings_information.
  ///
  /// In ko, this message translates to:
  /// **'정보'**
  String get settings_information;

  /// No description provided for @settings_appInfoTitle.
  ///
  /// In ko, this message translates to:
  /// **'앱 정보'**
  String get settings_appInfoTitle;

  /// No description provided for @settings_appInfoSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'버전 정보'**
  String get settings_appInfoSubtitle;

  /// No description provided for @settings_appDescription.
  ///
  /// In ko, this message translates to:
  /// **'가족과 함께하는 일상 플래너'**
  String get settings_appDescription;

  /// No description provided for @settings_termsOfServiceTitle.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용약관'**
  String get settings_termsOfServiceTitle;

  /// No description provided for @settings_termsOfServiceSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용 약관을 확인하세요'**
  String get settings_termsOfServiceSubtitle;

  /// No description provided for @settings_privacyPolicyTitle.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get settings_privacyPolicyTitle;

  /// No description provided for @settings_privacyPolicySubtitle.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리 방침을 확인하세요'**
  String get settings_privacyPolicySubtitle;

  /// No description provided for @settings_helpTitle.
  ///
  /// In ko, this message translates to:
  /// **'도움말'**
  String get settings_helpTitle;

  /// No description provided for @settings_helpSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'사용법을 확인하세요'**
  String get settings_helpSubtitle;

  /// No description provided for @settings_user.
  ///
  /// In ko, this message translates to:
  /// **'사용자'**
  String get settings_user;

  /// No description provided for @settings_logout.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get settings_logout;

  /// No description provided for @settings_logoutConfirmTitle.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get settings_logoutConfirmTitle;

  /// No description provided for @settings_logoutConfirmMessage.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃 하시겠습니까?'**
  String get settings_logoutConfirmMessage;

  /// No description provided for @settings_passwordSetupRequired.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 설정이 필요합니다'**
  String get settings_passwordSetupRequired;

  /// No description provided for @settings_passwordSetupMessage1.
  ///
  /// In ko, this message translates to:
  /// **'소셜 로그인으로만 가입하셔서 아직 비밀번호가 설정되지 않았습니다.'**
  String get settings_passwordSetupMessage1;

  /// No description provided for @settings_passwordSetupMessage2.
  ///
  /// In ko, this message translates to:
  /// **'프로필을 수정하거나 계정 보안을 강화하려면 비밀번호를 설정하는 것을 권장합니다.'**
  String get settings_passwordSetupMessage2;

  /// No description provided for @settings_passwordSetupMessage3.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 설정 화면으로 이동하시겠습니까?'**
  String get settings_passwordSetupMessage3;

  /// No description provided for @settings_passwordSetupLater.
  ///
  /// In ko, this message translates to:
  /// **'나중에'**
  String get settings_passwordSetupLater;

  /// No description provided for @settings_passwordSetupNow.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 설정하기'**
  String get settings_passwordSetupNow;

  /// No description provided for @settings_adminMenu.
  ///
  /// In ko, this message translates to:
  /// **'운영자 전용'**
  String get settings_adminMenu;

  /// No description provided for @settings_permissionManagementTitle.
  ///
  /// In ko, this message translates to:
  /// **'권한 관리'**
  String get settings_permissionManagementTitle;

  /// No description provided for @settings_permissionManagementSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'Role에 할당할 권한 종류를 관리하세요'**
  String get settings_permissionManagementSubtitle;

  /// No description provided for @permission_title.
  ///
  /// In ko, this message translates to:
  /// **'권한 관리'**
  String get permission_title;

  /// No description provided for @permission_search.
  ///
  /// In ko, this message translates to:
  /// **'권한 검색 (코드, 이름, 설명)'**
  String get permission_search;

  /// No description provided for @permission_allCategories.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get permission_allCategories;

  /// No description provided for @permission_create.
  ///
  /// In ko, this message translates to:
  /// **'권한 생성'**
  String get permission_create;

  /// No description provided for @permission_code.
  ///
  /// In ko, this message translates to:
  /// **'권한 코드'**
  String get permission_code;

  /// No description provided for @permission_category.
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get permission_category;

  /// No description provided for @permission_description.
  ///
  /// In ko, this message translates to:
  /// **'설명'**
  String get permission_description;

  /// No description provided for @permission_status.
  ///
  /// In ko, this message translates to:
  /// **'상태'**
  String get permission_status;

  /// No description provided for @permission_active.
  ///
  /// In ko, this message translates to:
  /// **'활성'**
  String get permission_active;

  /// No description provided for @permission_inactive.
  ///
  /// In ko, this message translates to:
  /// **'비활성'**
  String get permission_inactive;

  /// No description provided for @permission_count.
  ///
  /// In ko, this message translates to:
  /// **'개'**
  String get permission_count;

  /// No description provided for @permission_noPermissions.
  ///
  /// In ko, this message translates to:
  /// **'권한이 없습니다'**
  String get permission_noPermissions;

  /// No description provided for @permission_loadFailed.
  ///
  /// In ko, this message translates to:
  /// **'권한 목록을 불러오는데 실패했습니다'**
  String get permission_loadFailed;

  /// No description provided for @permission_deleteConfirm.
  ///
  /// In ko, this message translates to:
  /// **'권한 삭제'**
  String get permission_deleteConfirm;

  /// No description provided for @permission_deleteMessage.
  ///
  /// In ko, this message translates to:
  /// **'{name} 권한을 삭제하시겠습니까?'**
  String permission_deleteMessage(String name);

  /// No description provided for @permission_deleteSoftDescription.
  ///
  /// In ko, this message translates to:
  /// **'소프트 삭제: 비활성화하지만 데이터는 유지됩니다'**
  String get permission_deleteSoftDescription;

  /// No description provided for @permission_deleteHardDescription.
  ///
  /// In ko, this message translates to:
  /// **'하드 삭제: 데이터베이스에서 완전히 삭제됩니다 (주의!)'**
  String get permission_deleteHardDescription;

  /// No description provided for @permission_softDelete.
  ///
  /// In ko, this message translates to:
  /// **'소프트 삭제'**
  String get permission_softDelete;

  /// No description provided for @permission_hardDelete.
  ///
  /// In ko, this message translates to:
  /// **'하드 삭제'**
  String get permission_hardDelete;

  /// No description provided for @permission_deleteSuccess.
  ///
  /// In ko, this message translates to:
  /// **'권한이 삭제되었습니다'**
  String get permission_deleteSuccess;

  /// No description provided for @permission_deleteFailed.
  ///
  /// In ko, this message translates to:
  /// **'권한 삭제 실패'**
  String get permission_deleteFailed;

  /// No description provided for @permission_name.
  ///
  /// In ko, this message translates to:
  /// **'권한 이름'**
  String get permission_name;

  /// No description provided for @permission_codeAndNameRequired.
  ///
  /// In ko, this message translates to:
  /// **'권한 코드와 이름은 필수입니다'**
  String get permission_codeAndNameRequired;

  /// No description provided for @permission_createSuccess.
  ///
  /// In ko, this message translates to:
  /// **'권한이 생성되었습니다'**
  String get permission_createSuccess;

  /// No description provided for @permission_createFailed.
  ///
  /// In ko, this message translates to:
  /// **'권한 생성 실패'**
  String get permission_createFailed;

  /// No description provided for @permission_updateSuccess.
  ///
  /// In ko, this message translates to:
  /// **'권한이 수정되었습니다'**
  String get permission_updateSuccess;

  /// No description provided for @permission_updateFailed.
  ///
  /// In ko, this message translates to:
  /// **'권한 수정 실패'**
  String get permission_updateFailed;

  /// No description provided for @group_title.
  ///
  /// In ko, this message translates to:
  /// **'그룹 관리'**
  String get group_title;

  /// No description provided for @group_myGroups.
  ///
  /// In ko, this message translates to:
  /// **'내 그룹'**
  String get group_myGroups;

  /// No description provided for @group_createGroup.
  ///
  /// In ko, this message translates to:
  /// **'그룹 생성'**
  String get group_createGroup;

  /// No description provided for @group_joinGroup.
  ///
  /// In ko, this message translates to:
  /// **'그룹 참여'**
  String get group_joinGroup;

  /// No description provided for @group_groupName.
  ///
  /// In ko, this message translates to:
  /// **'그룹 이름'**
  String get group_groupName;

  /// No description provided for @group_groupDescription.
  ///
  /// In ko, this message translates to:
  /// **'그룹 설명'**
  String get group_groupDescription;

  /// No description provided for @group_groupColor.
  ///
  /// In ko, this message translates to:
  /// **'그룹 색상'**
  String get group_groupColor;

  /// No description provided for @group_defaultColor.
  ///
  /// In ko, this message translates to:
  /// **'기본 색상'**
  String get group_defaultColor;

  /// No description provided for @group_customColor.
  ///
  /// In ko, this message translates to:
  /// **'개인 색상'**
  String get group_customColor;

  /// No description provided for @group_inviteCode.
  ///
  /// In ko, this message translates to:
  /// **'초대 코드'**
  String get group_inviteCode;

  /// No description provided for @group_members.
  ///
  /// In ko, this message translates to:
  /// **'멤버'**
  String get group_members;

  /// No description provided for @group_pending.
  ///
  /// In ko, this message translates to:
  /// **'대기중'**
  String get group_pending;

  /// No description provided for @group_noPendingRequests.
  ///
  /// In ko, this message translates to:
  /// **'대기 중인 가입 요청이 없습니다'**
  String get group_noPendingRequests;

  /// No description provided for @group_memberCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}명'**
  String group_memberCount(int count);

  /// No description provided for @group_role.
  ///
  /// In ko, this message translates to:
  /// **'역할'**
  String get group_role;

  /// No description provided for @group_owner.
  ///
  /// In ko, this message translates to:
  /// **'그룹장'**
  String get group_owner;

  /// No description provided for @group_admin.
  ///
  /// In ko, this message translates to:
  /// **'관리자'**
  String get group_admin;

  /// No description provided for @group_member.
  ///
  /// In ko, this message translates to:
  /// **'멤버'**
  String get group_member;

  /// No description provided for @group_joinedAt.
  ///
  /// In ko, this message translates to:
  /// **'가입일'**
  String get group_joinedAt;

  /// No description provided for @group_createdAt.
  ///
  /// In ko, this message translates to:
  /// **'생성일'**
  String get group_createdAt;

  /// No description provided for @group_settings.
  ///
  /// In ko, this message translates to:
  /// **'그룹 설정'**
  String get group_settings;

  /// No description provided for @group_editGroup.
  ///
  /// In ko, this message translates to:
  /// **'그룹 정보 수정'**
  String get group_editGroup;

  /// No description provided for @group_deleteGroup.
  ///
  /// In ko, this message translates to:
  /// **'그룹 삭제'**
  String get group_deleteGroup;

  /// No description provided for @group_leaveGroup.
  ///
  /// In ko, this message translates to:
  /// **'그룹 나가기'**
  String get group_leaveGroup;

  /// No description provided for @group_inviteMembers.
  ///
  /// In ko, this message translates to:
  /// **'멤버 초대'**
  String get group_inviteMembers;

  /// No description provided for @group_manageMembers.
  ///
  /// In ko, this message translates to:
  /// **'멤버 관리'**
  String get group_manageMembers;

  /// No description provided for @group_regenerateCode.
  ///
  /// In ko, this message translates to:
  /// **'초대 코드 재생성'**
  String get group_regenerateCode;

  /// No description provided for @group_copyCode.
  ///
  /// In ko, this message translates to:
  /// **'코드 복사'**
  String get group_copyCode;

  /// No description provided for @group_enterInviteCode.
  ///
  /// In ko, this message translates to:
  /// **'초대 코드 입력'**
  String get group_enterInviteCode;

  /// No description provided for @group_inviteByEmail.
  ///
  /// In ko, this message translates to:
  /// **'이메일로 초대'**
  String get group_inviteByEmail;

  /// No description provided for @group_email.
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get group_email;

  /// No description provided for @group_send.
  ///
  /// In ko, this message translates to:
  /// **'보내기'**
  String get group_send;

  /// No description provided for @group_join.
  ///
  /// In ko, this message translates to:
  /// **'참여하기'**
  String get group_join;

  /// No description provided for @group_cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get group_cancel;

  /// No description provided for @group_save.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get group_save;

  /// No description provided for @group_delete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get group_delete;

  /// No description provided for @group_leave.
  ///
  /// In ko, this message translates to:
  /// **'나가기'**
  String get group_leave;

  /// No description provided for @group_create.
  ///
  /// In ko, this message translates to:
  /// **'생성'**
  String get group_create;

  /// No description provided for @group_edit.
  ///
  /// In ko, this message translates to:
  /// **'수정'**
  String get group_edit;

  /// No description provided for @group_confirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get group_confirm;

  /// No description provided for @group_accept.
  ///
  /// In ko, this message translates to:
  /// **'승인'**
  String get group_accept;

  /// No description provided for @group_reject.
  ///
  /// In ko, this message translates to:
  /// **'거부'**
  String get group_reject;

  /// No description provided for @group_requestedAt.
  ///
  /// In ko, this message translates to:
  /// **'요청일'**
  String get group_requestedAt;

  /// No description provided for @group_invitedAt.
  ///
  /// In ko, this message translates to:
  /// **'초대일'**
  String get group_invitedAt;

  /// No description provided for @group_acceptSuccess.
  ///
  /// In ko, this message translates to:
  /// **'가입 요청이 승인되었습니다'**
  String get group_acceptSuccess;

  /// No description provided for @group_rejectSuccess.
  ///
  /// In ko, this message translates to:
  /// **'가입 요청이 거부되었습니다'**
  String get group_rejectSuccess;

  /// No description provided for @group_rejectConfirmMessage.
  ///
  /// In ko, this message translates to:
  /// **'정말로 이 가입 요청을 거부하시겠습니까?'**
  String get group_rejectConfirmMessage;

  /// No description provided for @group_groupNameRequired.
  ///
  /// In ko, this message translates to:
  /// **'그룹 이름을 입력해주세요'**
  String get group_groupNameRequired;

  /// No description provided for @group_inviteCodeRequired.
  ///
  /// In ko, this message translates to:
  /// **'초대 코드를 입력해주세요'**
  String get group_inviteCodeRequired;

  /// No description provided for @group_emailRequired.
  ///
  /// In ko, this message translates to:
  /// **'이메일을 입력해주세요'**
  String get group_emailRequired;

  /// No description provided for @group_deleteConfirmTitle.
  ///
  /// In ko, this message translates to:
  /// **'그룹 삭제'**
  String get group_deleteConfirmTitle;

  /// No description provided for @group_deleteConfirmMessage.
  ///
  /// In ko, this message translates to:
  /// **'정말로 이 그룹을 삭제하시겠습니까?\n모든 데이터가 삭제되며 복구할 수 없습니다.'**
  String get group_deleteConfirmMessage;

  /// No description provided for @group_leaveConfirmTitle.
  ///
  /// In ko, this message translates to:
  /// **'그룹 나가기'**
  String get group_leaveConfirmTitle;

  /// No description provided for @group_leaveConfirmMessage.
  ///
  /// In ko, this message translates to:
  /// **'정말로 이 그룹을 나가시겠습니까?'**
  String get group_leaveConfirmMessage;

  /// No description provided for @group_ownerCannotLeave.
  ///
  /// In ko, this message translates to:
  /// **'그룹장은 그룹을 나갈 수 없습니다.\n그룹장 권한을 양도하거나 그룹을 삭제해주세요.'**
  String get group_ownerCannotLeave;

  /// No description provided for @group_createSuccess.
  ///
  /// In ko, this message translates to:
  /// **'그룹이 생성되었습니다'**
  String get group_createSuccess;

  /// No description provided for @group_joinSuccess.
  ///
  /// In ko, this message translates to:
  /// **'그룹에 참여했습니다'**
  String get group_joinSuccess;

  /// No description provided for @group_updateSuccess.
  ///
  /// In ko, this message translates to:
  /// **'그룹 정보가 수정되었습니다'**
  String get group_updateSuccess;

  /// No description provided for @group_deleteSuccess.
  ///
  /// In ko, this message translates to:
  /// **'그룹이 삭제되었습니다'**
  String get group_deleteSuccess;

  /// No description provided for @group_leaveSuccess.
  ///
  /// In ko, this message translates to:
  /// **'그룹에서 나갔습니다'**
  String get group_leaveSuccess;

  /// No description provided for @group_inviteSent.
  ///
  /// In ko, this message translates to:
  /// **'초대 이메일이 발송되었습니다'**
  String get group_inviteSent;

  /// No description provided for @group_codeRegenerated.
  ///
  /// In ko, this message translates to:
  /// **'초대 코드가 재생성되었습니다'**
  String get group_codeRegenerated;

  /// No description provided for @group_codeCopied.
  ///
  /// In ko, this message translates to:
  /// **'초대 코드가 복사되었습니다'**
  String get group_codeCopied;

  /// No description provided for @group_codeExpired.
  ///
  /// In ko, this message translates to:
  /// **'초대 코드가 만료되었습니다'**
  String get group_codeExpired;

  /// No description provided for @group_codeExpiresInDays.
  ///
  /// In ko, this message translates to:
  /// **'{count}일 후 만료'**
  String group_codeExpiresInDays(int count);

  /// No description provided for @group_codeExpiresInHours.
  ///
  /// In ko, this message translates to:
  /// **'{count}시간 후 만료'**
  String group_codeExpiresInHours(int count);

  /// No description provided for @group_codeExpiresInMinutes.
  ///
  /// In ko, this message translates to:
  /// **'{count}분 후 만료'**
  String group_codeExpiresInMinutes(int count);

  /// No description provided for @group_noGroups.
  ///
  /// In ko, this message translates to:
  /// **'참여 중인 그룹이 없습니다'**
  String get group_noGroups;

  /// No description provided for @group_noGroupsDescription.
  ///
  /// In ko, this message translates to:
  /// **'새로운 그룹을 생성하거나\n초대 코드로 그룹에 참여하세요'**
  String get group_noGroupsDescription;

  /// No description provided for @group_myJoinRequests.
  ///
  /// In ko, this message translates to:
  /// **'내 가입 신청 목록'**
  String get group_myJoinRequests;

  /// No description provided for @group_noJoinRequests.
  ///
  /// In ko, this message translates to:
  /// **'가입 신청 내역이 없습니다'**
  String get group_noJoinRequests;

  /// No description provided for @group_joinRequestStatusAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get group_joinRequestStatusAll;

  /// No description provided for @group_joinRequestStatusPending.
  ///
  /// In ko, this message translates to:
  /// **'대기중'**
  String get group_joinRequestStatusPending;

  /// No description provided for @group_joinRequestStatusDone.
  ///
  /// In ko, this message translates to:
  /// **'처리완료'**
  String get group_joinRequestStatusDone;

  /// No description provided for @group_joinRequestAccepted.
  ///
  /// In ko, this message translates to:
  /// **'승인됨'**
  String get group_joinRequestAccepted;

  /// No description provided for @group_joinRequestRejected.
  ///
  /// In ko, this message translates to:
  /// **'거부됨'**
  String get group_joinRequestRejected;

  /// No description provided for @group_codeExpiredLabel.
  ///
  /// In ko, this message translates to:
  /// **'초대 코드 만료됨'**
  String get group_codeExpiredLabel;

  /// No description provided for @group_defaultGroupTooltip.
  ///
  /// In ko, this message translates to:
  /// **'대표 그룹'**
  String get group_defaultGroupTooltip;

  /// No description provided for @group_setDefaultGroupTooltip.
  ///
  /// In ko, this message translates to:
  /// **'대표 그룹으로 설정'**
  String get group_setDefaultGroupTooltip;

  /// No description provided for @group_unsetDefaultGroupTooltip.
  ///
  /// In ko, this message translates to:
  /// **'대표 그룹 해제'**
  String get group_unsetDefaultGroupTooltip;

  /// No description provided for @group_setDefaultSuccess.
  ///
  /// In ko, this message translates to:
  /// **'\'{name}\'을(를) 대표 그룹으로 설정했습니다'**
  String group_setDefaultSuccess(String name);

  /// No description provided for @group_unsetDefaultSuccess.
  ///
  /// In ko, this message translates to:
  /// **'대표 그룹을 해제했습니다'**
  String get group_unsetDefaultSuccess;

  /// No description provided for @group_myColorTitle.
  ///
  /// In ko, this message translates to:
  /// **'나만의 그룹 색상'**
  String get group_myColorTitle;

  /// No description provided for @group_myColorNotSet.
  ///
  /// In ko, this message translates to:
  /// **'설정하지 않음 (그룹 기본 색상 사용)'**
  String get group_myColorNotSet;

  /// No description provided for @group_myColorSet.
  ///
  /// In ko, this message translates to:
  /// **'설정됨'**
  String get group_myColorSet;

  /// No description provided for @group_myColorReset.
  ///
  /// In ko, this message translates to:
  /// **'초기화'**
  String get group_myColorReset;

  /// No description provided for @group_dangerZone.
  ///
  /// In ko, this message translates to:
  /// **'위험 구역'**
  String get group_dangerZone;

  /// No description provided for @group_dangerZoneDesc.
  ///
  /// In ko, this message translates to:
  /// **'그룹을 삭제하면 모든 데이터가 영구적으로 삭제됩니다.'**
  String get group_dangerZoneDesc;

  /// No description provided for @group_leaveTitle.
  ///
  /// In ko, this message translates to:
  /// **'그룹 나가기'**
  String get group_leaveTitle;

  /// No description provided for @group_leaveDesc.
  ///
  /// In ko, this message translates to:
  /// **'그룹을 나가면 더 이상 그룹의 데이터에 접근할 수 없습니다.'**
  String get group_leaveDesc;

  /// No description provided for @group_leaveConfirmBody.
  ///
  /// In ko, this message translates to:
  /// **'정말로 \"{name}\" 그룹을 나가시겠습니까?\n\n그룹을 나가면 더 이상 그룹의 데이터에 접근할 수 없으며, 다시 참여하려면 초대 코드가 필요합니다.'**
  String group_leaveConfirmBody(String name);

  /// No description provided for @group_leaveButton.
  ///
  /// In ko, this message translates to:
  /// **'나가기'**
  String get group_leaveButton;

  /// No description provided for @group_roleManagementTitle.
  ///
  /// In ko, this message translates to:
  /// **'역할 관리'**
  String get group_roleManagementTitle;

  /// No description provided for @group_roleManagementDesc.
  ///
  /// In ko, this message translates to:
  /// **'이 그룹의 역할 목록입니다.'**
  String get group_roleManagementDesc;

  /// No description provided for @group_roleEmpty.
  ///
  /// In ko, this message translates to:
  /// **'역할이 없습니다'**
  String get group_roleEmpty;

  /// No description provided for @group_roleDefaultBadge.
  ///
  /// In ko, this message translates to:
  /// **'기본 역할'**
  String get group_roleDefaultBadge;

  /// No description provided for @group_rolePermissionCount.
  ///
  /// In ko, this message translates to:
  /// **'권한: {count}개'**
  String group_rolePermissionCount(int count);

  /// No description provided for @group_roleEdit.
  ///
  /// In ko, this message translates to:
  /// **'역할 수정'**
  String get group_roleEdit;

  /// No description provided for @group_roleDelete.
  ///
  /// In ko, this message translates to:
  /// **'역할 삭제'**
  String get group_roleDelete;

  /// No description provided for @group_roleSortSaved.
  ///
  /// In ko, this message translates to:
  /// **'정렬 순서가 저장되었습니다'**
  String get group_roleSortSaved;

  /// No description provided for @group_roleLoadError.
  ///
  /// In ko, this message translates to:
  /// **'역할 목록을 불러올 수 없습니다'**
  String get group_roleLoadError;

  /// No description provided for @group_roleInfoTitle.
  ///
  /// In ko, this message translates to:
  /// **'안내'**
  String get group_roleInfoTitle;

  /// No description provided for @group_roleInfoBullet1.
  ///
  /// In ko, this message translates to:
  /// **'공통 역할 (OWNER, ADMIN, MEMBER)은 모든 그룹에 기본으로 제공됩니다.'**
  String get group_roleInfoBullet1;

  /// No description provided for @group_roleInfoBullet2.
  ///
  /// In ko, this message translates to:
  /// **'커스텀 역할은 그룹 OWNER만 생성, 수정, 삭제할 수 있습니다.'**
  String get group_roleInfoBullet2;

  /// No description provided for @group_roleInfoBullet3.
  ///
  /// In ko, this message translates to:
  /// **'역할을 관리하려면 그룹 OWNER 권한이 필요합니다.'**
  String get group_roleInfoBullet3;

  /// No description provided for @group_roleCreateTitle.
  ///
  /// In ko, this message translates to:
  /// **'역할 생성'**
  String get group_roleCreateTitle;

  /// No description provided for @group_roleEditTitle.
  ///
  /// In ko, this message translates to:
  /// **'역할 수정'**
  String get group_roleEditTitle;

  /// No description provided for @group_roleDeleteTitle.
  ///
  /// In ko, this message translates to:
  /// **'역할 삭제'**
  String get group_roleDeleteTitle;

  /// No description provided for @group_roleNameLabel.
  ///
  /// In ko, this message translates to:
  /// **'역할 이름'**
  String get group_roleNameLabel;

  /// No description provided for @group_roleNameRequired.
  ///
  /// In ko, this message translates to:
  /// **'역할 이름을 입력해주세요'**
  String get group_roleNameRequired;

  /// No description provided for @group_roleDefaultSwitch.
  ///
  /// In ko, this message translates to:
  /// **'기본 역할'**
  String get group_roleDefaultSwitch;

  /// No description provided for @group_roleDefaultSwitchSub.
  ///
  /// In ko, this message translates to:
  /// **'새 멤버 가입 시 자동 부여'**
  String get group_roleDefaultSwitchSub;

  /// No description provided for @group_roleColorLabel.
  ///
  /// In ko, this message translates to:
  /// **'역할 색상'**
  String get group_roleColorLabel;

  /// No description provided for @group_rolePermissionsLabel.
  ///
  /// In ko, this message translates to:
  /// **'권한 선택'**
  String get group_rolePermissionsLabel;

  /// No description provided for @group_rolePermissionsViewLabel.
  ///
  /// In ko, this message translates to:
  /// **'권한 목록'**
  String get group_rolePermissionsViewLabel;

  /// No description provided for @group_rolePermissionNone.
  ///
  /// In ko, this message translates to:
  /// **'권한이 없습니다'**
  String get group_rolePermissionNone;

  /// No description provided for @group_roleDefaultLabel.
  ///
  /// In ko, this message translates to:
  /// **'기본 역할 (새 멤버 가입 시 자동 부여)'**
  String get group_roleDefaultLabel;

  /// No description provided for @group_roleDeleteConfirm.
  ///
  /// In ko, this message translates to:
  /// **'{name} 역할을 삭제하시겠습니까?'**
  String group_roleDeleteConfirm(String name);

  /// No description provided for @group_roleDeleteWarning.
  ///
  /// In ko, this message translates to:
  /// **'⚠️ 이 역할을 사용 중인 멤버가 있으면 삭제할 수 없습니다.'**
  String get group_roleDeleteWarning;

  /// No description provided for @group_roleCreateSuccess.
  ///
  /// In ko, this message translates to:
  /// **'역할이 생성되었습니다'**
  String get group_roleCreateSuccess;

  /// No description provided for @group_roleCreateFail.
  ///
  /// In ko, this message translates to:
  /// **'역할 생성 실패: {error}'**
  String group_roleCreateFail(String error);

  /// No description provided for @group_roleEditSuccess.
  ///
  /// In ko, this message translates to:
  /// **'역할이 수정되었습니다'**
  String get group_roleEditSuccess;

  /// No description provided for @group_roleEditFail.
  ///
  /// In ko, this message translates to:
  /// **'역할 수정 실패: {error}'**
  String group_roleEditFail(String error);

  /// No description provided for @group_roleDeleteSuccess.
  ///
  /// In ko, this message translates to:
  /// **'역할이 삭제되었습니다'**
  String get group_roleDeleteSuccess;

  /// No description provided for @group_roleDeleteFail.
  ///
  /// In ko, this message translates to:
  /// **'역할 삭제 실패: {error}'**
  String group_roleDeleteFail(String error);

  /// No description provided for @group_settings_groupManagementTitle.
  ///
  /// In ko, this message translates to:
  /// **'그룹 관리'**
  String get group_settings_groupManagementTitle;

  /// No description provided for @error_network.
  ///
  /// In ko, this message translates to:
  /// **'네트워크 연결을 확인해주세요'**
  String get error_network;

  /// No description provided for @error_server.
  ///
  /// In ko, this message translates to:
  /// **'서버 오류가 발생했습니다'**
  String get error_server;

  /// No description provided for @error_unknown.
  ///
  /// In ko, this message translates to:
  /// **'알 수 없는 오류가 발생했습니다'**
  String get error_unknown;

  /// No description provided for @common_comingSoon.
  ///
  /// In ko, this message translates to:
  /// **'준비 중'**
  String get common_comingSoon;

  /// No description provided for @common_logoutFailed.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃 실패'**
  String get common_logoutFailed;

  /// No description provided for @announcement_title.
  ///
  /// In ko, this message translates to:
  /// **'공지사항'**
  String get announcement_title;

  /// No description provided for @announcement_list.
  ///
  /// In ko, this message translates to:
  /// **'공지사항 목록'**
  String get announcement_list;

  /// No description provided for @announcement_detail.
  ///
  /// In ko, this message translates to:
  /// **'공지사항 상세'**
  String get announcement_detail;

  /// No description provided for @announcement_create.
  ///
  /// In ko, this message translates to:
  /// **'공지사항 작성'**
  String get announcement_create;

  /// No description provided for @announcement_edit.
  ///
  /// In ko, this message translates to:
  /// **'공지사항 수정'**
  String get announcement_edit;

  /// No description provided for @announcement_delete.
  ///
  /// In ko, this message translates to:
  /// **'공지사항 삭제'**
  String get announcement_delete;

  /// No description provided for @announcement_pin.
  ///
  /// In ko, this message translates to:
  /// **'상단 고정'**
  String get announcement_pin;

  /// No description provided for @announcement_unpin.
  ///
  /// In ko, this message translates to:
  /// **'고정 해제'**
  String get announcement_unpin;

  /// No description provided for @announcement_pinned.
  ///
  /// In ko, this message translates to:
  /// **'고정 공지'**
  String get announcement_pinned;

  /// No description provided for @announcement_pinDescription.
  ///
  /// In ko, this message translates to:
  /// **'중요한 공지사항을 목록 상단에 고정합니다'**
  String get announcement_pinDescription;

  /// No description provided for @announcement_category.
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get announcement_category;

  /// No description provided for @announcement_category_none.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 없음'**
  String get announcement_category_none;

  /// No description provided for @announcement_category_announcement.
  ///
  /// In ko, this message translates to:
  /// **'공지'**
  String get announcement_category_announcement;

  /// No description provided for @announcement_category_event.
  ///
  /// In ko, this message translates to:
  /// **'이벤트'**
  String get announcement_category_event;

  /// No description provided for @announcement_category_update.
  ///
  /// In ko, this message translates to:
  /// **'업데이트'**
  String get announcement_category_update;

  /// No description provided for @announcement_content.
  ///
  /// In ko, this message translates to:
  /// **'내용'**
  String get announcement_content;

  /// No description provided for @announcement_author.
  ///
  /// In ko, this message translates to:
  /// **'작성자'**
  String get announcement_author;

  /// No description provided for @announcement_createdAt.
  ///
  /// In ko, this message translates to:
  /// **'작성일'**
  String get announcement_createdAt;

  /// No description provided for @announcement_updatedAt.
  ///
  /// In ko, this message translates to:
  /// **'수정일'**
  String get announcement_updatedAt;

  /// No description provided for @announcement_readCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}명 읽음'**
  String announcement_readCount(int count);

  /// No description provided for @announcement_createSuccess.
  ///
  /// In ko, this message translates to:
  /// **'공지사항이 등록되었습니다'**
  String get announcement_createSuccess;

  /// No description provided for @announcement_createError.
  ///
  /// In ko, this message translates to:
  /// **'공지사항 등록에 실패했습니다'**
  String get announcement_createError;

  /// No description provided for @announcement_updateSuccess.
  ///
  /// In ko, this message translates to:
  /// **'공지사항이 수정되었습니다'**
  String get announcement_updateSuccess;

  /// No description provided for @announcement_updateError.
  ///
  /// In ko, this message translates to:
  /// **'공지사항 수정에 실패했습니다'**
  String get announcement_updateError;

  /// No description provided for @announcement_deleteSuccess.
  ///
  /// In ko, this message translates to:
  /// **'공지사항이 삭제되었습니다'**
  String get announcement_deleteSuccess;

  /// No description provided for @announcement_deleteError.
  ///
  /// In ko, this message translates to:
  /// **'공지사항 삭제에 실패했습니다'**
  String get announcement_deleteError;

  /// No description provided for @announcement_deleteDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'공지사항 삭제'**
  String get announcement_deleteDialogTitle;

  /// No description provided for @announcement_deleteDialogMessage.
  ///
  /// In ko, this message translates to:
  /// **'이 공지사항을 삭제하시겠습니까?\n삭제된 공지사항은 복구할 수 없습니다.'**
  String get announcement_deleteDialogMessage;

  /// No description provided for @announcement_pinSuccess.
  ///
  /// In ko, this message translates to:
  /// **'공지사항이 고정되었습니다'**
  String get announcement_pinSuccess;

  /// No description provided for @announcement_unpinSuccess.
  ///
  /// In ko, this message translates to:
  /// **'고정이 해제되었습니다'**
  String get announcement_unpinSuccess;

  /// No description provided for @announcement_deleteConfirm.
  ///
  /// In ko, this message translates to:
  /// **'이 공지사항을 삭제하시겠습니까?\n삭제된 공지사항은 복구할 수 없습니다.'**
  String get announcement_deleteConfirm;

  /// No description provided for @announcement_loadError.
  ///
  /// In ko, this message translates to:
  /// **'공지사항을 불러올 수 없습니다'**
  String get announcement_loadError;

  /// No description provided for @announcement_empty.
  ///
  /// In ko, this message translates to:
  /// **'등록된 공지사항이 없습니다'**
  String get announcement_empty;

  /// No description provided for @announcement_titleHint.
  ///
  /// In ko, this message translates to:
  /// **'공지사항 제목을 입력하세요'**
  String get announcement_titleHint;

  /// No description provided for @announcement_contentHint.
  ///
  /// In ko, this message translates to:
  /// **'공지사항 내용을 입력하세요'**
  String get announcement_contentHint;

  /// No description provided for @announcement_categoryHint.
  ///
  /// In ko, this message translates to:
  /// **'카테고리를 선택하세요 (선택사항)'**
  String get announcement_categoryHint;

  /// No description provided for @announcement_titleRequired.
  ///
  /// In ko, this message translates to:
  /// **'제목을 입력해주세요'**
  String get announcement_titleRequired;

  /// No description provided for @announcement_titleMinLength.
  ///
  /// In ko, this message translates to:
  /// **'제목은 최소 3자 이상 입력해주세요'**
  String get announcement_titleMinLength;

  /// No description provided for @announcement_contentRequired.
  ///
  /// In ko, this message translates to:
  /// **'내용을 입력해주세요'**
  String get announcement_contentRequired;

  /// No description provided for @announcement_contentMinLength.
  ///
  /// In ko, this message translates to:
  /// **'내용은 최소 10자 이상 입력해주세요'**
  String get announcement_contentMinLength;

  /// No description provided for @announcement_attachmentComingSoon.
  ///
  /// In ko, this message translates to:
  /// **'첨부파일 업로드 기능은 추후 업데이트 예정입니다'**
  String get announcement_attachmentComingSoon;

  /// No description provided for @qna_title.
  ///
  /// In ko, this message translates to:
  /// **'Q&A'**
  String get qna_title;

  /// No description provided for @qna_publicQuestions.
  ///
  /// In ko, this message translates to:
  /// **'공개 Q&A'**
  String get qna_publicQuestions;

  /// No description provided for @qna_myQuestions.
  ///
  /// In ko, this message translates to:
  /// **'내 질문'**
  String get qna_myQuestions;

  /// No description provided for @qna_askQuestion.
  ///
  /// In ko, this message translates to:
  /// **'질문하기'**
  String get qna_askQuestion;

  /// No description provided for @qna_question.
  ///
  /// In ko, this message translates to:
  /// **'질문'**
  String get qna_question;

  /// No description provided for @qna_answer.
  ///
  /// In ko, this message translates to:
  /// **'답변'**
  String get qna_answer;

  /// No description provided for @qna_category.
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get qna_category;

  /// No description provided for @qna_categoryFilter.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 필터'**
  String get qna_categoryFilter;

  /// No description provided for @qna_categoryAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get qna_categoryAll;

  /// No description provided for @qna_categoryNone.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 없음'**
  String get qna_categoryNone;

  /// No description provided for @qna_status.
  ///
  /// In ko, this message translates to:
  /// **'상태'**
  String get qna_status;

  /// No description provided for @qna_statusAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get qna_statusAll;

  /// No description provided for @qna_statusPending.
  ///
  /// In ko, this message translates to:
  /// **'답변 대기'**
  String get qna_statusPending;

  /// No description provided for @qna_statusAnswered.
  ///
  /// In ko, this message translates to:
  /// **'답변 완료'**
  String get qna_statusAnswered;

  /// No description provided for @qna_statusResolved.
  ///
  /// In ko, this message translates to:
  /// **'해결됨'**
  String get qna_statusResolved;

  /// No description provided for @qna_search.
  ///
  /// In ko, this message translates to:
  /// **'질문 검색'**
  String get qna_search;

  /// No description provided for @qna_searchHint.
  ///
  /// In ko, this message translates to:
  /// **'질문을 검색하세요'**
  String get qna_searchHint;

  /// No description provided for @qna_questionTitle.
  ///
  /// In ko, this message translates to:
  /// **'질문 제목'**
  String get qna_questionTitle;

  /// No description provided for @qna_questionTitleHint.
  ///
  /// In ko, this message translates to:
  /// **'질문 제목을 입력하세요'**
  String get qna_questionTitleHint;

  /// No description provided for @qna_questionContent.
  ///
  /// In ko, this message translates to:
  /// **'질문 내용'**
  String get qna_questionContent;

  /// No description provided for @qna_questionContentHint.
  ///
  /// In ko, this message translates to:
  /// **'질문 내용을 입력하세요'**
  String get qna_questionContentHint;

  /// No description provided for @qna_answerContent.
  ///
  /// In ko, this message translates to:
  /// **'답변 내용'**
  String get qna_answerContent;

  /// No description provided for @qna_answerContentHint.
  ///
  /// In ko, this message translates to:
  /// **'답변을 입력하세요'**
  String get qna_answerContentHint;

  /// No description provided for @qna_isPublic.
  ///
  /// In ko, this message translates to:
  /// **'공개 여부'**
  String get qna_isPublic;

  /// No description provided for @qna_publicQuestion.
  ///
  /// In ko, this message translates to:
  /// **'공개 질문'**
  String get qna_publicQuestion;

  /// No description provided for @qna_privateQuestion.
  ///
  /// In ko, this message translates to:
  /// **'비공개 질문'**
  String get qna_privateQuestion;

  /// No description provided for @qna_author.
  ///
  /// In ko, this message translates to:
  /// **'작성자'**
  String get qna_author;

  /// No description provided for @qna_answerer.
  ///
  /// In ko, this message translates to:
  /// **'답변자'**
  String get qna_answerer;

  /// No description provided for @qna_createdAt.
  ///
  /// In ko, this message translates to:
  /// **'작성일'**
  String get qna_createdAt;

  /// No description provided for @qna_answeredAt.
  ///
  /// In ko, this message translates to:
  /// **'답변일'**
  String get qna_answeredAt;

  /// No description provided for @qna_viewCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}회 조회'**
  String qna_viewCount(int count);

  /// No description provided for @qna_answerCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 답변'**
  String qna_answerCount(int count);

  /// No description provided for @qna_empty.
  ///
  /// In ko, this message translates to:
  /// **'등록된 질문이 없습니다'**
  String get qna_empty;

  /// No description provided for @qna_noAnswer.
  ///
  /// In ko, this message translates to:
  /// **'아직 답변이 없습니다'**
  String get qna_noAnswer;

  /// No description provided for @qna_loadError.
  ///
  /// In ko, this message translates to:
  /// **'질문을 불러올 수 없습니다'**
  String get qna_loadError;

  /// No description provided for @qna_createSuccess.
  ///
  /// In ko, this message translates to:
  /// **'질문이 등록되었습니다'**
  String get qna_createSuccess;

  /// No description provided for @qna_createError.
  ///
  /// In ko, this message translates to:
  /// **'질문 등록에 실패했습니다'**
  String get qna_createError;

  /// No description provided for @qna_updateSuccess.
  ///
  /// In ko, this message translates to:
  /// **'질문이 수정되었습니다'**
  String get qna_updateSuccess;

  /// No description provided for @qna_updateError.
  ///
  /// In ko, this message translates to:
  /// **'질문 수정에 실패했습니다'**
  String get qna_updateError;

  /// No description provided for @qna_deleteSuccess.
  ///
  /// In ko, this message translates to:
  /// **'질문이 삭제되었습니다'**
  String get qna_deleteSuccess;

  /// No description provided for @qna_deleteError.
  ///
  /// In ko, this message translates to:
  /// **'질문 삭제에 실패했습니다'**
  String get qna_deleteError;

  /// No description provided for @qna_deleteDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'질문 삭제'**
  String get qna_deleteDialogTitle;

  /// No description provided for @qna_deleteDialogMessage.
  ///
  /// In ko, this message translates to:
  /// **'이 질문을 삭제하시겠습니까?\n삭제된 질문은 복구할 수 없습니다.'**
  String get qna_deleteDialogMessage;

  /// No description provided for @qna_answerSuccess.
  ///
  /// In ko, this message translates to:
  /// **'답변이 등록되었습니다'**
  String get qna_answerSuccess;

  /// No description provided for @qna_answerError.
  ///
  /// In ko, this message translates to:
  /// **'답변 등록에 실패했습니다'**
  String get qna_answerError;

  /// No description provided for @qna_answerUpdateSuccess.
  ///
  /// In ko, this message translates to:
  /// **'답변이 수정되었습니다'**
  String get qna_answerUpdateSuccess;

  /// No description provided for @qna_answerUpdateError.
  ///
  /// In ko, this message translates to:
  /// **'답변 수정에 실패했습니다'**
  String get qna_answerUpdateError;

  /// No description provided for @qna_answerDeleteSuccess.
  ///
  /// In ko, this message translates to:
  /// **'답변이 삭제되었습니다'**
  String get qna_answerDeleteSuccess;

  /// No description provided for @qna_answerDeleteError.
  ///
  /// In ko, this message translates to:
  /// **'답변 삭제에 실패했습니다'**
  String get qna_answerDeleteError;

  /// No description provided for @qna_markResolved.
  ///
  /// In ko, this message translates to:
  /// **'해결됨으로 표시'**
  String get qna_markResolved;

  /// No description provided for @qna_markUnresolved.
  ///
  /// In ko, this message translates to:
  /// **'미해결로 표시'**
  String get qna_markUnresolved;

  /// No description provided for @qna_resolveSuccess.
  ///
  /// In ko, this message translates to:
  /// **'질문이 해결됨으로 표시되었습니다'**
  String get qna_resolveSuccess;

  /// No description provided for @qna_resolveError.
  ///
  /// In ko, this message translates to:
  /// **'상태 변경에 실패했습니다'**
  String get qna_resolveError;

  /// No description provided for @qna_titleRequired.
  ///
  /// In ko, this message translates to:
  /// **'제목을 입력해주세요'**
  String get qna_titleRequired;

  /// No description provided for @qna_titleMinLength.
  ///
  /// In ko, this message translates to:
  /// **'제목은 최소 3자 이상 입력해주세요'**
  String get qna_titleMinLength;

  /// No description provided for @qna_contentRequired.
  ///
  /// In ko, this message translates to:
  /// **'내용을 입력해주세요'**
  String get qna_contentRequired;

  /// No description provided for @qna_contentMinLength.
  ///
  /// In ko, this message translates to:
  /// **'내용은 최소 10자 이상 입력해주세요'**
  String get qna_contentMinLength;

  /// No description provided for @qna_answerRequired.
  ///
  /// In ko, this message translates to:
  /// **'답변을 입력해주세요'**
  String get qna_answerRequired;

  /// No description provided for @schedule_today.
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get schedule_today;

  /// No description provided for @schedule_add.
  ///
  /// In ko, this message translates to:
  /// **'일정 추가'**
  String get schedule_add;

  /// No description provided for @schedule_edit.
  ///
  /// In ko, this message translates to:
  /// **'일정 수정'**
  String get schedule_edit;

  /// No description provided for @schedule_delete.
  ///
  /// In ko, this message translates to:
  /// **'일정 삭제'**
  String get schedule_delete;

  /// No description provided for @schedule_detail.
  ///
  /// In ko, this message translates to:
  /// **'일정 상세'**
  String get schedule_detail;

  /// No description provided for @schedule_allDay.
  ///
  /// In ko, this message translates to:
  /// **'종일'**
  String get schedule_allDay;

  /// No description provided for @schedule_loadError.
  ///
  /// In ko, this message translates to:
  /// **'일정을 불러올 수 없습니다'**
  String get schedule_loadError;

  /// No description provided for @schedule_empty.
  ///
  /// In ko, this message translates to:
  /// **'등록된 일정이 없습니다'**
  String get schedule_empty;

  /// No description provided for @schedule_createSuccess.
  ///
  /// In ko, this message translates to:
  /// **'일정이 등록되었습니다'**
  String get schedule_createSuccess;

  /// No description provided for @schedule_createError.
  ///
  /// In ko, this message translates to:
  /// **'일정 등록에 실패했습니다'**
  String get schedule_createError;

  /// No description provided for @schedule_updateSuccess.
  ///
  /// In ko, this message translates to:
  /// **'일정이 수정되었습니다'**
  String get schedule_updateSuccess;

  /// No description provided for @schedule_updateError.
  ///
  /// In ko, this message translates to:
  /// **'일정 수정에 실패했습니다'**
  String get schedule_updateError;

  /// No description provided for @schedule_deleteSuccess.
  ///
  /// In ko, this message translates to:
  /// **'일정이 삭제되었습니다'**
  String get schedule_deleteSuccess;

  /// No description provided for @schedule_deleteError.
  ///
  /// In ko, this message translates to:
  /// **'일정 삭제에 실패했습니다'**
  String get schedule_deleteError;

  /// No description provided for @schedule_deleteDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'일정 삭제'**
  String get schedule_deleteDialogTitle;

  /// No description provided for @schedule_deleteDialogMessage.
  ///
  /// In ko, this message translates to:
  /// **'이 일정을 삭제하시겠습니까?'**
  String get schedule_deleteDialogMessage;

  /// No description provided for @schedule_title.
  ///
  /// In ko, this message translates to:
  /// **'제목'**
  String get schedule_title;

  /// No description provided for @schedule_titleHint.
  ///
  /// In ko, this message translates to:
  /// **'일정 제목을 입력하세요'**
  String get schedule_titleHint;

  /// No description provided for @schedule_titleRequired.
  ///
  /// In ko, this message translates to:
  /// **'제목을 입력해주세요'**
  String get schedule_titleRequired;

  /// No description provided for @schedule_description.
  ///
  /// In ko, this message translates to:
  /// **'설명'**
  String get schedule_description;

  /// No description provided for @schedule_descriptionHint.
  ///
  /// In ko, this message translates to:
  /// **'일정 설명을 입력하세요 (선택)'**
  String get schedule_descriptionHint;

  /// No description provided for @schedule_location.
  ///
  /// In ko, this message translates to:
  /// **'장소'**
  String get schedule_location;

  /// No description provided for @schedule_locationHint.
  ///
  /// In ko, this message translates to:
  /// **'장소를 입력하세요 (선택)'**
  String get schedule_locationHint;

  /// No description provided for @schedule_startDate.
  ///
  /// In ko, this message translates to:
  /// **'시작일'**
  String get schedule_startDate;

  /// No description provided for @schedule_endDate.
  ///
  /// In ko, this message translates to:
  /// **'종료일'**
  String get schedule_endDate;

  /// No description provided for @schedule_startTime.
  ///
  /// In ko, this message translates to:
  /// **'시작 시간'**
  String get schedule_startTime;

  /// No description provided for @schedule_endTime.
  ///
  /// In ko, this message translates to:
  /// **'종료 시간'**
  String get schedule_endTime;

  /// No description provided for @schedule_dueDate.
  ///
  /// In ko, this message translates to:
  /// **'마감일 설정'**
  String get schedule_dueDate;

  /// No description provided for @schedule_dueDateSelect.
  ///
  /// In ko, this message translates to:
  /// **'마감 날짜'**
  String get schedule_dueDateSelect;

  /// No description provided for @schedule_dueTime.
  ///
  /// In ko, this message translates to:
  /// **'마감 시간'**
  String get schedule_dueTime;

  /// No description provided for @schedule_color.
  ///
  /// In ko, this message translates to:
  /// **'색상'**
  String get schedule_color;

  /// No description provided for @schedule_share.
  ///
  /// In ko, this message translates to:
  /// **'공유 설정'**
  String get schedule_share;

  /// No description provided for @schedule_sharePrivate.
  ///
  /// In ko, this message translates to:
  /// **'나만 보기'**
  String get schedule_sharePrivate;

  /// No description provided for @schedule_shareGroup.
  ///
  /// In ko, this message translates to:
  /// **'특정 그룹'**
  String get schedule_shareGroup;

  /// No description provided for @schedule_reminder.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get schedule_reminder;

  /// No description provided for @schedule_reminderNone.
  ///
  /// In ko, this message translates to:
  /// **'없음'**
  String get schedule_reminderNone;

  /// No description provided for @schedule_reminderAtTime.
  ///
  /// In ko, this message translates to:
  /// **'정시'**
  String get schedule_reminderAtTime;

  /// No description provided for @schedule_reminder5Min.
  ///
  /// In ko, this message translates to:
  /// **'5분 전'**
  String get schedule_reminder5Min;

  /// No description provided for @schedule_reminder15Min.
  ///
  /// In ko, this message translates to:
  /// **'15분 전'**
  String get schedule_reminder15Min;

  /// No description provided for @schedule_reminder30Min.
  ///
  /// In ko, this message translates to:
  /// **'30분 전'**
  String get schedule_reminder30Min;

  /// No description provided for @schedule_reminder1Hour.
  ///
  /// In ko, this message translates to:
  /// **'1시간 전'**
  String get schedule_reminder1Hour;

  /// No description provided for @schedule_reminder1Day.
  ///
  /// In ko, this message translates to:
  /// **'1일 전'**
  String get schedule_reminder1Day;

  /// No description provided for @schedule_recurrence.
  ///
  /// In ko, this message translates to:
  /// **'반복'**
  String get schedule_recurrence;

  /// No description provided for @schedule_recurrenceNone.
  ///
  /// In ko, this message translates to:
  /// **'반복 안함'**
  String get schedule_recurrenceNone;

  /// No description provided for @schedule_recurrenceDaily.
  ///
  /// In ko, this message translates to:
  /// **'매일'**
  String get schedule_recurrenceDaily;

  /// No description provided for @schedule_recurrenceWeekly.
  ///
  /// In ko, this message translates to:
  /// **'매주'**
  String get schedule_recurrenceWeekly;

  /// No description provided for @schedule_recurrenceMonthly.
  ///
  /// In ko, this message translates to:
  /// **'매월'**
  String get schedule_recurrenceMonthly;

  /// No description provided for @schedule_recurrenceYearly.
  ///
  /// In ko, this message translates to:
  /// **'매년'**
  String get schedule_recurrenceYearly;

  /// No description provided for @schedule_personal.
  ///
  /// In ko, this message translates to:
  /// **'개인 일정'**
  String get schedule_personal;

  /// No description provided for @schedule_group.
  ///
  /// In ko, this message translates to:
  /// **'그룹'**
  String get schedule_group;

  /// No description provided for @schedule_taskType.
  ///
  /// In ko, this message translates to:
  /// **'일정 유형'**
  String get schedule_taskType;

  /// No description provided for @schedule_taskTypeCalendarOnly.
  ///
  /// In ko, this message translates to:
  /// **'단순 일정'**
  String get schedule_taskTypeCalendarOnly;

  /// No description provided for @schedule_taskTypeCalendarOnlyDesc.
  ///
  /// In ko, this message translates to:
  /// **'캘린더에만 표시됩니다'**
  String get schedule_taskTypeCalendarOnlyDesc;

  /// No description provided for @schedule_taskTypeTodoLinked.
  ///
  /// In ko, this message translates to:
  /// **'할일 연동'**
  String get schedule_taskTypeTodoLinked;

  /// No description provided for @schedule_taskTypeTodoLinkedDesc.
  ///
  /// In ko, this message translates to:
  /// **'캘린더와 할일 목록에 모두 표시됩니다'**
  String get schedule_taskTypeTodoLinkedDesc;

  /// No description provided for @schedule_taskTypeTodoOnly.
  ///
  /// In ko, this message translates to:
  /// **'할일 전용'**
  String get schedule_taskTypeTodoOnly;

  /// No description provided for @schedule_taskTypeTodoOnlyDesc.
  ///
  /// In ko, this message translates to:
  /// **'할일 목록에만 표시 (캘린더 제외)'**
  String get schedule_taskTypeTodoOnlyDesc;

  /// No description provided for @schedule_priority.
  ///
  /// In ko, this message translates to:
  /// **'우선순위'**
  String get schedule_priority;

  /// No description provided for @schedule_priorityLow.
  ///
  /// In ko, this message translates to:
  /// **'낮음'**
  String get schedule_priorityLow;

  /// No description provided for @schedule_priorityMedium.
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get schedule_priorityMedium;

  /// No description provided for @schedule_priorityHigh.
  ///
  /// In ko, this message translates to:
  /// **'높음'**
  String get schedule_priorityHigh;

  /// No description provided for @schedule_priorityUrgent.
  ///
  /// In ko, this message translates to:
  /// **'긴급'**
  String get schedule_priorityUrgent;

  /// No description provided for @schedule_participants.
  ///
  /// In ko, this message translates to:
  /// **'참가자'**
  String get schedule_participants;

  /// No description provided for @schedule_participantsHint.
  ///
  /// In ko, this message translates to:
  /// **'이 일정에 참여할 그룹 멤버를 선택하세요'**
  String get schedule_participantsHint;

  /// No description provided for @schedule_noMembers.
  ///
  /// In ko, this message translates to:
  /// **'그룹 멤버가 없습니다'**
  String get schedule_noMembers;

  /// No description provided for @schedule_participantsLoadError.
  ///
  /// In ko, this message translates to:
  /// **'멤버 목록을 불러올 수 없습니다'**
  String get schedule_participantsLoadError;

  /// No description provided for @schedule_participantsSelectAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 선택'**
  String get schedule_participantsSelectAll;

  /// No description provided for @schedule_participantsDeselectAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 해제'**
  String get schedule_participantsDeselectAll;

  /// No description provided for @schedule_reminderCustom.
  ///
  /// In ko, this message translates to:
  /// **'직접 설정'**
  String get schedule_reminderCustom;

  /// No description provided for @schedule_reminderCustomTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림 시간 설정'**
  String get schedule_reminderCustomTitle;

  /// No description provided for @schedule_reminderCustomHint.
  ///
  /// In ko, this message translates to:
  /// **'일정 시작 전 알림받을 시간을 설정하세요'**
  String get schedule_reminderCustomHint;

  /// No description provided for @schedule_reminderDays.
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get schedule_reminderDays;

  /// No description provided for @schedule_reminderHours.
  ///
  /// In ko, this message translates to:
  /// **'시간'**
  String get schedule_reminderHours;

  /// No description provided for @schedule_reminderMinutes.
  ///
  /// In ko, this message translates to:
  /// **'분'**
  String get schedule_reminderMinutes;

  /// No description provided for @schedule_reminderMinutesBefore.
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분 전'**
  String schedule_reminderMinutesBefore(int minutes);

  /// No description provided for @schedule_reminderHoursBefore.
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간 전'**
  String schedule_reminderHoursBefore(int hours);

  /// No description provided for @schedule_reminderHoursMinutesBefore.
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간 {minutes}분 전'**
  String schedule_reminderHoursMinutesBefore(int hours, int minutes);

  /// No description provided for @schedule_reminderDaysBefore.
  ///
  /// In ko, this message translates to:
  /// **'{days}일 전'**
  String schedule_reminderDaysBefore(int days);

  /// No description provided for @schedule_reminderDaysHoursBefore.
  ///
  /// In ko, this message translates to:
  /// **'{days}일 {hours}시간 전'**
  String schedule_reminderDaysHoursBefore(int days, int hours);

  /// No description provided for @category_management.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 관리'**
  String get category_management;

  /// No description provided for @category_filter.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 필터'**
  String get category_filter;

  /// No description provided for @category_add.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 추가'**
  String get category_add;

  /// No description provided for @category_edit.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 수정'**
  String get category_edit;

  /// No description provided for @category_empty.
  ///
  /// In ko, this message translates to:
  /// **'카테고리가 없습니다'**
  String get category_empty;

  /// No description provided for @category_emptyHint.
  ///
  /// In ko, this message translates to:
  /// **'카테고리를 추가하여 일정을 분류해보세요'**
  String get category_emptyHint;

  /// No description provided for @category_loadError.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 로딩 실패'**
  String get category_loadError;

  /// No description provided for @category_name.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 이름'**
  String get category_name;

  /// No description provided for @category_nameHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 업무, 개인, 가족'**
  String get category_nameHint;

  /// No description provided for @category_nameRequired.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 이름을 입력해주세요'**
  String get category_nameRequired;

  /// No description provided for @category_description.
  ///
  /// In ko, this message translates to:
  /// **'설명'**
  String get category_description;

  /// No description provided for @category_descriptionHint.
  ///
  /// In ko, this message translates to:
  /// **'카테고리에 대한 설명 (선택)'**
  String get category_descriptionHint;

  /// No description provided for @category_emoji.
  ///
  /// In ko, this message translates to:
  /// **'이모지'**
  String get category_emoji;

  /// No description provided for @category_color.
  ///
  /// In ko, this message translates to:
  /// **'색상'**
  String get category_color;

  /// No description provided for @category_createSuccess.
  ///
  /// In ko, this message translates to:
  /// **'카테고리가 생성되었습니다'**
  String get category_createSuccess;

  /// No description provided for @category_createError.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 생성 실패'**
  String get category_createError;

  /// No description provided for @category_updateSuccess.
  ///
  /// In ko, this message translates to:
  /// **'카테고리가 수정되었습니다'**
  String get category_updateSuccess;

  /// No description provided for @category_updateError.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 수정 실패'**
  String get category_updateError;

  /// No description provided for @category_deleteSuccess.
  ///
  /// In ko, this message translates to:
  /// **'카테고리가 삭제되었습니다'**
  String get category_deleteSuccess;

  /// No description provided for @category_deleteError.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 삭제 실패'**
  String get category_deleteError;

  /// No description provided for @category_deleteDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 삭제'**
  String get category_deleteDialogTitle;

  /// No description provided for @category_deleteDialogMessage.
  ///
  /// In ko, this message translates to:
  /// **'이 카테고리를 삭제하시겠습니까?\n연결된 일정이 있으면 삭제할 수 없습니다.'**
  String get category_deleteDialogMessage;

  /// No description provided for @schedule_recurringEvery.
  ///
  /// In ko, this message translates to:
  /// **'매'**
  String get schedule_recurringEvery;

  /// No description provided for @schedule_recurringIntervalDay.
  ///
  /// In ko, this message translates to:
  /// **'일마다'**
  String get schedule_recurringIntervalDay;

  /// No description provided for @schedule_recurringIntervalWeek.
  ///
  /// In ko, this message translates to:
  /// **'주마다'**
  String get schedule_recurringIntervalWeek;

  /// No description provided for @schedule_recurringIntervalMonth.
  ///
  /// In ko, this message translates to:
  /// **'개월마다'**
  String get schedule_recurringIntervalMonth;

  /// No description provided for @schedule_recurringIntervalYear.
  ///
  /// In ko, this message translates to:
  /// **'년마다'**
  String get schedule_recurringIntervalYear;

  /// No description provided for @schedule_recurringDaysOfWeek.
  ///
  /// In ko, this message translates to:
  /// **'반복 요일'**
  String get schedule_recurringDaysOfWeek;

  /// No description provided for @schedule_daySun.
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get schedule_daySun;

  /// No description provided for @schedule_dayMon.
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get schedule_dayMon;

  /// No description provided for @schedule_dayTue.
  ///
  /// In ko, this message translates to:
  /// **'화'**
  String get schedule_dayTue;

  /// No description provided for @schedule_dayWed.
  ///
  /// In ko, this message translates to:
  /// **'수'**
  String get schedule_dayWed;

  /// No description provided for @schedule_dayThu.
  ///
  /// In ko, this message translates to:
  /// **'목'**
  String get schedule_dayThu;

  /// No description provided for @schedule_dayFri.
  ///
  /// In ko, this message translates to:
  /// **'금'**
  String get schedule_dayFri;

  /// No description provided for @schedule_daySat.
  ///
  /// In ko, this message translates to:
  /// **'토'**
  String get schedule_daySat;

  /// No description provided for @schedule_daySunday.
  ///
  /// In ko, this message translates to:
  /// **'일요일'**
  String get schedule_daySunday;

  /// No description provided for @schedule_dayMonday.
  ///
  /// In ko, this message translates to:
  /// **'월요일'**
  String get schedule_dayMonday;

  /// No description provided for @schedule_dayTuesday.
  ///
  /// In ko, this message translates to:
  /// **'화요일'**
  String get schedule_dayTuesday;

  /// No description provided for @schedule_dayWednesday.
  ///
  /// In ko, this message translates to:
  /// **'수요일'**
  String get schedule_dayWednesday;

  /// No description provided for @schedule_dayThursday.
  ///
  /// In ko, this message translates to:
  /// **'목요일'**
  String get schedule_dayThursday;

  /// No description provided for @schedule_dayFriday.
  ///
  /// In ko, this message translates to:
  /// **'금요일'**
  String get schedule_dayFriday;

  /// No description provided for @schedule_daySaturday.
  ///
  /// In ko, this message translates to:
  /// **'토요일'**
  String get schedule_daySaturday;

  /// No description provided for @schedule_recurringMonthlyType.
  ///
  /// In ko, this message translates to:
  /// **'월간 반복 방식'**
  String get schedule_recurringMonthlyType;

  /// No description provided for @schedule_recurringMonthlyDayOfMonth.
  ///
  /// In ko, this message translates to:
  /// **'날짜 기준'**
  String get schedule_recurringMonthlyDayOfMonth;

  /// No description provided for @schedule_recurringMonthlyWeekOfMonth.
  ///
  /// In ko, this message translates to:
  /// **'요일 기준'**
  String get schedule_recurringMonthlyWeekOfMonth;

  /// No description provided for @schedule_recurringMonthlyEveryMonth.
  ///
  /// In ko, this message translates to:
  /// **'매월'**
  String get schedule_recurringMonthlyEveryMonth;

  /// No description provided for @schedule_recurringDay.
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get schedule_recurringDay;

  /// No description provided for @schedule_recurringWeek1.
  ///
  /// In ko, this message translates to:
  /// **'첫째 주'**
  String get schedule_recurringWeek1;

  /// No description provided for @schedule_recurringWeek2.
  ///
  /// In ko, this message translates to:
  /// **'둘째 주'**
  String get schedule_recurringWeek2;

  /// No description provided for @schedule_recurringWeek3.
  ///
  /// In ko, this message translates to:
  /// **'셋째 주'**
  String get schedule_recurringWeek3;

  /// No description provided for @schedule_recurringWeek4.
  ///
  /// In ko, this message translates to:
  /// **'넷째 주'**
  String get schedule_recurringWeek4;

  /// No description provided for @schedule_recurringWeekLast.
  ///
  /// In ko, this message translates to:
  /// **'마지막 주'**
  String get schedule_recurringWeekLast;

  /// No description provided for @schedule_recurringYearlyType.
  ///
  /// In ko, this message translates to:
  /// **'연간 반복 방식'**
  String get schedule_recurringYearlyType;

  /// No description provided for @schedule_recurringYearlyDayOfMonth.
  ///
  /// In ko, this message translates to:
  /// **'날짜 기준'**
  String get schedule_recurringYearlyDayOfMonth;

  /// No description provided for @schedule_recurringYearlyWeekOfMonth.
  ///
  /// In ko, this message translates to:
  /// **'요일 기준'**
  String get schedule_recurringYearlyWeekOfMonth;

  /// No description provided for @schedule_recurringYearlyEveryYear.
  ///
  /// In ko, this message translates to:
  /// **'매년'**
  String get schedule_recurringYearlyEveryYear;

  /// No description provided for @schedule_month1.
  ///
  /// In ko, this message translates to:
  /// **'1월'**
  String get schedule_month1;

  /// No description provided for @schedule_month2.
  ///
  /// In ko, this message translates to:
  /// **'2월'**
  String get schedule_month2;

  /// No description provided for @schedule_month3.
  ///
  /// In ko, this message translates to:
  /// **'3월'**
  String get schedule_month3;

  /// No description provided for @schedule_month4.
  ///
  /// In ko, this message translates to:
  /// **'4월'**
  String get schedule_month4;

  /// No description provided for @schedule_month5.
  ///
  /// In ko, this message translates to:
  /// **'5월'**
  String get schedule_month5;

  /// No description provided for @schedule_month6.
  ///
  /// In ko, this message translates to:
  /// **'6월'**
  String get schedule_month6;

  /// No description provided for @schedule_month7.
  ///
  /// In ko, this message translates to:
  /// **'7월'**
  String get schedule_month7;

  /// No description provided for @schedule_month8.
  ///
  /// In ko, this message translates to:
  /// **'8월'**
  String get schedule_month8;

  /// No description provided for @schedule_month9.
  ///
  /// In ko, this message translates to:
  /// **'9월'**
  String get schedule_month9;

  /// No description provided for @schedule_month10.
  ///
  /// In ko, this message translates to:
  /// **'10월'**
  String get schedule_month10;

  /// No description provided for @schedule_month11.
  ///
  /// In ko, this message translates to:
  /// **'11월'**
  String get schedule_month11;

  /// No description provided for @schedule_month12.
  ///
  /// In ko, this message translates to:
  /// **'12월'**
  String get schedule_month12;

  /// No description provided for @schedule_recurringEndCondition.
  ///
  /// In ko, this message translates to:
  /// **'종료 조건'**
  String get schedule_recurringEndCondition;

  /// No description provided for @schedule_recurringEndNever.
  ///
  /// In ko, this message translates to:
  /// **'종료 없음'**
  String get schedule_recurringEndNever;

  /// No description provided for @schedule_recurringEndDate.
  ///
  /// In ko, this message translates to:
  /// **'날짜까지'**
  String get schedule_recurringEndDate;

  /// No description provided for @schedule_recurringEndCount.
  ///
  /// In ko, this message translates to:
  /// **'횟수만큼'**
  String get schedule_recurringEndCount;

  /// No description provided for @schedule_recurringCountTimes.
  ///
  /// In ko, this message translates to:
  /// **'회 반복'**
  String get schedule_recurringCountTimes;

  /// No description provided for @schedule_searchHint.
  ///
  /// In ko, this message translates to:
  /// **'제목, 설명, 장소로 검색'**
  String get schedule_searchHint;

  /// No description provided for @schedule_searchNoResults.
  ///
  /// In ko, this message translates to:
  /// **'검색 결과가 없습니다'**
  String get schedule_searchNoResults;

  /// No description provided for @schedule_searchResultCount.
  ///
  /// In ko, this message translates to:
  /// **'검색 결과 {count}건'**
  String schedule_searchResultCount(int count);

  /// No description provided for @todo_add.
  ///
  /// In ko, this message translates to:
  /// **'할일 추가'**
  String get todo_add;

  /// No description provided for @todo_edit.
  ///
  /// In ko, this message translates to:
  /// **'할일 수정'**
  String get todo_edit;

  /// No description provided for @todo_delete.
  ///
  /// In ko, this message translates to:
  /// **'할일 삭제'**
  String get todo_delete;

  /// No description provided for @todo_detail.
  ///
  /// In ko, this message translates to:
  /// **'할일 상세'**
  String get todo_detail;

  /// No description provided for @todo_showCompleted.
  ///
  /// In ko, this message translates to:
  /// **'완료 포함'**
  String get todo_showCompleted;

  /// No description provided for @todo_priority.
  ///
  /// In ko, this message translates to:
  /// **'우선순위'**
  String get todo_priority;

  /// No description provided for @todo_priorityLow.
  ///
  /// In ko, this message translates to:
  /// **'낮음'**
  String get todo_priorityLow;

  /// No description provided for @todo_priorityMedium.
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get todo_priorityMedium;

  /// No description provided for @todo_priorityHigh.
  ///
  /// In ko, this message translates to:
  /// **'높음'**
  String get todo_priorityHigh;

  /// No description provided for @todo_priorityUrgent.
  ///
  /// In ko, this message translates to:
  /// **'긴급'**
  String get todo_priorityUrgent;

  /// No description provided for @todo_noTodos.
  ///
  /// In ko, this message translates to:
  /// **'등록된 할일이 없습니다'**
  String get todo_noTodos;

  /// No description provided for @todo_allCompleted.
  ///
  /// In ko, this message translates to:
  /// **'모든 할일을 완료했습니다!'**
  String get todo_allCompleted;

  /// No description provided for @todo_loadError.
  ///
  /// In ko, this message translates to:
  /// **'할일을 불러올 수 없습니다'**
  String get todo_loadError;

  /// No description provided for @todo_noDueDate.
  ///
  /// In ko, this message translates to:
  /// **'마감일 없음'**
  String get todo_noDueDate;

  /// No description provided for @todo_viewKanban.
  ///
  /// In ko, this message translates to:
  /// **'칸반 보드'**
  String get todo_viewKanban;

  /// No description provided for @todo_viewList.
  ///
  /// In ko, this message translates to:
  /// **'리스트 보기'**
  String get todo_viewList;

  /// No description provided for @todo_statusPending.
  ///
  /// In ko, this message translates to:
  /// **'대기중'**
  String get todo_statusPending;

  /// No description provided for @todo_statusInProgress.
  ///
  /// In ko, this message translates to:
  /// **'진행중'**
  String get todo_statusInProgress;

  /// No description provided for @todo_statusCompleted.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get todo_statusCompleted;

  /// No description provided for @todo_statusHold.
  ///
  /// In ko, this message translates to:
  /// **'보류'**
  String get todo_statusHold;

  /// No description provided for @todo_statusDrop.
  ///
  /// In ko, this message translates to:
  /// **'드롭'**
  String get todo_statusDrop;

  /// No description provided for @todo_statusFailed.
  ///
  /// In ko, this message translates to:
  /// **'실패'**
  String get todo_statusFailed;

  /// No description provided for @todo_prevWeek.
  ///
  /// In ko, this message translates to:
  /// **'이전 주'**
  String get todo_prevWeek;

  /// No description provided for @todo_nextWeek.
  ///
  /// In ko, this message translates to:
  /// **'다음 주'**
  String get todo_nextWeek;

  /// No description provided for @todo_changeStatus.
  ///
  /// In ko, this message translates to:
  /// **'상태 변경'**
  String get todo_changeStatus;

  /// No description provided for @todo_viewByDate.
  ///
  /// In ko, this message translates to:
  /// **'날짜별 보기'**
  String get todo_viewByDate;

  /// No description provided for @todo_viewOverview.
  ///
  /// In ko, this message translates to:
  /// **'모아 보기'**
  String get todo_viewOverview;

  /// No description provided for @todo_overviewOverdue.
  ///
  /// In ko, this message translates to:
  /// **'지난 할일'**
  String get todo_overviewOverdue;

  /// No description provided for @todo_overviewToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get todo_overviewToday;

  /// No description provided for @todo_overviewTomorrow.
  ///
  /// In ko, this message translates to:
  /// **'내일'**
  String get todo_overviewTomorrow;

  /// No description provided for @todo_overviewThisWeek.
  ///
  /// In ko, this message translates to:
  /// **'이번 주'**
  String get todo_overviewThisWeek;

  /// No description provided for @todo_overviewNextWeek.
  ///
  /// In ko, this message translates to:
  /// **'다음 주'**
  String get todo_overviewNextWeek;

  /// No description provided for @todo_overviewLater.
  ///
  /// In ko, this message translates to:
  /// **'그 이후'**
  String get todo_overviewLater;

  /// No description provided for @todo_overviewNoDueDate.
  ///
  /// In ko, this message translates to:
  /// **'기한 없음'**
  String get todo_overviewNoDueDate;

  /// No description provided for @todo_filter.
  ///
  /// In ko, this message translates to:
  /// **'필터'**
  String get todo_filter;

  /// No description provided for @todo_filterAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get todo_filterAll;

  /// No description provided for @todo_filterStatus.
  ///
  /// In ko, this message translates to:
  /// **'상태'**
  String get todo_filterStatus;

  /// No description provided for @todo_filterPriority.
  ///
  /// In ko, this message translates to:
  /// **'우선순위'**
  String get todo_filterPriority;

  /// No description provided for @todo_sortBy.
  ///
  /// In ko, this message translates to:
  /// **'정렬'**
  String get todo_sortBy;

  /// No description provided for @todo_sortByStatus.
  ///
  /// In ko, this message translates to:
  /// **'상태순'**
  String get todo_sortByStatus;

  /// No description provided for @todo_sortByPriority.
  ///
  /// In ko, this message translates to:
  /// **'우선순위순'**
  String get todo_sortByPriority;

  /// No description provided for @todo_sortByDueDate.
  ///
  /// In ko, this message translates to:
  /// **'마감일순'**
  String get todo_sortByDueDate;

  /// No description provided for @todo_sortByCreatedAt.
  ///
  /// In ko, this message translates to:
  /// **'생성일순'**
  String get todo_sortByCreatedAt;

  /// No description provided for @todo_filterApplied.
  ///
  /// In ko, this message translates to:
  /// **'필터 적용됨'**
  String get todo_filterApplied;

  /// No description provided for @todo_clearFilter.
  ///
  /// In ko, this message translates to:
  /// **'필터 초기화'**
  String get todo_clearFilter;

  /// No description provided for @todo_filterTooltip.
  ///
  /// In ko, this message translates to:
  /// **'할일 필터'**
  String get todo_filterTooltip;

  /// No description provided for @todo_widgetTitleToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘의 할일'**
  String get todo_widgetTitleToday;

  /// No description provided for @todo_widgetTitleWeek.
  ///
  /// In ko, this message translates to:
  /// **'금주 할일'**
  String get todo_widgetTitleWeek;

  /// No description provided for @todo_widgetTitleMonth.
  ///
  /// In ko, this message translates to:
  /// **'이번달 할일'**
  String get todo_widgetTitleMonth;

  /// No description provided for @todo_emptyToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘 할일이 없습니다'**
  String get todo_emptyToday;

  /// No description provided for @todo_emptyWeek.
  ///
  /// In ko, this message translates to:
  /// **'이번 주 할일이 없습니다'**
  String get todo_emptyWeek;

  /// No description provided for @todo_emptyMonth.
  ///
  /// In ko, this message translates to:
  /// **'이번 달 할일이 없습니다'**
  String get todo_emptyMonth;

  /// No description provided for @todo_searchHint.
  ///
  /// In ko, this message translates to:
  /// **'할일 제목, 설명으로 검색'**
  String get todo_searchHint;

  /// No description provided for @todo_searchNoResults.
  ///
  /// In ko, this message translates to:
  /// **'검색 결과가 없습니다'**
  String get todo_searchNoResults;

  /// No description provided for @todo_searchResultCount.
  ///
  /// In ko, this message translates to:
  /// **'검색 결과 {count}건'**
  String todo_searchResultCount(int count);

  /// No description provided for @memo_title.
  ///
  /// In ko, this message translates to:
  /// **'메모'**
  String get memo_title;

  /// No description provided for @memo_list.
  ///
  /// In ko, this message translates to:
  /// **'메모 목록'**
  String get memo_list;

  /// No description provided for @memo_detail.
  ///
  /// In ko, this message translates to:
  /// **'메모 상세'**
  String get memo_detail;

  /// No description provided for @memo_create.
  ///
  /// In ko, this message translates to:
  /// **'메모 작성'**
  String get memo_create;

  /// No description provided for @memo_edit.
  ///
  /// In ko, this message translates to:
  /// **'메모 수정'**
  String get memo_edit;

  /// No description provided for @memo_delete.
  ///
  /// In ko, this message translates to:
  /// **'메모 삭제'**
  String get memo_delete;

  /// No description provided for @memo_content.
  ///
  /// In ko, this message translates to:
  /// **'내용'**
  String get memo_content;

  /// No description provided for @memo_category.
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get memo_category;

  /// No description provided for @memo_categoryHint.
  ///
  /// In ko, this message translates to:
  /// **'카테고리를 입력하세요 (선택사항)'**
  String get memo_categoryHint;

  /// No description provided for @memo_tags.
  ///
  /// In ko, this message translates to:
  /// **'태그'**
  String get memo_tags;

  /// No description provided for @memo_tagsHint.
  ///
  /// In ko, this message translates to:
  /// **'태그를 추가하세요'**
  String get memo_tagsHint;

  /// No description provided for @memo_author.
  ///
  /// In ko, this message translates to:
  /// **'작성자'**
  String get memo_author;

  /// No description provided for @memo_createdAt.
  ///
  /// In ko, this message translates to:
  /// **'작성일'**
  String get memo_createdAt;

  /// No description provided for @memo_updatedAt.
  ///
  /// In ko, this message translates to:
  /// **'수정일'**
  String get memo_updatedAt;

  /// No description provided for @memo_createSuccess.
  ///
  /// In ko, this message translates to:
  /// **'메모가 작성되었습니다'**
  String get memo_createSuccess;

  /// No description provided for @memo_createError.
  ///
  /// In ko, this message translates to:
  /// **'메모 작성에 실패했습니다'**
  String get memo_createError;

  /// No description provided for @memo_updateSuccess.
  ///
  /// In ko, this message translates to:
  /// **'메모가 수정되었습니다'**
  String get memo_updateSuccess;

  /// No description provided for @memo_updateError.
  ///
  /// In ko, this message translates to:
  /// **'메모 수정에 실패했습니다'**
  String get memo_updateError;

  /// No description provided for @memo_deleteSuccess.
  ///
  /// In ko, this message translates to:
  /// **'메모가 삭제되었습니다'**
  String get memo_deleteSuccess;

  /// No description provided for @memo_deleteError.
  ///
  /// In ko, this message translates to:
  /// **'메모 삭제에 실패했습니다'**
  String get memo_deleteError;

  /// No description provided for @memo_deleteDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'메모 삭제'**
  String get memo_deleteDialogTitle;

  /// No description provided for @memo_deleteDialogMessage.
  ///
  /// In ko, this message translates to:
  /// **'이 메모를 삭제하시겠습니까?\n삭제된 메모는 복구할 수 없습니다.'**
  String get memo_deleteDialogMessage;

  /// No description provided for @memo_loadError.
  ///
  /// In ko, this message translates to:
  /// **'메모를 불러올 수 없습니다'**
  String get memo_loadError;

  /// No description provided for @memo_empty.
  ///
  /// In ko, this message translates to:
  /// **'작성된 메모가 없습니다'**
  String get memo_empty;

  /// No description provided for @memo_titleHint.
  ///
  /// In ko, this message translates to:
  /// **'메모 제목을 입력하세요'**
  String get memo_titleHint;

  /// No description provided for @memo_contentHint.
  ///
  /// In ko, this message translates to:
  /// **'메모 내용을 입력하세요'**
  String get memo_contentHint;

  /// No description provided for @memo_titleRequired.
  ///
  /// In ko, this message translates to:
  /// **'제목을 입력해주세요'**
  String get memo_titleRequired;

  /// No description provided for @memo_titleMinLength.
  ///
  /// In ko, this message translates to:
  /// **'제목은 최소 2자 이상 입력해주세요'**
  String get memo_titleMinLength;

  /// No description provided for @memo_contentRequired.
  ///
  /// In ko, this message translates to:
  /// **'내용을 입력해주세요'**
  String get memo_contentRequired;

  /// No description provided for @memo_searchHint.
  ///
  /// In ko, this message translates to:
  /// **'제목, 내용으로 검색'**
  String get memo_searchHint;

  /// No description provided for @memo_searchNoResults.
  ///
  /// In ko, this message translates to:
  /// **'검색 결과가 없습니다'**
  String get memo_searchNoResults;

  /// No description provided for @memo_tagAdd.
  ///
  /// In ko, this message translates to:
  /// **'태그 추가'**
  String get memo_tagAdd;

  /// No description provided for @memo_tagName.
  ///
  /// In ko, this message translates to:
  /// **'태그 이름'**
  String get memo_tagName;

  /// No description provided for @memo_tagNameHint.
  ///
  /// In ko, this message translates to:
  /// **'태그 이름을 입력하세요'**
  String get memo_tagNameHint;

  /// No description provided for @memo_visibility.
  ///
  /// In ko, this message translates to:
  /// **'공개 범위'**
  String get memo_visibility;

  /// No description provided for @memo_visibilityPrivate.
  ///
  /// In ko, this message translates to:
  /// **'나만 보기'**
  String get memo_visibilityPrivate;

  /// No description provided for @memo_visibilityGroup.
  ///
  /// In ko, this message translates to:
  /// **'특정 그룹'**
  String get memo_visibilityGroup;

  /// No description provided for @memo_groupSelect.
  ///
  /// In ko, this message translates to:
  /// **'그룹 선택'**
  String get memo_groupSelect;

  /// No description provided for @memo_typeNote.
  ///
  /// In ko, this message translates to:
  /// **'일반 메모'**
  String get memo_typeNote;

  /// No description provided for @memo_typeChecklist.
  ///
  /// In ko, this message translates to:
  /// **'체크리스트'**
  String get memo_typeChecklist;

  /// No description provided for @memo_typeSelect.
  ///
  /// In ko, this message translates to:
  /// **'메모 유형'**
  String get memo_typeSelect;

  /// No description provided for @memo_checklist.
  ///
  /// In ko, this message translates to:
  /// **'체크리스트'**
  String get memo_checklist;

  /// No description provided for @memo_checklistAdd.
  ///
  /// In ko, this message translates to:
  /// **'항목 추가'**
  String get memo_checklistAdd;

  /// No description provided for @memo_checklistAddHint.
  ///
  /// In ko, this message translates to:
  /// **'새 항목을 입력하세요'**
  String get memo_checklistAddHint;

  /// No description provided for @memo_checklistEmpty.
  ///
  /// In ko, this message translates to:
  /// **'체크리스트 항목이 없습니다'**
  String get memo_checklistEmpty;

  /// No description provided for @memo_checklistReset.
  ///
  /// In ko, this message translates to:
  /// **'전체 해제'**
  String get memo_checklistReset;

  /// No description provided for @memo_checklistSelectAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 선택'**
  String get memo_checklistSelectAll;

  /// No description provided for @memo_checklistDeleteItem.
  ///
  /// In ko, this message translates to:
  /// **'항목 삭제'**
  String get memo_checklistDeleteItem;

  /// No description provided for @memo_checklistEditItem.
  ///
  /// In ko, this message translates to:
  /// **'항목 수정'**
  String get memo_checklistEditItem;

  /// No description provided for @memo_checklistProgress.
  ///
  /// In ko, this message translates to:
  /// **'{checked}/{total} 완료'**
  String memo_checklistProgress(int checked, int total);

  /// 가계부 메인 타이틀
  ///
  /// In ko, this message translates to:
  /// **'가계부'**
  String get household_title;

  /// 지출 유형 레이블
  ///
  /// In ko, this message translates to:
  /// **'지출'**
  String get household_expense;

  /// 그룹 미선택 안내
  ///
  /// In ko, this message translates to:
  /// **'그룹을 선택해주세요'**
  String get household_no_group_selected;

  /// 개인 모드 라벨
  ///
  /// In ko, this message translates to:
  /// **'개인'**
  String get household_personal_mode;

  /// 지출 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'지출 추가'**
  String get household_add_expense;

  /// 연결된 장보기 기록으로 이동
  ///
  /// In ko, this message translates to:
  /// **'장보기 기록 보기'**
  String get household_view_shopping_history;

  /// 지출 수정 버튼
  ///
  /// In ko, this message translates to:
  /// **'지출 수정'**
  String get household_edit_expense;

  /// 지출 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'지출 삭제'**
  String get household_delete_expense;

  /// 지출 삭제 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'지출을 삭제하시겠습니까?'**
  String get household_delete_confirm;

  /// 금액 레이블
  ///
  /// In ko, this message translates to:
  /// **'금액'**
  String get household_amount;

  /// 카테고리 레이블
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get household_category;

  /// 결제 수단 레이블
  ///
  /// In ko, this message translates to:
  /// **'결제 수단'**
  String get household_payment_method;

  /// 내용 레이블
  ///
  /// In ko, this message translates to:
  /// **'내용'**
  String get household_description;

  /// 날짜 레이블
  ///
  /// In ko, this message translates to:
  /// **'날짜'**
  String get household_date;

  /// 고정 지출 레이블
  ///
  /// In ko, this message translates to:
  /// **'고정 지출'**
  String get household_recurring;

  /// 총 입금 레이블
  ///
  /// In ko, this message translates to:
  /// **'총 입금'**
  String get household_total_income;

  /// 총 지출 레이블
  ///
  /// In ko, this message translates to:
  /// **'총 지출'**
  String get household_total_expense;

  /// 잔액 (입금 - 지출)
  ///
  /// In ko, this message translates to:
  /// **'잔액'**
  String get household_balance;

  /// 입금 유형 레이블
  ///
  /// In ko, this message translates to:
  /// **'입금'**
  String get household_income;

  /// 거래 유형 레이블
  ///
  /// In ko, this message translates to:
  /// **'유형'**
  String get household_type;

  /// 총 예산 레이블
  ///
  /// In ko, this message translates to:
  /// **'총 예산'**
  String get household_total_budget;

  /// 통계 탭
  ///
  /// In ko, this message translates to:
  /// **'통계'**
  String get household_statistics;

  /// 월간 통계 타이틀
  ///
  /// In ko, this message translates to:
  /// **'월간 통계'**
  String get household_monthly_statistics;

  /// 지출 없음 안내
  ///
  /// In ko, this message translates to:
  /// **'지출 내역이 없습니다'**
  String get household_no_expenses;

  /// 카테고리: 식비
  ///
  /// In ko, this message translates to:
  /// **'식비'**
  String get household_category_food;

  /// 카테고리: 교통비
  ///
  /// In ko, this message translates to:
  /// **'교통비'**
  String get household_category_transport;

  /// 카테고리: 여가비
  ///
  /// In ko, this message translates to:
  /// **'여가비'**
  String get household_category_leisure;

  /// 카테고리: 생활비
  ///
  /// In ko, this message translates to:
  /// **'생활비'**
  String get household_category_living;

  /// 카테고리: 의료비
  ///
  /// In ko, this message translates to:
  /// **'의료비'**
  String get household_category_health;

  /// 카테고리: 교육비
  ///
  /// In ko, this message translates to:
  /// **'교육비'**
  String get household_category_education;

  /// 카테고리: 의류비
  ///
  /// In ko, this message translates to:
  /// **'의류비'**
  String get household_category_clothing;

  /// 카테고리: 용돈
  ///
  /// In ko, this message translates to:
  /// **'용돈'**
  String get household_category_allowance;

  /// 카테고리: 경조사비
  ///
  /// In ko, this message translates to:
  /// **'경조사비'**
  String get household_category_celebration;

  /// 카테고리: 자산이동
  ///
  /// In ko, this message translates to:
  /// **'자산이동'**
  String get household_category_asset_transfer;

  /// 카테고리: 육아비
  ///
  /// In ko, this message translates to:
  /// **'육아비'**
  String get household_category_childcare;

  /// 카테고리: 통신비
  ///
  /// In ko, this message translates to:
  /// **'통신비'**
  String get household_category_communication;

  /// 카테고리: 장보기
  ///
  /// In ko, this message translates to:
  /// **'장보기'**
  String get household_category_groceries;

  /// 카테고리: 기타
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get household_category_other;

  /// 결제수단: 현금
  ///
  /// In ko, this message translates to:
  /// **'현금'**
  String get household_payment_cash;

  /// 결제수단: 카드
  ///
  /// In ko, this message translates to:
  /// **'카드'**
  String get household_payment_card;

  /// 결제수단: 이체
  ///
  /// In ko, this message translates to:
  /// **'이체'**
  String get household_payment_transfer;

  /// 결제수단: 기타
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get household_payment_other;

  /// 예산 설정 타이틀
  ///
  /// In ko, this message translates to:
  /// **'예산 설정'**
  String get household_budget_settings;

  /// 예산 금액 레이블
  ///
  /// In ko, this message translates to:
  /// **'예산 금액'**
  String get household_budget_amount;

  /// 예산 설정 버튼
  ///
  /// In ko, this message translates to:
  /// **'예산 설정'**
  String get household_set_budget;

  /// 금액 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'금액을 입력하세요'**
  String get household_amount_hint;

  /// 내용 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'내용을 입력하세요'**
  String get household_description_hint;

  /// 금액 필수 유효성 메시지
  ///
  /// In ko, this message translates to:
  /// **'금액을 입력해주세요'**
  String get household_amount_required;

  /// 저장 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'저장되었습니다'**
  String get household_save_success;

  /// 삭제 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'삭제되었습니다'**
  String get household_delete_success;

  /// 예산 설정 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'예산이 설정되었습니다'**
  String get household_budget_saved;

  /// 고정 지출 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'고정 지출'**
  String get household_recurring_expenses;

  /// 고정 지출 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'고정 지출이 없습니다'**
  String get household_recurring_no_expenses;

  /// 고정 지출 월 합계 레이블
  ///
  /// In ko, this message translates to:
  /// **'월 합계'**
  String get household_recurring_total;

  /// 고정 지출 항목 수 레이블
  ///
  /// In ko, this message translates to:
  /// **'항목 수'**
  String get household_recurring_count;

  /// 고정 지출 항목 수 단위
  ///
  /// In ko, this message translates to:
  /// **'{count}건'**
  String household_recurring_count_unit(int count);

  /// 고정 지출 카테고리별 분포 레이블
  ///
  /// In ko, this message translates to:
  /// **'카테고리별 분포'**
  String get household_recurring_top_category;

  /// 소비처 관리 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'소비처 관리'**
  String get household_merchants;

  /// 내 소비처 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'내 소비처'**
  String get household_merchants_my;

  /// 샘플 소비처 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'자주 쓰는 소비처'**
  String get household_merchants_samples;

  /// 소비처 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'등록된 소비처가 없습니다'**
  String get household_merchants_empty;

  /// 소비처 추가 시트 제목
  ///
  /// In ko, this message translates to:
  /// **'소비처 추가'**
  String get household_merchants_add;

  /// 소비처 수정 시트 제목
  ///
  /// In ko, this message translates to:
  /// **'소비처 수정'**
  String get household_merchants_edit;

  /// 소비처 이름 입력 레이블
  ///
  /// In ko, this message translates to:
  /// **'소비처 이름'**
  String get household_merchants_name;

  /// 소비처 삭제 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'소비처 삭제'**
  String get household_merchants_delete;

  /// 소비처 삭제 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'\"{name}\" 소비처를 삭제할까요?'**
  String household_merchants_delete_confirm(String name);

  /// 지출 폼 소비처 선택 레이블
  ///
  /// In ko, this message translates to:
  /// **'소비처 선택'**
  String get household_merchant_select;

  /// 소비처 없음 옵션
  ///
  /// In ko, this message translates to:
  /// **'없음'**
  String get household_merchant_none;

  /// 예산 설정 버튼/제목
  ///
  /// In ko, this message translates to:
  /// **'예산 설정'**
  String get household_budget_set;

  /// 전체 예산 항목 레이블
  ///
  /// In ko, this message translates to:
  /// **'전체 예산'**
  String get household_budget_total_label;

  /// 카테고리별 예산 섹션 레이블
  ///
  /// In ko, this message translates to:
  /// **'카테고리별 예산'**
  String get household_budget_category_label;

  /// 예산 미설정 상태 표시
  ///
  /// In ko, this message translates to:
  /// **'미설정'**
  String get household_budget_not_set;

  /// 이번 달 예산 탭 레이블
  ///
  /// In ko, this message translates to:
  /// **'이번 달 예산'**
  String get household_budget_tab_monthly;

  /// 매월 자동 예산 탭 레이블
  ///
  /// In ko, this message translates to:
  /// **'매월 자동 예산'**
  String get household_budget_tab_template;

  /// 예산 템플릿 안내 문구
  ///
  /// In ko, this message translates to:
  /// **'매월 1일에 템플릿 기반으로 예산이 자동 설정됩니다. 해당 월에 이미 예산이 있으면 건너뜁니다.'**
  String get household_budget_template_info;

  /// 예산 템플릿 저장 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'자동 예산 템플릿이 설정되었습니다'**
  String get household_budget_template_saved;

  /// 예산 템플릿 삭제 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'템플릿 삭제'**
  String get household_budget_template_delete_title;

  /// 예산 템플릿 삭제 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'이 카테고리의 자동 예산 템플릿을 삭제하시겠습니까?'**
  String get household_budget_template_delete_confirm;

  /// 예산 템플릿 삭제 완료 메시지
  ///
  /// In ko, this message translates to:
  /// **'자동 예산 템플릿이 삭제되었습니다'**
  String get household_budget_template_deleted;

  /// 카테고리 예산 합계가 전체 예산 초과 경고
  ///
  /// In ko, this message translates to:
  /// **'카테고리 예산 합계(₩{sum})가 전체 예산(₩{total})을 초과합니다'**
  String household_budget_category_sum_exceeds(String sum, String total);

  /// 카테고리 예산 합계 표시
  ///
  /// In ko, this message translates to:
  /// **'합계 ₩{amount}'**
  String household_budget_category_sum(String amount);

  /// 자산관리 메인 제목
  ///
  /// In ko, this message translates to:
  /// **'자산관리'**
  String get asset_title;

  /// 자산 통계 버튼
  ///
  /// In ko, this message translates to:
  /// **'통계'**
  String get asset_statistics;

  /// 그룹 미선택 안내
  ///
  /// In ko, this message translates to:
  /// **'그룹을 선택해주세요'**
  String get asset_no_group_selected;

  /// 계좌 없음 안내
  ///
  /// In ko, this message translates to:
  /// **'등록된 계좌가 없습니다'**
  String get asset_no_accounts;

  /// 총 잔액 레이블
  ///
  /// In ko, this message translates to:
  /// **'총 잔액'**
  String get asset_total_balance;

  /// 총 원금 레이블
  ///
  /// In ko, this message translates to:
  /// **'총 원금'**
  String get asset_total_principal;

  /// 총 수익금 레이블
  ///
  /// In ko, this message translates to:
  /// **'총 수익금'**
  String get asset_total_profit;

  /// 수익률 레이블
  ///
  /// In ko, this message translates to:
  /// **'수익률'**
  String get asset_profit_rate;

  /// 계좌명 레이블
  ///
  /// In ko, this message translates to:
  /// **'계좌명'**
  String get asset_account_name;

  /// 계좌명 힌트
  ///
  /// In ko, this message translates to:
  /// **'예) 주택청약'**
  String get asset_account_name_hint;

  /// 계좌명 필수
  ///
  /// In ko, this message translates to:
  /// **'계좌명을 입력해주세요'**
  String get asset_account_name_required;

  /// 금융기관명 레이블
  ///
  /// In ko, this message translates to:
  /// **'금융기관'**
  String get asset_institution;

  /// 금융기관 힌트
  ///
  /// In ko, this message translates to:
  /// **'예) 국민은행'**
  String get asset_institution_hint;

  /// 금융기관 필수
  ///
  /// In ko, this message translates to:
  /// **'금융기관명을 입력해주세요'**
  String get asset_institution_required;

  /// 계좌번호 레이블
  ///
  /// In ko, this message translates to:
  /// **'계좌번호 (선택)'**
  String get asset_account_number;

  /// 계좌번호 힌트
  ///
  /// In ko, this message translates to:
  /// **'예) 123-456-789'**
  String get asset_account_number_hint;

  /// 계좌 유형 레이블
  ///
  /// In ko, this message translates to:
  /// **'계좌 유형'**
  String get asset_account_type;

  /// 계좌 유형: 적금
  ///
  /// In ko, this message translates to:
  /// **'적금'**
  String get asset_type_savings;

  /// 계좌 유형: 예금
  ///
  /// In ko, this message translates to:
  /// **'예금'**
  String get asset_type_deposit;

  /// 계좌 유형: 주식
  ///
  /// In ko, this message translates to:
  /// **'주식'**
  String get asset_type_stock;

  /// 계좌 유형: 펀드
  ///
  /// In ko, this message translates to:
  /// **'펀드'**
  String get asset_type_fund;

  /// 계좌 유형: 부동산
  ///
  /// In ko, this message translates to:
  /// **'부동산'**
  String get asset_type_real_estate;

  /// 계좌 유형: 실물 금
  ///
  /// In ko, this message translates to:
  /// **'실물 금'**
  String get asset_type_gold;

  /// 계좌 유형: 기타
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get asset_type_other;

  /// 금 보유 중량 입력 레이블
  ///
  /// In ko, this message translates to:
  /// **'보유 중량'**
  String get asset_gold_gram_weight;

  /// 금 보유 그램 수 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 37.5'**
  String get asset_gold_gram_weight_hint;

  /// 금 중량 단위: 그램
  ///
  /// In ko, this message translates to:
  /// **'g (그램)'**
  String get asset_gold_unit_gram;

  /// 금 중량 단위: 돈
  ///
  /// In ko, this message translates to:
  /// **'돈'**
  String get asset_gold_unit_don;

  /// 금 돈 수 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 10'**
  String get asset_gold_don_hint;

  /// 돈 → 그램 환산 표시 레이블
  ///
  /// In ko, this message translates to:
  /// **'g 환산'**
  String get asset_gold_gram_converted;

  /// 금 예상 원금 레이블
  ///
  /// In ko, this message translates to:
  /// **'예상 원금'**
  String get asset_gold_estimated_principal;

  /// 금 중량 필수 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'보유 중량을 입력해 주세요'**
  String get asset_gold_gram_weight_required;

  /// 금 중량 형식 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'유효한 숫자를 입력해 주세요'**
  String get asset_gold_gram_weight_invalid;

  /// 금 시세 조회 레이블
  ///
  /// In ko, this message translates to:
  /// **'현재 금 시세'**
  String get asset_gold_current_price_label;

  /// 금 시세 로딩 메시지
  ///
  /// In ko, this message translates to:
  /// **'금 시세 조회 중…'**
  String get asset_gold_price_loading;

  /// 금 시세 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'금 시세를 불러올 수 없습니다'**
  String get asset_gold_price_error;

  /// 계좌 추가 제목
  ///
  /// In ko, this message translates to:
  /// **'계좌 추가'**
  String get asset_add_account;

  /// 계좌 수정 제목
  ///
  /// In ko, this message translates to:
  /// **'계좌 수정'**
  String get asset_edit_account;

  /// 계좌 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'계좌 삭제'**
  String get asset_delete_account;

  /// 계좌 삭제 확인
  ///
  /// In ko, this message translates to:
  /// **'이 계좌를 삭제하시겠습니까?\n관련된 모든 기록도 함께 삭제됩니다.'**
  String get asset_delete_account_confirm;

  /// 삭제 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'삭제되었습니다'**
  String get asset_delete_success;

  /// 저장 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'저장되었습니다'**
  String get asset_save_success;

  /// 계좌 상세 제목
  ///
  /// In ko, this message translates to:
  /// **'계좌 상세'**
  String get asset_account_detail;

  /// 자산 기록 제목
  ///
  /// In ko, this message translates to:
  /// **'자산 기록'**
  String get asset_records;

  /// 포트폴리오 비중 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'포트폴리오 비중'**
  String get asset_holdings;

  /// 종목 없음 안내
  ///
  /// In ko, this message translates to:
  /// **'등록된 종목이 없습니다'**
  String get asset_holdings_empty;

  /// 종목 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'종목 추가'**
  String get asset_holding_add;

  /// 종목 수정 버튼
  ///
  /// In ko, this message translates to:
  /// **'종목 수정'**
  String get asset_holding_edit;

  /// 종목 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'종목 삭제'**
  String get asset_holding_delete;

  /// 종목명 입력 레이블
  ///
  /// In ko, this message translates to:
  /// **'종목명'**
  String get asset_holding_name;

  /// 종목명 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 나스닥 ETF'**
  String get asset_holding_name_hint;

  /// 종목명 필수 오류
  ///
  /// In ko, this message translates to:
  /// **'종목명을 입력해 주세요'**
  String get asset_holding_name_required;

  /// 티커 심볼 입력 레이블
  ///
  /// In ko, this message translates to:
  /// **'티커 (선택)'**
  String get asset_holding_ticker;

  /// 티커 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: QQQ'**
  String get asset_holding_ticker_hint;

  /// 비율 입력 레이블
  ///
  /// In ko, this message translates to:
  /// **'비율 (%)'**
  String get asset_holding_ratio;

  /// 비율 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 40'**
  String get asset_holding_ratio_hint;

  /// 비율 필수 오류
  ///
  /// In ko, this message translates to:
  /// **'비율을 입력해 주세요'**
  String get asset_holding_ratio_required;

  /// 비율 범위 오류
  ///
  /// In ko, this message translates to:
  /// **'0.01 ~ 100 사이의 숫자를 입력해 주세요'**
  String get asset_holding_ratio_invalid;

  /// 비율 초과 오류
  ///
  /// In ko, this message translates to:
  /// **'비율 합계가 100%를 초과합니다'**
  String get asset_holding_ratio_exceeded;

  /// 종목 삭제 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'이 종목을 삭제하시겠습니까?'**
  String get asset_holding_delete_confirm;

  /// 비율 합계 레이블
  ///
  /// In ko, this message translates to:
  /// **'합계'**
  String get asset_holding_total_ratio;

  /// 금 계좌 안내 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'금 계좌 자동 관리 안내'**
  String get asset_gold_record_info_title;

  /// 금 계좌 안내 다이얼로그 본문
  ///
  /// In ko, this message translates to:
  /// **'이 계좌는 실물 금(現物金) 계좌로, 아래와 같이 자동 관리됩니다.\n\n• 기록 추가 시 현재 금 현물 시세(GOLD_KRW_SPOT)를 기준으로 보유 중량 × 시세 = 잔액이 자동 계산됩니다.\n\n• 매달 1일, 최신 금 현물 시세를 반영하여 잔액·수익금·수익률이 자동으로 갱신됩니다.\n\n• 원금은 직접 수정할 수 있으며, 수정하지 않으면 처음 기록 시 계산된 값이 유지됩니다.'**
  String get asset_gold_record_info_body;

  /// 기록 없음 안내
  ///
  /// In ko, this message translates to:
  /// **'기록이 없습니다'**
  String get asset_no_records;

  /// 기록 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'기록 추가'**
  String get asset_add_record;

  /// 기록 날짜 레이블
  ///
  /// In ko, this message translates to:
  /// **'기록 날짜'**
  String get asset_record_date;

  /// 잔액 레이블
  ///
  /// In ko, this message translates to:
  /// **'잔액'**
  String get asset_balance;

  /// 원금 레이블
  ///
  /// In ko, this message translates to:
  /// **'원금'**
  String get asset_principal;

  /// 수익금 레이블
  ///
  /// In ko, this message translates to:
  /// **'수익금'**
  String get asset_profit;

  /// 메모 레이블
  ///
  /// In ko, this message translates to:
  /// **'메모 (선택)'**
  String get asset_note;

  /// 메모 힌트
  ///
  /// In ko, this message translates to:
  /// **'예) 이자 입금'**
  String get asset_note_hint;

  /// 금액 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'금액을 입력하세요'**
  String get asset_amount_hint;

  /// 금액 필수
  ///
  /// In ko, this message translates to:
  /// **'금액을 입력해주세요'**
  String get asset_amount_required;

  /// 기록 날짜 필수
  ///
  /// In ko, this message translates to:
  /// **'기록 날짜를 선택해주세요'**
  String get asset_record_date_required;

  /// 기록 저장 성공
  ///
  /// In ko, this message translates to:
  /// **'기록이 저장되었습니다'**
  String get asset_record_save_success;

  /// 자산 통계 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'자산 통계'**
  String get asset_statistics_title;

  /// 유형별 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'유형별 현황'**
  String get asset_by_type;

  /// No description provided for @asset_account_count.
  ///
  /// In ko, this message translates to:
  /// **'{count}개 계좌'**
  String asset_account_count(int count);

  /// 자산 통계 - 저금통 합계 레이블
  ///
  /// In ko, this message translates to:
  /// **'저금통 합계'**
  String get asset_savings_total;

  /// 자산 통계 - 연동된 저금통 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'연동된 저금통'**
  String get asset_savings_goals;

  /// 자산 추이 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'자산 추이'**
  String get asset_trend;

  /// 월별 추이
  ///
  /// In ko, this message translates to:
  /// **'월별'**
  String get asset_trend_monthly;

  /// 연도별 추이
  ///
  /// In ko, this message translates to:
  /// **'연도별'**
  String get asset_trend_yearly;

  /// 추이 차트 - 잔액 탭
  ///
  /// In ko, this message translates to:
  /// **'잔액'**
  String get asset_trend_balance;

  /// 추이 차트 - 누적 수익률 탭
  ///
  /// In ko, this message translates to:
  /// **'누적 수익률'**
  String get asset_trend_profit_rate;

  /// 추이 차트 - 기간별 수익률 탭 (전월/전년 대비)
  ///
  /// In ko, this message translates to:
  /// **'기간 수익률'**
  String get asset_trend_period_return;

  /// 추이 데이터 없음
  ///
  /// In ko, this message translates to:
  /// **'표시할 데이터가 없습니다'**
  String get asset_trend_no_data;

  /// 연도 레이블
  ///
  /// In ko, this message translates to:
  /// **'{year}년'**
  String asset_trend_year_label(String year);

  /// 자산 기록 입력 방식 레이블
  ///
  /// In ko, this message translates to:
  /// **'입력 방식'**
  String get asset_input_mode;

  /// 직접 입력 방식
  ///
  /// In ko, this message translates to:
  /// **'직접 입력'**
  String get asset_input_mode_manual;

  /// 자동 계산 방식
  ///
  /// In ko, this message translates to:
  /// **'자동 계산'**
  String get asset_input_mode_auto;

  /// 자동 계산 - 추가 원금 레이블
  ///
  /// In ko, this message translates to:
  /// **'추가 원금'**
  String get asset_additional_principal;

  /// 추가 원금 힌트
  ///
  /// In ko, this message translates to:
  /// **'첫 기록이면 초기 원금 전체를 입력하세요'**
  String get asset_additional_principal_hint;

  /// 자동 계산 - 현재 잔액 레이블
  ///
  /// In ko, this message translates to:
  /// **'현재 잔액'**
  String get asset_current_balance;

  /// 중복 날짜 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'해당 날짜에 이미 기록이 존재합니다'**
  String get asset_duplicate_date_error;

  /// 기록 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'기록 삭제'**
  String get asset_delete_record;

  /// 기록 삭제 확인
  ///
  /// In ko, this message translates to:
  /// **'이 기록을 삭제하시겠습니까?'**
  String get asset_delete_record_confirm;

  /// 통계 화면 계좌 필터 레이블
  ///
  /// In ko, this message translates to:
  /// **'계좌 필터'**
  String get asset_stat_account_filter;

  /// 통계 화면 전체 선택 칩
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get asset_stat_filter_all;

  /// 추이 차트 - 원금 탭
  ///
  /// In ko, this message translates to:
  /// **'원금'**
  String get asset_trend_principal;

  /// 추이 차트 - 수익금 탭
  ///
  /// In ko, this message translates to:
  /// **'수익금'**
  String get asset_trend_profit;

  /// 육아포인트 메인 타이틀
  ///
  /// In ko, this message translates to:
  /// **'육아포인트'**
  String get childcare_title;

  /// 자녀 계정 목록
  ///
  /// In ko, this message translates to:
  /// **'자녀 계정'**
  String get childcare_accounts;

  /// 계정 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'계정 추가'**
  String get childcare_add_account;

  /// 포인트 잔액
  ///
  /// In ko, this message translates to:
  /// **'포인트 잔액'**
  String get childcare_balance;

  /// 월 용돈 포인트
  ///
  /// In ko, this message translates to:
  /// **'월 용돈'**
  String get childcare_monthly_allowance;

  /// 적금 잔액
  ///
  /// In ko, this message translates to:
  /// **'적금 잔액'**
  String get childcare_savings_balance;

  /// 적금 이자율
  ///
  /// In ko, this message translates to:
  /// **'적금 이자율'**
  String get childcare_savings_interest_rate;

  /// 포인트 탭
  ///
  /// In ko, this message translates to:
  /// **'포인트'**
  String get childcare_tab_points;

  /// 포인트 상점 탭
  ///
  /// In ko, this message translates to:
  /// **'상점'**
  String get childcare_tab_rewards;

  /// 규칙 탭
  ///
  /// In ko, this message translates to:
  /// **'규칙'**
  String get childcare_tab_rules;

  /// 히스토리 탭
  ///
  /// In ko, this message translates to:
  /// **'히스토리'**
  String get childcare_tab_history;

  /// 포인트 거래 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'포인트 지급/차감'**
  String get childcare_add_transaction;

  /// 보상 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'보상 추가'**
  String get childcare_add_reward;

  /// 규칙 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'규칙 추가'**
  String get childcare_add_rule;

  /// 적립 거래 유형
  ///
  /// In ko, this message translates to:
  /// **'포인트 적립'**
  String get childcare_transaction_type_earn;

  /// 사용 거래 유형
  ///
  /// In ko, this message translates to:
  /// **'포인트 사용'**
  String get childcare_transaction_type_spend;

  /// 페널티 거래 유형
  ///
  /// In ko, this message translates to:
  /// **'규칙 위반 차감'**
  String get childcare_transaction_type_penalty;

  /// 월 용돈 거래 유형
  ///
  /// In ko, this message translates to:
  /// **'월 용돈 지급'**
  String get childcare_transaction_type_monthly;

  /// 적금 입금 유형
  ///
  /// In ko, this message translates to:
  /// **'적금 입금'**
  String get childcare_transaction_type_savings_deposit;

  /// 적금 출금 유형
  ///
  /// In ko, this message translates to:
  /// **'적금 출금'**
  String get childcare_transaction_type_savings_withdraw;

  /// 이자 지급 유형
  ///
  /// In ko, this message translates to:
  /// **'이자 지급'**
  String get childcare_transaction_type_interest;

  /// 보상 포인트 비용
  ///
  /// In ko, this message translates to:
  /// **'{points}포인트'**
  String childcare_reward_points_cost(int points);

  /// 규칙 위반 차감 포인트
  ///
  /// In ko, this message translates to:
  /// **'차감 {penalty}포인트'**
  String childcare_rule_penalty(int penalty);

  /// 적금 입금 버튼
  ///
  /// In ko, this message translates to:
  /// **'적금 입금'**
  String get childcare_savings_deposit;

  /// 적금 출금 버튼
  ///
  /// In ko, this message translates to:
  /// **'적금 출금'**
  String get childcare_savings_withdraw;

  /// 계정 빈 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'자녀 계정이 없습니다.\n계정을 추가해보세요.'**
  String get childcare_empty_accounts;

  /// 거래 내역 빈 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'거래 내역이 없습니다.'**
  String get childcare_empty_transactions;

  /// 보상 빈 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'보상 항목이 없습니다.\n보상을 추가해보세요.'**
  String get childcare_empty_rewards;

  /// 규칙 빈 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'규칙이 없습니다.\n규칙을 추가해보세요.'**
  String get childcare_empty_rules;

  /// 자녀 ID 라벨
  ///
  /// In ko, this message translates to:
  /// **'자녀 ID'**
  String get childcare_account_child_id;

  /// 월 용돈 포인트 라벨
  ///
  /// In ko, this message translates to:
  /// **'월 용돈 포인트'**
  String get childcare_account_monthly_allowance;

  /// 이자율 라벨
  ///
  /// In ko, this message translates to:
  /// **'적금 이자율 (%)'**
  String get childcare_account_savings_rate;

  /// 거래 금액 라벨
  ///
  /// In ko, this message translates to:
  /// **'포인트 금액'**
  String get childcare_transaction_amount;

  /// 거래 설명 라벨
  ///
  /// In ko, this message translates to:
  /// **'설명'**
  String get childcare_transaction_description;

  /// 거래 유형 라벨
  ///
  /// In ko, this message translates to:
  /// **'거래 유형'**
  String get childcare_transaction_type;

  /// 보상 이름 라벨
  ///
  /// In ko, this message translates to:
  /// **'보상 이름'**
  String get childcare_reward_name;

  /// 보상 설명 라벨
  ///
  /// In ko, this message translates to:
  /// **'보상 설명 (선택)'**
  String get childcare_reward_description;

  /// 보상 포인트 비용 라벨
  ///
  /// In ko, this message translates to:
  /// **'포인트 비용'**
  String get childcare_reward_points;

  /// 규칙 이름 라벨
  ///
  /// In ko, this message translates to:
  /// **'규칙 이름'**
  String get childcare_rule_name;

  /// 규칙 설명 라벨
  ///
  /// In ko, this message translates to:
  /// **'규칙 설명 (선택)'**
  String get childcare_rule_description;

  /// 차감 포인트 라벨
  ///
  /// In ko, this message translates to:
  /// **'차감 포인트'**
  String get childcare_rule_penalty_points;

  /// 적금 금액 라벨
  ///
  /// In ko, this message translates to:
  /// **'금액'**
  String get childcare_savings_amount;

  /// 삭제 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'삭제하시겠습니까?'**
  String get childcare_delete_confirm;

  /// 그룹 선택 안내
  ///
  /// In ko, this message translates to:
  /// **'그룹을 선택해주세요'**
  String get childcare_select_group;

  /// 그룹 없음 안내
  ///
  /// In ko, this message translates to:
  /// **'그룹에 참여하면 육아포인트를 사용할 수 있습니다.'**
  String get childcare_no_group;

  /// 자녀 프로필 없음 안내
  ///
  /// In ko, this message translates to:
  /// **'등록된 자녀가 없습니다.\n오른쪽 상단 버튼으로 자녀를 등록해보세요.'**
  String get childcare_no_child;

  /// 가계부 설정 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'가계부 설정'**
  String get household_settings_title;

  /// 대표 그룹 섹션 헤더
  ///
  /// In ko, this message translates to:
  /// **'대표 그룹'**
  String get household_settings_group_section;

  /// 자동 등록 섹션 헤더
  ///
  /// In ko, this message translates to:
  /// **'푸시 자동 등록'**
  String get household_settings_auto_section;

  /// 자동 등록 토글 제목
  ///
  /// In ko, this message translates to:
  /// **'결제 알림 자동 등록'**
  String get household_settings_auto_toggle;

  /// 자동 등록 토글 설명
  ///
  /// In ko, this message translates to:
  /// **'카드·은행 결제 알림을 감지해 가계부에 자동으로 기록합니다'**
  String get household_settings_auto_toggle_desc;

  /// 알림 권한 미허용 안내
  ///
  /// In ko, this message translates to:
  /// **'알림 접근 권한이 필요합니다. \'허용\'을 눌러 설정 화면에서 권한을 부여해주세요.'**
  String get household_settings_permission_required;

  /// 권한 허용 버튼
  ///
  /// In ko, this message translates to:
  /// **'허용'**
  String get household_settings_permission_grant;

  /// 개인정보 섹션 헤더
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get household_settings_privacy_section;

  /// 개인정보 타일 제목
  ///
  /// In ko, this message translates to:
  /// **'수집 정보 및 처리 방침 확인'**
  String get household_settings_privacy_title;

  /// 개인정보 타일 부제목
  ///
  /// In ko, this message translates to:
  /// **'푸시 자동 등록 기능이 수집하는 정보를 확인합니다'**
  String get household_settings_privacy_subtitle;

  /// 개인정보 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get household_settings_privacy_dialog_title;

  /// 자동 등록 동작 범위 안내
  ///
  /// In ko, this message translates to:
  /// **'앱이 실행 중(포그라운드·백그라운드)일 때만 동작합니다. 앱을 완전히 종료하면 자동 등록이 중단됩니다.'**
  String get household_settings_auto_scope_notice;

  /// 개인정보 처리방침 전문
  ///
  /// In ko, this message translates to:
  /// **'■ 수집하는 정보\n앱은 기기에 표시되는 알림 중 카드사·은행 앱에서 발송된 결제 완료 알림의 아래 정보를 일시적으로 읽습니다.\n  · 알림 제목 및 본문 텍스트 (예: \"KB카드 12,000원 승인\")\n  · 알림을 보낸 앱 패키지명 (예: com.kbcard.kbkookmincard)\n\n■ 수집 목적\n읽은 알림 텍스트에서 결제 금액·결제 수단·카테고리를 추출하여 가계부에 자동으로 기록하는 데에만 사용됩니다.\n\n■ 보관 및 파기\n알림 텍스트는 기기 내에서 즉시 파싱 후 파기되며, 원문은 서버로 전송되거나 저장되지 않습니다. 가계부 항목으로 변환된 데이터만 회원 계정에 저장됩니다.\n\n■ 제3자 제공\n수집한 알림 정보는 어떠한 제3자에게도 제공·판매·공유되지 않습니다.\n\n■ 권한 철회\n언제든지 본 설정 화면에서 자동 등록을 끄거나, 기기 설정 > 알림 접근 권한에서 Family Planner의 권한을 해제할 수 있습니다.'**
  String get household_settings_privacy_content;

  /// 냉장고 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'냉장고'**
  String get fridge_title;

  /// 장보기 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'장보기'**
  String get shopping_title;

  /// 냉장고 탭
  ///
  /// In ko, this message translates to:
  /// **'냉장고'**
  String get fridge_tab_fridge;

  /// 장바구니 탭
  ///
  /// In ko, this message translates to:
  /// **'장바구니'**
  String get fridge_tab_cart;

  /// 자주 사는 항목 탭
  ///
  /// In ko, this message translates to:
  /// **'자주 사는 것'**
  String get fridge_tab_frequent;

  /// 구매 이력 탭
  ///
  /// In ko, this message translates to:
  /// **'구매 이력'**
  String get fridge_tab_history;

  /// 보관소 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'보관소 추가'**
  String get fridge_storage_add;

  /// 보관소 수정
  ///
  /// In ko, this message translates to:
  /// **'보관소 수정'**
  String get fridge_storage_edit;

  /// 보관소 삭제
  ///
  /// In ko, this message translates to:
  /// **'보관소 삭제'**
  String get fridge_storage_delete;

  /// 보관소 삭제 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'보관소를 삭제하면 안에 있는 모든 품목도 함께 삭제됩니다. 계속하시겠습니까?'**
  String get fridge_storage_delete_confirm;

  /// 보관소 이름 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 우리집 냉장고'**
  String get fridge_storage_name_hint;

  /// 냉장 타입
  ///
  /// In ko, this message translates to:
  /// **'냉장'**
  String get fridge_storage_type_fridge;

  /// 냉동 타입
  ///
  /// In ko, this message translates to:
  /// **'냉동'**
  String get fridge_storage_type_freezer;

  /// 팬트리 타입
  ///
  /// In ko, this message translates to:
  /// **'팬트리'**
  String get fridge_storage_type_pantry;

  /// 품목 추가
  ///
  /// In ko, this message translates to:
  /// **'품목 추가'**
  String get fridge_item_add;

  /// 품목 수정
  ///
  /// In ko, this message translates to:
  /// **'품목 수정'**
  String get fridge_item_edit;

  /// 품목 삭제 확인 제목
  ///
  /// In ko, this message translates to:
  /// **'품목 삭제'**
  String get fridge_item_delete_title;

  /// 품목 삭제 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'{name}을(를) 삭제하시겠습니까?'**
  String fridge_item_delete_confirm(String name);

  /// 품목명 레이블
  ///
  /// In ko, this message translates to:
  /// **'품목명'**
  String get fridge_item_name;

  /// 수량 레이블
  ///
  /// In ko, this message translates to:
  /// **'수량'**
  String get fridge_item_quantity;

  /// 단위 레이블
  ///
  /// In ko, this message translates to:
  /// **'단위 (선택)'**
  String get fridge_item_unit;

  /// 유통기한 레이블
  ///
  /// In ko, this message translates to:
  /// **'유통기한 (선택)'**
  String get fridge_item_expires_at;

  /// 만료 알림 일수
  ///
  /// In ko, this message translates to:
  /// **'만료 {days}일 전 알림'**
  String fridge_item_alert_days(int days);

  /// 메모 레이블
  ///
  /// In ko, this message translates to:
  /// **'메모 (선택)'**
  String get fridge_item_memo;

  /// 오늘 만료
  ///
  /// In ko, this message translates to:
  /// **'D-Day'**
  String get fridge_item_dday_today;

  /// 만료 지남
  ///
  /// In ko, this message translates to:
  /// **'D+{days}'**
  String fridge_item_dday_expired(int days);

  /// 남은 날수
  ///
  /// In ko, this message translates to:
  /// **'D-{days}'**
  String fridge_item_dday_remaining(int days);

  /// 유통기한 없음
  ///
  /// In ko, this message translates to:
  /// **'유통기한 없음'**
  String get fridge_item_no_expiry;

  /// 보관소 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'보관소가 없습니다. 추가해보세요.'**
  String get fridge_empty_storage;

  /// 품목 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'품목이 없습니다'**
  String get fridge_empty_items;

  /// 품목 수 단위
  ///
  /// In ko, this message translates to:
  /// **'개'**
  String get fridge_item_count;

  /// 유통기한 정렬
  ///
  /// In ko, this message translates to:
  /// **'유통기한순'**
  String get fridge_sort_expiry;

  /// 이름 정렬
  ///
  /// In ko, this message translates to:
  /// **'이름순'**
  String get fridge_sort_name;

  /// 등록일 정렬
  ///
  /// In ko, this message translates to:
  /// **'등록순'**
  String get fridge_sort_registered;

  /// 등록 후 경과일 단위
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get fridge_item_elapsed_days;

  /// 자주 사는 항목 추가
  ///
  /// In ko, this message translates to:
  /// **'항목 추가'**
  String get fridge_frequent_add;

  /// 자동 장바구니 토글 레이블
  ///
  /// In ko, this message translates to:
  /// **'소진 시 자동 장바구니'**
  String get fridge_frequent_auto_add;

  /// 자주 사는 항목 없음
  ///
  /// In ko, this message translates to:
  /// **'자주 사는 항목이 없습니다'**
  String get fridge_frequent_empty;

  /// 장바구니에 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'장바구니에 추가'**
  String get fridge_frequent_add_to_cart;

  /// No description provided for @fridge_frequent_added_snackbar.
  ///
  /// In ko, this message translates to:
  /// **'{name}을(를) 장바구니에 추가했습니다'**
  String fridge_frequent_added_snackbar(String name);

  /// No description provided for @fridge_frequent_delete_confirm.
  ///
  /// In ko, this message translates to:
  /// **'{name}을(를) 삭제하시겠습니까?'**
  String fridge_frequent_delete_confirm(String name);

  /// No description provided for @fridge_frequent_autoAddInfo_title.
  ///
  /// In ko, this message translates to:
  /// **'자동 추가란?'**
  String get fridge_frequent_autoAddInfo_title;

  /// No description provided for @fridge_frequent_autoAddInfo_body.
  ///
  /// In ko, this message translates to:
  /// **'냉장고에서 이 품목의 수량이 0이 되면 장바구니에 자동으로 추가돼요.\n스위치를 켜두면 냉장고가 비었을 때 알아서 장보기 목록에 담아드립니다.'**
  String get fridge_frequent_autoAddInfo_body;

  /// No description provided for @fridge_frequent_autoAddInfo_hint.
  ///
  /// In ko, this message translates to:
  /// **'냉장고 탭에서 수량을 관리하면 연동됩니다'**
  String get fridge_frequent_autoAddInfo_hint;

  /// No description provided for @fridge_frequent_coach_fabTitle.
  ///
  /// In ko, this message translates to:
  /// **'자주 사는 항목 추가'**
  String get fridge_frequent_coach_fabTitle;

  /// No description provided for @fridge_frequent_coach_fabDesc.
  ///
  /// In ko, this message translates to:
  /// **'자주 구매하는 품목을 등록해 두면\n다음 장보기 때 빠르게 담을 수 있어요.'**
  String get fridge_frequent_coach_fabDesc;

  /// No description provided for @fridge_frequent_coach_itemTitle.
  ///
  /// In ko, this message translates to:
  /// **'항목 관리'**
  String get fridge_frequent_coach_itemTitle;

  /// No description provided for @fridge_frequent_coach_itemDesc.
  ///
  /// In ko, this message translates to:
  /// **'품목명·기본 단위를 설정할 수 있어요.\n탭하면 수정, 길게 누르면 삭제할 수 있습니다.'**
  String get fridge_frequent_coach_itemDesc;

  /// No description provided for @fridge_frequent_coach_autoAddTitle.
  ///
  /// In ko, this message translates to:
  /// **'자동 추가'**
  String get fridge_frequent_coach_autoAddTitle;

  /// No description provided for @fridge_frequent_coach_autoAddDesc.
  ///
  /// In ko, this message translates to:
  /// **'냉장고에서 이 품목의 수량이 0이 되면\n장바구니에 자동으로 추가돼요.\n냉장고 탭과 연동되는 스마트 기능이에요.'**
  String get fridge_frequent_coach_autoAddDesc;

  /// No description provided for @fridge_frequent_coach_addToCartTitle.
  ///
  /// In ko, this message translates to:
  /// **'장바구니에 바로 담기'**
  String get fridge_frequent_coach_addToCartTitle;

  /// No description provided for @fridge_frequent_coach_addToCartDesc.
  ///
  /// In ko, this message translates to:
  /// **'버튼 하나로 현재 장바구니에\n즉시 추가할 수 있어요.'**
  String get fridge_frequent_coach_addToCartDesc;

  /// No description provided for @fridge_frequent_coach_skip.
  ///
  /// In ko, this message translates to:
  /// **'건너뛰기'**
  String get fridge_frequent_coach_skip;

  /// No description provided for @fridge_coach_fabTitle.
  ///
  /// In ko, this message translates to:
  /// **'보관소 추가'**
  String get fridge_coach_fabTitle;

  /// No description provided for @fridge_coach_fabDesc.
  ///
  /// In ko, this message translates to:
  /// **'냉장고, 냉동실, 팬트리 등 보관 장소를 추가할 수 있어요.\n+ 버튼을 눌러 보관소를 만들어 보세요.'**
  String get fridge_coach_fabDesc;

  /// No description provided for @fridge_coach_sectionTitle.
  ///
  /// In ko, this message translates to:
  /// **'보관소'**
  String get fridge_coach_sectionTitle;

  /// No description provided for @fridge_coach_sectionDesc.
  ///
  /// In ko, this message translates to:
  /// **'헤더를 탭해 펼치고 접을 수 있어요.\n우측 메뉴(⋮)로 보관소를 수정하거나 삭제할 수 있어요.'**
  String get fridge_coach_sectionDesc;

  /// No description provided for @fridge_coach_itemTitle.
  ///
  /// In ko, this message translates to:
  /// **'품목 관리'**
  String get fridge_coach_itemTitle;

  /// No description provided for @fridge_coach_itemDesc.
  ///
  /// In ko, this message translates to:
  /// **'• 탭하면 이름·유통기한·메모를 수정할 수 있어요\n• ± 버튼으로 수량을 조절하세요\n• 왼쪽으로 스와이프하면 삭제 표시돼요\n• 변경 후 저장 버튼을 눌러야 반영됩니다'**
  String get fridge_coach_itemDesc;

  /// No description provided for @fridge_coach_ddayTitle.
  ///
  /// In ko, this message translates to:
  /// **'유통기한 알림'**
  String get fridge_coach_ddayTitle;

  /// No description provided for @fridge_coach_ddayDesc.
  ///
  /// In ko, this message translates to:
  /// **'품목에 유통기한을 등록하면 남은 일수가 표시돼요.\n• 파란색: 여유 있음\n• 주황색: 3일 이내 임박\n• 빨간색: 오늘 또는 이미 지남\n설정한 알림일 전에 푸시 알림도 받을 수 있어요.'**
  String get fridge_coach_ddayDesc;

  /// No description provided for @fridge_coach_addItemTitle.
  ///
  /// In ko, this message translates to:
  /// **'품목 추가'**
  String get fridge_coach_addItemTitle;

  /// No description provided for @fridge_coach_addItemDesc.
  ///
  /// In ko, this message translates to:
  /// **'보관소 우측 + 버튼으로 품목을 추가해요.\n여러 품목을 한 번에 등록할 수 있고,\n유통기한·수량·단위·메모도 함께 입력할 수 있어요.'**
  String get fridge_coach_addItemDesc;

  /// No description provided for @fridge_coach_suggestionTitle.
  ///
  /// In ko, this message translates to:
  /// **'유통기한 자동 추천'**
  String get fridge_coach_suggestionTitle;

  /// No description provided for @fridge_coach_suggestionDesc.
  ///
  /// In ko, this message translates to:
  /// **'품목명을 입력하면 유통기한을 자동으로 추천해줘요.\n설정 > 유통기한 프리셋 관리에서 품목별 기준일을\n직접 추가·수정해 자동화 규칙을 커스터마이징할 수 있어요.'**
  String get fridge_coach_suggestionDesc;

  /// No description provided for @fridge_coach_skip.
  ///
  /// In ko, this message translates to:
  /// **'건너뛰기'**
  String get fridge_coach_skip;

  /// 장바구니 비어 있음
  ///
  /// In ko, this message translates to:
  /// **'장바구니가 비어 있습니다'**
  String get fridge_cart_empty;

  /// 장바구니 품목 추가
  ///
  /// In ko, this message translates to:
  /// **'품목 추가'**
  String get fridge_cart_add_item;

  /// 장보기 완료 버튼
  ///
  /// In ko, this message translates to:
  /// **'장보기 완료'**
  String get fridge_cart_complete;

  /// 장보기 완료 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'장보기 완료'**
  String get fridge_cart_complete_title;

  /// 장보기 완료 2단계 제목
  ///
  /// In ko, this message translates to:
  /// **'냉장고 이관 상세 입력'**
  String get fridge_cart_complete_step2_title;

  /// 이관 힌트
  ///
  /// In ko, this message translates to:
  /// **'냉장고로 이관할 보관소를 선택하세요'**
  String get fridge_cart_complete_transfer_hint;

  /// 가계부 등록 토글
  ///
  /// In ko, this message translates to:
  /// **'가계부에 등록'**
  String get fridge_cart_complete_add_expense;

  /// 구매 총액 레이블 (선택)
  ///
  /// In ko, this message translates to:
  /// **'총액 (선택 — 미입력 시 항목 금액 합산)'**
  String get fridge_cart_complete_amount;

  /// 항목별 금액 입력 레이블
  ///
  /// In ko, this message translates to:
  /// **'금액 (선택)'**
  String get fridge_cart_item_price;

  /// 장보기 메모
  ///
  /// In ko, this message translates to:
  /// **'메모 (선택)'**
  String get fridge_cart_complete_description;

  /// 이관 안 함 옵션
  ///
  /// In ko, this message translates to:
  /// **'이관 안 함'**
  String get fridge_cart_skip_transfer;

  /// 구매 이력 없음
  ///
  /// In ko, this message translates to:
  /// **'구매 이력이 없습니다'**
  String get fridge_history_empty;

  /// 품목 수
  ///
  /// In ko, this message translates to:
  /// **'{count}개 품목'**
  String fridge_history_items_count(int count);

  /// 가계부 연결 표시
  ///
  /// In ko, this message translates to:
  /// **'가계부 연결됨'**
  String get fridge_history_linked_expense;

  /// 가계부 보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'가계부 보기'**
  String get fridge_history_view_expense;

  /// 개인 모드
  ///
  /// In ko, this message translates to:
  /// **'개인'**
  String get fridge_group_selector_personal;

  /// 유통기한 추천 칩 텍스트
  ///
  /// In ko, this message translates to:
  /// **'{keyword} 기준 · {storageType} {days}일 추천'**
  String fridge_expiry_suggestion_label(
    String keyword,
    String storageType,
    int days,
  );

  /// 추천 유통기한 적용 버튼
  ///
  /// In ko, this message translates to:
  /// **'추천 적용'**
  String get fridge_expiry_apply;

  /// 유통기한 직접 입력 버튼
  ///
  /// In ko, this message translates to:
  /// **'직접 입력'**
  String get fridge_expiry_manual;

  /// 다른 기준 품목 선택 버튼
  ///
  /// In ko, this message translates to:
  /// **'다른 품목 기준으로 설정'**
  String get fridge_expiry_change_reference;

  /// 기준 품목 선택 모달 제목
  ///
  /// In ko, this message translates to:
  /// **'유통기한 기준 품목 선택'**
  String get fridge_expiry_reference_title;

  /// 기준 품목 검색 힌트
  ///
  /// In ko, this message translates to:
  /// **'품목 검색'**
  String get fridge_expiry_reference_search;

  /// 추천 일수 표시
  ///
  /// In ko, this message translates to:
  /// **'{days}일'**
  String fridge_expiry_reference_days(int days);

  /// 기준 품목 검색 결과 없음
  ///
  /// In ko, this message translates to:
  /// **'검색 결과가 없습니다'**
  String get fridge_expiry_reference_empty;

  /// 유통기한 프리셋 관리 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'유통기한 프리셋 관리'**
  String get fridge_preset_management_title;

  /// 앱바 메뉴 항목
  ///
  /// In ko, this message translates to:
  /// **'유통기한 프리셋 관리'**
  String get fridge_preset_management_menu;

  /// 기준 품목 선택 시트의 편집 바로가기 버튼
  ///
  /// In ko, this message translates to:
  /// **'프리셋 편집'**
  String get fridge_preset_edit_shortcut;

  /// 프리셋 일수 표시
  ///
  /// In ko, this message translates to:
  /// **'{days}일'**
  String fridge_preset_days_label(int days);

  /// 그룹 커스텀 프리셋 배지
  ///
  /// In ko, this message translates to:
  /// **'커스텀'**
  String get fridge_preset_custom_badge;

  /// 프리셋 초기화 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'기본값으로 초기화하시겠습니까?'**
  String get fridge_preset_reset_confirm;

  /// 프리셋 수정 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'유통기한 수정'**
  String get fridge_preset_edit_dialog_title;

  /// 프리셋 등록 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'새 프리셋 등록'**
  String get fridge_preset_add_dialog_title;

  /// 일수 입력 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'유통기한 (일)'**
  String get fridge_preset_days_input_label;

  /// 카테고리 입력 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get fridge_preset_category_input_label;

  /// 보관 방법 선택 라벨
  ///
  /// In ko, this message translates to:
  /// **'보관 방법'**
  String get fridge_preset_storage_type_label;

  /// 프리셋 삭제 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'커스텀 설정을 삭제하고 기본값으로 되돌리겠습니까?'**
  String get fridge_preset_delete_confirm;

  /// 프리셋 검색 힌트
  ///
  /// In ko, this message translates to:
  /// **'카테고리 또는 품목 검색'**
  String get fridge_preset_search_hint;

  /// No description provided for @dashboard_greetingMorning.
  ///
  /// In ko, this message translates to:
  /// **'좋은 아침입니다'**
  String get dashboard_greetingMorning;

  /// No description provided for @dashboard_greetingAfternoon.
  ///
  /// In ko, this message translates to:
  /// **'좋은 오후입니다'**
  String get dashboard_greetingAfternoon;

  /// No description provided for @dashboard_greetingEvening.
  ///
  /// In ko, this message translates to:
  /// **'좋은 저녁입니다'**
  String get dashboard_greetingEvening;

  /// No description provided for @dashboard_greetingSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'오늘도 좋은 하루 되세요!'**
  String get dashboard_greetingSubtitle;

  /// No description provided for @dashboard_emptyWidgets.
  ///
  /// In ko, this message translates to:
  /// **'표시할 위젯이 없습니다'**
  String get dashboard_emptyWidgets;

  /// No description provided for @dashboard_emptyWidgetsHint.
  ///
  /// In ko, this message translates to:
  /// **'설정에서 위젯을 활성화하세요'**
  String get dashboard_emptyWidgetsHint;

  /// No description provided for @dashboard_widgetSettings.
  ///
  /// In ko, this message translates to:
  /// **'위젯 설정'**
  String get dashboard_widgetSettings;

  /// No description provided for @dashboard_notifications.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get dashboard_notifications;

  /// No description provided for @weather_widgetTitle.
  ///
  /// In ko, this message translates to:
  /// **'오늘 날씨'**
  String get weather_widgetTitle;

  /// No description provided for @weather_refresh.
  ///
  /// In ko, this message translates to:
  /// **'날씨 새로고침'**
  String get weather_refresh;

  /// No description provided for @weather_detail.
  ///
  /// In ko, this message translates to:
  /// **'자세히'**
  String get weather_detail;

  /// No description provided for @weather_errorMessage.
  ///
  /// In ko, this message translates to:
  /// **'날씨 정보를 불러올 수 없습니다'**
  String get weather_errorMessage;

  /// No description provided for @weather_dustFine.
  ///
  /// In ko, this message translates to:
  /// **'미세'**
  String get weather_dustFine;

  /// No description provided for @weather_dustUltraFine.
  ///
  /// In ko, this message translates to:
  /// **'초미세'**
  String get weather_dustUltraFine;

  /// No description provided for @investment_widgetTitle.
  ///
  /// In ko, this message translates to:
  /// **'투자 지표'**
  String get investment_widgetTitle;

  /// No description provided for @investment_errorMessage.
  ///
  /// In ko, this message translates to:
  /// **'데이터를 불러올 수 없습니다'**
  String get investment_errorMessage;

  /// No description provided for @investment_emptyBookmarks.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기한 지표가 없습니다'**
  String get investment_emptyBookmarks;

  /// No description provided for @investment_screenTitle.
  ///
  /// In ko, this message translates to:
  /// **'투자 지표'**
  String get investment_screenTitle;

  /// No description provided for @investment_bookmarkSection.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기'**
  String get investment_bookmarkSection;

  /// No description provided for @investment_bookmarkReorderHint.
  ///
  /// In ko, this message translates to:
  /// **'(길게 눌러 순서 변경)'**
  String get investment_bookmarkReorderHint;

  /// No description provided for @investment_allSection.
  ///
  /// In ko, this message translates to:
  /// **'전체 지표'**
  String get investment_allSection;

  /// No description provided for @investment_noData.
  ///
  /// In ko, this message translates to:
  /// **'지표 데이터가 없습니다'**
  String get investment_noData;

  /// No description provided for @investment_loadError.
  ///
  /// In ko, this message translates to:
  /// **'데이터를 불러오지 못했습니다'**
  String get investment_loadError;

  /// No description provided for @investment_retry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get investment_retry;

  /// No description provided for @investment_adminTooltip.
  ///
  /// In ko, this message translates to:
  /// **'과거 데이터 초기화 (관리자)'**
  String get investment_adminTooltip;

  /// No description provided for @investment_briefingTitle.
  ///
  /// In ko, this message translates to:
  /// **'AI 시황 브리핑'**
  String get investment_briefingTitle;

  /// No description provided for @investment_briefingError.
  ///
  /// In ko, this message translates to:
  /// **'AI 브리핑 오류: {error}'**
  String investment_briefingError(String error);

  /// No description provided for @investment_briefingMacro.
  ///
  /// In ko, this message translates to:
  /// **'매크로'**
  String get investment_briefingMacro;

  /// No description provided for @investment_briefingDomestic.
  ///
  /// In ko, this message translates to:
  /// **'국내 시장'**
  String get investment_briefingDomestic;

  /// No description provided for @investment_briefingGlobal.
  ///
  /// In ko, this message translates to:
  /// **'글로벌 시장'**
  String get investment_briefingGlobal;

  /// No description provided for @investment_briefingUpdatedAt.
  ///
  /// In ko, this message translates to:
  /// **'업데이트: {time}'**
  String investment_briefingUpdatedAt(String time);

  /// No description provided for @investment_adminDialogTitle.
  ///
  /// In ko, this message translates to:
  /// **'과거 데이터 초기화'**
  String get investment_adminDialogTitle;

  /// No description provided for @investment_adminDialogDesc.
  ///
  /// In ko, this message translates to:
  /// **'Yahoo/CoinGecko/BOK에서 과거 시세를 수집해 DB에 저장합니다.\n시간이 걸릴 수 있습니다.'**
  String get investment_adminDialogDesc;

  /// No description provided for @investment_adminDaysLabel.
  ///
  /// In ko, this message translates to:
  /// **'수집 일수 (1~3650)'**
  String get investment_adminDaysLabel;

  /// No description provided for @investment_adminDaysSuffix.
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get investment_adminDaysSuffix;

  /// No description provided for @investment_adminExecute.
  ///
  /// In ko, this message translates to:
  /// **'초기화 실행'**
  String get investment_adminExecute;

  /// No description provided for @investment_adminResultTitle.
  ///
  /// In ko, this message translates to:
  /// **'초기화 완료'**
  String get investment_adminResultTitle;

  /// No description provided for @investment_adminResultYahoo.
  ///
  /// In ko, this message translates to:
  /// **'Yahoo (주가/환율/원자재)'**
  String get investment_adminResultYahoo;

  /// No description provided for @investment_adminResultCrypto.
  ///
  /// In ko, this message translates to:
  /// **'암호화폐 (BTC/KRW)'**
  String get investment_adminResultCrypto;

  /// No description provided for @investment_adminResultBond.
  ///
  /// In ko, this message translates to:
  /// **'한국 채권'**
  String get investment_adminResultBond;

  /// No description provided for @investment_adminResultGold.
  ///
  /// In ko, this message translates to:
  /// **'국내 금값'**
  String get investment_adminResultGold;

  /// No description provided for @investment_adminResultCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}건'**
  String investment_adminResultCount(int count);

  /// No description provided for @investment_adminInitError.
  ///
  /// In ko, this message translates to:
  /// **'초기화 실패: {error}'**
  String investment_adminInitError(String error);

  /// No description provided for @investment_adminLoading.
  ///
  /// In ko, this message translates to:
  /// **'과거 데이터를 수집 중입니다...'**
  String get investment_adminLoading;

  /// No description provided for @investment_prevPrice.
  ///
  /// In ko, this message translates to:
  /// **'전일 종가'**
  String get investment_prevPrice;

  /// No description provided for @investment_spreadBadge.
  ///
  /// In ko, this message translates to:
  /// **'이격률 {value}%'**
  String investment_spreadBadge(String value);

  /// No description provided for @investment_spreadPremium.
  ///
  /// In ko, this message translates to:
  /// **'국제 환산가 대비 프리미엄'**
  String get investment_spreadPremium;

  /// No description provided for @investment_spreadDiscount.
  ///
  /// In ko, this message translates to:
  /// **'국제 환산가 대비 디스카운트'**
  String get investment_spreadDiscount;

  /// No description provided for @investment_chartTitle.
  ///
  /// In ko, this message translates to:
  /// **'시세 추이'**
  String get investment_chartTitle;

  /// No description provided for @investment_chartDayChip.
  ///
  /// In ko, this message translates to:
  /// **'{days}일'**
  String investment_chartDayChip(int days);

  /// No description provided for @investment_chartYearChip.
  ///
  /// In ko, this message translates to:
  /// **'1년'**
  String get investment_chartYearChip;

  /// No description provided for @investment_chartLoadError.
  ///
  /// In ko, this message translates to:
  /// **'차트를 불러올 수 없습니다'**
  String get investment_chartLoadError;

  /// No description provided for @investment_chartNoData.
  ///
  /// In ko, this message translates to:
  /// **'데이터가 없습니다'**
  String get investment_chartNoData;

  /// No description provided for @investment_marketClosed.
  ///
  /// In ko, this message translates to:
  /// **'휴장 중 · 마지막 거래일: {date}'**
  String investment_marketClosed(String date);

  /// No description provided for @investment_spreadChartTitle.
  ///
  /// In ko, this message translates to:
  /// **'이격률 추이'**
  String get investment_spreadChartTitle;

  /// No description provided for @investment_spreadChartSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'(국제 환산가 대비)'**
  String get investment_spreadChartSubtitle;

  /// No description provided for @investment_spreadSummaryLabel.
  ///
  /// In ko, this message translates to:
  /// **'현재 국제 환산가 대비 {label}'**
  String investment_spreadSummaryLabel(String label);

  /// No description provided for @investment_spreadPremiumLabel.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄'**
  String get investment_spreadPremiumLabel;

  /// No description provided for @investment_spreadDiscountLabel.
  ///
  /// In ko, this message translates to:
  /// **'디스카운트'**
  String get investment_spreadDiscountLabel;

  /// No description provided for @investment_coachIndicatorTitle.
  ///
  /// In ko, this message translates to:
  /// **'투자 지표'**
  String get investment_coachIndicatorTitle;

  /// No description provided for @investment_coachIndicatorDesc.
  ///
  /// In ko, this message translates to:
  /// **'주요 주가지수, 환율, 원자재, 암호화폐 등\n실시간 지표를 한눈에 확인할 수 있어요.\n탭하면 상세 차트와 과거 추이를 볼 수 있어요.'**
  String get investment_coachIndicatorDesc;

  /// No description provided for @investment_coachBookmarkTitle.
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기'**
  String get investment_coachBookmarkTitle;

  /// No description provided for @investment_coachBookmarkDesc.
  ///
  /// In ko, this message translates to:
  /// **'별표를 눌러 즐겨찾기에 추가하세요.\n즐겨찾기한 지표는 목록 상단에 고정되고\n홈 화면 대시보드 위젯에서 바로 확인할 수 있어요.'**
  String get investment_coachBookmarkDesc;

  /// No description provided for @householdWidget_groupTooltip.
  ///
  /// In ko, this message translates to:
  /// **'그룹 선택'**
  String get householdWidget_groupTooltip;

  /// No description provided for @householdWidget_incomeLabel.
  ///
  /// In ko, this message translates to:
  /// **'{month} 입금'**
  String householdWidget_incomeLabel(String month);

  /// No description provided for @householdWidget_expenseLabel.
  ///
  /// In ko, this message translates to:
  /// **'{month} 지출'**
  String householdWidget_expenseLabel(String month);

  /// No description provided for @householdWidget_balance.
  ///
  /// In ko, this message translates to:
  /// **'잔액'**
  String get householdWidget_balance;

  /// No description provided for @householdWidget_budget.
  ///
  /// In ko, this message translates to:
  /// **'예산 {amount}'**
  String householdWidget_budget(String amount);

  /// No description provided for @householdWidget_budgetUsed.
  ///
  /// In ko, this message translates to:
  /// **'{percent}% 사용'**
  String householdWidget_budgetUsed(int percent);

  /// No description provided for @householdWidget_budgetOver.
  ///
  /// In ko, this message translates to:
  /// **'{amount} 초과'**
  String householdWidget_budgetOver(String amount);

  /// No description provided for @householdWidget_budgetRemaining.
  ///
  /// In ko, this message translates to:
  /// **'{amount} 남음'**
  String householdWidget_budgetRemaining(String amount);

  /// No description provided for @householdWidget_filterTitle.
  ///
  /// In ko, this message translates to:
  /// **'필터 선택'**
  String get householdWidget_filterTitle;

  /// No description provided for @householdWidget_filterPersonal.
  ///
  /// In ko, this message translates to:
  /// **'개인'**
  String get householdWidget_filterPersonal;

  /// No description provided for @householdWidget_filterPersonalSub.
  ///
  /// In ko, this message translates to:
  /// **'그룹 없이 개인 지출만'**
  String get householdWidget_filterPersonalSub;

  /// No description provided for @householdWidget_applyButton.
  ///
  /// In ko, this message translates to:
  /// **'적용'**
  String get householdWidget_applyButton;

  /// No description provided for @householdWidget_categoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'카테고리별 지출'**
  String get householdWidget_categoryTitle;

  /// No description provided for @householdWidget_categoryOver.
  ///
  /// In ko, this message translates to:
  /// **'{amount} 초과'**
  String householdWidget_categoryOver(String amount);

  /// No description provided for @householdWidget_categoryUsed.
  ///
  /// In ko, this message translates to:
  /// **'{percent}% 사용'**
  String householdWidget_categoryUsed(int percent);

  /// No description provided for @householdWidget_catTransportation.
  ///
  /// In ko, this message translates to:
  /// **'교통'**
  String get householdWidget_catTransportation;

  /// No description provided for @householdWidget_catFood.
  ///
  /// In ko, this message translates to:
  /// **'식비'**
  String get householdWidget_catFood;

  /// No description provided for @householdWidget_catLeisure.
  ///
  /// In ko, this message translates to:
  /// **'여가'**
  String get householdWidget_catLeisure;

  /// No description provided for @householdWidget_catLiving.
  ///
  /// In ko, this message translates to:
  /// **'생활'**
  String get householdWidget_catLiving;

  /// No description provided for @householdWidget_catMedical.
  ///
  /// In ko, this message translates to:
  /// **'의료'**
  String get householdWidget_catMedical;

  /// No description provided for @householdWidget_catEducation.
  ///
  /// In ko, this message translates to:
  /// **'교육'**
  String get householdWidget_catEducation;

  /// No description provided for @householdWidget_catAllowance.
  ///
  /// In ko, this message translates to:
  /// **'용돈'**
  String get householdWidget_catAllowance;

  /// No description provided for @householdWidget_catCelebration.
  ///
  /// In ko, this message translates to:
  /// **'경조사비'**
  String get householdWidget_catCelebration;

  /// No description provided for @householdWidget_catAssetTransfer.
  ///
  /// In ko, this message translates to:
  /// **'자산이동'**
  String get householdWidget_catAssetTransfer;

  /// No description provided for @householdWidget_catChildcare.
  ///
  /// In ko, this message translates to:
  /// **'육아비'**
  String get householdWidget_catChildcare;

  /// No description provided for @householdWidget_catOther.
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get householdWidget_catOther;

  /// No description provided for @assetWidget_title.
  ///
  /// In ko, this message translates to:
  /// **'자산 현황'**
  String get assetWidget_title;

  /// No description provided for @assetWidget_groupTitle.
  ///
  /// In ko, this message translates to:
  /// **'{groupName} 자산'**
  String assetWidget_groupTitle(String groupName);

  /// No description provided for @assetWidget_groupTooltip.
  ///
  /// In ko, this message translates to:
  /// **'그룹 선택'**
  String get assetWidget_groupTooltip;

  /// No description provided for @assetWidget_totalAsset.
  ///
  /// In ko, this message translates to:
  /// **'총 자산'**
  String get assetWidget_totalAsset;

  /// No description provided for @assetWidget_totalProfit.
  ///
  /// In ko, this message translates to:
  /// **'총 수익'**
  String get assetWidget_totalProfit;

  /// No description provided for @assetWidget_profitRate.
  ///
  /// In ko, this message translates to:
  /// **'수익률'**
  String get assetWidget_profitRate;

  /// No description provided for @assetWidget_distribution.
  ///
  /// In ko, this message translates to:
  /// **'자산 분포'**
  String get assetWidget_distribution;

  /// No description provided for @assetWidget_groupPickerTitle.
  ///
  /// In ko, this message translates to:
  /// **'그룹 선택'**
  String get assetWidget_groupPickerTitle;

  /// No description provided for @assetWidget_applyButton.
  ///
  /// In ko, this message translates to:
  /// **'적용'**
  String get assetWidget_applyButton;

  /// No description provided for @assetWidget_typeSavings.
  ///
  /// In ko, this message translates to:
  /// **'적금'**
  String get assetWidget_typeSavings;

  /// No description provided for @assetWidget_typeDeposit.
  ///
  /// In ko, this message translates to:
  /// **'예금'**
  String get assetWidget_typeDeposit;

  /// No description provided for @assetWidget_typeStock.
  ///
  /// In ko, this message translates to:
  /// **'주식'**
  String get assetWidget_typeStock;

  /// No description provided for @assetWidget_typeFund.
  ///
  /// In ko, this message translates to:
  /// **'펀드'**
  String get assetWidget_typeFund;

  /// No description provided for @assetWidget_typeRealEstate.
  ///
  /// In ko, this message translates to:
  /// **'부동산'**
  String get assetWidget_typeRealEstate;

  /// No description provided for @assetWidget_typeGold.
  ///
  /// In ko, this message translates to:
  /// **'실물 금'**
  String get assetWidget_typeGold;

  /// No description provided for @assetWidget_typeOther.
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get assetWidget_typeOther;

  /// No description provided for @legal_termsOfService.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용약관'**
  String get legal_termsOfService;

  /// No description provided for @legal_privacyPolicy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get legal_privacyPolicy;

  /// No description provided for @legal_termsLastUpdated.
  ///
  /// In ko, this message translates to:
  /// **'시행일: 2026년 6월 1일'**
  String get legal_termsLastUpdated;

  /// No description provided for @legal_termsContact.
  ///
  /// In ko, this message translates to:
  /// **'문의: hmn.corp.dev@gmail.com'**
  String get legal_termsContact;

  /// No description provided for @legal_agreeToTerms.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용약관'**
  String get legal_agreeToTerms;

  /// No description provided for @legal_agreeToPrivacy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get legal_agreeToPrivacy;

  /// No description provided for @legal_required.
  ///
  /// In ko, this message translates to:
  /// **'(필수)'**
  String get legal_required;

  /// No description provided for @legal_agreeAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 동의'**
  String get legal_agreeAll;

  /// No description provided for @legal_mustAgreeTerms.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용약관에 동의해 주세요.'**
  String get legal_mustAgreeTerms;

  /// No description provided for @legal_mustAgreePrivacy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침에 동의해 주세요.'**
  String get legal_mustAgreePrivacy;

  /// No description provided for @legal_agreeAgeVerification.
  ///
  /// In ko, this message translates to:
  /// **'만 14세 이상입니다 (필수)'**
  String get legal_agreeAgeVerification;

  /// No description provided for @legal_mustAgreeAgeVerification.
  ///
  /// In ko, this message translates to:
  /// **'만 14세 이상인지 확인해 주세요.'**
  String get legal_mustAgreeAgeVerification;

  /// No description provided for @legal_socialLoginConsent.
  ///
  /// In ko, this message translates to:
  /// **'계속하면 서비스 {termsLink} 및 {privacyLink}에 동의하는 것으로 간주합니다.'**
  String legal_socialLoginConsent(String termsLink, String privacyLink);

  /// No description provided for @legal_terms_section1_title.
  ///
  /// In ko, this message translates to:
  /// **'제1조 (목적)'**
  String get legal_terms_section1_title;

  /// No description provided for @legal_terms_section1_body.
  ///
  /// In ko, this message translates to:
  /// **'본 약관은 에이치엠엔 코퍼레이션(HMN Corporation)이 제공하는 Family Planner 서비스(이하 \"서비스\")의 이용과 관련하여 회사와 회원 간의 권리, 의무 및 책임 사항을 규정함을 목적으로 합니다.'**
  String get legal_terms_section1_body;

  /// No description provided for @legal_terms_section2_title.
  ///
  /// In ko, this message translates to:
  /// **'제2조 (서비스의 내용)'**
  String get legal_terms_section2_title;

  /// No description provided for @legal_terms_section2_body.
  ///
  /// In ko, this message translates to:
  /// **'회사는 회원에게 다음과 같은 서비스를 제공합니다.\n• 가족 그룹 기반의 캘린더 및 할 일 공유\n• 구성원 간 자산 관리 및 내역 공유\n• 육아 보상(칭찬 스티커 등) 관리 시스템\n• AI 에이전트를 통한 대화, 일정 관리, 거시 경제/시장 브리핑 서비스\n• 기타 회사가 추가로 개발하거나 제휴 계약 등을 통해 제공하는 서비스'**
  String get legal_terms_section2_body;

  /// No description provided for @legal_terms_section3_title.
  ///
  /// In ko, this message translates to:
  /// **'제3조 (회원의 의무)'**
  String get legal_terms_section3_title;

  /// No description provided for @legal_terms_section3_body.
  ///
  /// In ko, this message translates to:
  /// **'• 회원은 본 서비스의 AI 에이전트에게 불법적이거나 타인에게 위해를 가할 수 있는 프롬프트를 입력해서는 안 됩니다.\n• 회원은 가족 그룹 초대 코드 및 계정 정보를 안전하게 관리할 책임이 있습니다.\n• 서비스 내 자산 관리 및 시장 브리핑 기능은 참고용 데이터 제공을 목적으로 하며, 회사는 이를 통한 투자 결과에 대해 법적 책임을 지지 않습니다.'**
  String get legal_terms_section3_body;

  /// No description provided for @legal_terms_section4_title.
  ///
  /// In ko, this message translates to:
  /// **'제4조 (게시물의 저작권 및 관리)'**
  String get legal_terms_section4_title;

  /// No description provided for @legal_terms_section4_body.
  ///
  /// In ko, this message translates to:
  /// **'• 회원이 서비스 내에 게시한 정보(채팅, 일정, 자산 정보 등)의 저작권은 해당 회원에게 있습니다.\n• 회사는 회원의 게시물을 서비스 운영, 개선(AI 기능 고도화 등), 홍보의 목적으로만 활용하며, 개인을 식별할 수 없는 형태로 비식별화하여 사용합니다.'**
  String get legal_terms_section4_body;

  /// No description provided for @legal_terms_section5_title.
  ///
  /// In ko, this message translates to:
  /// **'제5조 (서비스의 중단 및 변경)'**
  String get legal_terms_section5_title;

  /// No description provided for @legal_terms_section5_body.
  ///
  /// In ko, this message translates to:
  /// **'회사는 운영상, 기술상의 필요에 따라 제공하고 있는 서비스의 전부 또는 일부를 변경하거나 중단할 수 있으며, 이 경우 사전에 공지합니다.'**
  String get legal_terms_section5_body;

  /// No description provided for @legal_terms_section6_title.
  ///
  /// In ko, this message translates to:
  /// **'제6조 (책임 제한)'**
  String get legal_terms_section6_title;

  /// No description provided for @legal_terms_section6_body.
  ///
  /// In ko, this message translates to:
  /// **'회사는 천재지변, 서버 제공 업체의 장애, 제3자 AI API 서비스의 장애 등 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다.'**
  String get legal_terms_section6_body;

  /// No description provided for @legal_terms_section7_title.
  ///
  /// In ko, this message translates to:
  /// **'제7조 (시행일)'**
  String get legal_terms_section7_title;

  /// No description provided for @legal_terms_section7_body.
  ///
  /// In ko, this message translates to:
  /// **'본 약관은 2026년 6월 1일부터 적용됩니다.'**
  String get legal_terms_section7_body;

  /// No description provided for @legal_privacy_section1_title.
  ///
  /// In ko, this message translates to:
  /// **'1. 개인정보의 처리 목적'**
  String get legal_privacy_section1_title;

  /// No description provided for @legal_privacy_section1_body.
  ///
  /// In ko, this message translates to:
  /// **'에이치엠엔 코퍼레이션(HMN Corporation)(이하 \'회사\')은 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.\n• 회원 가입 및 관리, 가족 그룹(초대 코드 등) 식별\n• 서비스 제공 (캘린더, 할 일, 자산 관리, 육아 보상 시스템 등)\n• AI 에이전트(챗봇, 브리핑 등) 서비스 제공 및 품질 향상\n• 신규 서비스 개발 및 맞춤 서비스 제공'**
  String get legal_privacy_section1_body;

  /// No description provided for @legal_privacy_section2_title.
  ///
  /// In ko, this message translates to:
  /// **'2. 처리하는 개인정보 항목'**
  String get legal_privacy_section2_title;

  /// No description provided for @legal_privacy_section2_body.
  ///
  /// In ko, this message translates to:
  /// **'회사는 서비스 제공을 위해 다음의 개인정보 항목을 처리하고 있습니다.\n• 필수항목: 이메일 주소, 비밀번호, 이름(또는 닉네임), 프로필 이미지\n• 서비스 이용 과정에서 수집되는 정보: 캘린더 일정, 할 일 목록, 자산 데이터, 가족 그룹 정보, AI와의 채팅 내역, 서비스 이용 기록, 기기 정보'**
  String get legal_privacy_section2_body;

  /// No description provided for @legal_privacy_section3_title.
  ///
  /// In ko, this message translates to:
  /// **'3. 개인정보의 제3자 제공 및 위탁'**
  String get legal_privacy_section3_title;

  /// No description provided for @legal_privacy_section3_body.
  ///
  /// In ko, this message translates to:
  /// **'회사는 원활한 AI 서비스 제공(문맥 분석, 브리핑 생성 등)을 위해 입력된 데이터의 일부를 외부 AI 모델 API(예: OpenAI, Anthropic, Google 등)에 전송할 수 있습니다.\n단, 이 데이터는 서비스 제공 목적으로만 활용되며 모델 학습에 사용되지 않도록 조치합니다.'**
  String get legal_privacy_section3_body;

  /// No description provided for @legal_privacy_section4_title.
  ///
  /// In ko, this message translates to:
  /// **'4. 개인정보의 파기'**
  String get legal_privacy_section4_title;

  /// No description provided for @legal_privacy_section4_body.
  ///
  /// In ko, this message translates to:
  /// **'회사는 원칙적으로 개인정보 처리 목적이 달성된 경우에는 지체 없이 해당 개인정보를 파기합니다.\n• 파기절차: 이용자가 회원탈퇴를 요청하는 경우, 수집된 정보는 즉시 또는 법령에 따른 보존 기간 경과 후 파기됩니다.\n• 파기방법: 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다.'**
  String get legal_privacy_section4_body;

  /// No description provided for @legal_privacy_section5_title.
  ///
  /// In ko, this message translates to:
  /// **'5. 정보주체의 권리 및 행사 방법'**
  String get legal_privacy_section5_title;

  /// No description provided for @legal_privacy_section5_body.
  ///
  /// In ko, this message translates to:
  /// **'이용자는 언제든지 자신의 개인정보를 조회하거나 수정할 수 있으며, 회원 탈퇴를 통해 개인정보의 수집 및 이용 동의를 철회할 수 있습니다.'**
  String get legal_privacy_section5_body;

  /// No description provided for @legal_privacy_section6_title.
  ///
  /// In ko, this message translates to:
  /// **'6. 개인정보 보호책임자'**
  String get legal_privacy_section6_title;

  /// No description provided for @legal_privacy_section6_body.
  ///
  /// In ko, this message translates to:
  /// **'성명: 유영진\n이메일: hmn.corp.dev@gmail.com'**
  String get legal_privacy_section6_body;

  /// No description provided for @legal_privacy_section7_title.
  ///
  /// In ko, this message translates to:
  /// **'7. 시행일'**
  String get legal_privacy_section7_title;

  /// No description provided for @legal_privacy_section7_body.
  ///
  /// In ko, this message translates to:
  /// **'본 개인정보 처리방침은 2026년 6월 1일부터 적용됩니다.'**
  String get legal_privacy_section7_body;

  /// No description provided for @legal_privacyLastUpdated.
  ///
  /// In ko, this message translates to:
  /// **'시행일: 2026년 6월 1일'**
  String get legal_privacyLastUpdated;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
