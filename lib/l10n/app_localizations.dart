import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
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
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
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
