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

  /// 새로고침 버튼
  ///
  /// In ko, this message translates to:
  /// **'새로고침'**
  String get common_refresh;

  /// 지표 즐겨찾기 등록 버튼
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기 추가'**
  String get investment_bookmarkAdd;

  /// 지표 즐겨찾기 해제 버튼
  ///
  /// In ko, this message translates to:
  /// **'즐겨찾기 해제'**
  String get investment_bookmarkRemove;

  /// 투표 생성 FAB
  ///
  /// In ko, this message translates to:
  /// **'투표 만들기'**
  String get vote_create;

  /// 장바구니 품목 추가 FAB
  ///
  /// In ko, this message translates to:
  /// **'품목 추가'**
  String get cart_item_add;

  /// 저금통 목표 추가 FAB
  ///
  /// In ko, this message translates to:
  /// **'저금통 추가'**
  String get savings_goal_add;

  /// 가계부 내역 추가 FAB
  ///
  /// In ko, this message translates to:
  /// **'내역 추가'**
  String get household_expense_add;

  /// 고정지출 추가 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'고정지출 추가'**
  String get household_recurring_add;

  /// 자산 계좌 추가 FAB
  ///
  /// In ko, this message translates to:
  /// **'계좌 추가'**
  String get asset_account_add;

  /// 그룹 역할 추가 FAB
  ///
  /// In ko, this message translates to:
  /// **'역할 추가'**
  String get group_role_add;

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

  /// 로그인 화면의 테스트 계정(그룹 소유자) 로그인 버튼 텍스트 (local/development 환경 전용)
  ///
  /// In ko, this message translates to:
  /// **'테스트 계정으로 로그인 (그룹 소유자)'**
  String get auth_testAccountLoginOwner;

  /// 로그인 화면의 테스트 계정(그룹 멤버) 로그인 버튼 텍스트 (local/development 환경 전용)
  ///
  /// In ko, this message translates to:
  /// **'테스트 계정으로 로그인 (그룹 멤버)'**
  String get auth_testAccountLoginMember;

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

  /// No description provided for @auth_appleLoginFailed.
  ///
  /// In ko, this message translates to:
  /// **'Apple 로그인 실패'**
  String get auth_appleLoginFailed;

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

  /// No description provided for @announcement_markdownImport.
  ///
  /// In ko, this message translates to:
  /// **'마크다운 가져오기'**
  String get announcement_markdownImport;

  /// No description provided for @announcement_markdownImportTitle.
  ///
  /// In ko, this message translates to:
  /// **'마크다운 붙여넣기'**
  String get announcement_markdownImportTitle;

  /// No description provided for @announcement_markdownImportDescription.
  ///
  /// In ko, this message translates to:
  /// **'마크다운 원문을 붙여넣으면 서식이 적용된 내용으로 변환됩니다.'**
  String get announcement_markdownImportDescription;

  /// No description provided for @announcement_markdownImportHint.
  ///
  /// In ko, this message translates to:
  /// **'# 제목\n- 목록 항목\n**굵게**'**
  String get announcement_markdownImportHint;

  /// No description provided for @announcement_markdownImportEmpty.
  ///
  /// In ko, this message translates to:
  /// **'변환할 마크다운을 입력해주세요'**
  String get announcement_markdownImportEmpty;

  /// No description provided for @announcement_markdownImportFailed.
  ///
  /// In ko, this message translates to:
  /// **'마크다운 변환에 실패했습니다'**
  String get announcement_markdownImportFailed;

  /// No description provided for @announcement_markdownImportReplace.
  ///
  /// In ko, this message translates to:
  /// **'기존 내용 대체'**
  String get announcement_markdownImportReplace;

  /// No description provided for @announcement_markdownImportReplaceDescription.
  ///
  /// In ko, this message translates to:
  /// **'끄면 커서 위치에 이어서 삽입합니다'**
  String get announcement_markdownImportReplaceDescription;

  /// No description provided for @announcement_markdownImportConvert.
  ///
  /// In ko, this message translates to:
  /// **'변환'**
  String get announcement_markdownImportConvert;

  /// No description provided for @announcement_markdownImportSuccess.
  ///
  /// In ko, this message translates to:
  /// **'마크다운을 변환했습니다'**
  String get announcement_markdownImportSuccess;

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

  /// 메모 작성 화면 개인 옵션 라벨
  ///
  /// In ko, this message translates to:
  /// **'나만의 메모'**
  String get memo_personal;

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

  /// No description provided for @memo_duplicate.
  ///
  /// In ko, this message translates to:
  /// **'복사'**
  String get memo_duplicate;

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

  /// 환불 등록 버튼
  ///
  /// In ko, this message translates to:
  /// **'환불 등록'**
  String get household_refund;

  /// 환불된 지출에 표시되는 배지
  ///
  /// In ko, this message translates to:
  /// **'환불됨'**
  String get household_refund_badge;

  /// 환불 항목(입금)에 표시되는 배지
  ///
  /// In ko, this message translates to:
  /// **'환불'**
  String get household_refund_origin_badge;

  /// 환불 금액 레이블
  ///
  /// In ko, this message translates to:
  /// **'환불 금액'**
  String get household_refund_amount_label;

  /// 환불 항목에서 원본 지출을 가리키는 레이블
  ///
  /// In ko, this message translates to:
  /// **'원본 지출'**
  String get household_refund_origin_label;

  /// 환불 항목에서 원본 지출 화면으로 이동 버튼
  ///
  /// In ko, this message translates to:
  /// **'원본 지출 보기'**
  String get household_view_refund_origin;

  /// 원본 지출에 연결된 환불 합계 레이블
  ///
  /// In ko, this message translates to:
  /// **'총 환불'**
  String get household_refund_total;

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

  /// 잔금 이월 버튼
  ///
  /// In ko, this message translates to:
  /// **'이월'**
  String get household_carry_over;

  /// 이월 확인 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'잔금 이월'**
  String get household_carry_over_title;

  /// 이월 확인 다이얼로그 설명
  ///
  /// In ko, this message translates to:
  /// **'이번 달 잔금 ₩{amount}을 다음 달로 이월합니다.\n\n· 이번 달 말일에 \'잔금 이월\' (자산이동) 지출이 등록됩니다.\n· 다음 달 1일에 \'전월 이월\' 입금이 등록됩니다.'**
  String household_carry_over_desc(String amount);

  /// 이월 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'이월이 완료되었습니다'**
  String get household_carry_over_success;

  /// 잔금 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'이월할 잔금이 없습니다'**
  String get household_carry_over_no_balance;

  /// 잔금 이동 진입 버튼
  ///
  /// In ko, this message translates to:
  /// **'잔금 이동'**
  String get household_balance_transfer;

  /// 이월 방법: 다음 달 이월
  ///
  /// In ko, this message translates to:
  /// **'다음 달 이월'**
  String get household_carry_over_mode_next_month;

  /// 이월 방법: 자산 계좌로 이동
  ///
  /// In ko, this message translates to:
  /// **'자산 계좌'**
  String get household_carry_over_mode_asset;

  /// 이월 방법: 저금통으로 이동
  ///
  /// In ko, this message translates to:
  /// **'저금통'**
  String get household_carry_over_mode_savings;

  /// 이월 금액 입력 레이블
  ///
  /// In ko, this message translates to:
  /// **'금액'**
  String get household_carry_over_amount_label;

  /// 잔금 초과 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'잔금을 초과할 수 없습니다'**
  String get household_carry_over_amount_exceeded;

  /// 자산 계좌 선택 안내
  ///
  /// In ko, this message translates to:
  /// **'계좌를 선택하세요'**
  String get household_carry_over_select_account;

  /// 저금통 선택 안내
  ///
  /// In ko, this message translates to:
  /// **'저금통을 선택하세요'**
  String get household_carry_over_select_savings;

  /// 계좌 없음 안내
  ///
  /// In ko, this message translates to:
  /// **'등록된 계좌가 없습니다'**
  String get household_carry_over_no_accounts;

  /// 저금통 없음 안내
  ///
  /// In ko, this message translates to:
  /// **'등록된 저금통이 없습니다'**
  String get household_carry_over_no_savings;

  /// 자산 이동 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'자산 이동이 완료되었습니다'**
  String get household_transfer_success;

  /// 입금 유형 레이블
  ///
  /// In ko, this message translates to:
  /// **'입금'**
  String get household_income;

  /// 거래 유형 탭 - 수입 레이블
  ///
  /// In ko, this message translates to:
  /// **'수입'**
  String get household_revenue;

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

  /// 카테고리: 이월 지출
  ///
  /// In ko, this message translates to:
  /// **'이월'**
  String get household_category_carryover;

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

  /// 입금 카테고리 선택 레이블
  ///
  /// In ko, this message translates to:
  /// **'입금 종류'**
  String get household_income_category;

  /// 입금 카테고리: 월급
  ///
  /// In ko, this message translates to:
  /// **'월급'**
  String get household_income_category_salary;

  /// 입금 카테고리: 용돈
  ///
  /// In ko, this message translates to:
  /// **'용돈'**
  String get household_income_category_allowance;

  /// 입금 카테고리: 전월 이월
  ///
  /// In ko, this message translates to:
  /// **'이월'**
  String get household_income_category_carryover;

  /// 입금 카테고리: 상여금
  ///
  /// In ko, this message translates to:
  /// **'상여금'**
  String get household_income_category_bonus;

  /// 입금 카테고리: 이자 수익
  ///
  /// In ko, this message translates to:
  /// **'이자 수익'**
  String get household_income_category_interest;

  /// 입금 카테고리: 임대 수익
  ///
  /// In ko, this message translates to:
  /// **'임대 수익'**
  String get household_income_category_rental;

  /// 입금 카테고리: 부업
  ///
  /// In ko, this message translates to:
  /// **'부업'**
  String get household_income_category_side_income;

  /// 입금 카테고리: 계좌이체 입금
  ///
  /// In ko, this message translates to:
  /// **'계좌이체'**
  String get household_income_category_transfer_in;

  /// 입금 카테고리: 기타 수입
  ///
  /// In ko, this message translates to:
  /// **'기타 수입'**
  String get household_income_category_other;

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

  /// 고정 지출 합계 레이블
  ///
  /// In ko, this message translates to:
  /// **'지출 합계'**
  String get household_recurring_expense_total;

  /// 고정 수입 합계 레이블
  ///
  /// In ko, this message translates to:
  /// **'수입 합계'**
  String get household_recurring_income_total;

  /// 이번달 남은 고정 지출
  ///
  /// In ko, this message translates to:
  /// **'지출 {count}건 · ₩{amount}'**
  String household_unpaid_recurring_expense(int count, String amount);

  /// 이번달 남은 고정 수입
  ///
  /// In ko, this message translates to:
  /// **'수입 {count}건 · ₩{amount}'**
  String household_unpaid_recurring_income(int count, String amount);

  /// 고정 지출 카테고리별 분포 레이블
  ///
  /// In ko, this message translates to:
  /// **'카테고리별 분포'**
  String get household_recurring_top_category;

  /// 고정 금액 고정지출 타입 레이블
  ///
  /// In ko, this message translates to:
  /// **'고정'**
  String get household_recurring_fixed;

  /// 가변 금액 고정지출 타입 레이블
  ///
  /// In ko, this message translates to:
  /// **'가변'**
  String get household_recurring_variable;

  /// 고정 지출 유형 선택 레이블
  ///
  /// In ko, this message translates to:
  /// **'고정 지출 유형'**
  String get household_recurring_type_label;

  /// 고정 지출 없음 옵션
  ///
  /// In ko, this message translates to:
  /// **'없음'**
  String get household_recurring_type_none;

  /// 매월 동일한 금액이 지출되는 고정 지출
  ///
  /// In ko, this message translates to:
  /// **'고정 금액'**
  String get household_recurring_type_fixed;

  /// 고정 금액 고정지출 설명
  ///
  /// In ko, this message translates to:
  /// **'매월 동일한 금액이 반영됩니다'**
  String get household_recurring_type_fixed_desc;

  /// 매월 금액이 달라지는 가변 고정 지출
  ///
  /// In ko, this message translates to:
  /// **'가변 금액'**
  String get household_recurring_type_variable;

  /// 가변 금액 고정지출 설명
  ///
  /// In ko, this message translates to:
  /// **'매월 발생하지만 금액이 달라집니다 (예: 관리비)'**
  String get household_recurring_type_variable_desc;

  /// 가변 고정지출 금액 입력 레이블
  ///
  /// In ko, this message translates to:
  /// **'기준 금액 (예상)'**
  String get household_recurring_amount_variable_label;

  /// 가변 금액 안내 텍스트
  ///
  /// In ko, this message translates to:
  /// **'매월 금액이 다를 수 있습니다. 실제 지출 발생 후 수정해 확정해주세요.'**
  String get household_recurring_amount_variable_hint;

  /// 고정 금액 안내 텍스트
  ///
  /// In ko, this message translates to:
  /// **'매월 이 금액으로 자동 등록됩니다.'**
  String get household_recurring_amount_fixed_hint;

  /// 고정지출 비활성 배지
  ///
  /// In ko, this message translates to:
  /// **'비활성'**
  String get household_recurring_inactive;

  /// 고정지출 수정 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'고정지출 수정'**
  String get household_recurring_edit;

  /// 고정 내역 화면 제목 (수입/지출 모두 포함)
  ///
  /// In ko, this message translates to:
  /// **'고정 내역'**
  String get household_recurring_title;

  /// 고정 내역 추가 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'고정 내역 추가'**
  String get household_recurring_add_title;

  /// 고정 내역 수정 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'고정 내역 수정'**
  String get household_recurring_edit_title;

  /// 매달 발생 일 선택 레이블
  ///
  /// In ko, this message translates to:
  /// **'매달 발생 일'**
  String get household_recurring_day_of_month;

  /// 매달 발생 일 값
  ///
  /// In ko, this message translates to:
  /// **'매월 {day}일'**
  String household_recurring_day_of_month_value(int day);

  /// 소급 등록 토글 레이블
  ///
  /// In ko, this message translates to:
  /// **'이전 지출도 등록하기'**
  String get household_recurring_backfill_toggle;

  /// 소급 등록 안내 문구
  ///
  /// In ko, this message translates to:
  /// **'시작 월을 선택하면 오늘까지의 지출 내역이 함께 생성돼요'**
  String get household_recurring_backfill_hint;

  /// 고정지출 시작 월 선택 레이블
  ///
  /// In ko, this message translates to:
  /// **'시작 월'**
  String get household_recurring_start_month;

  /// 반복 종료 옵션 선택 레이블
  ///
  /// In ko, this message translates to:
  /// **'반복 종료'**
  String get household_recurring_end_option;

  /// 무기한 반복 옵션
  ///
  /// In ko, this message translates to:
  /// **'무기한'**
  String get household_recurring_end_indefinite;

  /// 개월 수 지정 옵션 (할부 등)
  ///
  /// In ko, this message translates to:
  /// **'개월 수 지정'**
  String get household_recurring_end_fixed_months;

  /// 총 반복 개월 수 입력 레이블
  ///
  /// In ko, this message translates to:
  /// **'총 개월 수'**
  String get household_recurring_total_months_label;

  /// 총 반복 개월 수 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 24'**
  String get household_recurring_total_months_hint;

  /// 총 반복 개월 수 필수 입력 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'개월 수를 입력해주세요'**
  String get household_recurring_total_months_required;

  /// 종료 예정 안내 문구
  ///
  /// In ko, this message translates to:
  /// **'{endMonth}까지 ({current}/{total}개월차)'**
  String household_recurring_end_date_info(
    String endMonth,
    int current,
    int total,
  );

  /// 무기한 반복 안내 문구
  ///
  /// In ko, this message translates to:
  /// **'무기한 반복'**
  String get household_recurring_indefinite;

  /// 수정 화면 소급 재실행 안내 문구
  ///
  /// In ko, this message translates to:
  /// **'시작 월/개월 수를 변경해도 과거 지출은 다시 생성되지 않아요. 소급 생성은 등록 시에만 적용됩니다.'**
  String get household_recurring_edit_backfill_notice;

  /// 가변 고정 지출 예상 금액 레이블
  ///
  /// In ko, this message translates to:
  /// **'예상 금액'**
  String get household_estimated_amount;

  /// 예상 금액 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'이번 달 예상 금액을 입력하세요'**
  String get household_estimated_amount_hint;

  /// 예상 금액 필수 입력 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'예상 금액을 입력해주세요'**
  String get household_estimated_amount_required;

  /// 가변 고정지출 배지 텍스트
  ///
  /// In ko, this message translates to:
  /// **'가변'**
  String get household_variable_badge;

  /// 실제 금액 미확인 상태 배지
  ///
  /// In ko, this message translates to:
  /// **'미확인'**
  String get household_unconfirmed_badge;

  /// 통계/일별 합산에서 환불 항목 제외 체크버튼
  ///
  /// In ko, this message translates to:
  /// **'환불 제외'**
  String get household_exclude_refunds;

  /// 통계/일별 합산에서 이월 항목 제외 체크버튼
  ///
  /// In ko, this message translates to:
  /// **'이월 제외'**
  String get household_exclude_carryover;

  /// 이번 달 아직 발생하지 않은 고정 내역 배너 제목
  ///
  /// In ko, this message translates to:
  /// **'이번 달 남은 고정 내역'**
  String get household_unpaid_recurring_title;

  /// 미치뤄진 고정 지출 건수 및 예상 합계
  ///
  /// In ko, this message translates to:
  /// **'{count}건 · 예상 합계 ₩{amount}'**
  String household_unpaid_recurring_subtitle(int count, String amount);

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
  /// **'수익률'**
  String get asset_trend_profit_rate;

  /// 추이 차트 - 기간별 수익률 탭 (전월/전년 대비)
  ///
  /// In ko, this message translates to:
  /// **'기간별'**
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

  /// 파이차트 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'계좌별 비중'**
  String get asset_pie_chart_title;

  /// 파이차트 모드 - 유형별
  ///
  /// In ko, this message translates to:
  /// **'유형별'**
  String get asset_pie_mode_type;

  /// 파이차트 모드 - 계좌별
  ///
  /// In ko, this message translates to:
  /// **'계좌별'**
  String get asset_pie_mode_account;

  /// 파이차트 모드 - 포트폴리오 합산
  ///
  /// In ko, this message translates to:
  /// **'포트폴리오 합산'**
  String get asset_pie_mode_portfolio;

  /// 포트폴리오 데이터 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'포트폴리오 데이터가 없습니다'**
  String get asset_pie_no_portfolio;

  /// 비교 차트 - 내 자산 라인 레이블
  ///
  /// In ko, this message translates to:
  /// **'내 자산'**
  String get asset_compare_my_asset;

  /// 비교 차트 - 달러 환산 라인 레이블
  ///
  /// In ko, this message translates to:
  /// **'달러 환산'**
  String get asset_compare_usd_label;

  /// 지수 비교 모드 토글 버튼
  ///
  /// In ko, this message translates to:
  /// **'비교'**
  String get asset_compare_button;

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

  /// 보관소 이름 입력 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'보관소 이름'**
  String get fridge_storage_name;

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
  /// **'총액 (항목 금액 입력 시 자동 계산)'**
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

  /// 구매 이력 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'이력 삭제'**
  String get fridge_history_delete;

  /// 삭제 확인 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'구매 이력 삭제'**
  String get fridge_history_delete_confirm_title;

  /// 삭제 확인 다이얼로그 본문
  ///
  /// In ko, this message translates to:
  /// **'이 구매 이력을 삭제할까요?'**
  String get fridge_history_delete_confirm_body;

  /// 가계부 연동 이력 삭제 안내
  ///
  /// In ko, this message translates to:
  /// **'가계부에 연동된 지출은 장보기 이력을 삭제해도 가계부에 그대로 남아 있어요.'**
  String get fridge_history_delete_expense_notice;

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

  /// 대시보드 요약 위젯에서 데이터 로드 실패 시 표시
  ///
  /// In ko, this message translates to:
  /// **'불러오지 못했습니다'**
  String get dashboard_loadFailed;

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

  /// No description provided for @weather_fallbackLocationNotice.
  ///
  /// In ko, this message translates to:
  /// **'현재 위치를 가져오지 못해 서울 날씨를 표시하고 있습니다'**
  String get weather_fallbackLocationNotice;

  /// No description provided for @weather_enableLocationAction.
  ///
  /// In ko, this message translates to:
  /// **'위치 권한 허용하기'**
  String get weather_enableLocationAction;

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

  /// 구매 이력 삭제 확인 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'구매 이력 삭제'**
  String get shopping_history_delete_title;

  /// 구매 이력 삭제 확인 본문
  ///
  /// In ko, this message translates to:
  /// **'이 장보기 기록을 삭제하시겠습니까?'**
  String get shopping_history_delete_body;

  /// 구매 이력 삭제 시 가계부/냉장고 데이터 유지 안내
  ///
  /// In ko, this message translates to:
  /// **'가계부 지출 내역과 냉장고 보관 품목은 삭제되지 않고 유지됩니다.'**
  String get shopping_history_delete_notice;

  /// 구매 이력 전체 장바구니 다시 담기 버튼
  ///
  /// In ko, this message translates to:
  /// **'이 리스트 그대로 장바구니에 담기'**
  String get shopping_history_readd_all;

  /// 전체 담기 스낵바
  ///
  /// In ko, this message translates to:
  /// **'{count}개 항목을 장바구니에 담았습니다.'**
  String shopping_history_readd_all_snackbar(int count);

  /// 개별 담기 스낵바
  ///
  /// In ko, this message translates to:
  /// **'{name}을(를) 장바구니에 담았습니다.'**
  String shopping_history_readd_item_snackbar(String name);

  /// 가격 미입력 표시
  ///
  /// In ko, this message translates to:
  /// **'가격 미입력'**
  String get shopping_history_price_none;

  /// 개별 항목 장바구니 담기 툴팁
  ///
  /// In ko, this message translates to:
  /// **'장바구니에 담기'**
  String get shopping_history_add_to_cart;

  /// 냉장고 이관 완료 툴팁
  ///
  /// In ko, this message translates to:
  /// **'냉장고에 이관됨'**
  String get shopping_history_fridge_transferred;

  /// 냉장고 미이관 툴팁
  ///
  /// In ko, this message translates to:
  /// **'이관 안 함'**
  String get shopping_history_fridge_not_transferred;

  /// 장보기 완료 스낵바
  ///
  /// In ko, this message translates to:
  /// **'장보기가 완료되었습니다.'**
  String get shopping_complete_snackbar;

  /// 계정 관리 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'계정 관리'**
  String get account_management_title;

  /// 계정 삭제 예약 버튼
  ///
  /// In ko, this message translates to:
  /// **'계정 삭제 예약'**
  String get account_delete_schedule_title;

  /// 계정 삭제 예약 설명
  ///
  /// In ko, this message translates to:
  /// **'7일 유예 후 모든 데이터 삭제'**
  String get account_delete_schedule_subtitle;

  /// 계정 삭제 예약 확인 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'계정 삭제를 예약하시겠습니까?'**
  String get account_delete_schedule_confirm_title;

  /// 계정 삭제 예약 확인 다이얼로그 본문
  ///
  /// In ko, this message translates to:
  /// **'7일 후 계정과 모든 데이터가 영구 삭제됩니다.\n유예 기간 중에는 취소할 수 있습니다.'**
  String get account_delete_schedule_confirm_body;

  /// 계정 삭제 예약 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'계정 삭제가 예약되었습니다. {date}에 삭제됩니다.'**
  String account_delete_schedule_success(String date);

  /// 계정 삭제 예약 취소 버튼
  ///
  /// In ko, this message translates to:
  /// **'계정 삭제 예약 취소'**
  String get account_cancel_delete_title;

  /// 계정 삭제 취소 설명
  ///
  /// In ko, this message translates to:
  /// **'예약된 계정 삭제를 취소합니다'**
  String get account_cancel_delete_subtitle;

  /// 계정 삭제 취소 확인 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'계정 삭제 예약을 취소하시겠습니까?'**
  String get account_cancel_delete_confirm_title;

  /// 계정 삭제 취소 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'계정 삭제 예약이 취소되었습니다'**
  String get account_cancel_delete_success;

  /// 데이터 내보내기 버튼
  ///
  /// In ko, this message translates to:
  /// **'내 데이터 내보내기'**
  String get account_export_data_title;

  /// 데이터 내보내기 설명
  ///
  /// In ko, this message translates to:
  /// **'등록된 이메일로 데이터 사본을 보내드립니다'**
  String get account_export_data_subtitle;

  /// 데이터 내보내기 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'요청이 완료되었습니다. 이메일을 확인해 주세요.'**
  String get account_export_data_success;

  /// 계정 작업 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다: {error}'**
  String account_action_failed(String error);

  /// 무료 구독 티어 이름
  ///
  /// In ko, this message translates to:
  /// **'무료 플랜'**
  String get subscription_free_label;

  /// 무료 플랜 설명
  ///
  /// In ko, this message translates to:
  /// **'광고가 표시됩니다'**
  String get subscription_free_sublabel;

  /// 체험 구독 티어 이름
  ///
  /// In ko, this message translates to:
  /// **'2주 무료 체험 중'**
  String get subscription_trial_label;

  /// 체험 남은 일수
  ///
  /// In ko, this message translates to:
  /// **'{days}일 후 무료 플랜으로 전환됩니다'**
  String subscription_trial_sublabel_days(int days);

  /// 체험 당일 안내
  ///
  /// In ko, this message translates to:
  /// **'오늘 체험이 종료됩니다'**
  String get subscription_trial_sublabel_today;

  /// 광고 제거 구독 티어 이름
  ///
  /// In ko, this message translates to:
  /// **'광고 제거'**
  String get subscription_ad_free_label;

  /// 광고 제거 만료일
  ///
  /// In ko, this message translates to:
  /// **'{date} 까지'**
  String subscription_ad_free_sublabel_expires(String date);

  /// 광고 제거 무기한 안내
  ///
  /// In ko, this message translates to:
  /// **'광고 없이 이용 중'**
  String get subscription_ad_free_sublabel_active;

  /// 프리미엄 구독 티어 이름
  ///
  /// In ko, this message translates to:
  /// **'Premium'**
  String get subscription_premium_label;

  /// 프리미엄 만료일
  ///
  /// In ko, this message translates to:
  /// **'{date} 까지'**
  String subscription_premium_sublabel_expires(String date);

  /// 프리미엄 무기한 안내
  ///
  /// In ko, this message translates to:
  /// **'모든 기능 이용 중'**
  String get subscription_premium_sublabel_active;

  /// 대시보드 체험 배너 제목
  ///
  /// In ko, this message translates to:
  /// **'광고 없는 2주 무료 체험 중'**
  String get dashboard_trial_banner_title;

  /// 대시보드 체험 배너 남은 일수
  ///
  /// In ko, this message translates to:
  /// **'{days}일 후 일반 플랜으로 전환됩니다'**
  String dashboard_trial_banner_sublabel_days(int days);

  /// 대시보드 체험 배너 당일 안내
  ///
  /// In ko, this message translates to:
  /// **'오늘 체험이 종료됩니다'**
  String get dashboard_trial_banner_sublabel_today;

  /// 기념일 대시보드 위젯 제목
  ///
  /// In ko, this message translates to:
  /// **'다가오는 기념일'**
  String get anniversary_widgetTitle;

  /// 기념일 위젯 빈 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'등록된 기념일이 없습니다'**
  String get anniversary_widgetEmpty;

  /// 위젯 설정 - 기념일 위젯 이름
  ///
  /// In ko, this message translates to:
  /// **'기념일'**
  String get widgetSettings_anniversarySummary;

  /// 위젯 설정 - 기념일 위젯 설명
  ///
  /// In ko, this message translates to:
  /// **'다가오는 기념일과 D-day를 표시합니다'**
  String get widgetSettings_anniversarySummaryDesc;

  /// 더보기 탭의 구독 관리 메뉴 타이틀
  ///
  /// In ko, this message translates to:
  /// **'구독 관리'**
  String get subscription_manage_title;

  /// 구독 관리 화면 AppBar 타이틀
  ///
  /// In ko, this message translates to:
  /// **'구독 관리'**
  String get subscription_screen_title;

  /// 구독 관리 화면 현재 플랜 섹션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'현재 플랜'**
  String get subscription_current_plan_label;

  /// 구독 활성 여부 라벨
  ///
  /// In ko, this message translates to:
  /// **'활성 여부'**
  String get subscription_active_status_label;

  /// 구독 활성 상태 값
  ///
  /// In ko, this message translates to:
  /// **'활성'**
  String get subscription_active;

  /// 구독 비활성 상태 값
  ///
  /// In ko, this message translates to:
  /// **'비활성'**
  String get subscription_inactive;

  /// 구독 만료일 라벨
  ///
  /// In ko, this message translates to:
  /// **'만료일'**
  String get subscription_expires_at_label;

  /// 구독 남은 기간 라벨
  ///
  /// In ko, this message translates to:
  /// **'남은 기간'**
  String get subscription_days_left_label;

  /// 구독 남은 일수 값
  ///
  /// In ko, this message translates to:
  /// **'{days}일'**
  String subscription_days_left_value(int days);

  /// 구독이 오늘 끝날 때 표시하는 값
  ///
  /// In ko, this message translates to:
  /// **'오늘 종료'**
  String get subscription_days_left_today;

  /// 무료 체험 종료일 라벨
  ///
  /// In ko, this message translates to:
  /// **'체험 종료일'**
  String get subscription_trial_ends_at_label;

  /// 유료 구독의 현재 이용 기간 종료일 라벨
  ///
  /// In ko, this message translates to:
  /// **'이용 기간 종료일'**
  String get subscription_period_end_label;

  /// 이용 기간 종료일 아래 자동 갱신 안내
  ///
  /// In ko, this message translates to:
  /// **'해지하지 않으면 이 날짜에 자동으로 갱신됩니다'**
  String get subscription_auto_renew_hint;

  /// 자동 갱신 예약된 구독의 다음 결제일 라벨
  ///
  /// In ko, this message translates to:
  /// **'다음 갱신일'**
  String get subscription_next_renewal_label;

  /// 자동 갱신이 꺼진 구독의 안내
  ///
  /// In ko, this message translates to:
  /// **'구독이 해지되어 이 날짜에 종료됩니다'**
  String get subscription_canceled_hint;

  /// 구독 상품 목록 섹션 타이틀
  ///
  /// In ko, this message translates to:
  /// **'구독 상품'**
  String get subscription_products_section_title;

  /// 구독 구매 버튼
  ///
  /// In ko, this message translates to:
  /// **'구독하기'**
  String get subscription_purchase_button;

  /// 구독 복원 버튼
  ///
  /// In ko, this message translates to:
  /// **'구독 복원'**
  String get subscription_restore_button;

  /// 구독 구매 성공 스낵바 메시지
  ///
  /// In ko, this message translates to:
  /// **'구독이 완료되었습니다.'**
  String get subscription_purchase_success;

  /// 구매 검증 실패(422) 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'구매 확인 실패'**
  String get subscription_verify_failed_title;

  /// 구매 검증 실패(422) 다이얼로그 본문
  ///
  /// In ko, this message translates to:
  /// **'이미 사용된 구매이거나 검증에 실패했습니다. 문제가 지속되면 고객센터에 문의해주세요.'**
  String get subscription_verify_failed_message;

  /// 구매 검증 중 네트워크 오류 스낵바 메시지
  ///
  /// In ko, this message translates to:
  /// **'네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.'**
  String get subscription_verify_network_error;

  /// 구독 복원 성공 스낵바 메시지
  ///
  /// In ko, this message translates to:
  /// **'구독이 복원되었습니다.'**
  String get subscription_restore_success;

  /// 스토어에서 상품을 찾을 수 없을 때 안내 메시지
  ///
  /// In ko, this message translates to:
  /// **'구독 상품을 준비 중입니다. 잠시 후 다시 시도해주세요.'**
  String get subscription_product_not_found;

  /// 광고 제거 상품 혜택 설명
  ///
  /// In ko, this message translates to:
  /// **'앱 내 모든 광고가 표시되지 않습니다.'**
  String get subscription_ad_free_benefit;

  /// 월 단위 구독 기간 라벨
  ///
  /// In ko, this message translates to:
  /// **'월간 구독'**
  String get subscription_period_monthly;

  /// 자동 갱신 고지 (App Store Guideline 3.1.2 필수)
  ///
  /// In ko, this message translates to:
  /// **'구독은 매월 자동으로 갱신되며, 현재 구독 기간이 끝나기 24시간 전까지 해지하지 않으면 동일한 금액이 결제됩니다. 구매 확정 시 스토어 계정으로 결제되며, 구독 관리 및 해지는 기기의 스토어 계정 설정에서 언제든지 할 수 있습니다.'**
  String get subscription_auto_renew_notice;

  /// 스토어 구독 관리 화면으로 이동하는 버튼
  ///
  /// In ko, this message translates to:
  /// **'구독 관리 및 해지'**
  String get subscription_manage_subscription_button;

  /// 구독 화면 이용약관 링크
  ///
  /// In ko, this message translates to:
  /// **'이용약관'**
  String get subscription_terms_button;

  /// 구독 화면 개인정보 처리방침 링크
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get subscription_privacy_button;

  /// 스토어 구독 관리 화면 실행 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'스토어 구독 관리 화면을 열 수 없습니다.'**
  String get subscription_manage_launch_failed;

  /// 플랜 비교 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'플랜 비교'**
  String get subscription_compare_title;

  /// 현재 사용 중인 플랜 표시
  ///
  /// In ko, this message translates to:
  /// **'이용 중'**
  String get subscription_plan_current;

  /// 플랜 혜택 - 모든 기능
  ///
  /// In ko, this message translates to:
  /// **'모든 기능 이용'**
  String get subscription_benefit_all_features;

  /// 무료 플랜 - 광고 표시
  ///
  /// In ko, this message translates to:
  /// **'광고가 표시됩니다'**
  String get subscription_benefit_ads_shown;

  /// 광고 제거 플랜 - 광고 없음
  ///
  /// In ko, this message translates to:
  /// **'광고 없이 이용'**
  String get subscription_benefit_no_ads;

  /// 광고 제거 플랜 - 보상형 광고 불필요
  ///
  /// In ko, this message translates to:
  /// **'기능 사용 시 광고 시청 불필요'**
  String get subscription_benefit_no_reward_ads;

  /// 광고 제거 플랜 - 해지 자유
  ///
  /// In ko, this message translates to:
  /// **'언제든 해지 가능'**
  String get subscription_benefit_cancel_anytime;

  /// 무료 플랜 가격 표시
  ///
  /// In ko, this message translates to:
  /// **'₩0'**
  String get subscription_free_plan_price;

  /// 루틴 메인 타이틀
  ///
  /// In ko, this message translates to:
  /// **'루틴'**
  String get routine_title;

  /// 루틴 목록 날짜 선택기에서 오늘로 돌아가는 버튼
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get routine_date_today;

  /// 루틴 목록 순서변경 편집 모드 진입 버튼
  ///
  /// In ko, this message translates to:
  /// **'순서변경'**
  String get routine_reorder;

  /// 루틴 목록 순서변경 편집 모드 종료 버튼
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get routine_reorder_done;

  /// 습관 목록 비어있을 때 안내
  ///
  /// In ko, this message translates to:
  /// **'등록된 습관이 없습니다'**
  String get routine_list_empty;

  /// 습관 목록 빈 상태 부가 설명
  ///
  /// In ko, this message translates to:
  /// **'매일 반복하고 싶은 습관을 등록하고\n꾸준히 체크하며 스트릭을 쌓아보세요'**
  String get routine_list_empty_subtitle;

  /// 습관 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'습관 추가'**
  String get routine_add;

  /// 습관 수정 버튼/타이틀
  ///
  /// In ko, this message translates to:
  /// **'습관 수정'**
  String get routine_edit;

  /// 습관 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'습관 삭제'**
  String get routine_delete;

  /// 습관 삭제 확인 다이얼로그
  ///
  /// In ko, this message translates to:
  /// **'이 습관을 삭제하시겠습니까?'**
  String get routine_delete_confirm;

  /// 습관 제목 입력 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'제목'**
  String get routine_field_title;

  /// 습관 제목 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 아침 스트레칭'**
  String get routine_field_title_hint;

  /// 제목 미입력 시 유효성 검사 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'제목을 입력해주세요'**
  String get routine_field_title_required;

  /// 제목 길이 초과 시 유효성 검사 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'제목은 100자 이내로 입력해주세요'**
  String get routine_field_title_too_long;

  /// 습관 이모지 입력 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'이모지'**
  String get routine_field_emoji;

  /// 이모지 직접 입력 필드 라벨 (프리셋에 없는 이모지용)
  ///
  /// In ko, this message translates to:
  /// **'직접 입력'**
  String get routine_field_emoji_custom;

  /// 이모지 입력 필드 도움말
  ///
  /// In ko, this message translates to:
  /// **'이모지 하나를 입력해주세요 (예: 🏃)'**
  String get routine_field_emoji_helper;

  /// 습관 색상 선택 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'색상'**
  String get routine_field_color;

  /// 주간 목표 체크 횟수 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'주 목표 횟수'**
  String get routine_field_target_count;

  /// 월간 목표 체크 횟수 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'월 목표 횟수'**
  String get routine_field_target_count_month;

  /// 이번 달 진행 상황 라벨
  ///
  /// In ko, this message translates to:
  /// **'이번 달 진행'**
  String get routine_this_month_progress;

  /// 습관 시작일 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'시작일'**
  String get routine_field_start_date;

  /// 습관 종료일 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'종료일 (선택)'**
  String get routine_field_end_date;

  /// 종료일 미지정 표시
  ///
  /// In ko, this message translates to:
  /// **'무기한'**
  String get routine_field_end_date_none;

  /// 습관이 소속될 루틴(묶음) 선택 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'소속 루틴'**
  String get routine_field_group;

  /// 소속 루틴 없음 옵션
  ///
  /// In ko, this message translates to:
  /// **'없음 (독립 습관)'**
  String get routine_field_group_none;

  /// 습관 저장 버튼
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get routine_save;

  /// 습관 체크 액션
  ///
  /// In ko, this message translates to:
  /// **'체크'**
  String get routine_check;

  /// 습관 체크 취소 액션
  ///
  /// In ko, this message translates to:
  /// **'체크 취소'**
  String get routine_uncheck;

  /// 중복 체크(409) 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'이미 체크했습니다'**
  String get routine_check_already;

  /// 미래 날짜 체크(400) 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'미래 날짜는 체크할 수 없습니다'**
  String get routine_check_future_date;

  /// 체크 처리 실패 일반 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'체크에 실패했습니다'**
  String get routine_check_error;

  /// 체크 후 스트릭이 갱신되었을 때 축하 스낵바 메시지
  ///
  /// In ko, this message translates to:
  /// **'🔥 {days}일 연속 달성!'**
  String routine_streak_celebration(int days);

  /// 루틴 상세 히트맵 탭
  ///
  /// In ko, this message translates to:
  /// **'달력'**
  String get routine_tab_heatmap;

  /// 루틴 상세 통계 탭
  ///
  /// In ko, this message translates to:
  /// **'통계'**
  String get routine_tab_stats;

  /// 현재 연속 체크 일수 라벨
  ///
  /// In ko, this message translates to:
  /// **'현재 연속 일수'**
  String get routine_streak_current_days;

  /// 최장 연속 체크 일수 라벨
  ///
  /// In ko, this message translates to:
  /// **'최장 연속 일수'**
  String get routine_streak_longest_days;

  /// 현재 연속 달성 주 수 라벨
  ///
  /// In ko, this message translates to:
  /// **'현재 연속 주'**
  String get routine_streak_current_weeks;

  /// 최장 연속 달성 주 수 라벨
  ///
  /// In ko, this message translates to:
  /// **'최장 연속 주'**
  String get routine_streak_longest_weeks;

  /// 현재 연속 달성 개월 수 라벨 (월간 습관 전용)
  ///
  /// In ko, this message translates to:
  /// **'현재 연속 달'**
  String get routine_streak_current_months;

  /// 최장 연속 달성 개월 수 라벨 (월간 습관 전용)
  ///
  /// In ko, this message translates to:
  /// **'최장 연속 달'**
  String get routine_streak_longest_months;

  /// 월간 습관의 이번 달 진행 상황 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'이번 달 진행'**
  String get routine_this_month_progress_label;

  /// 배지 화면 상단 설명 — 배지가 일일 목표 기준임을 안내
  ///
  /// In ko, this message translates to:
  /// **'오늘의 목표를 달성하며 모은 배지예요'**
  String get routine_badges_goal_subtitle;

  /// 목록에서 목표 포함 습관을 나타내는 깃발 아이콘의 툴팁
  ///
  /// In ko, this message translates to:
  /// **'오늘의 목표에 포함된 습관'**
  String get routine_daily_goal_included_badge;

  /// 목표 습관 필터가 켜졌을 때 진행 바에 표시되는 안내
  ///
  /// In ko, this message translates to:
  /// **'목표 습관만 보는 중'**
  String get routine_daily_goal_filter_on;

  /// 진행 바를 탭하면 필터가 켜진다는 안내
  ///
  /// In ko, this message translates to:
  /// **'탭하면 목표 습관만 볼 수 있어요'**
  String get routine_daily_goal_filter_hint;

  /// 루틴 온보딩 1단계 제목
  ///
  /// In ko, this message translates to:
  /// **'습관 만들기'**
  String get routine_coach_add_title;

  /// 루틴 온보딩 1단계 설명
  ///
  /// In ko, this message translates to:
  /// **'매일 반복하고 싶은 일을 습관으로 등록해보세요.\n여러 습관을 묶어 하나의 루틴으로 만들 수도 있어요.'**
  String get routine_coach_add_desc;

  /// 루틴 온보딩 2단계 제목
  ///
  /// In ko, this message translates to:
  /// **'오늘의 목표'**
  String get routine_coach_goal_title;

  /// 루틴 온보딩 2단계 설명 — 일일 목표 개념
  ///
  /// In ko, this message translates to:
  /// **'습관을 전부 못 채워도 괜찮아요.\n정해둔 개수만 채우면 그날은 성공이에요.\n연속으로 달성하면 배지도 받을 수 있어요.'**
  String get routine_coach_goal_desc;

  /// 루틴 온보딩 3단계 제목
  ///
  /// In ko, this message translates to:
  /// **'목표에 포함된 습관'**
  String get routine_coach_flag_title;

  /// 루틴 온보딩 3단계 설명 — 깃발 표시와 필터
  ///
  /// In ko, this message translates to:
  /// **'깃발이 붙은 습관이 오늘의 목표에 들어가요.\n위의 목표 막대를 누르면 이 습관만 모아볼 수 있어요.'**
  String get routine_coach_flag_desc;

  /// 루틴 온보딩 4단계 제목
  ///
  /// In ko, this message translates to:
  /// **'체크하기'**
  String get routine_coach_check_title;

  /// 루틴 온보딩 4단계 설명
  ///
  /// In ko, this message translates to:
  /// **'동그라미를 눌러 완료 표시를 하세요.\n기록형 습관은 시간이나 횟수도 함께 남길 수 있어요.'**
  String get routine_coach_check_desc;

  /// 온보딩 예시 습관 이름 1
  ///
  /// In ko, this message translates to:
  /// **'아침 스트레칭'**
  String get routine_coach_demo_habit_1;

  /// 온보딩 예시 습관 이름 2
  ///
  /// In ko, this message translates to:
  /// **'물 2L 마시기'**
  String get routine_coach_demo_habit_2;

  /// 온보딩 예시 습관 이름 3
  ///
  /// In ko, this message translates to:
  /// **'책 30분 읽기'**
  String get routine_coach_demo_habit_3;

  /// 루틴 온보딩 건너뛰기 버튼
  ///
  /// In ko, this message translates to:
  /// **'건너뛰기'**
  String get routine_coach_skip;

  /// 목록 온보딩 - 그룹 기능 안내 단계 제목
  ///
  /// In ko, this message translates to:
  /// **'그룹과 함께하기'**
  String get routine_coach_together_title;

  /// 목록 온보딩 - 그룹 기능 안내 단계 설명
  ///
  /// In ko, this message translates to:
  /// **'가족이나 친구 그룹과 습관을 공유할 수 있어요.\n서로의 현황을 보고, 함께 챌린지도 할 수 있어요.'**
  String get routine_coach_together_desc;

  /// 함께하기 온보딩 1단계 제목
  ///
  /// In ko, this message translates to:
  /// **'그룹원 현황'**
  String get routine_together_coach_status_title;

  /// 함께하기 온보딩 1단계 설명
  ///
  /// In ko, this message translates to:
  /// **'그룹원들이 오늘 어떤 습관을 했는지 볼 수 있어요.\n이름을 누르면 자세한 기록도 확인할 수 있어요.'**
  String get routine_together_coach_status_desc;

  /// 함께하기 온보딩 2단계 제목
  ///
  /// In ko, this message translates to:
  /// **'랭킹과 챌린지'**
  String get routine_together_coach_tabs_title;

  /// 함께하기 온보딩 2단계 설명
  ///
  /// In ko, this message translates to:
  /// **'랭킹에서는 목표 달성률로 순위를 겨뤄요.\n챌린지는 기간을 정해 함께 목표에 도전하고,\n내기를 걸 수도 있어요.'**
  String get routine_together_coach_tabs_desc;

  /// 함께하기 온보딩 3단계 제목
  ///
  /// In ko, this message translates to:
  /// **'공유 설정'**
  String get routine_together_coach_settings_title;

  /// 함께하기 온보딩 3단계 설명
  ///
  /// In ko, this message translates to:
  /// **'어느 그룹에 내 습관을 보여줄지 정해요.\n숨기고 싶은 습관은 \'비공개\'로 표시하면\n그룹원에게 보이지 않아요.'**
  String get routine_together_coach_settings_desc;

  /// 이번 주 진행 상황 라벨
  ///
  /// In ko, this message translates to:
  /// **'이번 주 진행'**
  String get routine_this_week_progress;

  /// 히트맵 탭 주간 달성 스트립 제목
  ///
  /// In ko, this message translates to:
  /// **'최근 8주 달성 현황'**
  String get routine_weekly_strip_title;

  /// 달성률 기간 단위 - 주
  ///
  /// In ko, this message translates to:
  /// **'주'**
  String get routine_rate_period_week;

  /// 달성률 기간 단위 - 월
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get routine_rate_period_month;

  /// 달성률 기간 단위 - 커스텀
  ///
  /// In ko, this message translates to:
  /// **'기간 지정'**
  String get routine_rate_period_custom;

  /// 기간별 달성률 라벨
  ///
  /// In ko, this message translates to:
  /// **'달성률'**
  String get routine_rate_achievement;

  /// 루틴 공유 그룹 관리 화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'공유 그룹 관리'**
  String get routine_share_title;

  /// 공유 설정 화면 상단 설명
  ///
  /// In ko, this message translates to:
  /// **'선택한 그룹의 구성원이 내 습관과 달성 현황을 볼 수 있어요.'**
  String get routine_share_screen_desc;

  /// 공유 설정 화면에서 비공개 습관은 제외된다는 안내
  ///
  /// In ko, this message translates to:
  /// **'비공개로 표시한 습관은 공유되지 않아요.'**
  String get routine_share_private_note;

  /// 공유 중인 그룹이 없을 때 안내
  ///
  /// In ko, this message translates to:
  /// **'아직 공유 중인 그룹이 없어요'**
  String get routine_share_none;

  /// 가입한 그룹이 하나도 없을 때 안내
  ///
  /// In ko, this message translates to:
  /// **'참여 중인 그룹이 없어요.\n그룹을 먼저 만들거나 참여해주세요.'**
  String get routine_share_no_groups;

  /// 공유 설정 저장 성공 스낵바
  ///
  /// In ko, this message translates to:
  /// **'공유 설정을 저장했어요'**
  String get routine_share_saved;

  /// 습관 생성/수정 폼의 비공개 스위치 라벨
  ///
  /// In ko, this message translates to:
  /// **'비공개'**
  String get routine_field_private;

  /// 비공개 스위치 설명
  ///
  /// In ko, this message translates to:
  /// **'공유 그룹의 다른 사람에게 이 습관을 숨겨요'**
  String get routine_field_private_desc;

  /// 목록에서 비공개 습관을 나타내는 자물쇠 아이콘 툴팁
  ///
  /// In ko, this message translates to:
  /// **'비공개 습관'**
  String get routine_private_badge;

  /// 공유 그룹 선택 시트 타이틀
  ///
  /// In ko, this message translates to:
  /// **'공유할 그룹 선택'**
  String get routine_share_select_group;

  /// 그룹 현황/랭킹 통합 화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'함께하기'**
  String get routine_together_title;

  /// 함께하기 화면 - 그룹원 현황 탭
  ///
  /// In ko, this message translates to:
  /// **'현황'**
  String get routine_together_tab_status;

  /// 함께하기 화면 - 랭킹 탭
  ///
  /// In ko, this message translates to:
  /// **'랭킹'**
  String get routine_together_tab_ranking;

  /// 함께하기 화면 - 챌린지 탭
  ///
  /// In ko, this message translates to:
  /// **'챌린지'**
  String get routine_together_tab_challenge;

  /// 챌린지 생성 화면 제목/버튼
  ///
  /// In ko, this message translates to:
  /// **'챌린지 만들기'**
  String get routine_challenge_create;

  /// 챌린지 수정 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'챌린지 수정'**
  String get routine_challenge_edit;

  /// 챌린지가 하나도 없을 때 안내
  ///
  /// In ko, this message translates to:
  /// **'아직 챌린지가 없어요.\n그룹과 함께할 목표를 만들어보세요.'**
  String get routine_challenge_empty;

  /// 챌린지 제목 입력 라벨
  ///
  /// In ko, this message translates to:
  /// **'챌린지 이름'**
  String get routine_challenge_field_title;

  /// 챌린지 제목 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 이번 주 운동하기'**
  String get routine_challenge_field_title_hint;

  /// 챌린지 설명 입력 라벨
  ///
  /// In ko, this message translates to:
  /// **'설명'**
  String get routine_challenge_field_description;

  /// 챌린지 기간 선택 라벨
  ///
  /// In ko, this message translates to:
  /// **'기간'**
  String get routine_challenge_field_period;

  /// 챌린지 목표 횟수 라벨
  ///
  /// In ko, this message translates to:
  /// **'목표 횟수'**
  String get routine_challenge_field_target;

  /// 목표 횟수 설명
  ///
  /// In ko, this message translates to:
  /// **'기간 안에 {count}번 체크하면 달성이에요'**
  String routine_challenge_field_target_desc(int count);

  /// 챌린지 보상/벌칙 입력 라벨
  ///
  /// In ko, this message translates to:
  /// **'내기 · 벌칙'**
  String get routine_challenge_field_reward;

  /// 보상/벌칙 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 진 사람이 치킨 쏘기'**
  String get routine_challenge_field_reward_hint;

  /// 챌린지 상태 - 시작 전
  ///
  /// In ko, this message translates to:
  /// **'시작 전'**
  String get routine_challenge_status_upcoming;

  /// 챌린지 상태 - 진행 중
  ///
  /// In ko, this message translates to:
  /// **'진행 중'**
  String get routine_challenge_status_ongoing;

  /// 챌린지 상태 - 종료
  ///
  /// In ko, this message translates to:
  /// **'종료'**
  String get routine_challenge_status_ended;

  /// 챌린지 참가자 수
  ///
  /// In ko, this message translates to:
  /// **'참가자 {count}명'**
  String routine_challenge_participants(int count);

  /// 챌린지 참가 버튼
  ///
  /// In ko, this message translates to:
  /// **'참가하기'**
  String get routine_challenge_join;

  /// 챌린지 참가 취소 버튼
  ///
  /// In ko, this message translates to:
  /// **'참가 취소'**
  String get routine_challenge_leave;

  /// 참가 취소 확인
  ///
  /// In ko, this message translates to:
  /// **'이 챌린지에서 빠지시겠어요?'**
  String get routine_challenge_leave_confirm;

  /// 챌린지 삭제 확인
  ///
  /// In ko, this message translates to:
  /// **'이 챌린지를 삭제하시겠어요?\n참가자들의 기록도 함께 사라져요.'**
  String get routine_challenge_delete_confirm;

  /// 참가 시 습관 선택 시트 제목
  ///
  /// In ko, this message translates to:
  /// **'어떤 습관으로 참가할까요?'**
  String get routine_challenge_select_routine;

  /// 습관 선택 시트 설명
  ///
  /// In ko, this message translates to:
  /// **'이 챌린지에 연결할 내 습관을 골라주세요.\n비공개 습관은 참가할 수 없어요.'**
  String get routine_challenge_select_routine_desc;

  /// 연결 가능한 습관이 없을 때
  ///
  /// In ko, this message translates to:
  /// **'참가할 수 있는 습관이 없어요.\n먼저 습관을 만들어주세요.'**
  String get routine_challenge_no_routine;

  /// 연결한 습관 교체 버튼
  ///
  /// In ko, this message translates to:
  /// **'습관 바꾸기'**
  String get routine_challenge_change_routine;

  /// 챌린지 진행률
  ///
  /// In ko, this message translates to:
  /// **'{checked} / {target}회'**
  String routine_challenge_progress(int checked, int target);

  /// 챌린지 종료까지 남은 일수
  ///
  /// In ko, this message translates to:
  /// **'{days}일 남음'**
  String routine_challenge_days_left(int days);

  /// 챌린지 저장 성공
  ///
  /// In ko, this message translates to:
  /// **'챌린지를 저장했어요'**
  String get routine_challenge_saved;

  /// 챌린지 참가 성공
  ///
  /// In ko, this message translates to:
  /// **'챌린지에 참가했어요'**
  String get routine_challenge_joined;

  /// 그룹원 루틴 목록 비어있을 때 안내
  ///
  /// In ko, this message translates to:
  /// **'공유된 루틴이 없습니다'**
  String get routine_group_members_empty;

  /// 루틴 순서 변경 완료 스낵바
  ///
  /// In ko, this message translates to:
  /// **'순서가 변경되었습니다'**
  String get routine_sort_order_updated;

  /// 루틴 관련 일반 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다'**
  String get routine_error_generic;

  /// 홈 위젯 설정 - 루틴 요약 위젯 라벨
  ///
  /// In ko, this message translates to:
  /// **'내 루틴'**
  String get widgetSettings_routineSummary;

  /// 루틴 네비게이션 라벨
  ///
  /// In ko, this message translates to:
  /// **'루틴'**
  String get nav_routines;

  /// 배지 목록 화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'내 배지'**
  String get routine_badges_title;

  /// 전체 루틴 통합 통계 화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'통계'**
  String get routine_overview_title;

  /// 통합 히트맵 캘린더 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'전체 습관 달성 현황'**
  String get routine_overview_heatmap_title;

  /// 통계 화면 이전 주/달 이동 버튼 툴팁
  ///
  /// In ko, this message translates to:
  /// **'이전 기간'**
  String get routine_overview_previous_period;

  /// 통계 화면 다음 주/달 이동 버튼 툴팁
  ///
  /// In ko, this message translates to:
  /// **'다음 기간'**
  String get routine_overview_next_period;

  /// 통계 화면 주간 모드에서 이번 주로 돌아가는 버튼
  ///
  /// In ko, this message translates to:
  /// **'금주로'**
  String get routine_overview_this_week;

  /// 통계 화면 월간 모드에서 이번 달로 돌아가는 버튼
  ///
  /// In ko, this message translates to:
  /// **'이번 달로'**
  String get routine_overview_this_month;

  /// 주간 모드 습관별 7일 그리드 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'이번 주 습관별 수행 현황'**
  String get routine_overview_weekly_title;

  /// 주간 목표를 달성한 습관 수 라벨
  ///
  /// In ko, this message translates to:
  /// **'달성'**
  String get routine_overview_achieved;

  /// 주간 목표를 달성하지 못한 습관 수 라벨
  ///
  /// In ko, this message translates to:
  /// **'미달성'**
  String get routine_overview_not_achieved;

  /// 주간 모드에서 전체 습관의 체크된 총 횟수 라벨
  ///
  /// In ko, this message translates to:
  /// **'총 체크'**
  String get routine_overview_total_checked;

  /// 일일 목표 설정 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'오늘의 목표'**
  String get routine_daily_goal_title;

  /// 더보기 메뉴에서 일일 목표 설정으로 진입하는 항목
  ///
  /// In ko, this message translates to:
  /// **'오늘의 목표 설정'**
  String get routine_daily_goal_setting;

  /// 목표 개수 슬라이더 위에 표시되는 현재 선택값
  ///
  /// In ko, this message translates to:
  /// **'습관 {total}개 중 {count}개'**
  String routine_daily_goal_count_label(int total, int count);

  /// 목표 개수 슬라이더 아래 격려 문구
  ///
  /// In ko, this message translates to:
  /// **'하루 {count}개면 성공이에요'**
  String routine_daily_goal_encourage(int count);

  /// 목표 개수가 전체 습관 수보다 클 때 안내
  ///
  /// In ko, this message translates to:
  /// **'지금 등록된 습관보다 목표가 많아요. 습관을 더 추가하거나 목표를 낮춰보세요'**
  String get routine_daily_goal_exceeds_total;

  /// 오늘의 목표 진행 상황 (체크 수 / 목표 수)
  ///
  /// In ko, this message translates to:
  /// **'오늘 {checked} / {target}'**
  String routine_daily_goal_today_progress(int checked, int target);

  /// 오늘 목표를 달성했을 때 표시 문구
  ///
  /// In ko, this message translates to:
  /// **'오늘 목표 달성!'**
  String get routine_daily_goal_achieved_today;

  /// 목표를 초과 달성했을 때 추가 체크 수 표시
  ///
  /// In ko, this message translates to:
  /// **'보너스 +{count}'**
  String routine_daily_goal_bonus(int count);

  /// 일일 목표 연속 달성 일수
  ///
  /// In ko, this message translates to:
  /// **'{days}일 연속 달성'**
  String routine_daily_goal_streak(int days);

  /// 역대 최장 연속 달성 일수
  ///
  /// In ko, this message translates to:
  /// **'최장 {days}일'**
  String routine_daily_goal_streak_longest(int days);

  /// 통계 화면 일일 목표 달성률 라벨
  ///
  /// In ko, this message translates to:
  /// **'목표 달성률'**
  String get routine_daily_goal_rate;

  /// 기간 내 목표 달성 일수
  ///
  /// In ko, this message translates to:
  /// **'{achieved}일 / {total}일 달성'**
  String routine_daily_goal_achieved_days(int achieved, int total);

  /// 목표 저장 성공 스낵바
  ///
  /// In ko, this message translates to:
  /// **'목표를 저장했어요'**
  String get routine_daily_goal_saved;

  /// 목표 상향 제안 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'목표를 올려볼까요?'**
  String get routine_daily_goal_raise_title;

  /// 목표 상향 제안 본문
  ///
  /// In ko, this message translates to:
  /// **'최근 2주 동안 목표를 자주 넘었어요. 요즘 하루 평균 {average}개를 하고 계세요.\n\n하루 목표를 {current}개에서 {suggested}개로 올려볼까요?'**
  String routine_daily_goal_raise_body(int average, int current, int suggested);

  /// 목표 상향 수락 버튼
  ///
  /// In ko, this message translates to:
  /// **'올릴게요'**
  String get routine_daily_goal_raise_accept;

  /// 목표 조정 제안 거절 버튼
  ///
  /// In ko, this message translates to:
  /// **'지금이 좋아요'**
  String get routine_daily_goal_keep;

  /// 목표 하향 제안 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'목표를 잠시 낮춰볼까요?'**
  String get routine_daily_goal_lower_title;

  /// 목표 하향 제안 본문
  ///
  /// In ko, this message translates to:
  /// **'요즘 조금 바쁘신가요? 무리하지 않아도 괜찮아요.\n\n하루 목표를 {current}개에서 {suggested}개로 낮춰도 좋아요. 언제든 다시 올릴 수 있어요.'**
  String routine_daily_goal_lower_body(int current, int suggested);

  /// 목표 하향 수락 버튼
  ///
  /// In ko, this message translates to:
  /// **'낮출게요'**
  String get routine_daily_goal_lower_accept;

  /// 일일 목표 집계 대상 습관 선택 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'목표에 포함할 습관'**
  String get routine_daily_goal_included_section;

  /// 집계에 포함된 습관 수 요약
  ///
  /// In ko, this message translates to:
  /// **'습관 {included}개가 목표 집계에 포함돼요'**
  String routine_daily_goal_included_summary(int included);

  /// DAILY 습관 그룹 제목
  ///
  /// In ko, this message translates to:
  /// **'매일 하는 습관'**
  String get routine_daily_goal_group_daily;

  /// WEEKLY/MONTHLY 습관 그룹 제목
  ///
  /// In ko, this message translates to:
  /// **'주기적으로 하는 습관'**
  String get routine_daily_goal_group_periodic;

  /// 주기 습관을 포함할 때의 트레이드오프 안내
  ///
  /// In ko, this message translates to:
  /// **'켜면 매일 해야 하는 것으로 계산돼요. 주 3회 습관을 켜면 3회를 다 채운 뒤에도 남은 날에 미완료로 남아요'**
  String get routine_daily_goal_periodic_hint;

  /// 주기 배지 - 매일
  ///
  /// In ko, this message translates to:
  /// **'매일'**
  String get routine_daily_goal_freq_daily;

  /// 주기 배지 - 주 N회
  ///
  /// In ko, this message translates to:
  /// **'주 {count}회'**
  String routine_daily_goal_freq_weekly_count(int count);

  /// 주기 배지 - 월 N회
  ///
  /// In ko, this message translates to:
  /// **'월 {count}회'**
  String routine_daily_goal_freq_monthly_count(int count);

  /// 포함된 습관이 0개일 때 안내
  ///
  /// In ko, this message translates to:
  /// **'목표에 포함된 습관이 없어요. 아래에서 습관을 켜주세요'**
  String get routine_daily_goal_no_included;

  /// 습관이 하나도 없을 때 안내
  ///
  /// In ko, this message translates to:
  /// **'등록된 습관이 없어요'**
  String get routine_daily_goal_no_routines;

  /// 통합 달성률 카드에 집계 대상 습관 수를 보여주는 문구
  ///
  /// In ko, this message translates to:
  /// **'전체 습관 {count}개 기준'**
  String routine_overview_total_routines(int count);

  /// 루틴별 배지 목록이 비어있을 때 안내
  ///
  /// In ko, this message translates to:
  /// **'아직 획득한 배지가 없습니다'**
  String get routine_badges_empty;

  /// 배지 획득 축하 다이얼로그 타이틀
  ///
  /// In ko, this message translates to:
  /// **'배지 획득!'**
  String get routine_badge_earned_title;

  /// 배지 획득 축하 다이얼로그 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get routine_badge_earned_confirm;

  /// 랭킹보드 정렬 기준 - 일일 목표 달성률
  ///
  /// In ko, this message translates to:
  /// **'목표 달성률'**
  String get routine_leaderboard_metric_goalRate;

  /// 랭킹보드 정렬 기준 - 연속 달성 일수
  ///
  /// In ko, this message translates to:
  /// **'연속 달성'**
  String get routine_leaderboard_metric_goalStreak;

  /// 랭킹보드 목표 달성 일수 표기
  ///
  /// In ko, this message translates to:
  /// **'{achieved}일 / {total}일'**
  String routine_leaderboard_goal_days(int achieved, int total);

  /// 랭킹보드 연속 달성 일수 표기
  ///
  /// In ko, this message translates to:
  /// **'{days}일 연속'**
  String routine_leaderboard_streak_days(int days);

  /// 랭킹보드에 표시할 순위가 없을 때 안내
  ///
  /// In ko, this message translates to:
  /// **'공유된 루틴이 있는 그룹원이 없습니다'**
  String get routine_leaderboard_empty;

  /// 루틴(습관 묶음) 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'루틴 추가'**
  String get routine_group_add;

  /// 루틴(습관 묶음) 수정 버튼/타이틀
  ///
  /// In ko, this message translates to:
  /// **'루틴 수정'**
  String get routine_group_edit;

  /// 루틴(습관 묶음) 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'루틴 삭제'**
  String get routine_group_delete;

  /// 루틴 삭제 확인 다이얼로그
  ///
  /// In ko, this message translates to:
  /// **'이 루틴을 삭제하시겠습니까?\n소속된 습관은 삭제되지 않고 독립 습관으로 남습니다.'**
  String get routine_group_delete_confirm;

  /// 루틴 제목 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 아침 루틴'**
  String get routine_group_field_title_hint;

  /// 루틴 저장 버튼
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get routine_group_save;

  /// 루틴에 소속되지 않은 습관 섹션 헤더
  ///
  /// In ko, this message translates to:
  /// **'독립 습관'**
  String get routine_group_standalone_section_title;

  /// 습관 표 헤더 - 번호 컬럼
  ///
  /// In ko, this message translates to:
  /// **'번호'**
  String get routine_table_header_number;

  /// 습관 표 헤더 - 습관 컬럼
  ///
  /// In ko, this message translates to:
  /// **'습관'**
  String get routine_table_header_habit;

  /// 습관 표 헤더 - 체크 컬럼
  ///
  /// In ko, this message translates to:
  /// **'체크'**
  String get routine_table_header_check;

  /// 루틴 관련 일반 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다'**
  String get routine_group_error_generic;

  /// 습관 메모 입력 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'메모'**
  String get routine_field_memo;

  /// 메모 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'이 습관에 대한 설명을 남겨보세요'**
  String get routine_field_memo_hint;

  /// 습관 중요도 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'중요도'**
  String get routine_field_importance;

  /// 중요도 - 낮음
  ///
  /// In ko, this message translates to:
  /// **'낮음'**
  String get routine_importance_low;

  /// 중요도 - 보통
  ///
  /// In ko, this message translates to:
  /// **'보통'**
  String get routine_importance_medium;

  /// 중요도 - 높음
  ///
  /// In ko, this message translates to:
  /// **'높음'**
  String get routine_importance_high;

  /// 시간대 분류 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'시간대'**
  String get routine_field_time_filter;

  /// 시간대 - 오전
  ///
  /// In ko, this message translates to:
  /// **'오전'**
  String get routine_time_filter_morning;

  /// 시간대 - 오후
  ///
  /// In ko, this message translates to:
  /// **'오후'**
  String get routine_time_filter_afternoon;

  /// 시간대 - 저녁
  ///
  /// In ko, this message translates to:
  /// **'저녁'**
  String get routine_time_filter_evening;

  /// 시간대 미지정 옵션
  ///
  /// In ko, this message translates to:
  /// **'지정 안 함'**
  String get routine_time_filter_none;

  /// 습관 카테고리 선택 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get routine_field_category;

  /// 카테고리 없음 옵션
  ///
  /// In ko, this message translates to:
  /// **'미분류'**
  String get routine_field_category_none;

  /// 카테고리 관리 화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get routine_category_title;

  /// 카테고리 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'카테고리 추가'**
  String get routine_category_add;

  /// 카테고리 수정 버튼/타이틀
  ///
  /// In ko, this message translates to:
  /// **'카테고리 수정'**
  String get routine_category_edit;

  /// 카테고리 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'카테고리 삭제'**
  String get routine_category_delete;

  /// 카테고리 삭제 확인 다이얼로그
  ///
  /// In ko, this message translates to:
  /// **'이 카테고리를 삭제하시겠습니까?\n소속 습관은 삭제되지 않고 미분류로 남습니다.'**
  String get routine_category_delete_confirm;

  /// 카테고리 저장 버튼
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get routine_category_save;

  /// 카테고리 제목 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 규칙적인 삶'**
  String get routine_category_field_title_hint;

  /// 카테고리 관련 일반 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다'**
  String get routine_category_error_generic;

  /// 카테고리 목록 비어있을 때 안내
  ///
  /// In ko, this message translates to:
  /// **'등록된 카테고리가 없습니다'**
  String get routine_category_empty;

  /// 카테고리 필터 칩 - 전체
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get routine_category_filter_all;

  /// 카테고리 다중 선택 바텀시트 타이틀
  ///
  /// In ko, this message translates to:
  /// **'카테고리 선택'**
  String get routine_category_picker_title;

  /// 카테고리 바텀시트 편집 모드 진입 버튼
  ///
  /// In ko, this message translates to:
  /// **'편집'**
  String get routine_category_edit_mode;

  /// 카테고리 바텀시트 편집 모드 종료(완료) 버튼
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get routine_category_edit_mode_done;

  /// 카테고리 편집 모드에서 핸들 아이콘을 눌러 드래그 정렬 가능함을 안내
  ///
  /// In ko, this message translates to:
  /// **'핸들을 눌러 순서를 변경하세요'**
  String get routine_category_reorder_hint;

  /// 카테고리 다중 선택 바텀시트 닫기(선택 완료) 버튼
  ///
  /// In ko, this message translates to:
  /// **'선택 완료'**
  String get routine_category_select_done;

  /// 폼 화면에서 카테고리를 하나도 선택하지 않았을 때의 플레이스홀더
  ///
  /// In ko, this message translates to:
  /// **'카테고리 선택'**
  String get routine_category_none_selected;

  /// 기록 방식 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'기록 방식'**
  String get routine_field_record_type;

  /// 기록 방식 - 단순 체크
  ///
  /// In ko, this message translates to:
  /// **'단순 체크'**
  String get routine_record_type_boolean;

  /// 기록 방식 - 텍스트
  ///
  /// In ko, this message translates to:
  /// **'텍스트'**
  String get routine_record_type_text;

  /// 기록 방식 - 시각
  ///
  /// In ko, this message translates to:
  /// **'시각'**
  String get routine_record_type_time;

  /// 기록 방식 - 수치
  ///
  /// In ko, this message translates to:
  /// **'수치'**
  String get routine_record_type_numeric;

  /// 수정 화면에서 기록 방식이 읽기 전용임을 안내
  ///
  /// In ko, this message translates to:
  /// **'기록 방식은 생성 후 변경할 수 없습니다'**
  String get routine_record_type_readonly_hint;

  /// 체크 값 입력 다이얼로그 타이틀
  ///
  /// In ko, this message translates to:
  /// **'기록 입력'**
  String get routine_check_dialog_title;

  /// 텍스트 기록 입력 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'내용'**
  String get routine_check_dialog_text_label;

  /// 수치 기록 입력 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'수치'**
  String get routine_check_dialog_numeric_label;

  /// 시각 기록 입력 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'시각'**
  String get routine_check_dialog_time_label;

  /// 체크 값 입력 다이얼로그 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'체크'**
  String get routine_check_dialog_confirm;

  /// 체크 값 입력 다이얼로그 취소 버튼
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get routine_check_dialog_cancel;

  /// 루틴 상태 - 활성
  ///
  /// In ko, this message translates to:
  /// **'활성'**
  String get routine_status_active;

  /// 루틴 상태 - 일시정지
  ///
  /// In ko, this message translates to:
  /// **'일시정지'**
  String get routine_status_paused;

  /// 루틴 상태 - 종료
  ///
  /// In ko, this message translates to:
  /// **'종료'**
  String get routine_status_ended;

  /// 일시정지 액션
  ///
  /// In ko, this message translates to:
  /// **'일시정지'**
  String get routine_pause;

  /// 일시정지 확인 다이얼로그
  ///
  /// In ko, this message translates to:
  /// **'이 습관을 일시정지하시겠습니까?\n일시정지 중에는 체크할 수 없습니다.'**
  String get routine_pause_confirm;

  /// 재개 액션
  ///
  /// In ko, this message translates to:
  /// **'재개'**
  String get routine_resume;

  /// 재개 성공 스낵바
  ///
  /// In ko, this message translates to:
  /// **'재개되었습니다'**
  String get routine_resume_success;

  /// 일시정지 실패 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'일시정지에 실패했습니다'**
  String get routine_pause_error;

  /// 재개 실패 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'재개에 실패했습니다'**
  String get routine_resume_error;

  /// 습관 종료 버튼
  ///
  /// In ko, this message translates to:
  /// **'종료'**
  String get routine_end;

  /// 습관 종료 확인 다이얼로그
  ///
  /// In ko, this message translates to:
  /// **'이 습관을 종료하시겠습니까?\n체크 기록은 보존됩니다.'**
  String get routine_end_confirm;

  /// 반복 타입 - 일간
  ///
  /// In ko, this message translates to:
  /// **'일간'**
  String get routine_frequency_type_daily;

  /// 반복 타입 - 주간
  ///
  /// In ko, this message translates to:
  /// **'주간'**
  String get routine_frequency_type_weekly;

  /// 반복 타입 - 월간
  ///
  /// In ko, this message translates to:
  /// **'월간'**
  String get routine_frequency_type_monthly;

  /// 주 반복 방식 - 요일 무관 주 N회
  ///
  /// In ko, this message translates to:
  /// **'주 N회'**
  String get routine_weekly_mode_count_only;

  /// 주 반복 방식 - 특정 요일 지정
  ///
  /// In ko, this message translates to:
  /// **'요일 지정'**
  String get routine_weekly_mode_fixed_days;

  /// 반복 요일 선택 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'반복 요일'**
  String get routine_field_target_days;

  /// 요일 축약 - 일요일
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get routine_day_sun;

  /// 요일 축약 - 월요일
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get routine_day_mon;

  /// 요일 축약 - 화요일
  ///
  /// In ko, this message translates to:
  /// **'화'**
  String get routine_day_tue;

  /// 요일 축약 - 수요일
  ///
  /// In ko, this message translates to:
  /// **'수'**
  String get routine_day_wed;

  /// 요일 축약 - 목요일
  ///
  /// In ko, this message translates to:
  /// **'목'**
  String get routine_day_thu;

  /// 요일 축약 - 금요일
  ///
  /// In ko, this message translates to:
  /// **'금'**
  String get routine_day_fri;

  /// 요일 축약 - 토요일
  ///
  /// In ko, this message translates to:
  /// **'토'**
  String get routine_day_sat;

  /// 주간 반복인데 weeklyMode 미선택 시 에러
  ///
  /// In ko, this message translates to:
  /// **'주 반복 방식을 선택해주세요'**
  String get routine_error_weekly_mode_required;

  /// 주 N회인데 목표 횟수 미입력 시 에러
  ///
  /// In ko, this message translates to:
  /// **'주 목표 횟수를 선택해주세요'**
  String get routine_error_weekly_target_required;

  /// 요일지정인데 요일 미선택 시 에러
  ///
  /// In ko, this message translates to:
  /// **'반복할 요일을 1개 이상 선택해주세요'**
  String get routine_error_fixed_days_required;

  /// 월간인데 목표 횟수 미입력 시 에러
  ///
  /// In ko, this message translates to:
  /// **'월 목표 횟수를 선택해주세요'**
  String get routine_error_monthly_target_required;

  /// 공용 이모지 선택 필드의 '전체 이모지 보기' 버튼 툴팁
  ///
  /// In ko, this message translates to:
  /// **'더 많은 이모지'**
  String get emoji_picker_more;

  /// 프리셋에 없는 이모지를 바텀시트에서 선택했을 때 안내 문구
  ///
  /// In ko, this message translates to:
  /// **'프리셋 외 이모지가 선택되었습니다'**
  String get emoji_picker_custom_selected;

  /// 이모지 검색창 placeholder
  ///
  /// In ko, this message translates to:
  /// **'이모지 검색'**
  String get emoji_picker_search_hint;

  /// 이모지 검색 결과가 없을 때 안내 문구
  ///
  /// In ko, this message translates to:
  /// **'검색 결과가 없습니다'**
  String get emoji_picker_no_result;

  /// 최근 사용 이모지 카테고리 라벨
  ///
  /// In ko, this message translates to:
  /// **'최근 사용'**
  String get emoji_picker_category_recent;

  /// 이모지 카테고리 - 표정
  ///
  /// In ko, this message translates to:
  /// **'표정'**
  String get emoji_picker_category_smileys;

  /// 이모지 카테고리 - 동물
  ///
  /// In ko, this message translates to:
  /// **'동물'**
  String get emoji_picker_category_animals;

  /// 이모지 카테고리 - 음식
  ///
  /// In ko, this message translates to:
  /// **'음식'**
  String get emoji_picker_category_foods;

  /// 이모지 카테고리 - 여행
  ///
  /// In ko, this message translates to:
  /// **'여행'**
  String get emoji_picker_category_travel;

  /// 이모지 카테고리 - 활동
  ///
  /// In ko, this message translates to:
  /// **'활동'**
  String get emoji_picker_category_activities;

  /// 이모지 카테고리 - 사물
  ///
  /// In ko, this message translates to:
  /// **'사물'**
  String get emoji_picker_category_objects;

  /// 이모지 카테고리 - 기호
  ///
  /// In ko, this message translates to:
  /// **'기호'**
  String get emoji_picker_category_symbols;

  /// 이모지 카테고리 - 깃발
  ///
  /// In ko, this message translates to:
  /// **'깃발'**
  String get emoji_picker_category_flags;

  /// 태그 필터 선택을 해제하는 버튼 툴팁
  ///
  /// In ko, this message translates to:
  /// **'태그 필터 초기화'**
  String get memo_tag_filter_clear;

  /// 메모 목록에서 고정된 메모 구역 제목
  ///
  /// In ko, this message translates to:
  /// **'고정된 메모'**
  String get memo_section_pinned;

  /// 고정 메모가 많을 때 더 보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'펼치기 ({count}개 더)'**
  String memo_pinned_expand(int count);

  /// 펼쳐진 고정 메모를 다시 접는 버튼
  ///
  /// In ko, this message translates to:
  /// **'접기'**
  String get memo_pinned_collapse;

  /// 메모를 고정하는 버튼 툴팁
  ///
  /// In ko, this message translates to:
  /// **'대시보드에 고정'**
  String get memo_pin_add;

  /// 메모 고정을 푸는 버튼 툴팁
  ///
  /// In ko, this message translates to:
  /// **'핀 해제'**
  String get memo_pin_remove;

  /// 고정 상태 변경 실패 안내
  ///
  /// In ko, this message translates to:
  /// **'핀 설정에 실패했습니다'**
  String get memo_pin_error;

  /// 메모를 고정했을 때 안내
  ///
  /// In ko, this message translates to:
  /// **'메모가 상단에 고정되고, 대시보드에 추가되었습니다.'**
  String get memo_pin_added;

  /// 메모 고정을 풀었을 때 안내
  ///
  /// In ko, this message translates to:
  /// **'고정이 해제되었습니다.'**
  String get memo_pin_removed;

  /// 메모를 복사할 때 새 메모에 붙는 제목
  ///
  /// In ko, this message translates to:
  /// **'{title} (복사본)'**
  String memo_duplicate_title(String title);

  /// 태그 입력칸 힌트
  ///
  /// In ko, this message translates to:
  /// **'태그 입력 후 추가'**
  String get memo_tag_input_hint;

  /// 클립보드 붙여넣기 실패 안내
  ///
  /// In ko, this message translates to:
  /// **'클립보드 붙여넣기에 실패했습니다.'**
  String get memo_editor_paste_failed;

  /// 링크 카드 추가 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'링크 카드 추가'**
  String get memo_editor_link_card_add;

  /// 에디터 도구 - 이미지
  ///
  /// In ko, this message translates to:
  /// **'이미지'**
  String get memo_editor_image;

  /// 에디터 도구 - 서식 유지 붙여넣기
  ///
  /// In ko, this message translates to:
  /// **'서식 유지 붙여넣기'**
  String get memo_editor_paste_formatted;

  /// 에디터 도구 - 선택한 글자에 링크 걸기
  ///
  /// In ko, this message translates to:
  /// **'하이퍼링크 적용'**
  String get memo_editor_link_apply;

  /// 링크를 걸려면 글자를 먼저 선택하라는 안내
  ///
  /// In ko, this message translates to:
  /// **'텍스트를 선택하세요'**
  String get memo_editor_link_select_first;

  /// 에디터 도구 - 굵게
  ///
  /// In ko, this message translates to:
  /// **'굵게'**
  String get memo_editor_bold;

  /// 에디터 도구 - 기울임
  ///
  /// In ko, this message translates to:
  /// **'기울임'**
  String get memo_editor_italic;

  /// 에디터 도구 - 취소선
  ///
  /// In ko, this message translates to:
  /// **'취소선'**
  String get memo_editor_strikethrough;

  /// 에디터 도구 - 제목 1
  ///
  /// In ko, this message translates to:
  /// **'제목 1'**
  String get memo_editor_heading1;

  /// 에디터 도구 - 제목 2(체크리스트 구역 구분)
  ///
  /// In ko, this message translates to:
  /// **'제목 2 (체크리스트 섹션)'**
  String get memo_editor_heading2;

  /// 에디터 도구 - 글머리 기호 목록
  ///
  /// In ko, this message translates to:
  /// **'글머리 기호'**
  String get memo_editor_bullet_list;

  /// 에디터 도구 - 번호 목록
  ///
  /// In ko, this message translates to:
  /// **'번호 목록'**
  String get memo_editor_numbered_list;

  /// 에디터 도구 - 실행 취소
  ///
  /// In ko, this message translates to:
  /// **'실행 취소'**
  String get memo_editor_undo;

  /// 에디터 도구 - 다시 실행
  ///
  /// In ko, this message translates to:
  /// **'다시 실행'**
  String get memo_editor_redo;

  /// 그룹 저금통 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'그룹 저금통'**
  String get savings_title;

  /// 그룹을 고르라는 안내
  ///
  /// In ko, this message translates to:
  /// **'그룹을 선택해 주세요'**
  String get savings_select_group;

  /// 저금통 소개 제목
  ///
  /// In ko, this message translates to:
  /// **'그룹과 함께 목표를 정해 돈을 모아요'**
  String get savings_intro_title;

  /// 저금통 소개 본문
  ///
  /// In ko, this message translates to:
  /// **'여행 경비, 비상금, 가전 구매 등 원하는 목표를 만들고 매달 자동으로 적립하거나 수동으로 입금할 수 있어요.'**
  String get savings_intro_body;

  /// 저금통 소개 팁
  ///
  /// In ko, this message translates to:
  /// **'가족 외에도 친구, 동료 등 그룹이라면 누구든 \"계\" 처럼 활용할 수 있어요.'**
  String get savings_intro_tip;

  /// 저금통이 하나도 없을 때
  ///
  /// In ko, this message translates to:
  /// **'저금통이 없습니다\n+ 버튼을 눌러 저금통을 추가하세요'**
  String get savings_list_empty;

  /// 달성률 표시
  ///
  /// In ko, this message translates to:
  /// **'{rate}% 달성'**
  String savings_achievement_rate(String rate);

  /// 입금
  ///
  /// In ko, this message translates to:
  /// **'입금'**
  String get savings_deposit;

  /// 출금
  ///
  /// In ko, this message translates to:
  /// **'출금'**
  String get savings_withdraw;

  /// 금액 입력칸 라벨
  ///
  /// In ko, this message translates to:
  /// **'금액 (원)'**
  String get savings_amount_label;

  /// 메모 입력칸 라벨(선택)
  ///
  /// In ko, this message translates to:
  /// **'메모 (선택)'**
  String get savings_memo_label;

  /// 출금 사유 입력칸 라벨(필수)
  ///
  /// In ko, this message translates to:
  /// **'출금 사유 (필수)'**
  String get savings_withdraw_reason_label;

  /// 목표 삭제 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'목표 삭제'**
  String get savings_delete_title;

  /// 목표 삭제 확인 문구
  ///
  /// In ko, this message translates to:
  /// **'\'{name}\'을(를) 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'**
  String savings_delete_message(String name);

  /// 적립 목표 상세 기본 제목
  ///
  /// In ko, this message translates to:
  /// **'적립 목표'**
  String get savings_detail_title;

  /// 목표 금액을 다 모았을 때
  ///
  /// In ko, this message translates to:
  /// **'목표 금액 달성!'**
  String get savings_goal_reached;

  /// 목표 금액 표시
  ///
  /// In ko, this message translates to:
  /// **'목표: {amount}'**
  String savings_target_amount(String amount);

  /// 자동 적립
  ///
  /// In ko, this message translates to:
  /// **'자동 적립'**
  String get savings_auto_deposit;

  /// 매달 적립하는 금액
  ///
  /// In ko, this message translates to:
  /// **'월 {amount}'**
  String savings_auto_deposit_monthly(String amount);

  /// 자동 적립 중지 버튼
  ///
  /// In ko, this message translates to:
  /// **'자동 적립 중지'**
  String get savings_auto_deposit_pause;

  /// 자동 적립 재개 버튼
  ///
  /// In ko, this message translates to:
  /// **'자동 적립 재개'**
  String get savings_auto_deposit_resume;

  /// 최근 거래 내역 제목
  ///
  /// In ko, this message translates to:
  /// **'최근 내역'**
  String get savings_recent_transactions;

  /// 전체 내역 보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'전체 보기'**
  String get savings_view_all;

  /// 거래 내역이 없을 때
  ///
  /// In ko, this message translates to:
  /// **'거래 내역이 없습니다.'**
  String get savings_transactions_empty;

  /// 거래 내역 로드 실패
  ///
  /// In ko, this message translates to:
  /// **'내역을 불러오지 못했습니다'**
  String get savings_transactions_load_error;

  /// 거래 내역 필터 - 자동 적립
  ///
  /// In ko, this message translates to:
  /// **'자동 적립'**
  String get savings_filter_auto;

  /// 저금통 추가 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'저금통 추가'**
  String get savings_form_title_add;

  /// 저금통 수정 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'저금통 수정'**
  String get savings_form_title_edit;

  /// 수정 완료 버튼
  ///
  /// In ko, this message translates to:
  /// **'수정 완료'**
  String get savings_form_submit_edit;

  /// 저장 실패 안내
  ///
  /// In ko, this message translates to:
  /// **'저장하지 못했습니다'**
  String get savings_form_save_error;

  /// 목표 이름 입력칸
  ///
  /// In ko, this message translates to:
  /// **'목표 이름 *'**
  String get savings_field_name;

  /// 목표 이름 검증
  ///
  /// In ko, this message translates to:
  /// **'목표 이름을 입력해 주세요'**
  String get savings_field_name_required;

  /// 설명 입력칸
  ///
  /// In ko, this message translates to:
  /// **'설명 (선택)'**
  String get savings_field_description;

  /// 목표 금액 입력칸
  ///
  /// In ko, this message translates to:
  /// **'목표 금액 (선택, 원)'**
  String get savings_field_target;

  /// 목표 금액 예시
  ///
  /// In ko, this message translates to:
  /// **'예: 1000000'**
  String get savings_field_target_hint;

  /// 목표 금액 없이도 된다는 안내
  ///
  /// In ko, this message translates to:
  /// **'목표 금액을 지정하지 않으면 비상금·계처럼 계속 모아서 사용할 수 있어요.'**
  String get savings_field_target_helper;

  /// 금액 형식 검증
  ///
  /// In ko, this message translates to:
  /// **'올바른 금액을 입력해 주세요'**
  String get savings_field_amount_invalid;

  /// 자동 적립 스위치 설명
  ///
  /// In ko, this message translates to:
  /// **'매월 자동으로 적립합니다'**
  String get savings_field_auto_deposit_desc;

  /// 월 적립금 입력칸
  ///
  /// In ko, this message translates to:
  /// **'월 적립금 (원)'**
  String get savings_field_monthly_amount;

  /// 월 적립금 예시
  ///
  /// In ko, this message translates to:
  /// **'예: 100000'**
  String get savings_field_monthly_amount_hint;

  /// 월 적립금 검증
  ///
  /// In ko, this message translates to:
  /// **'월 적립금을 입력해 주세요'**
  String get savings_field_monthly_amount_required;

  /// 적립일 입력칸
  ///
  /// In ko, this message translates to:
  /// **'매달 적립일 (1~31일)'**
  String get savings_field_deposit_day;

  /// 적립일 예시
  ///
  /// In ko, this message translates to:
  /// **'예: 25'**
  String get savings_field_deposit_day_hint;

  /// 말일 처리 안내
  ///
  /// In ko, this message translates to:
  /// **'해당 월에 날짜가 없으면 말일에 자동 처리돼요.'**
  String get savings_field_deposit_day_helper;

  /// 적립일 검증
  ///
  /// In ko, this message translates to:
  /// **'1~31 사이의 날짜를 입력해 주세요'**
  String get savings_field_deposit_day_invalid;

  /// 자산 통계 포함 스위치
  ///
  /// In ko, this message translates to:
  /// **'자산 통계에 포함'**
  String get savings_field_include_assets;

  /// 자산 통계 포함 설명
  ///
  /// In ko, this message translates to:
  /// **'자산 현황에서 적립금 잔액을 함께 확인할 수 있어요'**
  String get savings_field_include_assets_desc;

  /// 투표 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'투표'**
  String get vote_title;

  /// 진행 중 필터
  ///
  /// In ko, this message translates to:
  /// **'진행중'**
  String get vote_filter_ongoing;

  /// 종료됨 필터
  ///
  /// In ko, this message translates to:
  /// **'종료됨'**
  String get vote_filter_closed;

  /// 진행 중 배지
  ///
  /// In ko, this message translates to:
  /// **'진행중'**
  String get vote_status_ongoing;

  /// 종료 배지
  ///
  /// In ko, this message translates to:
  /// **'종료'**
  String get vote_status_closed;

  /// 그룹 선택 안내
  ///
  /// In ko, this message translates to:
  /// **'그룹을 선택하면 투표 목록이 표시됩니다'**
  String get vote_select_group;

  /// 투표가 없을 때
  ///
  /// In ko, this message translates to:
  /// **'아직 투표가 없습니다\n+ 버튼으로 새 투표를 만들어보세요'**
  String get vote_list_empty;

  /// 목록 로드 실패
  ///
  /// In ko, this message translates to:
  /// **'투표 목록을 불러오지 못했습니다'**
  String get vote_list_load_error;

  /// 상세 로드 실패
  ///
  /// In ko, this message translates to:
  /// **'투표를 불러오지 못했습니다'**
  String get vote_detail_load_error;

  /// 참여자 수
  ///
  /// In ko, this message translates to:
  /// **'{count}명 참여'**
  String vote_participants(int count);

  /// 내가 참여했음 배지
  ///
  /// In ko, this message translates to:
  /// **'참여함'**
  String get vote_participated;

  /// 마감된 상태
  ///
  /// In ko, this message translates to:
  /// **'마감됨'**
  String get vote_deadline_passed;

  /// 마감까지 남은 일수
  ///
  /// In ko, this message translates to:
  /// **'{days}일 후 마감'**
  String vote_deadline_days(int days);

  /// 마감까지 남은 시간
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간 후 마감'**
  String vote_deadline_hours(int hours);

  /// 마감까지 남은 분
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분 후 마감'**
  String vote_deadline_minutes(int minutes);

  /// 투표 삭제
  ///
  /// In ko, this message translates to:
  /// **'투표 삭제'**
  String get vote_delete;

  /// 투표 삭제 확인
  ///
  /// In ko, this message translates to:
  /// **'이 투표를 삭제하시겠습니까?\n삭제된 투표는 복구할 수 없습니다.'**
  String get vote_delete_message;

  /// 삭제 실패
  ///
  /// In ko, this message translates to:
  /// **'삭제하지 못했습니다'**
  String get vote_delete_failed;

  /// 투표 완료
  ///
  /// In ko, this message translates to:
  /// **'투표가 완료되었습니다'**
  String get vote_submit_success;

  /// 투표 실패
  ///
  /// In ko, this message translates to:
  /// **'투표하지 못했습니다'**
  String get vote_submit_failed;

  /// 복수 선택 배지
  ///
  /// In ko, this message translates to:
  /// **'복수 선택'**
  String get vote_multiple_choice_badge;

  /// 익명 배지
  ///
  /// In ko, this message translates to:
  /// **'익명'**
  String get vote_anonymous_badge;

  /// 투표하기 버튼
  ///
  /// In ko, this message translates to:
  /// **'투표하기'**
  String get vote_submit;

  /// 재투표 버튼
  ///
  /// In ko, this message translates to:
  /// **'재투표하기'**
  String get vote_revote;

  /// 선택지 득표 결과
  ///
  /// In ko, this message translates to:
  /// **'{count}표 ({percent}%)'**
  String vote_option_result(int count, String percent);

  /// 투표 만들기 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'새 투표 만들기'**
  String get vote_create_title;

  /// 투표 제목 입력칸
  ///
  /// In ko, this message translates to:
  /// **'투표 제목 *'**
  String get vote_field_title;

  /// 제목 검증
  ///
  /// In ko, this message translates to:
  /// **'제목을 입력해주세요'**
  String get vote_field_title_required;

  /// 설명 입력칸
  ///
  /// In ko, this message translates to:
  /// **'설명 (선택)'**
  String get vote_field_description;

  /// 선택지 구역 제목
  ///
  /// In ko, this message translates to:
  /// **'선택지'**
  String get vote_options_section;

  /// 선택지 입력칸 힌트
  ///
  /// In ko, this message translates to:
  /// **'선택지 {index}'**
  String vote_option_hint(int index);

  /// 선택지 2개 이상 안내
  ///
  /// In ko, this message translates to:
  /// **'선택지를 2개 이상 입력해주세요'**
  String get vote_options_min;

  /// 투표 생성 실패
  ///
  /// In ko, this message translates to:
  /// **'투표를 만들지 못했습니다'**
  String get vote_create_failed;

  /// 복수 선택 허용 스위치
  ///
  /// In ko, this message translates to:
  /// **'복수 선택 허용'**
  String get vote_allow_multiple;

  /// 복수 선택 설명
  ///
  /// In ko, this message translates to:
  /// **'여러 항목을 동시에 선택할 수 있습니다'**
  String get vote_allow_multiple_desc;

  /// 익명 투표 스위치
  ///
  /// In ko, this message translates to:
  /// **'익명 투표'**
  String get vote_anonymous;

  /// 익명 투표 설명
  ///
  /// In ko, this message translates to:
  /// **'투표자 이름이 공개되지 않습니다'**
  String get vote_anonymous_desc;

  /// 마감 시각 항목
  ///
  /// In ko, this message translates to:
  /// **'마감 시각'**
  String get vote_deadline;

  /// 마감 시각 미설정
  ///
  /// In ko, this message translates to:
  /// **'설정 안 함 (수동 종료)'**
  String get vote_deadline_none;

  /// 할일 상세 - 마감일 라벨
  ///
  /// In ko, this message translates to:
  /// **'마감일'**
  String get todo_label_dueDate;

  /// 할일 상세 - 카테고리 라벨
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get todo_label_category;

  /// 할일 상세 - 등록일 라벨
  ///
  /// In ko, this message translates to:
  /// **'등록일'**
  String get todo_label_createdAt;

  /// 할일 상세 - 완료일 라벨
  ///
  /// In ko, this message translates to:
  /// **'완료일'**
  String get todo_label_completedAt;

  /// 할일 상세 - 상태 라벨
  ///
  /// In ko, this message translates to:
  /// **'상태'**
  String get todo_label_status;

  /// 칸반 열에서 드래그 안내
  ///
  /// In ko, this message translates to:
  /// **'드래그하여 이동'**
  String get todo_drag_to_move;

  /// 더 보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'더 보기'**
  String get common_more;

  /// 장바구니 합계 라벨
  ///
  /// In ko, this message translates to:
  /// **'합계'**
  String get cart_total;

  /// 장바구니 저장 실패
  ///
  /// In ko, this message translates to:
  /// **'저장 중 오류가 발생했습니다'**
  String get cart_save_error;

  /// 개당 금액 모드
  ///
  /// In ko, this message translates to:
  /// **'개당'**
  String get cart_price_unit;

  /// 총액 모드
  ///
  /// In ko, this message translates to:
  /// **'총액'**
  String get cart_price_total;

  /// 개당 금액 입력칸 라벨
  ///
  /// In ko, this message translates to:
  /// **'개당 금액'**
  String get cart_price_unit_label;

  /// 총 금액 입력칸 라벨
  ///
  /// In ko, this message translates to:
  /// **'총 금액'**
  String get cart_price_total_label;

  /// 개당 금액 입력칸 힌트
  ///
  /// In ko, this message translates to:
  /// **'개당 금액 입력'**
  String get cart_price_unit_hint;

  /// 총 금액 입력칸 힌트
  ///
  /// In ko, this message translates to:
  /// **'총 금액 입력'**
  String get cart_price_total_hint;

  /// 단위·메모 입력 열기
  ///
  /// In ko, this message translates to:
  /// **'단위·메모 추가'**
  String get cart_extra_show;

  /// 단위·메모 입력 닫기
  ///
  /// In ko, this message translates to:
  /// **'단위·메모 숨기기'**
  String get cart_extra_hide;

  /// 장보기 날짜 항목
  ///
  /// In ko, this message translates to:
  /// **'장보기 날짜'**
  String get cart_shopping_date;

  /// 날짜 선택 버튼
  ///
  /// In ko, this message translates to:
  /// **'날짜 선택'**
  String get cart_select_date;

  /// 장보기 완료 시 기본 설명
  ///
  /// In ko, this message translates to:
  /// **'마트 장보기'**
  String get cart_default_description;

  /// 내 신고 내역 메뉴 제목
  ///
  /// In ko, this message translates to:
  /// **'내 신고 내역'**
  String get settings_myReportsTitle;

  /// 내 신고 내역 설명
  ///
  /// In ko, this message translates to:
  /// **'내가 신고한 목록을 확인합니다'**
  String get settings_myReportsSubtitle;

  /// 공통 역할 관리 메뉴
  ///
  /// In ko, this message translates to:
  /// **'공통 역할 관리'**
  String get settings_commonRolesTitle;

  /// 공통 역할 관리 설명
  ///
  /// In ko, this message translates to:
  /// **'시스템 전체에 적용되는 공통 역할 관리'**
  String get settings_commonRolesSubtitle;

  /// 사용자 및 계정 관리 메뉴
  ///
  /// In ko, this message translates to:
  /// **'사용자 및 계정 관리'**
  String get settings_userAdminTitle;

  /// 사용자 및 계정 관리 설명
  ///
  /// In ko, this message translates to:
  /// **'구독 수정, 계정 삭제 예약 및 처리'**
  String get settings_userAdminSubtitle;

  /// 신고 관리 메뉴
  ///
  /// In ko, this message translates to:
  /// **'신고 관리'**
  String get settings_reportAdminTitle;

  /// 신고 관리 설명
  ///
  /// In ko, this message translates to:
  /// **'그룹원 신고 접수 및 처리'**
  String get settings_reportAdminSubtitle;

  /// 튜토리얼 다시 보기 메뉴
  ///
  /// In ko, this message translates to:
  /// **'튜토리얼 다시 보기'**
  String get settings_replayTutorial;

  /// 튜토리얼 다시 보기 설명
  ///
  /// In ko, this message translates to:
  /// **'앱 소개 슬라이드와 각 기능의 안내를\n처음부터 다시 볼 수 있습니다.'**
  String get settings_replayTutorialBody;

  /// 다시 보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'다시 보기'**
  String get settings_replayTutorialConfirm;

  /// 튜토리얼 예약 완료 안내
  ///
  /// In ko, this message translates to:
  /// **'다음 앱 실행 시 튜토리얼이 표시됩니다.'**
  String get settings_replayTutorialDone;

  /// 개인 색상 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'개인 색상'**
  String get settings_personalColor;

  /// 개인 색상 선택 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'개인 색상 선택'**
  String get settings_personalColorPick;

  /// 위젯 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'위젯 추가하기'**
  String get widgetSettings_addWidget;

  /// 기념일 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'기념일 추가'**
  String get widgetSettings_addAnniversary;

  /// 신고하기 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'신고하기'**
  String get report_title;

  /// 신고 사유 라벨
  ///
  /// In ko, this message translates to:
  /// **'신고 사유'**
  String get report_reason;

  /// 상세 내용 라벨
  ///
  /// In ko, this message translates to:
  /// **'상세 내용 (선택)'**
  String get report_detail;

  /// 상세 내용 힌트
  ///
  /// In ko, this message translates to:
  /// **'추가 설명을 입력하세요'**
  String get report_detail_hint;

  /// 신고 접수 버튼
  ///
  /// In ko, this message translates to:
  /// **'신고 접수'**
  String get report_submit;

  /// 신고 접수 완료
  ///
  /// In ko, this message translates to:
  /// **'신고가 접수되었습니다.'**
  String get report_submitted;

  /// 신고 접수 실패
  ///
  /// In ko, this message translates to:
  /// **'신고를 접수하지 못했습니다'**
  String get report_submit_failed;

  /// 신고 내역 없음
  ///
  /// In ko, this message translates to:
  /// **'신고 내역이 없습니다'**
  String get report_empty;

  /// 신고 관리 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'신고 관리'**
  String get report_admin_title;

  /// 신고 처리 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'신고 처리'**
  String get report_handle_title;

  /// 처리 상태 라벨
  ///
  /// In ko, this message translates to:
  /// **'처리 상태'**
  String get report_handle_status;

  /// 처리 메모 라벨
  ///
  /// In ko, this message translates to:
  /// **'처리 메모 (선택)'**
  String get report_handle_memo;

  /// 처리 메모 힌트
  ///
  /// In ko, this message translates to:
  /// **'처리 내용을 입력하세요'**
  String get report_handle_memo_hint;

  /// 처리 완료 버튼
  ///
  /// In ko, this message translates to:
  /// **'처리 완료'**
  String get report_handle_done;

  /// 신고 처리 완료 안내
  ///
  /// In ko, this message translates to:
  /// **'신고가 처리되었습니다.'**
  String get report_handled;

  /// 신고 처리 실패
  ///
  /// In ko, this message translates to:
  /// **'처리하지 못했습니다'**
  String get report_handle_failed;

  /// 초대 취소
  ///
  /// In ko, this message translates to:
  /// **'초대 취소'**
  String get group_invite_cancel;

  /// 초대 취소 확인
  ///
  /// In ko, this message translates to:
  /// **'{email}에게 보낸 초대를 취소하시겠습니까?'**
  String group_invite_cancel_message(String email);

  /// 초대 취소 완료
  ///
  /// In ko, this message translates to:
  /// **'초대가 취소되었습니다'**
  String get group_invite_canceled;

  /// 초대 재전송 완료
  ///
  /// In ko, this message translates to:
  /// **'{email}에게 초대 이메일을 다시 보냈습니다'**
  String group_invite_resent(String email);

  /// 재전송 버튼
  ///
  /// In ko, this message translates to:
  /// **'재전송'**
  String get group_invite_resend;

  /// 색상 변경 실패
  ///
  /// In ko, this message translates to:
  /// **'색상을 바꾸지 못했습니다'**
  String get group_color_change_failed;

  /// 색상 초기화 완료
  ///
  /// In ko, this message translates to:
  /// **'그룹 기본 색상으로 되돌렸습니다'**
  String get group_color_reset;

  /// 색상 초기화 실패
  ///
  /// In ko, this message translates to:
  /// **'색상을 되돌리지 못했습니다'**
  String get group_color_reset_failed;

  /// 그룹 순서 저장 완료
  ///
  /// In ko, this message translates to:
  /// **'그룹 순서를 저장했습니다'**
  String get group_order_saved;

  /// 멤버 없음
  ///
  /// In ko, this message translates to:
  /// **'멤버가 없습니다'**
  String get group_members_empty;

  /// 멤버 탈퇴 메뉴
  ///
  /// In ko, this message translates to:
  /// **'멤버 탈퇴'**
  String get group_member_remove;

  /// 멤버 삭제 완료
  ///
  /// In ko, this message translates to:
  /// **'멤버를 삭제했습니다'**
  String get group_member_removed;

  /// 역할 변경 메뉴
  ///
  /// In ko, this message translates to:
  /// **'역할 변경'**
  String get group_role_change;

  /// 역할 변경 완료
  ///
  /// In ko, this message translates to:
  /// **'역할을 변경했습니다'**
  String get group_role_changed;

  /// 역할 목록 로드 실패
  ///
  /// In ko, this message translates to:
  /// **'역할 목록을 불러올 수 없습니다'**
  String get group_roles_load_error;

  /// 초대 코드 재생성 확인
  ///
  /// In ko, this message translates to:
  /// **'초대 코드를 재생성하시겠습니까?\n기존 초대 코드는 사용할 수 없게 됩니다.'**
  String get group_regenerate_code_message;

  /// 그룹장 양도
  ///
  /// In ko, this message translates to:
  /// **'그룹장 양도'**
  String get group_transfer_ownership;

  /// 양도하기 버튼
  ///
  /// In ko, this message translates to:
  /// **'양도하기'**
  String get group_transfer_confirm;

  /// 양도 확인 문구
  ///
  /// In ko, this message translates to:
  /// **'{name}님에게 그룹장 권한을 넘기시겠습니까?'**
  String group_transfer_message(String name);

  /// 양도 실패
  ///
  /// In ko, this message translates to:
  /// **'그룹장을 넘기지 못했습니다'**
  String get group_transfer_failed;

  /// 그룹 초대 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'그룹 초대'**
  String get invite_title;

  /// 가입 진행 중
  ///
  /// In ko, this message translates to:
  /// **'그룹에 가입 중...'**
  String get invite_joining;

  /// 가입 완료
  ///
  /// In ko, this message translates to:
  /// **'그룹 가입 완료!'**
  String get invite_joined;

  /// 홈으로 버튼
  ///
  /// In ko, this message translates to:
  /// **'홈으로'**
  String get invite_go_home;

  /// 로그인 필요 안내
  ///
  /// In ko, this message translates to:
  /// **'로그인 후 그룹에 가입할 수 있어요.'**
  String get invite_login_required;

  /// 로그인하기 버튼
  ///
  /// In ko, this message translates to:
  /// **'로그인하기'**
  String get invite_login;

  /// 가입 실패 제목
  ///
  /// In ko, this message translates to:
  /// **'가입 실패'**
  String get invite_failed;

  /// 양도 완료 안내
  ///
  /// In ko, this message translates to:
  /// **'{name}님에게 그룹장을 넘겼습니다'**
  String group_transfer_done(String name);

  /// 초대 코드 표시
  ///
  /// In ko, this message translates to:
  /// **'초대 코드: {code}'**
  String invite_code_label(String code);

  /// 알 수 없는 오류
  ///
  /// In ko, this message translates to:
  /// **'알 수 없는 오류가 발생했어요.'**
  String get invite_unknown_error;

  /// 알 수 없는 오류
  ///
  /// In ko, this message translates to:
  /// **'알 수 없는 오류'**
  String get common_unknownError;

  /// 정렬 순서 저장 완료
  ///
  /// In ko, this message translates to:
  /// **'정렬 순서를 저장했습니다'**
  String get common_sortOrderSaved;

  /// 저장 실패
  ///
  /// In ko, this message translates to:
  /// **'저장하지 못했습니다'**
  String get common_saveFailed;

  /// 삭제 실패
  ///
  /// In ko, this message translates to:
  /// **'삭제하지 못했습니다'**
  String get common_deleteFailed;

  /// 검색 결과 없음
  ///
  /// In ko, this message translates to:
  /// **'검색 결과가 없습니다'**
  String get common_noSearchResults;

  /// 공통 역할 관리 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'공통 역할 관리'**
  String get role_common_title;

  /// 역할 생성 버튼
  ///
  /// In ko, this message translates to:
  /// **'역할 생성'**
  String get role_create;

  /// 역할 목록 로드 실패
  ///
  /// In ko, this message translates to:
  /// **'역할 목록을 불러오지 못했습니다'**
  String get role_list_load_error;

  /// 공통 역할 없음
  ///
  /// In ko, this message translates to:
  /// **'등록된 공통 역할이 없습니다'**
  String get role_list_empty;

  /// 공통 역할 없음 안내
  ///
  /// In ko, this message translates to:
  /// **'+ 버튼을 눌러 새로운 역할을 만드세요'**
  String get role_list_empty_subtitle;

  /// 역할 정보 로드 실패
  ///
  /// In ko, this message translates to:
  /// **'역할 정보를 불러오지 못했습니다'**
  String get role_info_load_error;

  /// 역할 없음 예외
  ///
  /// In ko, this message translates to:
  /// **'역할을 찾을 수 없습니다'**
  String get role_not_found;

  /// 역할별 권한 관리 제목
  ///
  /// In ko, this message translates to:
  /// **'{name} 권한 관리'**
  String role_permissions_title(String name);

  /// 권한 검색 힌트
  ///
  /// In ko, this message translates to:
  /// **'권한 검색'**
  String get role_permission_search;

  /// 권한 목록 로드 실패
  ///
  /// In ko, this message translates to:
  /// **'권한 목록을 불러오지 못했습니다'**
  String get role_permissions_load_error;

  /// 권한 저장 완료
  ///
  /// In ko, this message translates to:
  /// **'권한을 저장했습니다'**
  String get role_permissions_saved;

  /// 공통 역할 수정 제목
  ///
  /// In ko, this message translates to:
  /// **'공통 역할 수정'**
  String get role_edit_title;

  /// 공통 역할 생성 제목
  ///
  /// In ko, this message translates to:
  /// **'공통 역할 생성'**
  String get role_create_title;

  /// 역할 생성 완료
  ///
  /// In ko, this message translates to:
  /// **'역할을 만들었습니다'**
  String get role_created;

  /// 역할 수정 완료
  ///
  /// In ko, this message translates to:
  /// **'역할을 수정했습니다'**
  String get role_updated;

  /// 역할 생성 실패
  ///
  /// In ko, this message translates to:
  /// **'역할을 만들지 못했습니다'**
  String get role_create_failed;

  /// 역할 수정 실패
  ///
  /// In ko, this message translates to:
  /// **'역할을 수정하지 못했습니다'**
  String get role_update_failed;

  /// 역할 이름 입력칸
  ///
  /// In ko, this message translates to:
  /// **'역할 이름'**
  String get role_field_name;

  /// 역할 이름 예시
  ///
  /// In ko, this message translates to:
  /// **'예: ADMIN, MEMBER'**
  String get role_field_name_hint;

  /// 역할 이름 검증
  ///
  /// In ko, this message translates to:
  /// **'역할 이름을 입력하세요'**
  String get role_field_name_required;

  /// 기본 역할 스위치
  ///
  /// In ko, this message translates to:
  /// **'기본 역할'**
  String get role_default;

  /// 기본 역할 설명
  ///
  /// In ko, this message translates to:
  /// **'신규 가입 시 자동으로 부여되는 역할'**
  String get role_default_desc;

  /// 기본 역할 배지
  ///
  /// In ko, this message translates to:
  /// **'기본'**
  String get role_default_badge;

  /// 역할 색상 섹션
  ///
  /// In ko, this message translates to:
  /// **'역할 색상'**
  String get role_color;

  /// 역할 삭제
  ///
  /// In ko, this message translates to:
  /// **'역할 삭제'**
  String get role_delete;

  /// 역할 삭제 확인
  ///
  /// In ko, this message translates to:
  /// **'{name} 역할을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'**
  String role_delete_message(String name);

  /// 역할 삭제 완료
  ///
  /// In ko, this message translates to:
  /// **'역할을 삭제했습니다'**
  String get role_deleted;

  /// 권한 관리 메뉴
  ///
  /// In ko, this message translates to:
  /// **'권한 관리'**
  String get role_manage_permissions;

  /// 권한 이름 힌트
  ///
  /// In ko, this message translates to:
  /// **'예시 권한'**
  String get permission_name_hint;

  /// 권한 설명 힌트
  ///
  /// In ko, this message translates to:
  /// **'이 권한에 대한 설명을 입력하세요'**
  String get permission_desc_hint;

  /// 직접 입력 선택지
  ///
  /// In ko, this message translates to:
  /// **'+ 직접 입력'**
  String get permission_category_custom;

  /// 새 카테고리 이름 입력칸
  ///
  /// In ko, this message translates to:
  /// **'새 카테고리 이름'**
  String get permission_category_new;

  /// 카테고리 이름 검증
  ///
  /// In ko, this message translates to:
  /// **'새 카테고리 이름을 입력해주세요'**
  String get permission_category_required;

  /// 적금 플랜 카드 제목
  ///
  /// In ko, this message translates to:
  /// **'적금 플랜'**
  String get childcare_savings_plan;

  /// 적금 진행 중 배지
  ///
  /// In ko, this message translates to:
  /// **'진행 중'**
  String get childcare_savings_ongoing;

  /// 적금 만기 배지
  ///
  /// In ko, this message translates to:
  /// **'만기 완료'**
  String get childcare_savings_matured;

  /// 단리
  ///
  /// In ko, this message translates to:
  /// **'단리'**
  String get childcare_interest_simple;

  /// 복리
  ///
  /// In ko, this message translates to:
  /// **'복리'**
  String get childcare_interest_compound;

  /// 이자 유형 라벨
  ///
  /// In ko, this message translates to:
  /// **'이자 유형'**
  String get childcare_interest_type;

  /// 월 납입액 라벨
  ///
  /// In ko, this message translates to:
  /// **'월 납입액'**
  String get childcare_monthly_deposit;

  /// 이자율 라벨
  ///
  /// In ko, this message translates to:
  /// **'이자율'**
  String get childcare_interest_rate;

  /// 기간 라벨
  ///
  /// In ko, this message translates to:
  /// **'기간'**
  String get childcare_period;

  /// 적금 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'적금 플랜 시작하기'**
  String get childcare_savings_start;

  /// 적금 시작 설명
  ///
  /// In ko, this message translates to:
  /// **'매월 자동으로 적금이 납입돼요'**
  String get childcare_savings_start_desc;

  /// 중도 해지 버튼
  ///
  /// In ko, this message translates to:
  /// **'중도 해지'**
  String get childcare_savings_cancel;

  /// 중도 해지 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'적금 중도 해지'**
  String get childcare_savings_cancel_title;

  /// 중도 해지 확인
  ///
  /// In ko, this message translates to:
  /// **'중도 해지 시 이자 없이 원금만 반환됩니다.\n정말 해지하시겠습니까?'**
  String get childcare_savings_cancel_message;

  /// 해지 버튼
  ///
  /// In ko, this message translates to:
  /// **'해지'**
  String get childcare_savings_cancel_confirm;

  /// 해지 완료
  ///
  /// In ko, this message translates to:
  /// **'적금을 해지했습니다'**
  String get childcare_savings_canceled;

  /// 해지 실패
  ///
  /// In ko, this message translates to:
  /// **'해지하지 못했습니다'**
  String get childcare_savings_cancel_failed;

  /// 적금 시작 완료
  ///
  /// In ko, this message translates to:
  /// **'적금 플랜을 시작했습니다'**
  String get childcare_savings_started;

  /// 적금 만들기 제목
  ///
  /// In ko, this message translates to:
  /// **'적금 플랜 만들기'**
  String get childcare_savings_create_title;

  /// 월 납입 포인트 입력칸
  ///
  /// In ko, this message translates to:
  /// **'월 납입 포인트'**
  String get childcare_savings_monthly_points;

  /// 연 이자율 입력칸
  ///
  /// In ko, this message translates to:
  /// **'연 이자율'**
  String get childcare_savings_annual_rate;

  /// 기준 금리 안내
  ///
  /// In ko, this message translates to:
  /// **'현재 국고채 3년물 금리({rate}%)를 참고해 기본값을 넣었어요'**
  String childcare_savings_rate_helper(String rate);

  /// 기준 금리 로딩
  ///
  /// In ko, this message translates to:
  /// **'국고채 3년물 금리를 불러오는 중...'**
  String get childcare_savings_rate_loading;

  /// 시작일 항목
  ///
  /// In ko, this message translates to:
  /// **'시작일'**
  String get childcare_start_date;

  /// 만기일 항목
  ///
  /// In ko, this message translates to:
  /// **'만기일'**
  String get childcare_maturity_date;

  /// 총 납입 라벨
  ///
  /// In ko, this message translates to:
  /// **'총 납입'**
  String get childcare_total_deposit;

  /// 예상 이자 라벨
  ///
  /// In ko, this message translates to:
  /// **'예상 이자'**
  String get childcare_expected_interest;

  /// 만기 수령 라벨
  ///
  /// In ko, this message translates to:
  /// **'만기 수령'**
  String get childcare_maturity_amount;

  /// 개월 단위
  ///
  /// In ko, this message translates to:
  /// **'{months}개월'**
  String childcare_months(int months);

  /// 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'시작'**
  String get childcare_start;

  /// 용돈 플랜 미설정 안내
  ///
  /// In ko, this message translates to:
  /// **'용돈 플랜이 설정되지 않았습니다'**
  String get childcare_allowance_missing;

  /// 용돈 플랜 미설정 설명
  ///
  /// In ko, this message translates to:
  /// **'월 포인트, 지급일 등을 설정해보세요'**
  String get childcare_allowance_missing_desc;

  /// 연봉 협상일 지남 제목
  ///
  /// In ko, this message translates to:
  /// **'연봉 협상일이 지났습니다'**
  String get childcare_negotiation_passed;

  /// 연봉 협상일 임박 제목
  ///
  /// In ko, this message translates to:
  /// **'연봉 협상일이 다가오고 있습니다'**
  String get childcare_negotiation_upcoming;

  /// 협상일 지남 설명
  ///
  /// In ko, this message translates to:
  /// **'{days}일 전({date})이었습니다. 용돈 플랜을 검토해보세요'**
  String childcare_negotiation_passed_desc(int days, String date);

  /// 협상일 당일 안내
  ///
  /// In ko, this message translates to:
  /// **'오늘이 연봉 협상일입니다! ({date})'**
  String childcare_negotiation_today(String date);

  /// 포인트 현금화 제목
  ///
  /// In ko, this message translates to:
  /// **'포인트 현금화'**
  String get childcare_cashout;

  /// 현금화 버튼
  ///
  /// In ko, this message translates to:
  /// **'현금화'**
  String get childcare_cashout_button;

  /// 현금화할 포인트 입력칸
  ///
  /// In ko, this message translates to:
  /// **'현금화할 포인트'**
  String get childcare_cashout_points;

  /// 현금화 실패
  ///
  /// In ko, this message translates to:
  /// **'현금화하지 못했습니다. 잠시 후 다시 시도해주세요.'**
  String get childcare_cashout_failed;

  /// 현금화 거래 설명
  ///
  /// In ko, this message translates to:
  /// **'포인트 현금화 ({amount}원)'**
  String childcare_cashout_description(String amount);

  /// 현금화 완료 안내
  ///
  /// In ko, this message translates to:
  /// **'{points}P를 {amount}원으로 바꿨습니다'**
  String childcare_cashout_done(String points, String amount);

  /// 현금화 환율·잔액 안내
  ///
  /// In ko, this message translates to:
  /// **'1P = {ratio}원 · 보유 {balance}P'**
  String childcare_cashout_rate(String ratio, String balance);

  /// 현금화 예상 금액
  ///
  /// In ko, this message translates to:
  /// **'≈ {amount}원'**
  String childcare_cashout_approx(String amount);

  /// 규칙 적용 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'규칙 적용'**
  String get childcare_rule_apply;

  /// 규칙 위반 적용 제목
  ///
  /// In ko, this message translates to:
  /// **'규칙 위반 적용'**
  String get childcare_rule_apply_penalty;

  /// 포인트 지급 확인
  ///
  /// In ko, this message translates to:
  /// **'\"{name}\"\n{points}P를 지급합니다.'**
  String childcare_rule_apply_plus_message(String name, String points);

  /// 포인트 차감 확인
  ///
  /// In ko, this message translates to:
  /// **'\"{name}\" 위반으로\n{points}P를 차감합니다.'**
  String childcare_rule_apply_minus_message(String name, String points);

  /// 지급 버튼
  ///
  /// In ko, this message translates to:
  /// **'지급'**
  String get childcare_rule_give;

  /// 차감 버튼
  ///
  /// In ko, this message translates to:
  /// **'차감'**
  String get childcare_rule_deduct;

  /// 포인트 지급 완료
  ///
  /// In ko, this message translates to:
  /// **'{points}P를 지급했습니다'**
  String childcare_points_given(String points);

  /// 포인트 차감 완료
  ///
  /// In ko, this message translates to:
  /// **'{points}P를 차감했습니다'**
  String childcare_points_deducted(String points);

  /// 규칙 삭제 제목
  ///
  /// In ko, this message translates to:
  /// **'규칙 삭제'**
  String get childcare_rule_delete;

  /// 규칙 삭제 확인
  ///
  /// In ko, this message translates to:
  /// **'\"{name}\"을(를) 삭제하시겠습니까?'**
  String childcare_rule_delete_message(String name);

  /// 삭제 완료 안내
  ///
  /// In ko, this message translates to:
  /// **'삭제되었습니다'**
  String get common_deleted;

  /// 저장 완료 안내
  ///
  /// In ko, this message translates to:
  /// **'저장되었습니다'**
  String get common_saved;

  /// +포인트 규칙
  ///
  /// In ko, this message translates to:
  /// **'+ 포인트 규칙'**
  String get childcare_rule_type_plus;

  /// -포인트 규칙
  ///
  /// In ko, this message translates to:
  /// **'- 포인트 규칙'**
  String get childcare_rule_type_minus;

  /// 일반 규칙
  ///
  /// In ko, this message translates to:
  /// **'일반 규칙'**
  String get childcare_rule_type_info;

  /// 규칙 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'규칙이란 무엇인가요?'**
  String get childcare_rule_help_title;

  /// 규칙 안내 본문
  ///
  /// In ko, this message translates to:
  /// **'규칙은 아이의 행동에 포인트를 연결하는 약속입니다.\n좋은 행동에는 포인트를 주고, 약속을 어겼을 때는 포인트를 차감해요.'**
  String get childcare_rule_help_body;

  /// 규칙 작성 팁
  ///
  /// In ko, this message translates to:
  /// **'규칙은 구체적이고 명확할수록 좋습니다.\n애매한 규칙은 아이와 불필요한 기싸움으로 이어질 수 있어요.\n아이와 함께 규칙을 정하면 신뢰가 쌓입니다.'**
  String get childcare_rule_help_tip;

  /// + 규칙 예시 라벨
  ///
  /// In ko, this message translates to:
  /// **'+ 규칙 예시 (포인트 지급)'**
  String get childcare_rule_examples_plus;

  /// - 규칙 예시 라벨
  ///
  /// In ko, this message translates to:
  /// **'- 규칙 예시 (포인트 차감)'**
  String get childcare_rule_examples_minus;

  /// 일반 규칙 예시 라벨
  ///
  /// In ko, this message translates to:
  /// **'일반 규칙 예시 (포인트 없음)'**
  String get childcare_rule_examples_info;

  /// + 예시 1
  ///
  /// In ko, this message translates to:
  /// **'학교 숙제를 혼자 힘으로 끝냈을 때  +10P'**
  String get childcare_rule_example_plus1;

  /// + 예시 2
  ///
  /// In ko, this message translates to:
  /// **'저녁 9시 이전에 스스로 잠자리에 들었을 때  +5P'**
  String get childcare_rule_example_plus2;

  /// + 예시 3
  ///
  /// In ko, this message translates to:
  /// **'밥 먹은 후 식기를 싱크대에 가져다 놓았을 때  +3P'**
  String get childcare_rule_example_plus3;

  /// + 예시 4
  ///
  /// In ko, this message translates to:
  /// **'일주일 동안 지각 없이 등교했을 때  +20P'**
  String get childcare_rule_example_plus4;

  /// - 예시 1
  ///
  /// In ko, this message translates to:
  /// **'평일에 스마트폰을 1시간 이상 사용했을 때  -10P'**
  String get childcare_rule_example_minus1;

  /// - 예시 2
  ///
  /// In ko, this message translates to:
  /// **'저녁 10시가 넘도록 잠자리에 들지 않았을 때  -5P'**
  String get childcare_rule_example_minus2;

  /// - 예시 3
  ///
  /// In ko, this message translates to:
  /// **'형제·자매에게 욕설을 했을 때  -15P'**
  String get childcare_rule_example_minus3;

  /// - 예시 4
  ///
  /// In ko, this message translates to:
  /// **'약속된 귀가 시간인 오후 6시를 넘겼을 때  -10P'**
  String get childcare_rule_example_minus4;

  /// 일반 예시 1
  ///
  /// In ko, this message translates to:
  /// **'이달 포인트 현금 전환은 최대 50P까지만 가능'**
  String get childcare_rule_example_info1;

  /// 일반 예시 2
  ///
  /// In ko, this message translates to:
  /// **'포인트 상점 아이템은 하루 1개만 사용 가능'**
  String get childcare_rule_example_info2;

  /// 규칙 적용 안내
  ///
  /// In ko, this message translates to:
  /// **'규칙을 적용하면 해당 포인트가 즉시 반영됩니다.'**
  String get childcare_rule_apply_note;

  /// 규칙 추가 제목
  ///
  /// In ko, this message translates to:
  /// **'규칙 추가'**
  String get childcare_rule_add;

  /// 규칙 수정 제목
  ///
  /// In ko, this message translates to:
  /// **'규칙 수정'**
  String get childcare_rule_edit;

  /// 규칙 유형 라벨
  ///
  /// In ko, this message translates to:
  /// **'규칙 유형'**
  String get childcare_rule_type;

  /// +포인트 선택지
  ///
  /// In ko, this message translates to:
  /// **'+포인트'**
  String get childcare_rule_type_plus_short;

  /// -포인트 선택지
  ///
  /// In ko, this message translates to:
  /// **'-포인트'**
  String get childcare_rule_type_minus_short;

  /// 일반 선택지
  ///
  /// In ko, this message translates to:
  /// **'일반'**
  String get childcare_rule_type_info_short;

  /// + 규칙 이름 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 숙제를 스스로 했을 때'**
  String get childcare_rule_name_hint_plus;

  /// - 규칙 이름 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 스마트폰을 30분 이상 보았을 때'**
  String get childcare_rule_name_hint_minus;

  /// 일반 규칙 이름 힌트
  ///
  /// In ko, this message translates to:
  /// **'예: 이달 현금 출금 한도'**
  String get childcare_rule_name_hint_info;

  /// 지급 포인트 라벨
  ///
  /// In ko, this message translates to:
  /// **'지급 포인트'**
  String get childcare_rule_points_give;

  /// 차감 포인트 라벨
  ///
  /// In ko, this message translates to:
  /// **'차감 포인트'**
  String get childcare_rule_points_deduct;

  /// 지급 포인트 설명
  ///
  /// In ko, this message translates to:
  /// **'좋은 행동 시 지급할 포인트'**
  String get childcare_rule_points_give_hint;

  /// 차감 포인트 설명
  ///
  /// In ko, this message translates to:
  /// **'규칙 위반 시 차감할 포인트'**
  String get childcare_rule_points_deduct_hint;

  /// 저장 실패 안내
  ///
  /// In ko, this message translates to:
  /// **'저장하지 못했습니다. 잠시 후 다시 시도해주세요.'**
  String get childcare_save_failed;

  /// 자녀 기본 호칭
  ///
  /// In ko, this message translates to:
  /// **'자녀'**
  String get childcare_child;

  /// 용돈 플랜 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'{name} 용돈 플랜'**
  String childcare_allowance_plan_title(String name);

  /// 설정 탭
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get childcare_tab_settings;

  /// 변경 히스토리 탭
  ///
  /// In ko, this message translates to:
  /// **'변경 히스토리'**
  String get childcare_tab_change_history;

  /// 용돈 플랜 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'용돈 플랜 설정'**
  String get childcare_allowance_setup;

  /// 용돈 플랜 수정 제목
  ///
  /// In ko, this message translates to:
  /// **'용돈 플랜 수정'**
  String get childcare_allowance_edit;

  /// 월 지급 포인트 입력칸
  ///
  /// In ko, this message translates to:
  /// **'월 지급 포인트'**
  String get childcare_monthly_points;

  /// 월 지급 포인트 예시
  ///
  /// In ko, this message translates to:
  /// **'예: 100'**
  String get childcare_monthly_points_hint;

  /// 월 지급 포인트 검증
  ///
  /// In ko, this message translates to:
  /// **'월 지급 포인트를 입력해주세요'**
  String get childcare_monthly_points_required;

  /// 숫자 검증
  ///
  /// In ko, this message translates to:
  /// **'숫자를 입력해주세요'**
  String get childcare_number_required;

  /// 지급일 입력칸
  ///
  /// In ko, this message translates to:
  /// **'매달 지급일'**
  String get childcare_pay_day;

  /// 일 단위
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get childcare_day_unit;

  /// 지급일 말일 안내
  ///
  /// In ko, this message translates to:
  /// **'해당 월에 선택한 날짜가 없으면 말일에 지급됩니다'**
  String get childcare_pay_day_helper;

  /// 선택한 일자
  ///
  /// In ko, this message translates to:
  /// **'{day}일'**
  String childcare_day_value(String day);

  /// 날짜 선택 안내
  ///
  /// In ko, this message translates to:
  /// **'날짜를 선택하세요'**
  String get childcare_select_date;

  /// 선택 날짜 안내
  ///
  /// In ko, this message translates to:
  /// **'날짜를 선택하세요 (선택)'**
  String get childcare_select_date_optional;

  /// 포인트 환산 입력칸
  ///
  /// In ko, this message translates to:
  /// **'1포인트 = N원'**
  String get childcare_point_ratio;

  /// 포인트 환산 예시
  ///
  /// In ko, this message translates to:
  /// **'예: 10'**
  String get childcare_point_ratio_hint;

  /// 포인트 환산 설명
  ///
  /// In ko, this message translates to:
  /// **'아이와의 약속을 명확히 하기 위한 표시용입니다'**
  String get childcare_point_ratio_helper;

  /// 1 이상 검증
  ///
  /// In ko, this message translates to:
  /// **'1 이상의 숫자를 입력해주세요'**
  String get childcare_min_one;

  /// 연봉 협상일 입력칸
  ///
  /// In ko, this message translates to:
  /// **'다음 연봉 협상일 (선택)'**
  String get childcare_negotiation_date;

  /// 플랜 설정 버튼
  ///
  /// In ko, this message translates to:
  /// **'플랜 설정'**
  String get childcare_plan_save;

  /// 플랜 수정 버튼
  ///
  /// In ko, this message translates to:
  /// **'플랜 수정'**
  String get childcare_plan_update;

  /// 플랜 저장 완료
  ///
  /// In ko, this message translates to:
  /// **'용돈 플랜을 저장했습니다'**
  String get childcare_plan_saved;

  /// 현재 플랜 카드 제목
  ///
  /// In ko, this message translates to:
  /// **'현재 용돈 플랜'**
  String get childcare_current_plan;

  /// 월 지급 라벨
  ///
  /// In ko, this message translates to:
  /// **'월 지급'**
  String get childcare_monthly_payout;

  /// 지급일 라벨
  ///
  /// In ko, this message translates to:
  /// **'지급일'**
  String get childcare_payout_day;

  /// 매월 N일
  ///
  /// In ko, this message translates to:
  /// **'매월 {day}일'**
  String childcare_payout_day_value(String day);

  /// 다음 협상일 라벨
  ///
  /// In ko, this message translates to:
  /// **'다음 협상일'**
  String get childcare_next_negotiation;

  /// 변경 히스토리 없음
  ///
  /// In ko, this message translates to:
  /// **'변경 히스토리가 없습니다'**
  String get childcare_history_empty;

  /// 히스토리 로드 실패
  ///
  /// In ko, this message translates to:
  /// **'히스토리를 불러오지 못했습니다'**
  String get childcare_history_load_error;

  /// 히스토리 항목 제목
  ///
  /// In ko, this message translates to:
  /// **'{points}P / 매월 {day}일'**
  String childcare_history_entry(String points, String day);

  /// 환산 비율 표시
  ///
  /// In ko, this message translates to:
  /// **'1P = {amount}원'**
  String childcare_ratio_value(String amount);

  /// 협상일 접미
  ///
  /// In ko, this message translates to:
  /// **'협상일 {date}'**
  String childcare_negotiation_suffix(String date);

  /// 매달 N일 선택 표시
  ///
  /// In ko, this message translates to:
  /// **'매달 {day}일'**
  String childcare_monthly_day(String day);

  /// 아이템 사용 제목
  ///
  /// In ko, this message translates to:
  /// **'아이템 사용'**
  String get childcare_item_use;

  /// 아이템 사용 확인
  ///
  /// In ko, this message translates to:
  /// **'\"{name}\"\n{points}P를 사용합니다.'**
  String childcare_item_use_message(String name, String points);

  /// 사용 버튼
  ///
  /// In ko, this message translates to:
  /// **'사용'**
  String get childcare_item_use_confirm;

  /// 사용 완료
  ///
  /// In ko, this message translates to:
  /// **'\"{name}\"을(를) 사용했습니다'**
  String childcare_item_used(String name);

  /// 사용 실패
  ///
  /// In ko, this message translates to:
  /// **'사용하지 못했습니다. 잠시 후 다시 시도해주세요.'**
  String get childcare_item_use_failed;

  /// 아이템 삭제 제목
  ///
  /// In ko, this message translates to:
  /// **'아이템 삭제'**
  String get childcare_item_delete;

  /// 아이템 삭제 확인
  ///
  /// In ko, this message translates to:
  /// **'\"{name}\"을(를) 삭제하시겠습니까?'**
  String childcare_item_delete_message(String name);

  /// 삭제 실패 안내
  ///
  /// In ko, this message translates to:
  /// **'삭제하지 못했습니다. 잠시 후 다시 시도해주세요.'**
  String get childcare_delete_failed;

  /// 상점 아이템 추가 제목
  ///
  /// In ko, this message translates to:
  /// **'상점 아이템 추가'**
  String get childcare_item_add;

  /// 상점 아이템 수정 제목
  ///
  /// In ko, this message translates to:
  /// **'상점 아이템 수정'**
  String get childcare_item_edit;

  /// 아이템 이름 입력칸
  ///
  /// In ko, this message translates to:
  /// **'아이템 이름'**
  String get childcare_item_name;

  /// 아이템 이름 예시
  ///
  /// In ko, this message translates to:
  /// **'예: TV 30분 더보기'**
  String get childcare_item_name_hint;

  /// 포인트 비용 입력칸
  ///
  /// In ko, this message translates to:
  /// **'포인트 비용'**
  String get childcare_item_points;

  /// 상점 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'포인트 상점이란?'**
  String get childcare_shop_help_title;

  /// 상점 안내 본문
  ///
  /// In ko, this message translates to:
  /// **'아이가 모은 포인트로 구매할 수 있는 보상 목록입니다.\n원하는 것을 얻기 위해 스스로 포인트를 모으는 동기부여가 됩니다.'**
  String get childcare_shop_help_body;

  /// 예시 아이템 라벨
  ///
  /// In ko, this message translates to:
  /// **'예시 아이템'**
  String get childcare_shop_examples;

  /// 예시 1
  ///
  /// In ko, this message translates to:
  /// **'TV 30분 더보기'**
  String get childcare_shop_example1;

  /// 예시 2
  ///
  /// In ko, this message translates to:
  /// **'게임 1시간 하기'**
  String get childcare_shop_example2;

  /// 예시 3
  ///
  /// In ko, this message translates to:
  /// **'원하는 간식 고르기'**
  String get childcare_shop_example3;

  /// 예시 4
  ///
  /// In ko, this message translates to:
  /// **'늦게 자도 되는 날'**
  String get childcare_shop_example4;

  /// 비활성화 안내
  ///
  /// In ko, this message translates to:
  /// **'아이템을 비활성화하면 목록에서 숨길 수 있습니다.'**
  String get childcare_shop_disable_note;

  /// 월별 보기
  ///
  /// In ko, this message translates to:
  /// **'월별'**
  String get childcare_period_monthly;

  /// 연도별 보기
  ///
  /// In ko, this message translates to:
  /// **'연도별'**
  String get childcare_period_yearly;

  /// 수입 라벨
  ///
  /// In ko, this message translates to:
  /// **'수입'**
  String get childcare_income;

  /// 지출 라벨
  ///
  /// In ko, this message translates to:
  /// **'지출'**
  String get childcare_expense;

  /// 순변동 라벨
  ///
  /// In ko, this message translates to:
  /// **'순변동'**
  String get childcare_net_change;

  /// 연간 수입 라벨
  ///
  /// In ko, this message translates to:
  /// **'연간 수입'**
  String get childcare_yearly_income;

  /// 연간 지출 라벨
  ///
  /// In ko, this message translates to:
  /// **'연간 지출'**
  String get childcare_yearly_expense;

  /// 잔액 추이 제목
  ///
  /// In ko, this message translates to:
  /// **'잔액 추이'**
  String get childcare_balance_trend;

  /// 월별 현황 제목
  ///
  /// In ko, this message translates to:
  /// **'월별 현황'**
  String get childcare_monthly_status;

  /// 유형별 분포 제목
  ///
  /// In ko, this message translates to:
  /// **'유형별 분포'**
  String get childcare_type_distribution;

  /// N월
  ///
  /// In ko, this message translates to:
  /// **'{month}월'**
  String childcare_month_unit(String month);

  /// 이번 달 수입 없음
  ///
  /// In ko, this message translates to:
  /// **'이번 달 수입 내역이 없습니다'**
  String get childcare_no_income_this_month;

  /// 이번 달 지출 없음
  ///
  /// In ko, this message translates to:
  /// **'이번 달 지출 내역이 없습니다'**
  String get childcare_no_expense_this_month;

  /// 거래유형 용돈
  ///
  /// In ko, this message translates to:
  /// **'용돈'**
  String get childcare_type_allowance;

  /// 거래유형 보상
  ///
  /// In ko, this message translates to:
  /// **'보상'**
  String get childcare_type_reward;

  /// 거래유형 보너스
  ///
  /// In ko, this message translates to:
  /// **'보너스'**
  String get childcare_type_bonus;

  /// 거래유형 이자
  ///
  /// In ko, this message translates to:
  /// **'이자'**
  String get childcare_type_interest;

  /// 거래유형 적금 출금
  ///
  /// In ko, this message translates to:
  /// **'적금 출금'**
  String get childcare_type_savings_withdraw;

  /// 거래유형 벌점
  ///
  /// In ko, this message translates to:
  /// **'벌점'**
  String get childcare_type_penalty;

  /// 거래유형 상점
  ///
  /// In ko, this message translates to:
  /// **'상점'**
  String get childcare_type_purchase;

  /// 거래유형 현금화
  ///
  /// In ko, this message translates to:
  /// **'현금화'**
  String get childcare_type_cashout;

  /// 거래유형 적금
  ///
  /// In ko, this message translates to:
  /// **'적금'**
  String get childcare_type_savings_deposit;

  /// 기타
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get common_etc;

  /// 자녀 프로필 등록 제목
  ///
  /// In ko, this message translates to:
  /// **'자녀 프로필 등록'**
  String get childcare_profile_add;

  /// 자녀 이름 입력칸
  ///
  /// In ko, this message translates to:
  /// **'자녀 이름'**
  String get childcare_child_name;

  /// 자녀 이름 예시
  ///
  /// In ko, this message translates to:
  /// **'예: 김민준'**
  String get childcare_child_name_hint;

  /// 자녀 이름 검증
  ///
  /// In ko, this message translates to:
  /// **'자녀 이름을 입력해주세요'**
  String get childcare_child_name_required;

  /// 생년월일 입력칸
  ///
  /// In ko, this message translates to:
  /// **'생년월일'**
  String get childcare_birthdate;

  /// 생년월일 검증
  ///
  /// In ko, this message translates to:
  /// **'생년월일을 선택해주세요'**
  String get childcare_birthdate_required;

  /// 프로필 등록 완료
  ///
  /// In ko, this message translates to:
  /// **'자녀 프로필을 등록했습니다'**
  String get childcare_profile_added;

  /// 프로필 등록 실패
  ///
  /// In ko, this message translates to:
  /// **'등록하지 못했습니다. 다시 시도해주세요'**
  String get childcare_profile_add_failed;

  /// 연월일 표시
  ///
  /// In ko, this message translates to:
  /// **'{year}년 {month}월 {day}일'**
  String childcare_date_full(String year, String month, String day);

  /// N년
  ///
  /// In ko, this message translates to:
  /// **'{year}년'**
  String childcare_year_unit(String year);

  /// 계정 연동 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'{name} 계정 연동'**
  String childcare_link_title(String name);

  /// 연동됨 상태
  ///
  /// In ko, this message translates to:
  /// **'앱 계정 연동됨'**
  String get childcare_link_linked;

  /// 미연동 상태
  ///
  /// In ko, this message translates to:
  /// **'앱 계정 미연동'**
  String get childcare_link_unlinked;

  /// 연동된 계정 ID
  ///
  /// In ko, this message translates to:
  /// **'연동된 계정 ID: {id}...'**
  String childcare_link_account_id(String id);

  /// 연동 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'계정 연동 안내'**
  String get childcare_link_guide;

  /// 연동 안내 1
  ///
  /// In ko, this message translates to:
  /// **'자녀가 앱에 직접 가입해야 연동이 가능합니다.'**
  String get childcare_link_guide1;

  /// 연동 안내 2
  ///
  /// In ko, this message translates to:
  /// **'연동 후 자녀가 직접 포인트 현황을 확인할 수 있습니다.'**
  String get childcare_link_guide2;

  /// 연동 안내 3
  ///
  /// In ko, this message translates to:
  /// **'자녀 계정으로 적금 입금이 가능해집니다.'**
  String get childcare_link_guide3;

  /// 연동 버튼
  ///
  /// In ko, this message translates to:
  /// **'앱 계정 연동하기'**
  String get childcare_link_button;

  /// 연동 정보 제목
  ///
  /// In ko, this message translates to:
  /// **'연동 정보'**
  String get childcare_link_info;

  /// 연동 정보 1
  ///
  /// In ko, this message translates to:
  /// **'자녀가 앱으로 직접 포인트를 확인할 수 있습니다.'**
  String get childcare_link_info1;

  /// 연동 정보 2
  ///
  /// In ko, this message translates to:
  /// **'자녀 계정으로 적금 입금이 가능합니다.'**
  String get childcare_link_info2;

  /// 연동 완료
  ///
  /// In ko, this message translates to:
  /// **'앱 계정을 연동했습니다'**
  String get childcare_link_done;

  /// 연동 실패
  ///
  /// In ko, this message translates to:
  /// **'연동하지 못했습니다. 자녀가 앱에 가입되어 있는지 확인해주세요'**
  String get childcare_link_failed;

  /// 보너스 지급 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'보너스 지급'**
  String get childcare_bonus_give;

  /// 자녀 등록 버튼 툴팁
  ///
  /// In ko, this message translates to:
  /// **'자녀 등록'**
  String get childcare_child_register;

  /// 용돈 플랜 설정 버튼
  ///
  /// In ko, this message translates to:
  /// **'용돈 플랜 설정'**
  String get childcare_allowance_setup_button;

  /// 앱 계정 연동 버튼
  ///
  /// In ko, this message translates to:
  /// **'앱 계정 연동'**
  String get childcare_link_account;

  /// 보너스 지급 설명
  ///
  /// In ko, this message translates to:
  /// **'아이에게 보너스 포인트를 지급합니다.\n규칙이나 상점 외에 특별히 칭찬하고 싶을 때 사용하세요.'**
  String get childcare_bonus_desc;

  /// 지급 포인트 입력칸
  ///
  /// In ko, this message translates to:
  /// **'지급 포인트'**
  String get childcare_bonus_points;

  /// 지급 포인트 검증
  ///
  /// In ko, this message translates to:
  /// **'지급 포인트를 입력해주세요'**
  String get childcare_bonus_points_required;

  /// 지급 포인트 양수 검증
  ///
  /// In ko, this message translates to:
  /// **'1 이상의 포인트를 입력해주세요'**
  String get childcare_bonus_points_positive;

  /// 지급 이유 입력칸
  ///
  /// In ko, this message translates to:
  /// **'지급 이유'**
  String get childcare_bonus_reason;

  /// 지급 이유 예시
  ///
  /// In ko, this message translates to:
  /// **'예: 방 청소를 스스로 해서'**
  String get childcare_bonus_reason_hint;

  /// 지급 이유 검증
  ///
  /// In ko, this message translates to:
  /// **'지급 이유를 입력해주세요'**
  String get childcare_bonus_reason_required;

  /// 보너스 지급 완료
  ///
  /// In ko, this message translates to:
  /// **'보너스를 지급했습니다'**
  String get childcare_bonus_given;

  /// 비활성화 메뉴
  ///
  /// In ko, this message translates to:
  /// **'비활성화'**
  String get common_deactivate;

  /// 활성화 메뉴
  ///
  /// In ko, this message translates to:
  /// **'활성화'**
  String get common_activate;

  /// 포인트 환산 근사값
  ///
  /// In ko, this message translates to:
  /// **'≈ {amount}원'**
  String childcare_approx_money(String amount);

  /// 월 포인트 단위
  ///
  /// In ko, this message translates to:
  /// **'P/월'**
  String get childcare_points_per_month;

  /// 용돈 플랜 요약
  ///
  /// In ko, this message translates to:
  /// **'매월 {day}일 · 1P={amount}원'**
  String childcare_plan_summary(String day, String amount);

  /// 반복 일정 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'반복 일정 안내'**
  String get task_recurring_guide;

  /// 반복 일정 안내 본문
  ///
  /// In ko, this message translates to:
  /// **'반복 일정은 아래 기준으로 자동 생성됩니다.'**
  String get task_recurring_guide_body;

  /// 매일/매주 라벨
  ///
  /// In ko, this message translates to:
  /// **'매일 / 매주'**
  String get task_recurring_daily_weekly;

  /// 월 단위 제목
  ///
  /// In ko, this message translates to:
  /// **'월 단위'**
  String get task_recurring_monthly_unit;

  /// 연 단위 제목
  ///
  /// In ko, this message translates to:
  /// **'연 단위'**
  String get task_recurring_yearly_unit;

  /// 매월 라벨
  ///
  /// In ko, this message translates to:
  /// **'매월 (1개월마다)'**
  String get task_recurring_every_month;

  /// 격월 라벨
  ///
  /// In ko, this message translates to:
  /// **'격월 (2개월마다)'**
  String get task_recurring_every_2months;

  /// 3개월 라벨
  ///
  /// In ko, this message translates to:
  /// **'3개월마다'**
  String get task_recurring_every_3months;

  /// 매년 라벨
  ///
  /// In ko, this message translates to:
  /// **'매년 (1년마다)'**
  String get task_recurring_every_year;

  /// 2년 라벨
  ///
  /// In ko, this message translates to:
  /// **'2년마다'**
  String get task_recurring_every_2years;

  /// N개월치 사전 생성
  ///
  /// In ko, this message translates to:
  /// **'{months}개월치'**
  String task_recurring_ahead_months(String months);

  /// 3개월치 사전 생성
  ///
  /// In ko, this message translates to:
  /// **'3개월치 사전 생성'**
  String get task_recurring_ahead_3months;

  /// 음력 칩
  ///
  /// In ko, this message translates to:
  /// **'음력'**
  String get task_lunar;

  /// 윤달 접두
  ///
  /// In ko, this message translates to:
  /// **'윤'**
  String get task_lunar_leap_prefix;

  /// 음력 날짜 표시
  ///
  /// In ko, this message translates to:
  /// **'음력 {prefix}{month}월 {day}일'**
  String task_lunar_date(String prefix, String month, String day);

  /// 음력 날짜 선택 제목
  ///
  /// In ko, this message translates to:
  /// **'음력 날짜 선택'**
  String get task_lunar_pick;

  /// 월 라벨
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get task_month;

  /// 일 라벨
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get task_day;

  /// N월
  ///
  /// In ko, this message translates to:
  /// **'{month}월'**
  String task_month_value(String month);

  /// N일
  ///
  /// In ko, this message translates to:
  /// **'{day}일'**
  String task_day_value(String day);

  /// 윤달 스위치
  ///
  /// In ko, this message translates to:
  /// **'윤달'**
  String get task_leap_month;

  /// 윤달 설명
  ///
  /// In ko, this message translates to:
  /// **'윤달이 없는 해에는 해당 달의 같은 날로 처리됩니다'**
  String get task_leap_month_desc;

  /// 건너뜀 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'건너뜀 설정'**
  String get task_skip_settings;

  /// 주말 건너뛰기
  ///
  /// In ko, this message translates to:
  /// **'주말'**
  String get task_skip_weekend;

  /// 공휴일 건너뛰기
  ///
  /// In ko, this message translates to:
  /// **'공휴일'**
  String get task_skip_holiday;

  /// 건너뛸 때 라벨
  ///
  /// In ko, this message translates to:
  /// **'건너뛸 때'**
  String get task_skip_when;

  /// 건너뜀 선택지
  ///
  /// In ko, this message translates to:
  /// **'건너뜀'**
  String get task_skip_do;

  /// 다음 평일 선택지
  ///
  /// In ko, this message translates to:
  /// **'다음 평일로'**
  String get task_skip_next_weekday;

  /// 기념일 상세 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'기념일 상세'**
  String get anniversary_detail;

  /// 기념일 날짜 라벨
  ///
  /// In ko, this message translates to:
  /// **'기념일 날짜'**
  String get anniversary_date;

  /// 등록일 라벨
  ///
  /// In ko, this message translates to:
  /// **'등록일'**
  String get anniversary_created_at;

  /// 기념일 삭제 제목
  ///
  /// In ko, this message translates to:
  /// **'기념일 삭제'**
  String get anniversary_delete;

  /// 기념일 삭제 확인
  ///
  /// In ko, this message translates to:
  /// **'\"{title}\"을(를) 삭제하시겠습니까?'**
  String anniversary_delete_message(String title);

  /// 연동 일정 함께 삭제 옵션
  ///
  /// In ko, this message translates to:
  /// **'연동된 기념일 일정도 함께 삭제'**
  String get anniversary_delete_linked;

  /// 연동 삭제 설명
  ///
  /// In ko, this message translates to:
  /// **'체크 해제 시 일정은 유지됩니다'**
  String get anniversary_delete_linked_desc;

  /// 기념일 삭제 실패
  ///
  /// In ko, this message translates to:
  /// **'삭제하지 못했습니다'**
  String get anniversary_delete_failed;

  /// 경과일 라벨
  ///
  /// In ko, this message translates to:
  /// **'경과일'**
  String get anniversary_days_elapsed;

  /// 다음 기념일 라벨
  ///
  /// In ko, this message translates to:
  /// **'다음 기념일'**
  String get anniversary_next;

  /// 예정된 기념일 제목
  ///
  /// In ko, this message translates to:
  /// **'예정된 기념일'**
  String get anniversary_upcoming;

  /// 접기 버튼
  ///
  /// In ko, this message translates to:
  /// **'접기'**
  String get anniversary_collapse;

  /// 더 보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'+ {count}개 더 보기'**
  String anniversary_show_more(int count);

  /// 100일 단위 옵션
  ///
  /// In ko, this message translates to:
  /// **'100일 단위 (D+100, D+200…)'**
  String get anniversary_every100;

  /// 매년 주년 옵션
  ///
  /// In ko, this message translates to:
  /// **'매년 주년 (1주년, 2주년…)'**
  String get anniversary_everyYear;

  /// 자동 생성 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'기념일 알림 일정 자동 생성'**
  String get anniversary_auto_create;

  /// 기념일 관리 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'기념일 관리'**
  String get anniversary_manage;

  /// 기념일 추가
  ///
  /// In ko, this message translates to:
  /// **'기념일 추가'**
  String get anniversary_add;

  /// 기념일 수정
  ///
  /// In ko, this message translates to:
  /// **'기념일 수정'**
  String get anniversary_edit;

  /// 기념일 로드 실패
  ///
  /// In ko, this message translates to:
  /// **'기념일을 불러오지 못했습니다'**
  String get anniversary_load_failed;

  /// 기념일 없음
  ///
  /// In ko, this message translates to:
  /// **'등록된 기념일이 없습니다'**
  String get anniversary_empty;

  /// 기념일 이름 입력칸
  ///
  /// In ko, this message translates to:
  /// **'기념일 이름'**
  String get anniversary_name;

  /// 기념일 이름 예시
  ///
  /// In ko, this message translates to:
  /// **'예: 결혼기념일'**
  String get anniversary_name_hint;

  /// 기념일 이름 검증
  ///
  /// In ko, this message translates to:
  /// **'기념일 이름을 입력해 주세요'**
  String get anniversary_name_required;

  /// 기념일 생성 실패
  ///
  /// In ko, this message translates to:
  /// **'만들지 못했습니다'**
  String get anniversary_create_failed;

  /// 기념일 수정 실패
  ///
  /// In ko, this message translates to:
  /// **'수정하지 못했습니다'**
  String get anniversary_update_failed;

  /// 날짜 라벨
  ///
  /// In ko, this message translates to:
  /// **'날짜'**
  String get common_date;

  /// 반복 일정 수정 확인 제목
  ///
  /// In ko, this message translates to:
  /// **'반복 일정을 수정하시겠습니까?'**
  String get task_recurring_edit_title;

  /// 이 일정만 수정
  ///
  /// In ko, this message translates to:
  /// **'이 일정만 수정'**
  String get task_recurring_edit_this;

  /// 이후 일정 모두 수정
  ///
  /// In ko, this message translates to:
  /// **'이 일정 및 이후 일정 모두 수정'**
  String get task_recurring_edit_following;

  /// 반복 일정 삭제 확인 제목
  ///
  /// In ko, this message translates to:
  /// **'이 반복 일정을 삭제하시겠습니까?'**
  String get task_recurring_delete_title;

  /// 이 일정만 삭제
  ///
  /// In ko, this message translates to:
  /// **'이 일정만 삭제'**
  String get task_recurring_delete_this;

  /// 이후 일정 모두 삭제
  ///
  /// In ko, this message translates to:
  /// **'이 일정 및 이후 일정 모두 삭제'**
  String get task_recurring_delete_following;

  /// 모든 반복 일정 삭제
  ///
  /// In ko, this message translates to:
  /// **'모든 반복 일정 삭제'**
  String get task_recurring_delete_all;

  /// 유형 라벨
  ///
  /// In ko, this message translates to:
  /// **'유형'**
  String get task_label_type;

  /// 카테고리 라벨
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get task_label_category;

  /// 등록일 라벨
  ///
  /// In ko, this message translates to:
  /// **'등록일'**
  String get task_label_createdAt;

  /// 완료됨 배지
  ///
  /// In ko, this message translates to:
  /// **'완료됨'**
  String get task_completed;

  /// 비활성 표시
  ///
  /// In ko, this message translates to:
  /// **'(비활성)'**
  String get task_inactive;

  /// 시작 시각 표시
  ///
  /// In ko, this message translates to:
  /// **'시작: {date} {time}'**
  String task_start_at(String date, String time);

  /// 종료 시각 표시
  ///
  /// In ko, this message translates to:
  /// **'종료: {date} {time}'**
  String task_end_at(String date, String time);

  /// 종료 시각(시간만)
  ///
  /// In ko, this message translates to:
  /// **'종료: {time}'**
  String task_end_time_only(String time);

  /// 캘린더 전용
  ///
  /// In ko, this message translates to:
  /// **'캘린더 전용'**
  String get task_type_calendarOnly;

  /// 할일 연동
  ///
  /// In ko, this message translates to:
  /// **'할일 연동'**
  String get task_type_todoLinked;

  /// 할일 전용
  ///
  /// In ko, this message translates to:
  /// **'할일 전용'**
  String get task_type_todoOnly;

  /// 일반 일정
  ///
  /// In ko, this message translates to:
  /// **'일반 일정'**
  String get task_type_default;

  /// 코치마크 - 일정 제목
  ///
  /// In ko, this message translates to:
  /// **'일정 제목'**
  String get task_coach_title_title;

  /// 코치마크 - 일정 제목 설명
  ///
  /// In ko, this message translates to:
  /// **'일정의 이름을 입력하세요.\n짧고 명확하게 적을수록 좋아요.'**
  String get task_coach_title_desc;

  /// 코치마크 - 날짜 시간
  ///
  /// In ko, this message translates to:
  /// **'날짜 & 시간'**
  String get task_coach_date_title;

  /// 코치마크 - 날짜 시간 설명
  ///
  /// In ko, this message translates to:
  /// **'일정 시작일과 종료일,\n시간을 지정할 수 있어요.'**
  String get task_coach_date_desc;

  /// 코치마크 - 일정 유형
  ///
  /// In ko, this message translates to:
  /// **'일정 유형'**
  String get task_coach_type_title;

  /// 코치마크 - 일정 유형 설명
  ///
  /// In ko, this message translates to:
  /// **'일반 일정, 할 일, 또는 둘 다로\n유형을 선택할 수 있어요.'**
  String get task_coach_type_desc;

  /// 코치마크 - 참가자
  ///
  /// In ko, this message translates to:
  /// **'참가자'**
  String get task_coach_participants_title;

  /// 코치마크 - 참가자 설명
  ///
  /// In ko, this message translates to:
  /// **'그룹원을 이 일정에 초대할 수 있어요.\n참가자에게 알림이 전송돼요.'**
  String get task_coach_participants_desc;

  /// 건너뛰기 버튼
  ///
  /// In ko, this message translates to:
  /// **'건너뛰기'**
  String get common_skip;

  /// 장소 검색 힌트
  ///
  /// In ko, this message translates to:
  /// **'장소명 또는 주소 검색'**
  String get task_place_search_hint;

  /// 장소 검색 안내
  ///
  /// In ko, this message translates to:
  /// **'장소를 검색해보세요'**
  String get task_place_search_prompt;

  /// 알림 설정 제목
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get notif_settings;

  /// 오전 N시
  ///
  /// In ko, this message translates to:
  /// **'오전 {hour}시'**
  String notif_hour_am(String hour);

  /// 낮 12시
  ///
  /// In ko, this message translates to:
  /// **'낮 12시'**
  String get notif_hour_noon;

  /// 오후 N시
  ///
  /// In ko, this message translates to:
  /// **'오후 {hour}시'**
  String notif_hour_pm(String hour);

  /// 일정 알림
  ///
  /// In ko, this message translates to:
  /// **'일정 알림'**
  String get notif_task;

  /// 일정 알림 설명
  ///
  /// In ko, this message translates to:
  /// **'일정 시작 전 알림을 받습니다'**
  String get notif_task_desc;

  /// 할 일 알림
  ///
  /// In ko, this message translates to:
  /// **'할 일 알림'**
  String get notif_todo;

  /// 할 일 알림 설명
  ///
  /// In ko, this message translates to:
  /// **'할 일 마감 기한 알림을 받습니다'**
  String get notif_todo_desc;

  /// 가계부 알림
  ///
  /// In ko, this message translates to:
  /// **'가계부 알림'**
  String get notif_household;

  /// 가계부 알림 설명
  ///
  /// In ko, this message translates to:
  /// **'가계부 관련 알림을 받습니다'**
  String get notif_household_desc;

  /// 자산 알림
  ///
  /// In ko, this message translates to:
  /// **'자산 알림'**
  String get notif_assets;

  /// 자산 알림 설명
  ///
  /// In ko, this message translates to:
  /// **'자산 변동 관련 알림을 받습니다'**
  String get notif_assets_desc;

  /// 육아 알림
  ///
  /// In ko, this message translates to:
  /// **'육아 알림'**
  String get notif_childcare;

  /// 육아 알림 설명
  ///
  /// In ko, this message translates to:
  /// **'육아 포인트 관련 알림을 받습니다'**
  String get notif_childcare_desc;

  /// 그룹 알림
  ///
  /// In ko, this message translates to:
  /// **'그룹 알림'**
  String get notif_group;

  /// 그룹 알림 설명
  ///
  /// In ko, this message translates to:
  /// **'그룹 관련 알림을 받습니다'**
  String get notif_group_desc;

  /// 적금 알림
  ///
  /// In ko, this message translates to:
  /// **'적금 알림'**
  String get notif_savings;

  /// 적금 알림 설명
  ///
  /// In ko, this message translates to:
  /// **'적금 목표 및 납입 관련 알림을 받습니다'**
  String get notif_savings_desc;

  /// 시스템 알림
  ///
  /// In ko, this message translates to:
  /// **'시스템 알림'**
  String get notif_system;

  /// 시스템 알림 설명
  ///
  /// In ko, this message translates to:
  /// **'중요한 시스템 알림을 받습니다'**
  String get notif_system_desc;

  /// 날씨 알림
  ///
  /// In ko, this message translates to:
  /// **'날씨 알림'**
  String get notif_weather;

  /// 날씨 알림 설명
  ///
  /// In ko, this message translates to:
  /// **'비·눈 예보 또는 큰 기온 변화 시 알립니다'**
  String get notif_weather_desc;

  /// 날씨 알림 시간
  ///
  /// In ko, this message translates to:
  /// **'날씨 알림 시간'**
  String get notif_weather_time;

  /// 날씨 알림 시간 설명
  ///
  /// In ko, this message translates to:
  /// **'앱 실행 시 설정 시간이 되면 알림을 보냅니다'**
  String get notif_weather_time_desc;

  /// 루틴 알림
  ///
  /// In ko, this message translates to:
  /// **'루틴 알림'**
  String get notif_routine;

  /// 루틴 알림 설명
  ///
  /// In ko, this message translates to:
  /// **'미체크 루틴 리마인드, 배지 획득, 주간 요약을 받습니다'**
  String get notif_routine_desc;

  /// 루틴 리마인드 시간
  ///
  /// In ko, this message translates to:
  /// **'루틴 리마인드 시간'**
  String get notif_routine_time;

  /// 루틴 리마인드 설명
  ///
  /// In ko, this message translates to:
  /// **'설정 시간까지 오늘 미체크 루틴이 있으면 알림을 보냅니다'**
  String get notif_routine_time_desc;

  /// 읽지 않은 알림 제목
  ///
  /// In ko, this message translates to:
  /// **'읽지 않은 알림'**
  String get notif_unread;

  /// 전체 읽음 버튼
  ///
  /// In ko, this message translates to:
  /// **'전체 읽음'**
  String get notif_mark_all_read;

  /// 전체보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'전체보기'**
  String get notif_view_all;

  /// 읽음 처리 툴팁
  ///
  /// In ko, this message translates to:
  /// **'읽음 처리'**
  String get notif_mark_read;

  /// 알림 처리 실패
  ///
  /// In ko, this message translates to:
  /// **'알림을 처리하지 못했습니다'**
  String get notif_action_failed;

  /// N개 읽음 처리 완료
  ///
  /// In ko, this message translates to:
  /// **'알림 {count}개를 읽음 처리했습니다'**
  String notif_marked_read_count(int count);

  /// 전체 읽음 실패
  ///
  /// In ko, this message translates to:
  /// **'전체 읽음 처리에 실패했습니다'**
  String get notif_mark_all_failed;

  /// 새 알림 없음
  ///
  /// In ko, this message translates to:
  /// **'새로운 알림이 없습니다'**
  String get notif_none_new;

  /// 알림 로드 실패
  ///
  /// In ko, this message translates to:
  /// **'알림을 불러오지 못했습니다'**
  String get notif_load_failed;

  /// 알림 권한 제목
  ///
  /// In ko, this message translates to:
  /// **'알림 권한'**
  String get notif_permission;

  /// 권한 허용됨 안내
  ///
  /// In ko, this message translates to:
  /// **'알림 권한이 허용되었습니다'**
  String get notif_permission_granted;

  /// 권한 거부됨 안내
  ///
  /// In ko, this message translates to:
  /// **'알림 권한이 거부되었습니다'**
  String get notif_permission_denied;

  /// 권한 활성화 상태
  ///
  /// In ko, this message translates to:
  /// **'활성화됨'**
  String get notif_permission_on;

  /// 권한 비활성화 상태
  ///
  /// In ko, this message translates to:
  /// **'비활성화됨'**
  String get notif_permission_off;

  /// 권한 있음 설명
  ///
  /// In ko, this message translates to:
  /// **'푸시 알림을 받을 수 있습니다.'**
  String get notif_permission_on_desc;

  /// 권한 없음 설명
  ///
  /// In ko, this message translates to:
  /// **'알림을 받으려면 권한을 허용해주세요.'**
  String get notif_permission_off_desc;

  /// 권한 요청 버튼
  ///
  /// In ko, this message translates to:
  /// **'권한 요청'**
  String get notif_permission_request;

  /// 설정에서 허용 버튼
  ///
  /// In ko, this message translates to:
  /// **'설정에서 권한 허용'**
  String get notif_permission_settings;

  /// 위치 권한 제목
  ///
  /// In ko, this message translates to:
  /// **'위치 권한'**
  String get location_permission;

  /// 위치 권한 허용됨
  ///
  /// In ko, this message translates to:
  /// **'위치 권한이 허용되었습니다'**
  String get location_permission_granted;

  /// 위치 권한 거부됨
  ///
  /// In ko, this message translates to:
  /// **'위치 권한이 거부되었습니다'**
  String get location_permission_denied;

  /// 위치 권한 있음 설명
  ///
  /// In ko, this message translates to:
  /// **'날씨 알림 발송에 현재 위치가 사용됩니다.'**
  String get location_permission_on_desc;

  /// 위치 권한 없음 설명
  ///
  /// In ko, this message translates to:
  /// **'날씨 알림을 받으려면 위치 권한을 허용해주세요.\n위치 정보는 날씨 알림 발송 목적으로만 사용되며 서버에 저장됩니다.'**
  String get location_permission_off_desc;

  /// 알림 삭제 제목
  ///
  /// In ko, this message translates to:
  /// **'알림 삭제'**
  String get notif_delete;

  /// 알림 삭제 확인
  ///
  /// In ko, this message translates to:
  /// **'이 알림을 삭제하시겠습니까?'**
  String get notif_delete_message;

  /// 알림 삭제 완료
  ///
  /// In ko, this message translates to:
  /// **'알림을 삭제했습니다'**
  String get notif_deleted;

  /// 알림 삭제 실패
  ///
  /// In ko, this message translates to:
  /// **'알림을 삭제하지 못했습니다'**
  String get notif_delete_failed;

  /// 알림 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get notif_title;

  /// 알림 없음
  ///
  /// In ko, this message translates to:
  /// **'알림이 없습니다'**
  String get notif_empty;

  /// 알림 히스토리 메뉴
  ///
  /// In ko, this message translates to:
  /// **'알림 히스토리'**
  String get notif_history;

  /// 알림 히스토리 설명
  ///
  /// In ko, this message translates to:
  /// **'받은 알림 목록을 확인합니다'**
  String get notif_history_desc;

  /// 설정 로드 실패
  ///
  /// In ko, this message translates to:
  /// **'알림 설정을 불러오지 못했습니다'**
  String get notif_settings_load_failed;

  /// 테스트 알림 메뉴
  ///
  /// In ko, this message translates to:
  /// **'테스트 알림 전송'**
  String get notif_test_send;

  /// 테스트 알림 설명
  ///
  /// In ko, this message translates to:
  /// **'테스트 알림을 자신에게 전송합니다 (운영자 전용)'**
  String get notif_test_send_desc;

  /// 테스트 알림 전송 완료
  ///
  /// In ko, this message translates to:
  /// **'테스트 알림을 보냈습니다'**
  String get notif_test_sent;

  /// 테스트 알림 실패
  ///
  /// In ko, this message translates to:
  /// **'테스트 알림을 보내지 못했습니다'**
  String get notif_test_failed;

  /// 익명 표기
  ///
  /// In ko, this message translates to:
  /// **'익명'**
  String get common_anonymous;

  /// 관리자 표기
  ///
  /// In ko, this message translates to:
  /// **'관리자'**
  String get common_admin;

  /// 수정 완료 버튼
  ///
  /// In ko, this message translates to:
  /// **'수정 완료'**
  String get common_updateDone;

  /// 내 질문만 필터
  ///
  /// In ko, this message translates to:
  /// **'내 질문만'**
  String get qna_myQuestionsOnly;

  /// 전체 카테고리 항목
  ///
  /// In ko, this message translates to:
  /// **'전체 카테고리'**
  String get qna_allCategories;

  /// 대기중 탭
  ///
  /// In ko, this message translates to:
  /// **'대기중'**
  String get qna_tab_pending;

  /// 답변완료 탭
  ///
  /// In ko, this message translates to:
  /// **'답변완료'**
  String get qna_tab_answered;

  /// 해결완료 탭
  ///
  /// In ko, this message translates to:
  /// **'해결완료'**
  String get qna_tab_resolved;

  /// 검색어 표시
  ///
  /// In ko, this message translates to:
  /// **'검색: {query}'**
  String qna_searchLabel(String query);

  /// 질문 작성 버튼
  ///
  /// In ko, this message translates to:
  /// **'질문 작성'**
  String get qna_writeQuestion;

  /// 질문 수정 제목
  ///
  /// In ko, this message translates to:
  /// **'질문 수정'**
  String get qna_editQuestion;

  /// 검색 힌트
  ///
  /// In ko, this message translates to:
  /// **'제목 또는 내용으로 검색'**
  String get qna_searchByTitleOrContent;

  /// 상태별 질문 없음
  ///
  /// In ko, this message translates to:
  /// **'{status} 상태의 질문이 없습니다'**
  String qna_emptyByStatus(String status);

  /// 카테고리별 질문 없음
  ///
  /// In ko, this message translates to:
  /// **'{category} 카테고리의 질문이 없습니다'**
  String qna_emptyByCategory(String category);

  /// 내 질문 없음
  ///
  /// In ko, this message translates to:
  /// **'아직 작성한 질문이 없습니다\n궁금한 점을 질문해보세요!'**
  String get qna_emptyMine;

  /// 질문 목록 로드 실패
  ///
  /// In ko, this message translates to:
  /// **'질문 목록을 불러오지 못했습니다'**
  String get qna_listLoadError;

  /// 내용 라벨
  ///
  /// In ko, this message translates to:
  /// **'내용'**
  String get qna_contentLabel;

  /// 제목 라벨
  ///
  /// In ko, this message translates to:
  /// **'제목'**
  String get qna_titleLabel;

  /// 내용 상세 힌트
  ///
  /// In ko, this message translates to:
  /// **'질문 내용을 자세히 작성해주세요. 스크린샷이 있으면 더 빠른 답변이 가능합니다.'**
  String get qna_contentHintDetailed;

  /// 내용 최대 길이
  ///
  /// In ko, this message translates to:
  /// **'내용은 5000자를 초과할 수 없습니다'**
  String get qna_contentMaxLength;

  /// 제목 최소 5자
  ///
  /// In ko, this message translates to:
  /// **'제목은 5자 이상 입력해주세요'**
  String get qna_titleMin5;

  /// 내용 최소 10자
  ///
  /// In ko, this message translates to:
  /// **'내용은 10자 이상 입력해주세요'**
  String get qna_contentMin10;

  /// 질문 등록 버튼
  ///
  /// In ko, this message translates to:
  /// **'질문 등록'**
  String get qna_submitQuestion;

  /// 질문 작성 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'질문 작성 안내'**
  String get qna_writeGuide;

  /// 질문 작성 안내 본문
  ///
  /// In ko, this message translates to:
  /// **'• 질문은 관리자가 확인 후 답변드립니다.\n• 답변은 알림으로 안내됩니다.\n• 대기 중 상태에서만 수정/삭제 가능합니다.'**
  String get qna_writeGuideBody;

  /// 공개 설정 라벨
  ///
  /// In ko, this message translates to:
  /// **'공개 설정'**
  String get qna_visibility;

  /// 질문 등록 완료 안내
  ///
  /// In ko, this message translates to:
  /// **'질문이 등록되었습니다.\n답변은 알림으로 안내드립니다.'**
  String get qna_createSuccessDetail;

  /// 질문 상세 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'질문 상세'**
  String get qna_questionDetail;

  /// 해결완료 수정 불가
  ///
  /// In ko, this message translates to:
  /// **'해결 완료된 질문은 수정할 수 없습니다'**
  String get qna_cannotEditResolved;

  /// 해결완료 버튼
  ///
  /// In ko, this message translates to:
  /// **'해결완료'**
  String get qna_resolve;

  /// 첨부파일 라벨
  ///
  /// In ko, this message translates to:
  /// **'첨부파일'**
  String get qna_attachments;

  /// 다운로드 미구현 안내
  ///
  /// In ko, this message translates to:
  /// **'파일 다운로드는 아직 준비 중입니다'**
  String get qna_downloadNotReady;

  /// 답변 개수 제목
  ///
  /// In ko, this message translates to:
  /// **'답변 ({count})'**
  String qna_answersCount(int count);

  /// 해결완료 처리 제목
  ///
  /// In ko, this message translates to:
  /// **'해결완료 처리'**
  String get qna_resolveTitle;

  /// 해결완료 확인
  ///
  /// In ko, this message translates to:
  /// **'이 질문을 해결완료로 처리하시겠습니까?\n해결완료 후에는 질문을 수정할 수 없습니다.'**
  String get qna_resolveMessage;

  /// 답변 수정 제목
  ///
  /// In ko, this message translates to:
  /// **'답변 수정'**
  String get qna_editAnswer;

  /// 답변 삭제 제목
  ///
  /// In ko, this message translates to:
  /// **'답변 삭제'**
  String get qna_deleteAnswer;

  /// 답변 삭제 확인
  ///
  /// In ko, this message translates to:
  /// **'이 답변을 삭제하시겠습니까?\n삭제된 답변은 복구할 수 없습니다.'**
  String get qna_deleteAnswerMessage;

  /// 답변 작성 제목
  ///
  /// In ko, this message translates to:
  /// **'답변 작성'**
  String get qna_writeAnswer;

  /// 답변 등록 버튼
  ///
  /// In ko, this message translates to:
  /// **'답변 등록'**
  String get qna_submitAnswer;

  /// 답변 등록 중
  ///
  /// In ko, this message translates to:
  /// **'답변 등록 중...'**
  String get qna_submittingAnswer;

  /// 해결 확인 제목
  ///
  /// In ko, this message translates to:
  /// **'문제가 해결되셨나요?'**
  String get qna_resolvedPrompt;

  /// 해결 확인 본문
  ///
  /// In ko, this message translates to:
  /// **'답변이 도움이 되셨다면 해결 완료로 변경해주세요.\n1주일간 상태를 변경하지 않으면 자동으로 해결 완료로 변경됩니다.'**
  String get qna_resolvedPromptBody;

  /// 접기 버튼
  ///
  /// In ko, this message translates to:
  /// **'접기'**
  String get common_collapse;

  /// 필수 표시
  ///
  /// In ko, this message translates to:
  /// **'(필수)'**
  String get common_required_mark;

  /// 오류 발생 안내
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다'**
  String get common_errorOccurred;

  /// 계좌 순서 저장
  ///
  /// In ko, this message translates to:
  /// **'계좌 순서를 저장했습니다'**
  String get asset_account_order_saved;

  /// 자산 관리 제목
  ///
  /// In ko, this message translates to:
  /// **'자산 관리'**
  String get asset_management;

  /// 자산 관리 자리표시
  ///
  /// In ko, this message translates to:
  /// **'자산 관리 기능이 여기에 표시됩니다'**
  String get asset_management_placeholder;

  /// 기록 알림 제목
  ///
  /// In ko, this message translates to:
  /// **'기록 알림'**
  String get asset_record_reminder;

  /// 기록 알림 설명
  ///
  /// In ko, this message translates to:
  /// **'매월 지정한 날짜에 자산 기록 입력 알림을 보내드립니다.'**
  String get asset_record_reminder_desc;

  /// 알림 날짜 라벨
  ///
  /// In ko, this message translates to:
  /// **'알림 날짜'**
  String get asset_reminder_day;

  /// 매월 N일
  ///
  /// In ko, this message translates to:
  /// **'매월 {day}일'**
  String asset_monthly_day(String day);

  /// 말일 처리 안내
  ///
  /// In ko, this message translates to:
  /// **'29~31일은 해당 월에 없는 경우 말일에 발송됩니다.'**
  String get asset_reminder_day_note;

  /// 출금 기록 제목
  ///
  /// In ko, this message translates to:
  /// **'출금 기록'**
  String get asset_withdrawal_record;

  /// 출금 날짜 라벨
  ///
  /// In ko, this message translates to:
  /// **'출금 날짜: {date}'**
  String asset_withdrawal_date(String date);

  /// 출금 유형 라벨
  ///
  /// In ko, this message translates to:
  /// **'출금 유형'**
  String get asset_withdrawal_type;

  /// 출금 유형 설명
  ///
  /// In ko, this message translates to:
  /// **'출금한 금액이 원금에서 나간 것인지, 수익에서 나간 것인지 선택해 주세요.'**
  String get asset_withdrawal_type_desc;

  /// 출금 유형 검증
  ///
  /// In ko, this message translates to:
  /// **'출금 유형을 선택해 주세요'**
  String get asset_withdrawal_type_required;

  /// 출금 금액 라벨
  ///
  /// In ko, this message translates to:
  /// **'출금 금액'**
  String get asset_withdrawal_amount;

  /// 유효 금액 검증
  ///
  /// In ko, this message translates to:
  /// **'유효한 금액을 입력해 주세요'**
  String get asset_amount_invalid;

  /// 메모 라벨(선택)
  ///
  /// In ko, this message translates to:
  /// **'메모 (선택)'**
  String get asset_memo_optional;

  /// 메모 예시
  ///
  /// In ko, this message translates to:
  /// **'예: 생활비, 수익 실현'**
  String get asset_memo_hint;

  /// 저장 실패
  ///
  /// In ko, this message translates to:
  /// **'저장하지 못했습니다'**
  String get asset_save_failed;

  /// 원금 차감 설명
  ///
  /// In ko, this message translates to:
  /// **'원금에서 차감 (생활비, 계좌 이동 등)'**
  String get asset_withdrawal_from_principal;

  /// 종목 추가 제목
  ///
  /// In ko, this message translates to:
  /// **'종목 추가'**
  String get asset_holding_add;

  /// 종목 수정 제목
  ///
  /// In ko, this message translates to:
  /// **'종목 수정'**
  String get asset_holding_edit;

  /// 종목명 입력칸
  ///
  /// In ko, this message translates to:
  /// **'종목명'**
  String get asset_holding_name;

  /// 종목명 예시
  ///
  /// In ko, this message translates to:
  /// **'예: 나스닥 ETF, 삼성전자'**
  String get asset_holding_name_hint;

  /// 종목명 검증
  ///
  /// In ko, this message translates to:
  /// **'종목명을 입력해 주세요'**
  String get asset_holding_name_required;

  /// 티커 입력칸
  ///
  /// In ko, this message translates to:
  /// **'티커 (선택)'**
  String get asset_holding_ticker;

  /// 티커 예시
  ///
  /// In ko, this message translates to:
  /// **'예: QQQ, 005930'**
  String get asset_holding_ticker_hint;

  /// 금액 라벨
  ///
  /// In ko, this message translates to:
  /// **'금액'**
  String get asset_amount_label;

  /// 비율 자동 계산 안내
  ///
  /// In ko, this message translates to:
  /// **'비율은 잔액 기준으로 자동 계산됩니다'**
  String get asset_ratio_auto;

  /// 연월일 표시
  ///
  /// In ko, this message translates to:
  /// **'{year}년 {month}월 {day}일'**
  String asset_date_full(String year, String month, String day);

  /// 코치마크 계좌 상세
  ///
  /// In ko, this message translates to:
  /// **'계좌 상세 정보'**
  String get asset_coach_detail_title;

  /// 코치마크 계좌 상세 설명
  ///
  /// In ko, this message translates to:
  /// **'최신 잔액과 수익률을 확인하고,\n아래로 스크롤하면 자산 변화 차트와\n원금·수익금 통계를 볼 수 있어요.'**
  String get asset_coach_detail_desc;

  /// 코치마크 잔액 기록
  ///
  /// In ko, this message translates to:
  /// **'잔액 기록 추가'**
  String get asset_coach_record_title;

  /// 코치마크 잔액 기록 설명
  ///
  /// In ko, this message translates to:
  /// **'잔액을 주기적으로 기록하면\n자산 변화 추이를 차트로 확인할 수 있어요.\n출금 기록도 함께 관리할 수 있습니다.'**
  String get asset_coach_record_desc;

  /// 코치마크 포트폴리오
  ///
  /// In ko, this message translates to:
  /// **'포트폴리오'**
  String get asset_coach_portfolio_title;

  /// 코치마크 포트폴리오 설명
  ///
  /// In ko, this message translates to:
  /// **'날짜별로 보유 종목과 금액을 기록해\n자산 구성을 파이차트로 확인하세요.\n두 날짜를 비교해 변화도 볼 수 있어요.'**
  String get asset_coach_portfolio_desc;

  /// 전체 기록 보기
  ///
  /// In ko, this message translates to:
  /// **'전체 {count}건 보기'**
  String asset_view_all_records(int count);

  /// 잔액 기록 메뉴
  ///
  /// In ko, this message translates to:
  /// **'잔액 기록'**
  String get asset_balance_record;

  /// 잔액 기록 설명
  ///
  /// In ko, this message translates to:
  /// **'잔액·원금·수익을 기록합니다'**
  String get asset_balance_record_desc;

  /// 출금 메뉴
  ///
  /// In ko, this message translates to:
  /// **'출금'**
  String get asset_withdrawal;

  /// 출금 설명
  ///
  /// In ko, this message translates to:
  /// **'원금 인출 또는 수익 실현을 기록합니다'**
  String get asset_withdrawal_desc;

  /// 포트폴리오 제목
  ///
  /// In ko, this message translates to:
  /// **'포트폴리오'**
  String get asset_portfolio;

  /// 변화 라벨
  ///
  /// In ko, this message translates to:
  /// **'변화'**
  String get asset_change;

  /// 합계 라벨
  ///
  /// In ko, this message translates to:
  /// **'합계'**
  String get asset_total;

  /// 재시도 버튼
  ///
  /// In ko, this message translates to:
  /// **'재시도'**
  String get asset_retry;

  /// 자동 계산 되돌리기 툴팁
  ///
  /// In ko, this message translates to:
  /// **'자동 계산으로 되돌리기'**
  String get asset_reset_auto;

  /// 출금 기록 삭제 제목
  ///
  /// In ko, this message translates to:
  /// **'출금 기록 삭제'**
  String get asset_withdrawal_delete;

  /// 출금 삭제 확인
  ///
  /// In ko, this message translates to:
  /// **'삭제하면 출금일 이후 원금/수익이 원복됩니다. 계속하시겠어요?'**
  String get asset_withdrawal_delete_message;

  /// 종목 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'종목 추가'**
  String get asset_holding_add_button;

  /// 비교 버튼
  ///
  /// In ko, this message translates to:
  /// **'비교'**
  String get asset_compare;

  /// 잔액 기록 선행 안내
  ///
  /// In ko, this message translates to:
  /// **'잔액 기록을 먼저 추가하면 포트폴리오를 기록할 수 있습니다.'**
  String get asset_record_first;

  /// 해당 날짜 종목 없음
  ///
  /// In ko, this message translates to:
  /// **'이 날짜에 등록된 종목이 없습니다.'**
  String get asset_no_holdings;

  /// 현금 항목
  ///
  /// In ko, this message translates to:
  /// **'현금'**
  String get asset_cash;

  /// 종목 삭제 제목
  ///
  /// In ko, this message translates to:
  /// **'종목 삭제'**
  String get asset_holding_delete;

  /// 종목 삭제 확인
  ///
  /// In ko, this message translates to:
  /// **'{name} 기록을 삭제할까요?'**
  String asset_holding_delete_message(String name);

  /// 삭제 실패
  ///
  /// In ko, this message translates to:
  /// **'삭제하지 못했습니다'**
  String get asset_delete_failed;

  /// 기타 N개
  ///
  /// In ko, this message translates to:
  /// **'기타 {count}개'**
  String asset_others_count(int count);

  /// 현금으로 채우기
  ///
  /// In ko, this message translates to:
  /// **'현금으로 채우기 ({amount})'**
  String asset_fill_with_cash(String amount);

  /// 잔액 표시
  ///
  /// In ko, this message translates to:
  /// **'잔액: {amount}'**
  String asset_balance_value(String amount);

  /// 필터 최소 1개 안내
  ///
  /// In ko, this message translates to:
  /// **'적어도 하나는 선택해 주세요'**
  String get asset_filter_min_one;

  /// 출금 유형 상세 설명
  ///
  /// In ko, this message translates to:
  /// **'출금한 금액이 원금에서 나간 것인지, 수익에서 나간 것인지 선택해 주세요.\n잔액 기록 시 원금과 수익을 자동으로 재계산하는 데 사용됩니다.'**
  String get asset_withdrawal_type_desc_full;

  /// 수익 차감 설명
  ///
  /// In ko, this message translates to:
  /// **'수익에서 차감 (세금, 수익 인출 등)'**
  String get asset_withdrawal_from_profit;

  /// 계좌 최소 1개 선택
  ///
  /// In ko, this message translates to:
  /// **'적어도 한 개의 계좌를 선택해 주세요.'**
  String get asset_filter_min_one_account;

  /// 범례 더보기
  ///
  /// In ko, this message translates to:
  /// **'+{count}개 더보기'**
  String asset_legend_more(int count);

  /// 포트폴리오 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'포트폴리오'**
  String get asset_holdings_section;

  /// 기타 비율 표시
  ///
  /// In ko, this message translates to:
  /// **'기타 {count}개  {ratio}%'**
  String asset_others_ratio(int count, String ratio);

  /// 누적 수익률 라벨
  ///
  /// In ko, this message translates to:
  /// **'누적 수익률'**
  String get asset_cumulative_return;

  /// 기간 수익률 라벨
  ///
  /// In ko, this message translates to:
  /// **'기간 수익률'**
  String get asset_period_return;

  /// 잔액 툴팁 본문
  ///
  /// In ko, this message translates to:
  /// **'각 시점의 총 자산 잔액입니다.\n잔액 = 원금 + 수익금'**
  String get asset_tooltip_balance;

  /// 원금 툴팁 본문
  ///
  /// In ko, this message translates to:
  /// **'각 시점까지 실제로 입금한 누적 투자 원금입니다.\n수익·손실은 포함되지 않습니다.'**
  String get asset_tooltip_principal;

  /// 수익금 툴팁 본문
  ///
  /// In ko, this message translates to:
  /// **'각 시점의 누적 수익금입니다.\n수익금 = 잔액 − 원금'**
  String get asset_tooltip_profit;

  /// 누적 수익률 툴팁 본문
  ///
  /// In ko, this message translates to:
  /// **'각 시점의 누적 수익률입니다.\n누적 수익률 = 수익금 ÷ 원금 × 100'**
  String get asset_tooltip_cumulative;

  /// 기간 수익률 툴팁 본문
  ///
  /// In ko, this message translates to:
  /// **'직전 시점 대비 해당 기간의 수익률입니다.\n원금 입·출금의 영향을 제거하고 순수한 수익 변화만 반영합니다.\n\n기간 수익률 = (이번 수익금 − 전 수익금) ÷ 전 원금 × 100'**
  String get asset_tooltip_period;

  /// 금액 원 표기
  ///
  /// In ko, this message translates to:
  /// **'{amount}원'**
  String asset_amount_won(String amount);

  /// N월 표기
  ///
  /// In ko, this message translates to:
  /// **'{month}월'**
  String asset_month_unit(String month);

  /// 금 시세 g당 표기
  ///
  /// In ko, this message translates to:
  /// **'{amount}원/g'**
  String asset_gold_price_per_gram(String amount);

  /// USD 환산 비교 대상
  ///
  /// In ko, this message translates to:
  /// **'USD환산'**
  String get asset_compare_usd;

  /// 미니게임 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'미니게임'**
  String get minigame_title;

  /// 미니게임 코치마크 설명
  ///
  /// In ko, this message translates to:
  /// **'사다리타기와 룰렛 게임을 즐길 수 있어요.\n공정한 결정이 필요할 때 활용해보세요!'**
  String get minigame_coach_desc;

  /// 그룹 선택 코치마크
  ///
  /// In ko, this message translates to:
  /// **'그룹 선택'**
  String get minigame_coach_group;

  /// 그룹 선택 설명
  ///
  /// In ko, this message translates to:
  /// **'그룹을 선택하면 게임 결과가\n자동으로 저장돼요.\n그룹 멤버 누구나 이력을 확인할 수 있어요.'**
  String get minigame_coach_group_desc;

  /// 게임 이력 제목
  ///
  /// In ko, this message translates to:
  /// **'게임 이력'**
  String get minigame_history;

  /// 게임 이력 설명
  ///
  /// In ko, this message translates to:
  /// **'지금까지 진행한 게임 결과를\n이곳에서 확인할 수 있어요.\n누가 어떤 결과를 받았는지 투명하게 공개됩니다.'**
  String get minigame_coach_history_desc;

  /// 사다리타기
  ///
  /// In ko, this message translates to:
  /// **'사다리타기'**
  String get minigame_ladder;

  /// 룰렛
  ///
  /// In ko, this message translates to:
  /// **'룰렛'**
  String get minigame_roulette;

  /// 그룹 없음 옵션
  ///
  /// In ko, this message translates to:
  /// **'그룹 없음 (이력 저장 안 함)'**
  String get minigame_no_group;

  /// 게임 이력 없음
  ///
  /// In ko, this message translates to:
  /// **'게임 이력이 없습니다'**
  String get minigame_history_empty;

  /// 그룹 선택 안내
  ///
  /// In ko, this message translates to:
  /// **'그룹을 선택하면\n게임 이력이 자동 저장됩니다'**
  String get minigame_select_group_hint;

  /// 이력 삭제 제목
  ///
  /// In ko, this message translates to:
  /// **'이력 삭제'**
  String get minigame_history_delete;

  /// 이력 삭제 확인
  ///
  /// In ko, this message translates to:
  /// **'이 게임 이력을 삭제하시겠습니까?'**
  String get minigame_history_delete_message;

  /// 룰렛 당첨 표시
  ///
  /// In ko, this message translates to:
  /// **'당첨: {name}'**
  String minigame_winner(String name);

  /// 사다리 기본 제목
  ///
  /// In ko, this message translates to:
  /// **'사다리타기'**
  String get minigame_ladder_default_title;

  /// 룰렛 기본 제목
  ///
  /// In ko, this message translates to:
  /// **'룰렛'**
  String get minigame_roulette_default_title;

  /// 게임 제목 입력칸
  ///
  /// In ko, this message translates to:
  /// **'게임 제목'**
  String get minigame_game_title;

  /// 사다리 생성 버튼
  ///
  /// In ko, this message translates to:
  /// **'사다리 생성'**
  String get minigame_create_ladder;

  /// 사다리 안내
  ///
  /// In ko, this message translates to:
  /// **'참여자 이름을 눌러 사다리를 타세요!'**
  String get minigame_ladder_hint;

  /// 전체 스킵 버튼
  ///
  /// In ko, this message translates to:
  /// **'전체 스킵'**
  String get minigame_skip_all;

  /// 다시 설정 버튼
  ///
  /// In ko, this message translates to:
  /// **'다시 설정'**
  String get minigame_reset;

  /// 참여자 라벨
  ///
  /// In ko, this message translates to:
  /// **'참여자'**
  String get minigame_participants;

  /// 최종 결과 제목
  ///
  /// In ko, this message translates to:
  /// **'최종 결과'**
  String get minigame_final_result;

  /// 게임 저장 완료
  ///
  /// In ko, this message translates to:
  /// **'게임 결과를 저장했습니다'**
  String get minigame_saved;

  /// 게임 저장 실패
  ///
  /// In ko, this message translates to:
  /// **'저장하지 못했습니다'**
  String get minigame_save_failed;

  /// 결과 항목 제목
  ///
  /// In ko, this message translates to:
  /// **'결과 항목'**
  String get minigame_result_items;

  /// 항목 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'항목 {index}'**
  String minigame_item_hint(int index);

  /// 항목 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'항목 추가'**
  String get minigame_add_item;

  /// 수량 불일치 안내
  ///
  /// In ko, this message translates to:
  /// **'수량 합계({total})가 참여자 수({count})와 같아야 합니다'**
  String minigame_count_mismatch(String total, String count);

  /// 그룹 플레이 표시
  ///
  /// In ko, this message translates to:
  /// **'그룹으로 플레이 중'**
  String get minigame_playing_with_group;

  /// 멤버 로딩 안내
  ///
  /// In ko, this message translates to:
  /// **'그룹 멤버를 불러오는 중입니다. 잠시 후 다시 시도해주세요.'**
  String get minigame_members_loading;

  /// 직접 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'{label} 직접 추가'**
  String minigame_add_manually(String label);

  /// 멤버 선택 버튼
  ///
  /// In ko, this message translates to:
  /// **'멤버 선택'**
  String get minigame_select_members;

  /// 그룹 멤버 선택 제목
  ///
  /// In ko, this message translates to:
  /// **'그룹 멤버 선택'**
  String get minigame_select_group_members;

  /// 알 수 없는 이름
  ///
  /// In ko, this message translates to:
  /// **'알 수 없음'**
  String get minigame_unknown;

  /// 이미 추가됨 표시
  ///
  /// In ko, this message translates to:
  /// **'이미 추가됨'**
  String get minigame_already_added;

  /// 선택 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'추가 ({count})'**
  String minigame_add_count(int count);

  /// 돌리기 버튼
  ///
  /// In ko, this message translates to:
  /// **'돌리기'**
  String get minigame_spin;

  /// 항목 2개 이상 안내
  ///
  /// In ko, this message translates to:
  /// **'항목을 2개 이상 입력해주세요'**
  String get minigame_need_two_items;

  /// 결과 제목
  ///
  /// In ko, this message translates to:
  /// **'결과'**
  String get minigame_result;

  /// 항목 라벨
  ///
  /// In ko, this message translates to:
  /// **'항목'**
  String get minigame_item;

  /// 비율 라벨
  ///
  /// In ko, this message translates to:
  /// **'비율'**
  String get minigame_ratio;

  /// 필터 제목
  ///
  /// In ko, this message translates to:
  /// **'필터'**
  String get common_filter;

  /// 그룹 선택
  ///
  /// In ko, this message translates to:
  /// **'그룹 선택'**
  String get common_selectGroup;

  /// 알 수 없음
  ///
  /// In ko, this message translates to:
  /// **'알 수 없음'**
  String get common_unknown;

  /// 계정 삭제 예정 안내
  ///
  /// In ko, this message translates to:
  /// **'계정이 {date} ({days}일 후)에 삭제될 예정입니다.'**
  String home_delete_scheduled(String date, String days);

  /// 삭제 취소 버튼
  ///
  /// In ko, this message translates to:
  /// **'삭제 취소'**
  String get home_delete_cancel;

  /// 삭제 취소 완료
  ///
  /// In ko, this message translates to:
  /// **'계정 삭제 예약을 취소했습니다'**
  String get home_delete_canceled;

  /// 더보기 안내
  ///
  /// In ko, this message translates to:
  /// **'더보기 탭에서 시작하세요'**
  String get home_coach_more;

  /// 그룹 관리 코치마크
  ///
  /// In ko, this message translates to:
  /// **'그룹 관리'**
  String get home_coach_group;

  /// 그룹 관리 설명
  ///
  /// In ko, this message translates to:
  /// **'가족, 연인, 친구 등 원하는 그룹을 만들고\n초대 코드로 구성원을 초대하세요.'**
  String get home_coach_group_desc;

  /// 위젯 설정 코치마크
  ///
  /// In ko, this message translates to:
  /// **'대시보드 위젯 커스터마이징'**
  String get home_coach_widget;

  /// 위젯 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'설정 → 홈 위젯 설정에서\n원하는 위젯만 골라 대시보드를 꾸미세요.'**
  String get home_coach_widget_desc;

  /// 탭 설정 코치마크
  ///
  /// In ko, this message translates to:
  /// **'하단 탭 커스터마이징'**
  String get home_coach_tab;

  /// 탭 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'설정 → 하단 네비게이션 설정에서\n자주 쓰는 메뉴로 자유롭게 바꾸세요.'**
  String get home_coach_tab_desc;

  /// 더보기 이동 안내
  ///
  /// In ko, this message translates to:
  /// **'탭을 눌러 더보기로 이동'**
  String get home_coach_tap_more;

  /// 기간 라벨
  ///
  /// In ko, this message translates to:
  /// **'기간'**
  String get home_period;

  /// 개인 일정 필터
  ///
  /// In ko, this message translates to:
  /// **'개인 일정'**
  String get home_personal_schedule;

  /// 개인 일정 설명
  ///
  /// In ko, this message translates to:
  /// **'내 개인 일정 포함'**
  String get home_personal_schedule_desc;

  /// 보기 모드 라벨
  ///
  /// In ko, this message translates to:
  /// **'보기 모드'**
  String get home_view_mode;

  /// 고정된 메모 위젯 제목
  ///
  /// In ko, this message translates to:
  /// **'고정된 메모'**
  String get home_pinned_memos;

  /// 고정 메모 없음
  ///
  /// In ko, this message translates to:
  /// **'고정된 메모가 없습니다'**
  String get home_pinned_memos_empty;

  /// 체크리스트 진행
  ///
  /// In ko, this message translates to:
  /// **'{checked}/{total} 완료'**
  String home_checklist_progress(String checked, String total);

  /// 유통기한 없음
  ///
  /// In ko, this message translates to:
  /// **'기한 없음'**
  String get home_no_expiry;

  /// 기한 초과
  ///
  /// In ko, this message translates to:
  /// **'{days}일 초과'**
  String home_expired_days(String days);

  /// 오늘 만료
  ///
  /// In ko, this message translates to:
  /// **'오늘 만료'**
  String get home_expires_today;

  /// 총 적립액 라벨
  ///
  /// In ko, this message translates to:
  /// **'총 적립액'**
  String get home_total_savings;

  /// 진행 중 목표 수
  ///
  /// In ko, this message translates to:
  /// **'{count}개 진행 중'**
  String home_active_goals(int count);

  /// 목표 금액 표시
  ///
  /// In ko, this message translates to:
  /// **'목표 {amount}'**
  String home_goal_amount(String amount);

  /// 외 N개
  ///
  /// In ko, this message translates to:
  /// **'외 {count}개'**
  String home_more_goals(int count);

  /// 일정 필터 툴팁
  ///
  /// In ko, this message translates to:
  /// **'일정 필터'**
  String get home_schedule_filter;

  /// 자녀 없음
  ///
  /// In ko, this message translates to:
  /// **'등록된 자녀가 없습니다'**
  String get home_no_children;

  /// 자녀 적금 표시
  ///
  /// In ko, this message translates to:
  /// **'적금 {points}P'**
  String home_childcare_savings(String points);

  /// 기념일 더보기
  ///
  /// In ko, this message translates to:
  /// **'+ {count}개 더 보기'**
  String home_anniversary_more(int count);

  /// 이메일 복사 안내
  ///
  /// In ko, this message translates to:
  /// **'이메일 주소를 복사했습니다'**
  String get auth_email_copied;

  /// 로그인 처리 중
  ///
  /// In ko, this message translates to:
  /// **'로그인 처리 중...'**
  String get auth_login_processing;

  /// 잠시 대기 안내
  ///
  /// In ko, this message translates to:
  /// **'잠시만 기다려주세요.'**
  String get auth_please_wait;

  /// 로그인 실패 제목
  ///
  /// In ko, this message translates to:
  /// **'로그인 실패'**
  String get auth_login_failed;

  /// 로그인 화면으로 버튼
  ///
  /// In ko, this message translates to:
  /// **'로그인 화면으로 돌아가기'**
  String get auth_back_to_login;

  /// 인증 코드 검증
  ///
  /// In ko, this message translates to:
  /// **'인증 코드를 입력해주세요'**
  String get auth_code_required;

  /// 이메일 인증 완료
  ///
  /// In ko, this message translates to:
  /// **'이메일 인증이 완료되었습니다. 로그인해주세요.'**
  String get auth_email_verified;

  /// 인증 메일 재전송 완료
  ///
  /// In ko, this message translates to:
  /// **'인증 이메일을 다시 보냈습니다.'**
  String get auth_email_resent;

  /// 이메일 인증 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'이메일 인증'**
  String get auth_email_verification;

  /// 이메일 확인 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'이메일을 확인해주세요'**
  String get auth_check_email;

  /// 인증 메일 발송 안내
  ///
  /// In ko, this message translates to:
  /// **'{email}\n으로 인증 이메일을 보냈습니다.'**
  String auth_email_sent_to(String email);

  /// 인증 코드 입력 제목
  ///
  /// In ko, this message translates to:
  /// **'인증 코드 입력'**
  String get auth_enter_code;

  /// 인증 코드 설명
  ///
  /// In ko, this message translates to:
  /// **'이메일에 포함된 6자리 인증 코드를 입력해주세요.'**
  String get auth_enter_code_desc;

  /// 인증 코드 라벨
  ///
  /// In ko, this message translates to:
  /// **'인증 코드'**
  String get auth_code_label;

  /// 인증 코드 예시
  ///
  /// In ko, this message translates to:
  /// **'예: 123456'**
  String get auth_code_hint;

  /// 메일 미수신 안내
  ///
  /// In ko, this message translates to:
  /// **'이메일을 받지 못하셨나요?'**
  String get auth_no_email;

  /// 인증 메일 재전송 버튼
  ///
  /// In ko, this message translates to:
  /// **'인증 이메일 재전송'**
  String get auth_resend_email;

  /// 나중에 인증 안내
  ///
  /// In ko, this message translates to:
  /// **'나중에 인증하기 '**
  String get auth_verify_later;

  /// 로그인으로 돌아가기
  ///
  /// In ko, this message translates to:
  /// **'로그인으로 돌아가기'**
  String get auth_back_to_signin;

  /// 인증 토큰 없음 안내
  ///
  /// In ko, this message translates to:
  /// **'인증 토큰이 없습니다. 다시 로그인해주세요.'**
  String get auth_no_token;

  /// 약관 동의 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용 동의'**
  String get auth_terms_title;

  /// 약관 동의 안내
  ///
  /// In ko, this message translates to:
  /// **'패밀리플래너 서비스 이용을\n위해 약관에 동의해 주세요'**
  String get auth_terms_desc;

  /// 동의하고 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'동의하고 시작하기'**
  String get auth_agree_and_start;

  /// AI 어시스턴트
  ///
  /// In ko, this message translates to:
  /// **'AI 어시스턴트'**
  String get ai_assistant;

  /// 프리미엄 안내
  ///
  /// In ko, this message translates to:
  /// **'내년 출시될 프리미엄 구독 기능입니다.\n구독을 통해 AI 어시스턴트를 사용하실 수 있습니다.'**
  String get ai_premium_desc;

  /// 프리미엄 출시 예정 배지
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 구독 출시 예정'**
  String get ai_premium_coming;

  /// 무엇이든 물어보세요
  ///
  /// In ko, this message translates to:
  /// **'무엇이든 물어보세요'**
  String get ai_ask_anything;

  /// 대화 초기화 툴팁
  ///
  /// In ko, this message translates to:
  /// **'대화 초기화'**
  String get ai_reset_chat;

  /// AI 인사말
  ///
  /// In ko, this message translates to:
  /// **'안녕하세요! 가족 플래너 AI입니다.'**
  String get ai_greeting;

  /// AI 인사 설명
  ///
  /// In ko, this message translates to:
  /// **'아래 추천 질문을 눌러보거나\n직접 질문을 입력해보세요.'**
  String get ai_greeting_desc;

  /// 새 대화 시작 안내
  ///
  /// In ko, this message translates to:
  /// **'새 대화를 시작했습니다'**
  String get ai_new_chat;

  /// 메시지 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'메시지를 입력하세요...'**
  String get ai_message_hint;

  /// 전송 버튼
  ///
  /// In ko, this message translates to:
  /// **'전송'**
  String get ai_send;

  /// 추천 질문 1
  ///
  /// In ko, this message translates to:
  /// **'이번 달 지출 분석해줘'**
  String get ai_suggest1;

  /// 추천 질문 2
  ///
  /// In ko, this message translates to:
  /// **'가족 일정 요약해줘'**
  String get ai_suggest2;

  /// 추천 질문 3
  ///
  /// In ko, this message translates to:
  /// **'저축 목표 달성률 알려줘'**
  String get ai_suggest3;

  /// 추천 질문 4
  ///
  /// In ko, this message translates to:
  /// **'미결 할 일 목록 보여줘'**
  String get ai_suggest4;

  /// 추천 질문 5
  ///
  /// In ko, this message translates to:
  /// **'투자 포트폴리오 현황은?'**
  String get ai_suggest5;

  /// 추천 질문 6
  ///
  /// In ko, this message translates to:
  /// **'이번 주 중요한 일정 뭐 있어?'**
  String get ai_suggest6;

  /// 날씨 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'날씨'**
  String get weather_title;

  /// 현재 날씨 실패
  ///
  /// In ko, this message translates to:
  /// **'현재 날씨를 불러오지 못했습니다'**
  String get weather_current_failed;

  /// 예보 실패
  ///
  /// In ko, this message translates to:
  /// **'예보를 불러오지 못했습니다'**
  String get weather_forecast_failed;

  /// 습도 라벨
  ///
  /// In ko, this message translates to:
  /// **'습도'**
  String get weather_humidity;

  /// 풍속 라벨
  ///
  /// In ko, this message translates to:
  /// **'풍속'**
  String get weather_wind;

  /// 강수량 라벨
  ///
  /// In ko, this message translates to:
  /// **'강수량'**
  String get weather_precipitation;

  /// 대기질 제목
  ///
  /// In ko, this message translates to:
  /// **'대기질'**
  String get weather_air_quality;

  /// 미세먼지 라벨
  ///
  /// In ko, this message translates to:
  /// **'미세먼지'**
  String get weather_pm10;

  /// 초미세먼지 라벨
  ///
  /// In ko, this message translates to:
  /// **'초미세먼지'**
  String get weather_pm25;

  /// 측정 기준 표시
  ///
  /// In ko, this message translates to:
  /// **'측정 기준: {region}'**
  String weather_measured_at(String region);

  /// 시간별 예보 제목
  ///
  /// In ko, this message translates to:
  /// **'시간별 예보'**
  String get weather_hourly;

  /// 시간별 예보 없음
  ///
  /// In ko, this message translates to:
  /// **'시간별 예보 정보가 없습니다'**
  String get weather_hourly_empty;

  /// 날짜별 예보 제목
  ///
  /// In ko, this message translates to:
  /// **'날짜별 예보'**
  String get weather_daily;

  /// N시 표기
  ///
  /// In ko, this message translates to:
  /// **'{hour}시'**
  String weather_hour(String hour);

  /// 오늘 라벨
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get weather_today;

  /// 일 보기
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get calendar_view_day;

  /// 주 보기
  ///
  /// In ko, this message translates to:
  /// **'주'**
  String get calendar_view_week;

  /// 월 보기
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get calendar_view_month;

  /// 연도 보기
  ///
  /// In ko, this message translates to:
  /// **'연도'**
  String get calendar_view_year;

  /// 기념일 관리 메뉴
  ///
  /// In ko, this message translates to:
  /// **'기념일 관리'**
  String get calendar_manage_anniversary;

  /// 뷰 선택 제목
  ///
  /// In ko, this message translates to:
  /// **'뷰 선택'**
  String get calendar_select_view;

  /// 종일 라벨
  ///
  /// In ko, this message translates to:
  /// **'종일'**
  String get calendar_allday;

  /// 음력 표시
  ///
  /// In ko, this message translates to:
  /// **'음력 {label}'**
  String calendar_lunar_label(String label);

  /// 숨겨진 일정 수
  ///
  /// In ko, this message translates to:
  /// **'+{count}개'**
  String calendar_hidden_count(int count);

  /// 그룹 외 N개
  ///
  /// In ko, this message translates to:
  /// **'{name} 외 {count}개'**
  String calendar_group_more(String name, int count);

  /// N년 표기
  ///
  /// In ko, this message translates to:
  /// **'{year}년'**
  String calendar_year_label(String year);

  /// 일정 추가 완료
  ///
  /// In ko, this message translates to:
  /// **'일정을 추가했습니다.'**
  String get calendar_task_added;

  /// 일정 제목 힌트
  ///
  /// In ko, this message translates to:
  /// **'일정 제목'**
  String get calendar_task_title_hint;

  /// 개인 선택지
  ///
  /// In ko, this message translates to:
  /// **'개인'**
  String get calendar_personal;

  /// 일정 유형
  ///
  /// In ko, this message translates to:
  /// **'일정'**
  String get calendar_type_event;

  /// 할일 유형
  ///
  /// In ko, this message translates to:
  /// **'할일'**
  String get calendar_type_todo;

  /// 일정+할일 유형
  ///
  /// In ko, this message translates to:
  /// **'일정+할일'**
  String get calendar_type_both;

  /// 더 보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'더 보기'**
  String get calendar_more;

  /// 5분 전 알림
  ///
  /// In ko, this message translates to:
  /// **'5분 전'**
  String get calendar_remind_5m;

  /// 15분 전 알림
  ///
  /// In ko, this message translates to:
  /// **'15분 전'**
  String get calendar_remind_15m;

  /// 30분 전 알림
  ///
  /// In ko, this message translates to:
  /// **'30분 전'**
  String get calendar_remind_30m;

  /// 1시간 전 알림
  ///
  /// In ko, this message translates to:
  /// **'1시간 전'**
  String get calendar_remind_1h;

  /// 1일 전 알림
  ///
  /// In ko, this message translates to:
  /// **'1일 전'**
  String get calendar_remind_1d;

  /// N년 표기
  ///
  /// In ko, this message translates to:
  /// **'{year}년'**
  String household_year_label(String year);

  /// 연간 통계 탭
  ///
  /// In ko, this message translates to:
  /// **'연간 통계'**
  String get household_yearly_stats;

  /// 통계 제외 안내
  ///
  /// In ko, this message translates to:
  /// **'환불금 및 이월 입금은 통계에서 제외됩니다'**
  String get household_stats_exclude_note;

  /// 카테고리별
  ///
  /// In ko, this message translates to:
  /// **'카테고리별'**
  String get household_by_category;

  /// 소비처별
  ///
  /// In ko, this message translates to:
  /// **'소비처별'**
  String get household_by_merchant;

  /// 멤버별
  ///
  /// In ko, this message translates to:
  /// **'멤버별'**
  String get household_by_member;

  /// 직접 필터링
  ///
  /// In ko, this message translates to:
  /// **'직접 필터링'**
  String get household_custom_filter;

  /// 카테고리별 지출 제목
  ///
  /// In ko, this message translates to:
  /// **'카테고리별 지출'**
  String get household_category_spending;

  /// 소비처별 지출 제목
  ///
  /// In ko, this message translates to:
  /// **'소비처별 지출'**
  String get household_merchant_spending;

  /// 멤버별 지출 제목
  ///
  /// In ko, this message translates to:
  /// **'멤버별 지출'**
  String get household_member_spending;

  /// 소비처 없음
  ///
  /// In ko, this message translates to:
  /// **'소비처 없음'**
  String get household_no_merchant;

  /// 미지정
  ///
  /// In ko, this message translates to:
  /// **'미지정'**
  String get household_unassigned;

  /// 멤버 라벨
  ///
  /// In ko, this message translates to:
  /// **'멤버'**
  String get household_member;

  /// 월별 지출 제목
  ///
  /// In ko, this message translates to:
  /// **'월별 지출'**
  String get household_monthly_spending;

  /// 지난달 비교 제목
  ///
  /// In ko, this message translates to:
  /// **'지난달 비교'**
  String get household_compare_last_month;

  /// 누적 지출 추이 제목
  ///
  /// In ko, this message translates to:
  /// **'누적 지출 추이'**
  String get household_cumulative_trend;

  /// 가변 배지
  ///
  /// In ko, this message translates to:
  /// **'가변'**
  String get household_variable;

  /// 예상금액 라벨
  ///
  /// In ko, this message translates to:
  /// **'예상금액'**
  String get household_expected_amount;

  /// 발생일 라벨
  ///
  /// In ko, this message translates to:
  /// **'발생일'**
  String get household_due_day;

  /// 매월 N일
  ///
  /// In ko, this message translates to:
  /// **'매월 {day}일'**
  String household_due_day_value(String day);

  /// 받는 사람 라벨
  ///
  /// In ko, this message translates to:
  /// **'받는 사람'**
  String get household_payee;

  /// 결제하는 사람 라벨
  ///
  /// In ko, this message translates to:
  /// **'결제하는 사람'**
  String get household_payer;

  /// 적용 내역 없음
  ///
  /// In ko, this message translates to:
  /// **'아직 적용된 내역이 없습니다'**
  String get household_no_applied;

  /// 확정 평균 라벨
  ///
  /// In ko, this message translates to:
  /// **'확정 평균'**
  String get household_confirmed_avg;

  /// 최솟값 라벨
  ///
  /// In ko, this message translates to:
  /// **'최솟값'**
  String get household_min;

  /// 최댓값 라벨
  ///
  /// In ko, this message translates to:
  /// **'최댓값'**
  String get household_max;

  /// 미확정 접미
  ///
  /// In ko, this message translates to:
  /// **'{date}  미확정'**
  String household_unconfirmed_suffix(String date);

  /// 예시 포트폴리오 - 나스닥 ETF
  ///
  /// In ko, this message translates to:
  /// **'나스닥 ETF'**
  String get asset_demo_nasdaq;

  /// 예시 포트폴리오 - 삼성전자
  ///
  /// In ko, this message translates to:
  /// **'삼성전자'**
  String get asset_demo_samsung;

  /// 금액 입력칸의 통화 단위
  ///
  /// In ko, this message translates to:
  /// **'원'**
  String get currency_won_unit;

  /// 가계부 자동 등록 완료 알림 제목
  ///
  /// In ko, this message translates to:
  /// **'가계부 자동 등록 완료'**
  String get household_auto_registered;

  /// 가계부 자동 등록 알림 본문
  ///
  /// In ko, this message translates to:
  /// **'{amount}원이 가계부에 등록되었습니다.'**
  String household_auto_registered_body(String amount);

  /// 결제 알림 감지 서비스 제목
  ///
  /// In ko, this message translates to:
  /// **'가계부 자동 등록'**
  String get household_auto_service;

  /// 결제 알림 감지 서비스 설명
  ///
  /// In ko, this message translates to:
  /// **'결제 알림을 감지해 가계부에 자동 등록합니다'**
  String get household_auto_service_desc;

  /// 캘린더 코치마크 - 공유 캘린더
  ///
  /// In ko, this message translates to:
  /// **'공유 캘린더'**
  String get coach_calendar_shared;

  /// 공유 캘린더 설명
  ///
  /// In ko, this message translates to:
  /// **'그룹 구성원의 일정을 한눈에 볼 수 있어요.\n날짜를 탭해 해당 날의 일정을 확인하세요.'**
  String get coach_calendar_shared_desc;

  /// 캘린더 코치마크 - 일정 추가
  ///
  /// In ko, this message translates to:
  /// **'일정 추가'**
  String get coach_calendar_add;

  /// 일정 추가 설명
  ///
  /// In ko, this message translates to:
  /// **'버튼을 눌러 새 일정을 만드세요.\n눌러서 생성 화면을 살펴보세요.'**
  String get coach_calendar_add_desc;

  /// 그룹 코치마크 - 그룹 만들기
  ///
  /// In ko, this message translates to:
  /// **'그룹 만들기'**
  String get coach_group_create;

  /// 그룹 만들기 설명
  ///
  /// In ko, this message translates to:
  /// **'가족, 연인, 친구, 팀 등\n원하는 그룹을 직접 만들어 보세요.'**
  String get coach_group_create_desc;

  /// 그룹 코치마크 - 참여하기
  ///
  /// In ko, this message translates to:
  /// **'그룹 참여하기'**
  String get coach_group_join;

  /// 그룹 참여 설명
  ///
  /// In ko, this message translates to:
  /// **'초대 코드를 입력해 기존 그룹에 합류하세요.\n그룹원이 공유한 코드를 사용하면 돼요.'**
  String get coach_group_join_desc;

  /// 그룹 코치마크 - 신청 내역
  ///
  /// In ko, this message translates to:
  /// **'신청 내역'**
  String get coach_group_requests;

  /// 신청 내역 설명
  ///
  /// In ko, this message translates to:
  /// **'내가 참여 신청한 그룹 목록을 확인하고\n수락 여부를 여기서 확인할 수 있어요.'**
  String get coach_group_requests_desc;

  /// 저금통 코치마크 - 적립 현황
  ///
  /// In ko, this message translates to:
  /// **'적립 현황'**
  String get coach_savings_status;

  /// 적립 현황 설명
  ///
  /// In ko, this message translates to:
  /// **'현재 적립금과 목표 금액,\n달성률을 상세하게 확인할 수 있어요.\n자동 적립 중일 때는 적립 상태도 표시돼요.'**
  String get coach_savings_status_desc;

  /// 저금통 코치마크 - 입출금
  ///
  /// In ko, this message translates to:
  /// **'입금 / 출금'**
  String get coach_savings_deposit;

  /// 입출금 설명
  ///
  /// In ko, this message translates to:
  /// **'언제든지 직접 입금하거나 출금할 수 있어요.\n자동 적립과 함께 활용하면 더욱 편리해요.'**
  String get coach_savings_deposit_desc;

  /// 저금통 코치마크 - 저금통
  ///
  /// In ko, this message translates to:
  /// **'저금통'**
  String get coach_savings_goal;

  /// 저금통 설명
  ///
  /// In ko, this message translates to:
  /// **'목표 이름, 현재 적립금, 달성률을 한눈에 확인할 수 있어요.\n자동 적립을 켜두면 매달 자동으로 입금돼요.'**
  String get coach_savings_goal_desc;

  /// 저금통 예시 설명
  ///
  /// In ko, this message translates to:
  /// **'올해 여름 가족 여행 목표'**
  String get coach_savings_demo_desc;

  /// 저금통 예시 - 제주도 여행
  ///
  /// In ko, this message translates to:
  /// **'제주도 여행'**
  String get coach_savings_demo_jeju;

  /// 저금통 예시 - 비상금
  ///
  /// In ko, this message translates to:
  /// **'비상금'**
  String get coach_savings_demo_emergency;

  /// 예시 품목 - 우유
  ///
  /// In ko, this message translates to:
  /// **'우유'**
  String get demo_milk;

  /// 예시 품목 - 계란
  ///
  /// In ko, this message translates to:
  /// **'계란'**
  String get demo_eggs;

  /// 예시 품목 - 두부
  ///
  /// In ko, this message translates to:
  /// **'두부'**
  String get demo_tofu;

  /// 예시 단위 - 개
  ///
  /// In ko, this message translates to:
  /// **'개'**
  String get demo_unit_piece;

  /// 예시 단위 - 판
  ///
  /// In ko, this message translates to:
  /// **'판'**
  String get demo_unit_pack;

  /// 예시 보관함 - 냉장고
  ///
  /// In ko, this message translates to:
  /// **'냉장고'**
  String get demo_fridge;

  /// 예시 보관함 - 냉동실
  ///
  /// In ko, this message translates to:
  /// **'냉동실'**
  String get demo_freezer;

  /// 예시 계좌 - 국민은행 적금
  ///
  /// In ko, this message translates to:
  /// **'국민은행 적금'**
  String get demo_bank_savings;

  /// 사다리 코치마크 - 참여자 입력
  ///
  /// In ko, this message translates to:
  /// **'참여자 입력'**
  String get coach_ladder_participants;

  /// 참여자 입력 설명
  ///
  /// In ko, this message translates to:
  /// **'사다리를 탈 참여자 이름을 입력해요.\n그룹 멤버 불러오기 버튼으로\n한 번에 추가할 수도 있어요.'**
  String get coach_ladder_participants_desc;

  /// 사다리 코치마크 - 결과 항목
  ///
  /// In ko, this message translates to:
  /// **'결과 항목 입력'**
  String get coach_ladder_results;

  /// 결과 항목 설명
  ///
  /// In ko, this message translates to:
  /// **'당첨될 결과 항목과 수량을 입력해요.\n수량의 합이 참여자 수와 같아야\n사다리를 생성할 수 있어요.'**
  String get coach_ladder_results_desc;

  /// 사다리 코치마크 - 생성
  ///
  /// In ko, this message translates to:
  /// **'사다리 생성'**
  String get coach_ladder_create;

  /// 사다리 생성 설명
  ///
  /// In ko, this message translates to:
  /// **'버튼을 누르면 사다리가 생성돼요.\n참여자 이름을 탭하면 경로가 애니메이션으로\n표시되고 결과가 공개됩니다.'**
  String get coach_ladder_create_desc;

  /// 룰렛 코치마크 - 항목 입력
  ///
  /// In ko, this message translates to:
  /// **'항목 입력'**
  String get coach_roulette_items;

  /// 항목 입력 설명
  ///
  /// In ko, this message translates to:
  /// **'룰렛에 올릴 항목을 입력해요.\n비율을 조정하면 당첨 확률을\n다르게 설정할 수 있어요.'**
  String get coach_roulette_items_desc;

  /// 룰렛 코치마크 - 원판
  ///
  /// In ko, this message translates to:
  /// **'룰렛 원판'**
  String get coach_roulette_wheel;

  /// 원판 설명
  ///
  /// In ko, this message translates to:
  /// **'항목을 2개 이상 입력하면\n룰렛 원판이 나타나요.\n가운데 버튼을 눌러도 돌릴 수 있어요.'**
  String get coach_roulette_wheel_desc;

  /// 룰렛 코치마크 - 돌리기
  ///
  /// In ko, this message translates to:
  /// **'돌리기'**
  String get coach_roulette_spin;

  /// 돌리기 설명
  ///
  /// In ko, this message translates to:
  /// **'버튼을 누르면 룰렛이 회전해요.\n결과는 자동으로 그룹 이력에\n저장되어 모두가 확인할 수 있어요.'**
  String get coach_roulette_spin_desc;

  /// 자산 코치마크 - 계좌 카드
  ///
  /// In ko, this message translates to:
  /// **'계좌 카드'**
  String get coach_asset_card;

  /// 계좌 카드 설명
  ///
  /// In ko, this message translates to:
  /// **'계좌명, 금융기관, 최신 잔액과 수익률을\n한눈에 확인할 수 있어요.\n탭하면 잔액 기록과 포트폴리오를 관리할 수 있습니다.'**
  String get coach_asset_card_desc;

  /// 자산 코치마크 - 자산 통계
  ///
  /// In ko, this message translates to:
  /// **'자산 통계'**
  String get coach_asset_stats;

  /// 자산 통계 설명
  ///
  /// In ko, this message translates to:
  /// **'전체 자산의 합계, 수익률, 유형별 분포를\n차트로 한눈에 확인할 수 있어요.\nKOSPI·S&P500 등 지수와 비교도 가능합니다.'**
  String get coach_asset_stats_desc;

  /// 예시 금융기관 - 국민은행
  ///
  /// In ko, this message translates to:
  /// **'국민은행'**
  String get demo_bank_kb;

  /// 그룹 상세 코치마크 - 멤버 초대
  ///
  /// In ko, this message translates to:
  /// **'멤버를 초대해보세요'**
  String get coach_group_invite;

  /// 멤버 초대 설명
  ///
  /// In ko, this message translates to:
  /// **'설정 탭에서 초대 코드를 공유하거나\n이메일로 직접 멤버를 초대할 수 있어요.\n\n탭을 눌러 설정으로 이동하세요.'**
  String get coach_group_invite_desc;

  /// 초대 코드 코치마크
  ///
  /// In ko, this message translates to:
  /// **'초대 코드로 멤버 초대'**
  String get coach_group_invite_code;

  /// 초대 코드 설명
  ///
  /// In ko, this message translates to:
  /// **'코드를 복사해 공유하거나\n이메일로 직접 초대장을 보낼 수 있어요.'**
  String get coach_group_invite_code_desc;

  /// 역할 관리 코치마크
  ///
  /// In ko, this message translates to:
  /// **'역할로 권한을 관리하세요'**
  String get coach_group_roles;

  /// 역할 관리 설명
  ///
  /// In ko, this message translates to:
  /// **'역할 탭에서 새로운 역할을 만들고\n멤버별 권한을 세밀하게 설정할 수 있어요.\n\n탭을 눌러 역할 관리로 이동하세요.'**
  String get coach_group_roles_desc;

  /// 새 역할 만들기 코치마크
  ///
  /// In ko, this message translates to:
  /// **'새 역할 만들기'**
  String get coach_group_role_new;

  /// 새 역할 설명
  ///
  /// In ko, this message translates to:
  /// **'버튼을 눌러 역할을 만들고\n이름, 색상, 권한을 자유롭게 설정하세요.'**
  String get coach_group_role_new_desc;

  /// 그룹 색상 코치마크
  ///
  /// In ko, this message translates to:
  /// **'나만의 그룹 색상을 설정하세요'**
  String get coach_group_color;

  /// 그룹 색상 설명
  ///
  /// In ko, this message translates to:
  /// **'설정 탭에서 이 그룹의 색상을 지정할 수 있어요.\n설정한 색상은 일정 등 다양한 메뉴에서\n이 그룹의 항목을 구분하는 데 사용돼요.\n\n탭을 눌러 설정으로 이동하세요.'**
  String get coach_group_color_desc;

  /// 장보기 완료 코치마크 제목
  ///
  /// In ko, this message translates to:
  /// **'장보기 완료 기능 안내'**
  String get coach_cart_complete;

  /// 장보기 완료 설명
  ///
  /// In ko, this message translates to:
  /// **'장보기 완료 버튼을 누르면 아래 두 가지를 한 번에 처리할 수 있어요.'**
  String get coach_cart_complete_desc;

  /// 냉장고 이관 제목
  ///
  /// In ko, this message translates to:
  /// **'냉장고로 이관'**
  String get coach_cart_to_fridge;

  /// 냉장고 이관 설명
  ///
  /// In ko, this message translates to:
  /// **'구매한 품목을 냉장고 보관소로 바로 옮길 수 있어요.\n수량·유통기한·알림일도 함께 설정할 수 있습니다.'**
  String get coach_cart_to_fridge_desc;

  /// 가계부 기록 제목
  ///
  /// In ko, this message translates to:
  /// **'가계부 자동 기록'**
  String get coach_cart_to_expense;

  /// 가계부 기록 설명
  ///
  /// In ko, this message translates to:
  /// **'지출 금액·결제 수단·메모를 입력하면\n가계부에 자동으로 기록돼요.'**
  String get coach_cart_to_expense_desc;

  /// 이관 안 함 표시
  ///
  /// In ko, this message translates to:
  /// **'이관 안 함'**
  String get coach_cart_no_transfer;

  /// 할일 예시 1
  ///
  /// In ko, this message translates to:
  /// **'장보기 목록 작성'**
  String get demo_todo_shopping;

  /// 할일 예시 1 설명
  ///
  /// In ko, this message translates to:
  /// **'이번 주 필요한 식재료 정리'**
  String get demo_todo_shopping_desc;

  /// 할일 예시 2
  ///
  /// In ko, this message translates to:
  /// **'가족 여행 계획'**
  String get demo_todo_trip;

  /// 할일 예시 2 설명
  ///
  /// In ko, this message translates to:
  /// **'여름 휴가 일정 및 숙소 예약'**
  String get demo_todo_trip_desc;

  /// 할일 예시 3
  ///
  /// In ko, this message translates to:
  /// **'월간 가계부 정리'**
  String get demo_todo_budget;

  /// 할일 예시 3 설명
  ///
  /// In ko, this message translates to:
  /// **'지난달 수입·지출 확인'**
  String get demo_todo_budget_desc;

  /// 할일 코치마크 - 날짜별
  ///
  /// In ko, this message translates to:
  /// **'날짜별 할 일'**
  String get coach_todo_byDate;

  /// 날짜별 설명
  ///
  /// In ko, this message translates to:
  /// **'날짜를 탭해 해당 날의 할 일을 확인하고\n그룹원과 역할을 나눠 보세요.'**
  String get coach_todo_byDate_desc;

  /// 할일 코치마크 - 상태 변경
  ///
  /// In ko, this message translates to:
  /// **'상태 변경'**
  String get coach_todo_status;

  /// 상태 변경 설명
  ///
  /// In ko, this message translates to:
  /// **'왼쪽 아이콘을 탭하면 할 일의 상태를\n대기 · 진행 중 · 완료 등으로 바꿀 수 있어요.'**
  String get coach_todo_status_desc;

  /// 할일 코치마크 - 추가
  ///
  /// In ko, this message translates to:
  /// **'할 일 추가'**
  String get coach_todo_add;

  /// 할일 추가 설명
  ///
  /// In ko, this message translates to:
  /// **'새로운 할 일을 추가하고\n담당자와 마감일을 지정해보세요.'**
  String get coach_todo_add_desc;

  /// 예시 품목 - 사과
  ///
  /// In ko, this message translates to:
  /// **'사과'**
  String get demo_apple;

  /// 구매 이력 코치마크
  ///
  /// In ko, this message translates to:
  /// **'구매 이력'**
  String get coach_history_records;

  /// 구매 이력 설명
  ///
  /// In ko, this message translates to:
  /// **'장보기를 완료할 때마다 이력이 쌓여요.\n카드를 탭하면 품목별 상세 내역을\n확인할 수 있어요.'**
  String get coach_history_records_desc;

  /// 가계부 연동 코치마크
  ///
  /// In ko, this message translates to:
  /// **'가계부 연동'**
  String get coach_history_expense;

  /// 가계부 연동 설명
  ///
  /// In ko, this message translates to:
  /// **'장보기 완료 시 지출을 함께 기록하면\n이 배지가 표시돼요.\n가계부와 자동으로 연동되어 지출 관리가 편해져요.'**
  String get coach_history_expense_desc;

  /// 가계부 예시 - 급여
  ///
  /// In ko, this message translates to:
  /// **'6월 급여'**
  String get demo_expense_salary;

  /// 가계부 예시 - 외식
  ///
  /// In ko, this message translates to:
  /// **'저녁 외식'**
  String get demo_expense_dining;

  /// 가계부 예시 - 주유
  ///
  /// In ko, this message translates to:
  /// **'주유'**
  String get demo_expense_fuel;

  /// 가계부 예시 - 공과금
  ///
  /// In ko, this message translates to:
  /// **'전기/가스 요금'**
  String get demo_expense_utility;

  /// 가계부 코치마크 - 월간 요약
  ///
  /// In ko, this message translates to:
  /// **'월간 요약'**
  String get coach_household_summary;

  /// 월간 요약 설명
  ///
  /// In ko, this message translates to:
  /// **'이번 달 수입·지출·잔액을 한눈에 확인하고,\n예산 대비 사용량을 진척도 바로 볼 수 있어요.'**
  String get coach_household_summary_desc;

  /// 가계부 코치마크 - 예산 설정
  ///
  /// In ko, this message translates to:
  /// **'예산 설정'**
  String get coach_household_budget;

  /// 예산 설정 설명
  ///
  /// In ko, this message translates to:
  /// **'여기 더보기 메뉴를 열면 월별 예산을\n카테고리별로 설정할 수 있어요.'**
  String get coach_household_budget_desc;

  /// 가계부 코치마크 - 고정 지출
  ///
  /// In ko, this message translates to:
  /// **'고정 지출'**
  String get coach_household_recurring;

  /// 고정 지출 설명
  ///
  /// In ko, this message translates to:
  /// **'월세, 구독료 등 매달 반복되는 지출을\n등록하면 자동으로 기록해 드려요.'**
  String get coach_household_recurring_desc;

  /// 가계부 코치마크 - 통계
  ///
  /// In ko, this message translates to:
  /// **'통계'**
  String get coach_household_stats;

  /// 통계 설명
  ///
  /// In ko, this message translates to:
  /// **'카테고리별 지출 비율과 월별 추이를\n차트로 확인할 수 있어요.'**
  String get coach_household_stats_desc;

  /// 가계부 코치마크 - 추가
  ///
  /// In ko, this message translates to:
  /// **'지출/수입 추가'**
  String get coach_household_add;

  /// 추가 설명
  ///
  /// In ko, this message translates to:
  /// **'새 지출이나 수입을 기록하세요.\n그룹별로 나눠서 관리할 수 있어요.'**
  String get coach_household_add_desc;

  /// 나(본인) 표기
  ///
  /// In ko, this message translates to:
  /// **'나'**
  String get common_me;

  /// 메모 예시 제목
  ///
  /// In ko, this message translates to:
  /// **'제주도 여행 준비'**
  String get demo_memo_trip;

  /// 메모 예시 본문
  ///
  /// In ko, this message translates to:
  /// **'항공권 예약 완료\n숙소는 한림읍 게스트하우스로 결정.\n렌터카 예약 필요. 우도, 성산일출봉 방문 예정.'**
  String get demo_memo_trip_body;

  /// 메모 예시 태그 - 여행
  ///
  /// In ko, this message translates to:
  /// **'여행'**
  String get demo_tag_travel;

  /// 메모 예시 태그 - 제주
  ///
  /// In ko, this message translates to:
  /// **'제주'**
  String get demo_tag_jeju;

  /// 체크리스트 메모 제목
  ///
  /// In ko, this message translates to:
  /// **'외박 준비물'**
  String get demo_memo_packing;

  /// 체크 항목 - 여권
  ///
  /// In ko, this message translates to:
  /// **'여권 / 신분증'**
  String get demo_check_passport;

  /// 체크 항목 - 세면도구
  ///
  /// In ko, this message translates to:
  /// **'세면도구'**
  String get demo_check_toiletries;

  /// 체크 항목 - 여벌 옷
  ///
  /// In ko, this message translates to:
  /// **'여벌 옷'**
  String get demo_check_clothes;

  /// 체크 항목 - 충전기
  ///
  /// In ko, this message translates to:
  /// **'충전기'**
  String get demo_check_charger;

  /// 체크 항목 - 상비약
  ///
  /// In ko, this message translates to:
  /// **'상비약'**
  String get demo_check_meds;

  /// 메모 코치마크 - 리치 텍스트
  ///
  /// In ko, this message translates to:
  /// **'리치 텍스트 메모'**
  String get coach_memo_richtext;

  /// 리치 텍스트 설명
  ///
  /// In ko, this message translates to:
  /// **'굵게, 기울임, 제목 등 서식을 자유롭게 적용할 수 있어요.\n태그로 분류하고 URL을 붙여넣으면\n링크 카드가 자동으로 생성됩니다.'**
  String get coach_memo_richtext_desc;

  /// 메모 코치마크 - 체크리스트
  ///
  /// In ko, this message translates to:
  /// **'체크리스트'**
  String get coach_memo_checklist;

  /// 체크리스트 설명
  ///
  /// In ko, this message translates to:
  /// **'메모 중간 어디에든 체크리스트를 삽입할 수 있어요.\n완료된 항목 수가 카드에 바로 표시되고\n상세 화면에서 탭해 체크할 수 있습니다.'**
  String get coach_memo_checklist_desc;

  /// 메모 코치마크 - 진행률
  ///
  /// In ko, this message translates to:
  /// **'진행률'**
  String get coach_memo_progress;

  /// 진행률 설명
  ///
  /// In ko, this message translates to:
  /// **'완료된 항목 수를 한눈에 볼 수 있어요.\n전체 선택/초기화 버튼도 있습니다.'**
  String get coach_memo_progress_desc;

  /// 메모 코치마크 - 항목 체크
  ///
  /// In ko, this message translates to:
  /// **'항목 체크'**
  String get coach_memo_check;

  /// 항목 체크 설명
  ///
  /// In ko, this message translates to:
  /// **'체크박스를 탭하면 완료 처리돼요.\n저장 버튼을 누르면 변경사항이 한 번에 저장됩니다.'**
  String get coach_memo_check_desc;

  /// 메모 코치마크 - 수정 모드
  ///
  /// In ko, this message translates to:
  /// **'수정 모드'**
  String get coach_memo_edit;

  /// 수정 모드 설명
  ///
  /// In ko, this message translates to:
  /// **'수정 버튼을 누르면 에디터가 열려요.\n툴바의 체크리스트 버튼으로 항목을 자유롭게 추가·수정할 수 있습니다.'**
  String get coach_memo_edit_desc;

  /// 투표 예시 제목 1
  ///
  /// In ko, this message translates to:
  /// **'이번 주말 가족 나들이 장소'**
  String get demo_vote_outing;

  /// 투표 예시 설명
  ///
  /// In ko, this message translates to:
  /// **'다수결로 결정해요! 의견을 남겨주세요.'**
  String get demo_vote_outing_desc;

  /// 투표 예시 제목 2
  ///
  /// In ko, this message translates to:
  /// **'저녁 메뉴 결정'**
  String get demo_vote_dinner;

  /// 예시 멤버 - 엄마
  ///
  /// In ko, this message translates to:
  /// **'엄마'**
  String get demo_member_mom;

  /// 예시 멤버 - 아빠
  ///
  /// In ko, this message translates to:
  /// **'아빠'**
  String get demo_member_dad;

  /// 예시 멤버 - 민준
  ///
  /// In ko, this message translates to:
  /// **'민준'**
  String get demo_member_child;

  /// 투표 선택지 - 한강공원
  ///
  /// In ko, this message translates to:
  /// **'한강공원'**
  String get demo_place_hangang;

  /// 투표 선택지 - 놀이동산
  ///
  /// In ko, this message translates to:
  /// **'놀이동산'**
  String get demo_place_amusement;

  /// 투표 선택지 - 동물원
  ///
  /// In ko, this message translates to:
  /// **'동물원'**
  String get demo_place_zoo;

  /// 투표 선택지 - 치킨
  ///
  /// In ko, this message translates to:
  /// **'치킨'**
  String get demo_food_chicken;

  /// 투표 선택지 - 피자
  ///
  /// In ko, this message translates to:
  /// **'피자'**
  String get demo_food_pizza;

  /// 투표 선택지 - 삼겹살
  ///
  /// In ko, this message translates to:
  /// **'삼겹살'**
  String get demo_food_pork;

  /// 예시 그룹 - 우리 가족
  ///
  /// In ko, this message translates to:
  /// **'우리 가족'**
  String get demo_group_family;

  /// 투표 코치마크 - 그룹 선택
  ///
  /// In ko, this message translates to:
  /// **'그룹 선택'**
  String get coach_vote_group;

  /// 그룹 선택 설명
  ///
  /// In ko, this message translates to:
  /// **'투표는 그룹 단위로 진행돼요.\n그룹을 선택하면 해당 그룹의\n투표 목록을 확인할 수 있어요.'**
  String get coach_vote_group_desc;

  /// 투표 코치마크 - 상태 필터
  ///
  /// In ko, this message translates to:
  /// **'상태 필터'**
  String get coach_vote_filter;

  /// 상태 필터 설명
  ///
  /// In ko, this message translates to:
  /// **'전체, 진행중, 종료된 투표를\n탭으로 쉽게 구분해서 볼 수 있어요.'**
  String get coach_vote_filter_desc;

  /// 투표 코치마크 - 투표 카드
  ///
  /// In ko, this message translates to:
  /// **'투표 카드'**
  String get coach_vote_card;

  /// 투표 카드 설명
  ///
  /// In ko, this message translates to:
  /// **'카드를 탭하면 선택지에 투표할 수 있어요.\n그룹 멤버 모두가 참여할 수 있고\n결과는 실시간으로 확인할 수 있어요.'**
  String get coach_vote_card_desc;

  /// 투표 코치마크 - 새 투표
  ///
  /// In ko, this message translates to:
  /// **'새 투표 만들기'**
  String get coach_vote_create;

  /// 새 투표 설명
  ///
  /// In ko, this message translates to:
  /// **'+ 버튼을 눌러 새 투표를 만들어보세요.\n단일/복수 선택, 익명 투표,\n마감 시각 설정도 지원해요.'**
  String get coach_vote_create_desc;

  /// 상점 예시 설명 - TV
  ///
  /// In ko, this message translates to:
  /// **'저녁 식사 후 TV 30분 추가'**
  String get demo_shop_tv_desc;

  /// 상점 예시 설명 - 게임
  ///
  /// In ko, this message translates to:
  /// **'주말에 게임 1시간'**
  String get demo_shop_game_desc;

  /// 규칙 예시 - 숙제
  ///
  /// In ko, this message translates to:
  /// **'숙제를 스스로 끝냈을 때'**
  String get demo_rule_homework;

  /// 규칙 예시 - 스마트폰
  ///
  /// In ko, this message translates to:
  /// **'스마트폰 1시간 이상 사용'**
  String get demo_rule_phone;

  /// 규칙 예시 - 현금 한도
  ///
  /// In ko, this message translates to:
  /// **'이달 현금 출금은 최대 50P'**
  String get demo_rule_cashout;

  /// 육아 코치마크 - 자녀 등록
  ///
  /// In ko, this message translates to:
  /// **'자녀 등록'**
  String get coach_child_register;

  /// 자녀 등록 설명
  ///
  /// In ko, this message translates to:
  /// **'먼저 자녀를 등록해요.\n이름과 생년월일을 입력하면\n포인트 계정이 자동으로 만들어져요.'**
  String get coach_child_register_desc;

  /// 육아 코치마크 - 포인트 현황
  ///
  /// In ko, this message translates to:
  /// **'포인트 현황'**
  String get coach_child_points;

  /// 포인트 현황 설명
  ///
  /// In ko, this message translates to:
  /// **'자녀의 현재 포인트 잔액과\n월 용돈 플랜을 한눈에 확인할 수 있어요.\n매월 설정한 날짜에 자동으로 포인트가 지급돼요.'**
  String get coach_child_points_desc;

  /// 육아 코치마크 - 적금 플랜
  ///
  /// In ko, this message translates to:
  /// **'적금 플랜'**
  String get coach_child_savings;

  /// 적금 플랜 설명
  ///
  /// In ko, this message translates to:
  /// **'포인트 적금을 설정하면\n매월 자동으로 포인트가 적립되고\n이자도 받을 수 있어요.'**
  String get coach_child_savings_desc;

  /// 육아 코치마크 - 포인트 상점
  ///
  /// In ko, this message translates to:
  /// **'포인트 상점'**
  String get coach_child_shop;

  /// 포인트 상점 설명
  ///
  /// In ko, this message translates to:
  /// **'아이가 모은 포인트로 구매할 수 있는\n보상 목록이에요.\n원하는 것을 얻기 위해 스스로 포인트를\n모으는 동기부여가 됩니다.'**
  String get coach_child_shop_desc;

  /// + 규칙 설명
  ///
  /// In ko, this message translates to:
  /// **'좋은 행동을 했을 때 포인트를 지급해요.\n예: 숙제를 스스로 끝냈을 때 +10P'**
  String get coach_child_rule_plus_desc;

  /// - 규칙 설명
  ///
  /// In ko, this message translates to:
  /// **'약속을 어겼을 때 포인트를 차감해요.\n예: 스마트폰을 1시간 이상 사용하면 -10P'**
  String get coach_child_rule_minus_desc;

  /// 일반 규칙 설명
  ///
  /// In ko, this message translates to:
  /// **'포인트 없이 약속만 기록해요.\n예: 이달 현금 출금은 최대 50P까지만 가능'**
  String get coach_child_rule_info_desc;

  /// 소개 슬라이드1 제목
  ///
  /// In ko, this message translates to:
  /// **'우리만의 플래너'**
  String get intro_slide1_title;

  /// 소개 슬라이드1 부제
  ///
  /// In ko, this message translates to:
  /// **'가족, 연인, 친구, 팀까지'**
  String get intro_slide1_subtitle;

  /// 소개 슬라이드1 설명
  ///
  /// In ko, this message translates to:
  /// **'하나의 앱으로 여러 그룹을 관리하세요.\n관계마다 다른 공간에서 함께 계획할 수 있어요.'**
  String get intro_slide1_desc;

  /// 소개 슬라이드2 제목
  ///
  /// In ko, this message translates to:
  /// **'일정을 함께'**
  String get intro_slide2_title;

  /// 소개 슬라이드2 부제
  ///
  /// In ko, this message translates to:
  /// **'공유 캘린더'**
  String get intro_slide2_subtitle;

  /// 소개 슬라이드2 설명
  ///
  /// In ko, this message translates to:
  /// **'그룹 구성원 모두의 일정을 한눈에.\n중요한 날을 절대 놓치지 않아요.'**
  String get intro_slide2_desc;

  /// 소개 슬라이드3 제목
  ///
  /// In ko, this message translates to:
  /// **'할 일 관리'**
  String get intro_slide3_title;

  /// 소개 슬라이드3 부제
  ///
  /// In ko, this message translates to:
  /// **'공동 TodoList'**
  String get intro_slide3_subtitle;

  /// 소개 슬라이드3 설명
  ///
  /// In ko, this message translates to:
  /// **'누가 무엇을 해야 하는지 명확하게.\n역할을 나누고 함께 완료해 나가세요.'**
  String get intro_slide3_desc;

  /// 소개 슬라이드4 제목
  ///
  /// In ko, this message translates to:
  /// **'가계를 한눈에'**
  String get intro_slide4_title;

  /// 소개 슬라이드4 부제
  ///
  /// In ko, this message translates to:
  /// **'공동 가계부'**
  String get intro_slide4_subtitle;

  /// 소개 슬라이드4 설명
  ///
  /// In ko, this message translates to:
  /// **'수입과 지출을 함께 기록하고 분석하세요.\n재정 목표를 그룹과 함께 달성해요.'**
  String get intro_slide4_desc;

  /// 소개 슬라이드5 제목
  ///
  /// In ko, this message translates to:
  /// **'그 외 다양한 기능'**
  String get intro_slide5_title;

  /// 소개 슬라이드5 부제
  ///
  /// In ko, this message translates to:
  /// **'자산·메모·적금·투표 등'**
  String get intro_slide5_subtitle;

  /// 소개 슬라이드5 설명
  ///
  /// In ko, this message translates to:
  /// **'일상에 필요한 모든 것을 한 곳에서.\n지금 바로 시작해보세요!'**
  String get intro_slide5_desc;

  /// 시작하기 버튼
  ///
  /// In ko, this message translates to:
  /// **'시작하기'**
  String get intro_start;

  /// 다음 버튼
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get intro_next;

  /// 미리보기 그룹 - 연인
  ///
  /// In ko, this message translates to:
  /// **'연인'**
  String get intro_preview_couple;

  /// 미리보기 그룹 - 친구 모임
  ///
  /// In ko, this message translates to:
  /// **'친구 모임'**
  String get intro_preview_friends;

  /// 미리보기 그룹 - 팀 프로젝트
  ///
  /// In ko, this message translates to:
  /// **'팀 프로젝트'**
  String get intro_preview_team;

  /// 미리보기 - 내 그룹
  ///
  /// In ko, this message translates to:
  /// **'내 그룹'**
  String get intro_preview_mygroups;

  /// 미리보기 - N명
  ///
  /// In ko, this message translates to:
  /// **'{count}명'**
  String intro_preview_members(String count);

  /// 미리보기 일정 - 가족 외식
  ///
  /// In ko, this message translates to:
  /// **'가족 외식'**
  String get intro_preview_dining;

  /// 미리보기 일정 - 병원 예약
  ///
  /// In ko, this message translates to:
  /// **'병원 예약'**
  String get intro_preview_hospital;

  /// 미리보기 일정 - 생일 파티
  ///
  /// In ko, this message translates to:
  /// **'생일 파티 🎂'**
  String get intro_preview_birthday;

  /// 미리보기 할일 - 장보기
  ///
  /// In ko, this message translates to:
  /// **'마트 장보기'**
  String get intro_preview_todo1;

  /// 미리보기 할일 - 청소
  ///
  /// In ko, this message translates to:
  /// **'청소기 돌리기'**
  String get intro_preview_todo2;

  /// 미리보기 할일 - 보험
  ///
  /// In ko, this message translates to:
  /// **'보험 갱신 확인'**
  String get intro_preview_todo3;

  /// 미리보기 할일 - 앨범
  ///
  /// In ko, this message translates to:
  /// **'가족사진 앨범 정리'**
  String get intro_preview_todo4;

  /// 미리보기 할일 - 숙제
  ///
  /// In ko, this message translates to:
  /// **'아이 숙제 확인'**
  String get intro_preview_todo5;

  /// 미리보기 - 오늘
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get intro_preview_today;

  /// 미리보기 - 내일
  ///
  /// In ko, this message translates to:
  /// **'내일'**
  String get intro_preview_tomorrow;

  /// 미리보기 - 이번 주
  ///
  /// In ko, this message translates to:
  /// **'이번 주'**
  String get intro_preview_thisweek;

  /// 미리보기 - 전체 N
  ///
  /// In ko, this message translates to:
  /// **'전체 {count}'**
  String intro_preview_total(String count);

  /// 미리보기 - 완료 N
  ///
  /// In ko, this message translates to:
  /// **'완료 {count}'**
  String intro_preview_done(String count);

  /// 미리보기 지출 - 마트
  ///
  /// In ko, this message translates to:
  /// **'마트'**
  String get intro_preview_mart;

  /// 미리보기 지출 - 외식
  ///
  /// In ko, this message translates to:
  /// **'외식'**
  String get intro_preview_eatout;

  /// 미리보기 수입 - 월급
  ///
  /// In ko, this message translates to:
  /// **'월급'**
  String get intro_preview_salary;

  /// 미리보기 지출 - 교통비
  ///
  /// In ko, this message translates to:
  /// **'교통비'**
  String get intro_preview_transport;

  /// 미리보기 기능 - 자산 관리
  ///
  /// In ko, this message translates to:
  /// **'자산 관리'**
  String get intro_preview_assets;

  /// 미리보기 기능 - 적금 관리
  ///
  /// In ko, this message translates to:
  /// **'적금 관리'**
  String get intro_preview_savings;

  /// 예시 메모 - 국산
  ///
  /// In ko, this message translates to:
  /// **'국산'**
  String get demo_memo_domestic;

  /// 장바구니 코치마크 - 품목 추가
  ///
  /// In ko, this message translates to:
  /// **'품목 추가'**
  String get coach_cart_add;

  /// 품목 추가 설명
  ///
  /// In ko, this message translates to:
  /// **'구매할 품목을 추가해요.\n추가하면 자동으로 저장됩니다.'**
  String get coach_cart_add_desc;

  /// 장바구니 코치마크 - 품목 관리
  ///
  /// In ko, this message translates to:
  /// **'품목 관리'**
  String get coach_cart_manage;

  /// 품목 관리 설명
  ///
  /// In ko, this message translates to:
  /// **'• 탭하면 이름·수량·메모를 수정할 수 있어요\n• ± 버튼으로 수량을 조절하세요\n• 왼쪽으로 스와이프하면 삭제돼요\n• 변경하면 잠시 후 자동으로 저장됩니다'**
  String get coach_cart_manage_desc;

  /// 장바구니 코치마크 - 장보기 완료
  ///
  /// In ko, this message translates to:
  /// **'장보기 완료'**
  String get coach_cart_finish;

  /// 장보기 완료 설명
  ///
  /// In ko, this message translates to:
  /// **'쇼핑을 마치면 여기를 눌러요.\n다음 화면에서 상세 기능을 확인해 보세요!'**
  String get coach_cart_finish_desc;

  /// 다음 기능 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'탭하면 다음 기능으로 넘어가요!'**
  String get coach_cart_next;

  /// 다음 기능 안내 설명
  ///
  /// In ko, this message translates to:
  /// **'자주 사는 물건 탭에서 더 많은 기능을 안내해 드릴게요.'**
  String get coach_cart_next_desc;

  /// 이월 지출 설명
  ///
  /// In ko, this message translates to:
  /// **'잔금 이월'**
  String get household_carryover_out;

  /// 이월 수입 설명
  ///
  /// In ko, this message translates to:
  /// **'전월 이월'**
  String get household_carryover_in;

  /// 자산 이동 설명
  ///
  /// In ko, this message translates to:
  /// **'자산 이동 ({name})'**
  String household_transfer_asset(String name);

  /// 저금통 이동 설명
  ///
  /// In ko, this message translates to:
  /// **'저금통 이동 ({name})'**
  String household_transfer_savings(String name);

  /// 가계부 잔금 이동 설명
  ///
  /// In ko, this message translates to:
  /// **'가계부 잔금 이동'**
  String get household_transfer_from_ledger;

  /// 다이어리 메인 타이틀
  ///
  /// In ko, this message translates to:
  /// **'다이어리'**
  String get diary_title;

  /// 다이어리 빈 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'아직 기록이 없어요'**
  String get diary_empty;

  /// 다이어리 빈 상태 부제
  ///
  /// In ko, this message translates to:
  /// **'아래에 한 줄만 남겨보세요'**
  String get diary_empty_subtitle;

  /// 다이어리 목록/상세 조회 실패
  ///
  /// In ko, this message translates to:
  /// **'일기를 불러오지 못했습니다'**
  String get diary_load_error;

  /// 빠른 기록 입력창 안내 문구 (오늘 일기 없음)
  ///
  /// In ko, this message translates to:
  /// **'오늘 어땠나요?'**
  String get diary_capture_hint;

  /// 빠른 기록 입력창 안내 문구 (오늘 일기 있음)
  ///
  /// In ko, this message translates to:
  /// **'이어서 기록하기'**
  String get diary_capture_hint_continue;

  /// 빠른 기록 전송 버튼
  ///
  /// In ko, this message translates to:
  /// **'기록하기'**
  String get diary_capture_send;

  /// 빠른 기록 전송 실패 안내
  ///
  /// In ko, this message translates to:
  /// **'기록을 저장하지 못했어요'**
  String get diary_capture_failed;

  /// 빠른 기록 재시도 버튼
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get diary_capture_retry;

  /// 오늘 날짜 표기
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get diary_today;

  /// 그룹 공유 일기 뱃지
  ///
  /// In ko, this message translates to:
  /// **'공유됨'**
  String get diary_shared_badge;

  /// 그룹 공유 일기 작성자 표기
  ///
  /// In ko, this message translates to:
  /// **'{name} · 그룹에 공유됨'**
  String diary_shared_by(String name);

  /// 일기 상세 화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'일기'**
  String get diary_detail_title;

  /// 일기 수정(다듬기) 버튼/화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'다듬기'**
  String get diary_polish;

  /// 일기 신규 작성 화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'일기 쓰기'**
  String get diary_write;

  /// 일기 삭제 확인 제목
  ///
  /// In ko, this message translates to:
  /// **'일기를 삭제할까요?'**
  String get diary_delete_confirm_title;

  /// 일기 삭제 확인 본문
  ///
  /// In ko, this message translates to:
  /// **'삭제한 일기는 30일 안에 복구할 수 있습니다.'**
  String get diary_delete_confirm_message;

  /// 일기 삭제 실패
  ///
  /// In ko, this message translates to:
  /// **'삭제에 실패했습니다'**
  String get diary_delete_failed;

  /// 일기 저장 실패
  ///
  /// In ko, this message translates to:
  /// **'저장에 실패했습니다'**
  String get diary_save_failed;

  /// 일기 제목 입력 안내
  ///
  /// In ko, this message translates to:
  /// **'제목 (선택)'**
  String get diary_title_hint;

  /// 일기 본문 입력 안내
  ///
  /// In ko, this message translates to:
  /// **'오늘 하루를 정리해보세요'**
  String get diary_content_hint;

  /// 일기 날짜 변경 버튼
  ///
  /// In ko, this message translates to:
  /// **'날짜 변경'**
  String get diary_change_date;

  /// 기분 선택 라벨
  ///
  /// In ko, this message translates to:
  /// **'기분'**
  String get diary_mood;

  /// 타임라인 뷰 전환
  ///
  /// In ko, this message translates to:
  /// **'타임라인'**
  String get diary_view_timeline;

  /// 캘린더 뷰 전환
  ///
  /// In ko, this message translates to:
  /// **'캘린더'**
  String get diary_view_calendar;

  /// 연속 작성일수
  ///
  /// In ko, this message translates to:
  /// **'{count}일 연속'**
  String diary_streak_days(int count);

  /// 이번 달 작성일수
  ///
  /// In ko, this message translates to:
  /// **'이번 달 {count}일 기록'**
  String diary_this_month_count(int count);

  /// 캘린더 뷰 해당 월 빈 상태
  ///
  /// In ko, this message translates to:
  /// **'이 달에는 기록이 없어요'**
  String get diary_calendar_empty;

  /// 온보딩 - 빠른 기록 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'한 줄만 남겨보세요'**
  String get diary_onboarding_capture_title;

  /// 온보딩 - 빠른 기록 안내 설명
  ///
  /// In ko, this message translates to:
  /// **'화면을 옮기지 않아도 여기서 바로 기록됩니다. 하루에 여러 번 던져두면 그날 일기에 차곡차곡 쌓여요.'**
  String get diary_onboarding_capture_desc;

  /// 온보딩 - 카드 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'하루에 한 편으로 모여요'**
  String get diary_onboarding_card_title;

  /// 온보딩 - 카드 안내 설명
  ///
  /// In ko, this message translates to:
  /// **'던진 기록은 날짜별로 묶입니다. 카드를 눌러 그날의 일기를 열고, 천천히 다듬을 수 있어요.'**
  String get diary_onboarding_card_desc;

  /// 온보딩 - 회고 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'지난 오늘이 찾아와요'**
  String get diary_onboarding_flashback_title;

  /// 온보딩 - 회고 안내 설명
  ///
  /// In ko, this message translates to:
  /// **'한 달 전, 일 년 전 오늘의 기록이 맨 위에 떠오릅니다. 쌓일수록 반가워져요.'**
  String get diary_onboarding_flashback_desc;

  /// 월간 업로드 용량 라벨
  ///
  /// In ko, this message translates to:
  /// **'이번 달 업로드'**
  String get diary_quota_monthly;

  /// 계정 누적 용량 라벨
  ///
  /// In ko, this message translates to:
  /// **'저장 공간'**
  String get diary_quota_total;

  /// 남은 용량
  ///
  /// In ko, this message translates to:
  /// **'{size} 남음'**
  String diary_quota_remaining(String size);

  /// 월간 용량 리셋일 안내
  ///
  /// In ko, this message translates to:
  /// **'{date}에 초기화됩니다'**
  String diary_quota_resets_on(String date);

  /// 월간 용량이 회복되지 않는다는 안내
  ///
  /// In ko, this message translates to:
  /// **'사진을 지우면 저장 공간은 바로 돌아오지만, 이번 달 업로드 용량은 채워진 채로 남아요.'**
  String get diary_quota_monthly_note;

  /// 구독 업그레이드 유도 버튼
  ///
  /// In ko, this message translates to:
  /// **'용량 늘리기'**
  String get diary_quota_upgrade;

  /// 월간 용량 소진 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'이번 달 무료 용량을 모두 사용했어요'**
  String get diary_quota_exceeded_title;

  /// 누적 용량 부족 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'저장 공간이 부족해요'**
  String get diary_quota_total_exceeded_title;

  /// 용량 초과 시 대안 안내
  ///
  /// In ko, this message translates to:
  /// **'다음 달에 초기화되거나, 저장 공간을 정리하면 계속 올릴 수 있어요.'**
  String get diary_quota_exceeded_options;

  /// 파일 1개 최대 크기 초과
  ///
  /// In ko, this message translates to:
  /// **'파일이 너무 커요'**
  String get diary_file_too_large;

  /// 파일 크기 초과 시 압축 유도
  ///
  /// In ko, this message translates to:
  /// **'압축해서 올리면 용량을 크게 줄일 수 있어요.'**
  String get diary_file_too_large_hint;

  /// 영상 불가 등급 안내
  ///
  /// In ko, this message translates to:
  /// **'영상 첨부는 상위 요금제에서 이용할 수 있어요'**
  String get diary_video_not_allowed;

  /// 사진 첨부 버튼
  ///
  /// In ko, this message translates to:
  /// **'사진 추가'**
  String get diary_add_photo;

  /// 업로드 시트 제목
  ///
  /// In ko, this message translates to:
  /// **'{count}장 추가'**
  String diary_upload_sheet_title(int count);

  /// 압축 업로드 선택지
  ///
  /// In ko, this message translates to:
  /// **'압축해서 올리기'**
  String get diary_upload_compressed;

  /// 원본 업로드 선택지
  ///
  /// In ko, this message translates to:
  /// **'원본 그대로 올리기'**
  String get diary_upload_original;

  /// 압축 절약량 표시
  ///
  /// In ko, this message translates to:
  /// **'{before} → {after} ({percent}% 절약)'**
  String diary_upload_saved(String before, String after, int percent);

  /// 업로드 시작 버튼
  ///
  /// In ko, this message translates to:
  /// **'올리기'**
  String get diary_upload_start;

  /// 업로드 실패
  ///
  /// In ko, this message translates to:
  /// **'올리지 못했어요'**
  String get diary_upload_failed;

  /// 업로드 재시도
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get diary_upload_retry;

  /// 미디어 삭제 확인 제목
  ///
  /// In ko, this message translates to:
  /// **'이 사진을 삭제할까요?'**
  String get diary_media_delete_confirm;

  /// 미디어 영구 삭제 경고
  ///
  /// In ko, this message translates to:
  /// **'사진과 영상은 즉시 삭제되며 복구할 수 없습니다.'**
  String get diary_media_delete_permanent;

  /// 저장공간 관리 화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'저장 공간 관리'**
  String get diary_storage_manage;

  /// 큰 파일 목록 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'용량이 큰 항목'**
  String get diary_storage_large_files;

  /// 원본 업로드 필터
  ///
  /// In ko, this message translates to:
  /// **'원본으로 올린 것만'**
  String get diary_storage_only_original;

  /// 저장공간 관리 빈 상태
  ///
  /// In ko, this message translates to:
  /// **'정리할 항목이 없어요'**
  String get diary_storage_empty;

  /// 원본 업로드 뱃지
  ///
  /// In ko, this message translates to:
  /// **'원본'**
  String get diary_media_original_badge;

  /// 사진 그리드 뷰 전환
  ///
  /// In ko, this message translates to:
  /// **'사진'**
  String get diary_view_photos;

  /// 사진 그리드 빈 상태
  ///
  /// In ko, this message translates to:
  /// **'아직 사진이 없어요'**
  String get diary_photos_empty;

  /// 사진 선택 - 갤러리
  ///
  /// In ko, this message translates to:
  /// **'갤러리에서 고르기'**
  String get diary_pick_gallery;

  /// 사진 선택 - 카메라
  ///
  /// In ko, this message translates to:
  /// **'사진 찍기'**
  String get diary_pick_camera;

  /// 등급별 첨부 용량 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'다이어리 첨부 용량'**
  String get subscription_quota_section_title;

  /// 월간 제공 용량
  ///
  /// In ko, this message translates to:
  /// **'매월 {size} 제공'**
  String subscription_quota_monthly(String size);

  /// 계정 누적 저장 공간
  ///
  /// In ko, this message translates to:
  /// **'저장 공간 {size}'**
  String subscription_quota_total(String size);

  /// 파일 1개 최대 크기
  ///
  /// In ko, this message translates to:
  /// **'파일 1개 최대 {size}'**
  String subscription_quota_per_file(String size);

  /// 영상 불가 등급
  ///
  /// In ko, this message translates to:
  /// **'사진 첨부'**
  String get subscription_quota_video_none;

  /// 영상 가능(길이 제한 없음)
  ///
  /// In ko, this message translates to:
  /// **'영상 첨부'**
  String get subscription_quota_video_supported;

  /// 영상 최대 길이(분)
  ///
  /// In ko, this message translates to:
  /// **'영상 최대 {minutes}분'**
  String subscription_quota_video_minutes(int minutes);

  /// 촬영일이 오늘과 다를 때 묻는 문구
  ///
  /// In ko, this message translates to:
  /// **'이 사진은 {date}에 찍었어요. 어느 날 일기에 넣을까요?'**
  String diary_exif_date_question(String date);

  /// 촬영일 일기에 넣기
  ///
  /// In ko, this message translates to:
  /// **'{date} 일기에 넣기'**
  String diary_exif_use_captured(String date);

  /// 오늘 일기에 넣기
  ///
  /// In ko, this message translates to:
  /// **'오늘 일기에 넣기'**
  String get diary_exif_use_today;

  /// n개월 전 오늘 (회고 라벨)
  ///
  /// In ko, this message translates to:
  /// **'{count, plural, other{{count}개월 전 오늘}}'**
  String diary_flashback_months(int count);

  /// n년 전 오늘 (회고 라벨)
  ///
  /// In ko, this message translates to:
  /// **'{count, plural, other{{count}년 전 오늘}}'**
  String diary_flashback_years(int count);

  /// 서버가 받지 않는 형식 (400)
  ///
  /// In ko, this message translates to:
  /// **'지원하지 않는 형식이에요'**
  String get diary_unsupported_format;

  /// 영상 길이 초과 (400)
  ///
  /// In ko, this message translates to:
  /// **'영상은 최대 {seconds}초까지 올릴 수 있어요'**
  String diary_video_too_long(int seconds);

  /// 형식을 바꾸지 못해 제외한 파일 안내
  ///
  /// In ko, this message translates to:
  /// **'{count, plural, =1{{fileName}은 지원하지 않는 형식이라 빼두었어요} other{{fileName} 외 {count}개는 지원하지 않는 형식이라 빼두었어요}}'**
  String diary_media_skipped(int count, String fileName);

  /// 다이어리 검색 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'제목, 내용으로 검색'**
  String get diary_search_hint;

  /// 검색·필터 결과 없음
  ///
  /// In ko, this message translates to:
  /// **'조건에 맞는 일기가 없어요'**
  String get diary_search_empty;

  /// 웹에서 구독 관리 불가 안내
  ///
  /// In ko, this message translates to:
  /// **'구독 관리와 결제는 모바일 앱에서 할 수 있어요'**
  String get subscription_manage_on_device;

  /// 홈 위젯 설정 - 가족 루틴 보드 위젯 라벨
  ///
  /// In ko, this message translates to:
  /// **'가족 루틴 보드'**
  String get widgetSettings_routineFamily;

  /// 내 루틴 위젯 - 오늘 뷰 라벨
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get routineWidget_tabToday;

  /// 내 루틴 위젯 - 이번 주 뷰 라벨
  ///
  /// In ko, this message translates to:
  /// **'이번 주'**
  String get routineWidget_tabWeekly;

  /// 내 루틴 위젯 - 뷰 전환 버튼 툴팁
  ///
  /// In ko, this message translates to:
  /// **'보기 전환'**
  String get routineWidget_viewToggleTooltip;

  /// 내 루틴 위젯 - 오늘 일일 목표를 모두 채웠을 때
  ///
  /// In ko, this message translates to:
  /// **'오늘 목표 달성 🎉'**
  String get routineWidget_allDone;

  /// 내 루틴 위젯 - 오늘 수행 대상 습관이 없을 때
  ///
  /// In ko, this message translates to:
  /// **'오늘 대상 습관이 없어요'**
  String get routineWidget_noTargetToday;

  /// 내 루틴 위젯 - 표시 개수 초과분
  ///
  /// In ko, this message translates to:
  /// **'외 {count}개'**
  String routineWidget_moreCount(int count);

  /// 내 루틴 위젯 - 스트릭 끊김 경고
  ///
  /// In ko, this message translates to:
  /// **'{days}일 연속이 오늘 끊겨요'**
  String routineWidget_streakAtRisk(int days);

  /// 내 루틴 위젯 - 주간 달성률
  ///
  /// In ko, this message translates to:
  /// **'달성률 {rate}%'**
  String routineWidget_achievementRate(int rate);

  /// 내 루틴 위젯 - 주간 일일 목표 달성 일수
  ///
  /// In ko, this message translates to:
  /// **'목표 달성 {achieved}/{total}일'**
  String routineWidget_goalDays(int achieved, int total);

  /// 내 루틴 위젯 - 다음 배지까지 남은 일수
  ///
  /// In ko, this message translates to:
  /// **'{title}까지 {days}일'**
  String routineWidget_nextBadge(String title, int days);

  /// 내 루틴 위젯 - 다음 배지까지 남은 주 수 (퍼펙트위크 기준 배지)
  ///
  /// In ko, this message translates to:
  /// **'{title}까지 {weeks}주'**
  String routineWidget_nextBadgeWeeks(String title, int weeks);

  /// 가족 루틴 보드 위젯 - 다른 그룹 챌린지일 때 그룹명 접두
  ///
  /// In ko, this message translates to:
  /// **'{group} · {title}'**
  String routineWidget_challengeGroup(String group, String title);

  /// 가족 루틴 보드 위젯 - 그룹 선택 툴팁
  ///
  /// In ko, this message translates to:
  /// **'그룹 선택'**
  String get routineWidget_groupTooltip;

  /// 가족 루틴 보드 위젯 - 참여 그룹 없음
  ///
  /// In ko, this message translates to:
  /// **'참여 중인 그룹이 없어요'**
  String get routineWidget_familyNoGroup;

  /// 가족 루틴 보드 위젯 - 공유 루틴 없음
  ///
  /// In ko, this message translates to:
  /// **'공유된 루틴이 없어요'**
  String get routineWidget_familyEmpty;

  /// 가족 루틴 보드 위젯 - 공유 유도 CTA
  ///
  /// In ko, this message translates to:
  /// **'가족에게 공유하기'**
  String get routineWidget_familyShareCta;

  /// 가족 루틴 보드 위젯 - 오늘 기준 내 순위
  ///
  /// In ko, this message translates to:
  /// **'오늘 {rank}위'**
  String routineWidget_familyRank(int rank);

  /// 가족 루틴 보드 위젯 - 챌린지 남은 일수
  ///
  /// In ko, this message translates to:
  /// **'D-{days}'**
  String routineWidget_challengeDday(int days);

  /// 가족 루틴 보드 위젯 - 챌린지 오늘 마감
  ///
  /// In ko, this message translates to:
  /// **'오늘 마감'**
  String get routineWidget_challengeLastDay;

  /// 가족 루틴 보드 위젯 - 내 챌린지 진행률
  ///
  /// In ko, this message translates to:
  /// **'내 진행 {checked}/{target}'**
  String routineWidget_myChallengeProgress(int checked, int target);

  /// 인사말 설정 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'대시보드 인사말'**
  String get greeting_settingsTitle;

  /// 설정 목록의 인사말 항목 설명
  ///
  /// In ko, this message translates to:
  /// **'오늘의 한마디를 직접 골라요'**
  String get greeting_settingsSubtitle;

  /// 인사말 설정 안내문
  ///
  /// In ko, this message translates to:
  /// **'기본 문구와 내가 등록한 문구 중에서 하루에 하나씩 표시돼요. 대시보드를 당겨서 새로고침하면 다음 문구로 넘어갑니다.'**
  String get greeting_guide;

  /// 내 인사말 사용 스위치
  ///
  /// In ko, this message translates to:
  /// **'나만의 인사말 사용'**
  String get greeting_useCustom;

  /// 내 인사말 사용 스위치 설명
  ///
  /// In ko, this message translates to:
  /// **'끄면 시간대별 인사말이 표시돼요'**
  String get greeting_useCustomDesc;

  /// 오늘 표시될 문구 미리보기 제목
  ///
  /// In ko, this message translates to:
  /// **'오늘의 미리보기'**
  String get greeting_previewTitle;

  /// 문구 후보가 없을 때 미리보기 안내
  ///
  /// In ko, this message translates to:
  /// **'표시할 문구가 없어 시간대 인사말이 표시돼요'**
  String get greeting_previewEmpty;

  /// 기본 제공 문구 팩 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'기본 문구'**
  String get greeting_presetSection;

  /// 사용자 등록 문구 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'내 문구'**
  String get greeting_customSection;

  /// 등록한 문구 개수 표시
  ///
  /// In ko, this message translates to:
  /// **'{count}/{max}'**
  String greeting_customCount(int count, int max);

  /// 명언 팩 이름
  ///
  /// In ko, this message translates to:
  /// **'명언과 속담'**
  String get greeting_packQuote;

  /// 응원 팩 이름
  ///
  /// In ko, this message translates to:
  /// **'응원 한마디'**
  String get greeting_packCheer;

  /// 팩에 포함된 문구 개수
  ///
  /// In ko, this message translates to:
  /// **'문구 {count}개'**
  String greeting_packMessageCount(int count);

  /// 문구 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'문구 추가'**
  String get greeting_addMessage;

  /// 문구 수정 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'문구 수정'**
  String get greeting_editMessage;

  /// 문구 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'대시보드에 표시할 문구를 입력하세요'**
  String get greeting_messageHint;

  /// 내 문구 빈 상태
  ///
  /// In ko, this message translates to:
  /// **'등록한 문구가 없어요'**
  String get greeting_emptyMessages;

  /// 내 문구 빈 상태 설명
  ///
  /// In ko, this message translates to:
  /// **'자주 보고 싶은 문구를 추가해보세요'**
  String get greeting_emptyMessagesDesc;

  /// 문구 삭제 확인
  ///
  /// In ko, this message translates to:
  /// **'이 문구를 삭제할까요?'**
  String get greeting_deleteConfirm;

  /// 문구 개수 초과 안내
  ///
  /// In ko, this message translates to:
  /// **'문구는 최대 {max}개까지 등록할 수 있어요'**
  String greeting_maxReached(int max);

  /// 중복 문구 안내
  ///
  /// In ko, this message translates to:
  /// **'이미 등록된 문구예요'**
  String get greeting_duplicated;

  /// 대시보드 인사말 라벨
  ///
  /// In ko, this message translates to:
  /// **'오늘의 한마디'**
  String get greeting_todayLabel;

  /// 영아 팩 이름
  ///
  /// In ko, this message translates to:
  /// **'아기 (0~12개월)'**
  String get greeting_packInfant;

  /// 걸음마기 팩 이름
  ///
  /// In ko, this message translates to:
  /// **'걸음마 (1~3세)'**
  String get greeting_packToddler;

  /// 유아 팩 이름
  ///
  /// In ko, this message translates to:
  /// **'유아 (3~5세)'**
  String get greeting_packPreschool;

  /// 초등 팩 이름
  ///
  /// In ko, this message translates to:
  /// **'초등 (6~12세)'**
  String get greeting_packSchool;

  /// 청소년 팩 이름
  ///
  /// In ko, this message translates to:
  /// **'청소년 (13세~)'**
  String get greeting_packTeen;

  /// 연령 공통 육아 원칙 팩 이름
  ///
  /// In ko, this message translates to:
  /// **'부모 마음 (모든 연령)'**
  String get greeting_packParenting;

  /// 기본 문구 출처 안내
  ///
  /// In ko, this message translates to:
  /// **'기본 문구는 CDC, 미국소아과학회(AAP), 미국 농무부(USDA), 미국세정협회(ACI), 환경보호청(EPA), 아동권리보장원의 공개 가이드를 참고해 한 줄로 정리한 것입니다'**
  String get greeting_presetSourceNote;

  /// 인사말 팩 묶음 - 나이대별 육아
  ///
  /// In ko, this message translates to:
  /// **'아이 나이대별'**
  String get greeting_groupChild;

  /// 인사말 팩 묶음 - 부모 마음/명언/응원
  ///
  /// In ko, this message translates to:
  /// **'마음 챙기기'**
  String get greeting_groupMind;

  /// 인사말 팩 묶음 - 집안일
  ///
  /// In ko, this message translates to:
  /// **'집안일'**
  String get greeting_groupChore;

  /// 인사말 팩 묶음 - 영어 회화
  ///
  /// In ko, this message translates to:
  /// **'영어 한 문장'**
  String get greeting_groupEnglish;

  /// 집안일 팩 - 주방
  ///
  /// In ko, this message translates to:
  /// **'주방과 식품'**
  String get greeting_packChoreKitchen;

  /// 집안일 팩 - 세탁
  ///
  /// In ko, this message translates to:
  /// **'세탁과 옷'**
  String get greeting_packChoreLaundry;

  /// 집안일 팩 - 청소
  ///
  /// In ko, this message translates to:
  /// **'청소와 곰팡이'**
  String get greeting_packChoreCleaning;

  /// 영어 팩 - 생활 회화
  ///
  /// In ko, this message translates to:
  /// **'생활 회화'**
  String get greeting_packEnglishDaily;

  /// 영어 팩 - 여행
  ///
  /// In ko, this message translates to:
  /// **'여행과 외식'**
  String get greeting_packEnglishTravel;

  /// 영어 팩 - 직장
  ///
  /// In ko, this message translates to:
  /// **'직장과 이메일'**
  String get greeting_packEnglishWork;

  /// 등급별 한도표 섹션 제목 (첨부 용량 + 그룹 수)
  ///
  /// In ko, this message translates to:
  /// **'등급별 한도'**
  String get subscription_limits_section_title;

  /// 등급별 그룹 수 한도
  ///
  /// In ko, this message translates to:
  /// **'그룹 {count}개'**
  String subscription_quota_groups(int count);

  /// 그룹 생성 402 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'그룹을 더 만들 수 없어요'**
  String get groupQuota_createTitle;

  /// 그룹 가입 402 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'그룹에 더 참여할 수 없어요'**
  String get groupQuota_joinTitle;

  /// 가입요청 승인 402 안내 제목 (한도를 넘긴 쪽은 승인자가 아니라 신청자)
  ///
  /// In ko, this message translates to:
  /// **'신청자의 그룹 한도가 찼어요'**
  String get groupQuota_applicantTitle;

  /// 그룹 한도 안내 본문 (서버가 내려준 groupQuota 기준)
  ///
  /// In ko, this message translates to:
  /// **'{tier} 요금제는 그룹 {limit}개까지 참여할 수 있어요. 지금 {used}개에 속해 있어요.'**
  String groupQuota_body(String tier, int limit, int used);

  /// 그룹 한도 안내 본문 (서버가 한도를 안 내려준 경우)
  ///
  /// In ko, this message translates to:
  /// **'현재 요금제의 그룹 개수 한도를 모두 사용했어요.'**
  String get groupQuota_bodyUnknown;

  /// 가입요청 승인 402 안내 본문
  ///
  /// In ko, this message translates to:
  /// **'신청한 분이 요금제의 그룹 개수 한도를 모두 사용했어요. 신청자가 요금제를 올리거나 다른 그룹에서 나온 뒤 다시 승인해 주세요.'**
  String get groupQuota_applicantBody;

  /// 최상위 요금제라 업그레이드 제안이 불가능할 때의 대안 안내
  ///
  /// In ko, this message translates to:
  /// **'다른 그룹에서 나오면 자리가 생겨요.'**
  String get groupQuota_leaveHint;

  /// 그룹 한도 안내에서 구독 화면으로 가는 버튼
  ///
  /// In ko, this message translates to:
  /// **'요금제 보기'**
  String get groupQuota_upgrade;
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
