import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

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

  /// No description provided for @common_next.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get common_next;

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
  /// **'최소 6자 이상'**
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
  /// **'버전 1.0.0'**
  String get settings_appInfoSubtitle;

  /// No description provided for @settings_appDescription.
  ///
  /// In ko, this message translates to:
  /// **'가족과 함께하는 일상 플래너'**
  String get settings_appDescription;

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
  /// **'그룹을 나갔습니다'**
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
      <String>['en', 'ja', 'ko'].contains(locale.languageCode);

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
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
