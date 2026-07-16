// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Family Planner';

  @override
  String get appDescription => '家族と一緒に日常を管理するプランナー';

  @override
  String get common_ok => 'OK';

  @override
  String get common_cancel => 'キャンセル';

  @override
  String get common_confirm => '確認';

  @override
  String get common_save => '保存';

  @override
  String get common_delete => '削除';

  @override
  String get common_edit => '編集';

  @override
  String get common_add => '追加';

  @override
  String get common_create => '作成';

  @override
  String get common_search => '検索';

  @override
  String get common_loading => '読み込み中...';

  @override
  String get common_optional => '任意';

  @override
  String get common_error => 'エラー';

  @override
  String get common_retry => '再試行';

  @override
  String get common_close => '閉じる';

  @override
  String get common_done => '完了';

  @override
  String get common_undo => '元に戻す';

  @override
  String get common_add_to_list => 'リストに追加';

  @override
  String get common_view_all => 'すべて見る';

  @override
  String get memo_filter_personal_only => '個人メモのみ';

  @override
  String get common_all_groups => 'すべてのグループ';

  @override
  String get schedule_filter_group_schedule => 'グループ予定';

  @override
  String common_date_format(int month, int day) {
    return '$month月$day日';
  }

  @override
  String get cart_unsaved_changes => '未保存の変更があります';

  @override
  String get common_next => '次へ';

  @override
  String get common_back => '戻る';

  @override
  String get common_previous => '前へ';

  @override
  String get common_all => 'すべて';

  @override
  String get common_apply => '適用';

  @override
  String get auth_login => 'ログイン';

  @override
  String get auth_signup => '新規登録';

  @override
  String get auth_logout => 'ログアウト';

  @override
  String get auth_email => 'メール';

  @override
  String get auth_password => 'パスワード';

  @override
  String get auth_passwordConfirm => 'パスワード確認';

  @override
  String get auth_name => '名前';

  @override
  String get auth_forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get auth_noAccount => 'アカウントをお持ちでないですか？';

  @override
  String get auth_haveAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get auth_continueWithGoogle => 'Googleで続ける';

  @override
  String get auth_continueWithKakao => 'Kakaoで続ける';

  @override
  String get auth_continueWithApple => 'Appleで続ける';

  @override
  String get auth_or => 'または';

  @override
  String get auth_testAccountLoginOwner => 'テストアカウントでログイン（グループオーナー）';

  @override
  String get auth_testAccountLoginMember => 'テストアカウントでログイン（グループメンバー）';

  @override
  String get auth_emailHint => 'メールアドレスを入力してください';

  @override
  String get auth_passwordHint => 'パスワードを入力してください';

  @override
  String get auth_nameHint => '名前を入力してください';

  @override
  String get auth_emailError => '有効なメールアドレスではありません';

  @override
  String get auth_passwordError => 'パスワードは6文字以上である必要があります';

  @override
  String get auth_passwordMismatch => 'パスワードが一致しません';

  @override
  String get auth_nameError => '名前を入力してください';

  @override
  String get auth_loginSuccess => 'ログイン成功';

  @override
  String get auth_loginFailed => 'ログイン失敗';

  @override
  String get auth_loginFailedInvalidCredentials => 'メールアドレスまたはパスワードが正しくありません';

  @override
  String get auth_googleLoginFailed => 'Googleログイン失敗';

  @override
  String get auth_kakaoLoginFailed => 'Kakaoログイン失敗';

  @override
  String get auth_appleLoginFailed => 'Appleログイン失敗';

  @override
  String get auth_signupSuccess => '登録成功';

  @override
  String get auth_signupFailed => '登録失敗';

  @override
  String get auth_logoutSuccess => 'ログアウトしました';

  @override
  String get auth_emailVerification => 'メール認証';

  @override
  String get auth_emailVerificationMessage => '登録されたメールアドレスに認証コードが送信されました。';

  @override
  String get auth_verificationCode => '認証コード';

  @override
  String get auth_verificationCodeHint => '認証コードを入力してください';

  @override
  String get auth_resendCode => '認証コードを再送信';

  @override
  String get auth_verify => '認証する';

  @override
  String get auth_resetPassword => 'パスワードリセット';

  @override
  String get auth_resetPasswordMessage =>
      '登録されたメールアドレスを入力してください。\n認証コードを送信します。';

  @override
  String get auth_newPassword => '新しいパスワード';

  @override
  String get auth_sendCode => '認証コードを取得';

  @override
  String get auth_resetPasswordSuccess => 'パスワードがリセットされました。ログインしてください。';

  @override
  String get auth_signupEmailVerificationMessage => '登録が完了しました。メールを確認してください。';

  @override
  String get auth_signupNameLabel => '名前';

  @override
  String get auth_signupNameMinLengthError => '名前は2文字以上である必要があります';

  @override
  String get auth_signupPasswordHelperText => '最低8文字以上';

  @override
  String get auth_signupConfirmPasswordLabel => 'パスワード確認';

  @override
  String get auth_signupConfirmPasswordError => 'パスワードをもう一度入力してください';

  @override
  String get auth_signupButton => '登録';

  @override
  String get auth_forgotPasswordTitle => 'パスワードを忘れた';

  @override
  String get auth_setPasswordTitle => 'パスワード設定';

  @override
  String get auth_forgotPasswordGuide => '登録されたメールアドレスを入力してください。\n認証コードを送信します。';

  @override
  String get auth_forgotPasswordGuideWithCode =>
      'メールで送信された認証コードを入力し、\n新しいパスワードを設定してください。';

  @override
  String get auth_setPasswordGuide =>
      'アカウントのセキュリティのためにパスワードを設定してください。\n登録されたメールアドレスを入力すると\n認証コードを送信します。';

  @override
  String get auth_setPasswordGuideWithCode =>
      'メールで送信された認証コードを入力し、\nパスワードを設定してください。';

  @override
  String get auth_verificationCodeLabel => '認証コード（6桁）';

  @override
  String get auth_verificationCodeError => '認証コードを入力してください';

  @override
  String get auth_verificationCodeLengthError => '認証コードは6桁です';

  @override
  String get auth_codeSentMessage => '認証コードがメールで送信されました';

  @override
  String get auth_codeSentError => '認証コード送信失敗';

  @override
  String get auth_passwordResetButton => 'パスワードリセット';

  @override
  String get auth_passwordSetButton => 'パスワード設定完了';

  @override
  String get auth_resendCodeButton => '認証コードを再送信';

  @override
  String get auth_passwordSetSuccess => 'パスワードが設定されました。ログインできます。';

  @override
  String get auth_passwordResetError => 'パスワードリセット失敗';

  @override
  String get auth_rememberPassword => 'パスワードを思い出しましたか？';

  @override
  String get nav_home => 'ホーム';

  @override
  String get nav_assets => '資産';

  @override
  String get nav_calendar => '予定';

  @override
  String get nav_todo => 'タスク';

  @override
  String get nav_more => 'その他';

  @override
  String get nav_household => '家計管理';

  @override
  String get nav_childPoints => '育児ポイント';

  @override
  String get nav_memo => 'メモ';

  @override
  String get nav_miniGames => 'ミニゲーム';

  @override
  String get nav_investmentIndicators => '投資指標';

  @override
  String get nav_savings => 'グループ貯金箱';

  @override
  String get nav_votes => '投票';

  @override
  String get more_coach_groupDesc => '家族、恋人、友達などのグループを作り、\n招待コードでメンバーを招待しましょう。';

  @override
  String get more_coach_settingsDesc =>
      'テーマ、言語、通知、ボトムタブ構成など\nアプリをお好みにカスタマイズしましょう。';

  @override
  String get home_greeting_morning => 'おはようございます！';

  @override
  String get home_greeting_afternoon => 'こんにちは！';

  @override
  String get home_greeting_evening => 'こんばんは！';

  @override
  String get home_greeting_night => '遅い時間ですね！';

  @override
  String get home_todaySchedule => '今日の予定';

  @override
  String get home_noSchedule => '予定がありません';

  @override
  String get home_investmentSummary => '投資指標サマリー';

  @override
  String get home_todoSummary => 'タスクサマリー';

  @override
  String get home_assetSummary => '資産サマリー';

  @override
  String get settings_title => '設定';

  @override
  String get settings_theme => 'テーマ設定';

  @override
  String get settings_language => '言語設定';

  @override
  String get settings_homeWidgets => 'ホームウィジェット設定';

  @override
  String get settings_profile => 'プロフィール設定';

  @override
  String get settings_family => '家族管理';

  @override
  String get settings_notifications => '通知設定';

  @override
  String get settings_about => 'アプリ情報';

  @override
  String get settings_bottomNavigation => '下部ナビゲーション';

  @override
  String get bottomNav_title => '下部ナビゲーション設定';

  @override
  String get bottomNav_reset => 'デフォルトに戻す';

  @override
  String get bottomNav_resetConfirmTitle => 'リセット確認';

  @override
  String get bottomNav_resetConfirmMessage => '下部ナビゲーション設定をデフォルトにリセットしますか？';

  @override
  String get bottomNav_resetSuccess => 'デフォルト設定にリセットされました';

  @override
  String get bottomNav_guideMessage =>
      'ホームとその他は固定されています。\n中央の3つのスロットをタップしてメニューを選択してください。';

  @override
  String get bottomNav_preview => '下部ナビゲーションプレビュー';

  @override
  String get bottomNav_howToUse => '使い方';

  @override
  String get bottomNav_instructions =>
      '• スロット2、3、4をタップして希望のメニューに変更してください。\n• スロット1（ホーム）とスロット5（その他）は固定です。\n• 下部ナビゲーションにないメニューは「その他」タブに表示されます。';

  @override
  String get bottomNav_availableMenus => '利用可能なメニュー';

  @override
  String get bottomNav_slot => 'スロット';

  @override
  String get bottomNav_unused => '未使用';

  @override
  String bottomNav_selectMenuTitle(Object slot) {
    return 'スロット $slot メニュー選択';
  }

  @override
  String get bottomNav_usedInOtherSlot => '他のスロットで使用中（選択すると交換されます）';

  @override
  String get widgetSettings_saveSuccess => '設定が保存されました';

  @override
  String get widgetSettings_guide => 'ホーム画面に表示するウィジェットを選択し、順序を変更してください';

  @override
  String get widgetSettings_widgetOrder => 'ウィジェットの順序';

  @override
  String get widgetSettings_dragToReorder => 'ウィジェットを長押ししてドラッグし、順序を変更できます';

  @override
  String get widgetSettings_restoreDefaults => 'デフォルト設定に戻す';

  @override
  String get widgetSettings_todayScheduleDesc => '当日の予定を表示します';

  @override
  String get widgetSettings_investmentSummaryDesc => 'コスピ、ナスダック、為替レート情報を表示します';

  @override
  String get widgetSettings_todoSummaryDesc => '進行中のタスクを表示します';

  @override
  String get widgetSettings_assetSummaryDesc => '総資産と収益率を表示します';

  @override
  String get widgetSettings_memoSummary => 'メモ概要';

  @override
  String get widgetSettings_memoSummaryDesc => '最近作成したメモを表示します';

  @override
  String get widgetSettings_householdSummary => '家計状況';

  @override
  String get widgetSettings_householdSummaryDesc => '今月の支出サマリーと予算達成率';

  @override
  String get widgetSettings_childcareSummary => '育児ポイント';

  @override
  String get widgetSettings_childcareSummaryDesc => 'お子様ごとのポイント残高状況';

  @override
  String get widgetSettings_savingsSummary => '貯金箱';

  @override
  String get widgetSettings_savingsSummaryDesc => 'グループ別の積立目標と達成状況';

  @override
  String get widgetSettings_fridgeSummary => '賞味期限間近';

  @override
  String get widgetSettings_fridgeSummaryDesc => '冷蔵庫の賞味期限が近い食品リスト';

  @override
  String get widgetSettings_viewToday => '今日';

  @override
  String get widgetSettings_viewWeek => '今週';

  @override
  String get widgetSettings_viewMonth => '今月';

  @override
  String get widgetSettings_viewBudget => '予算全体を見る';

  @override
  String get widgetSettings_viewCategory => 'カテゴリ別';

  @override
  String get widgetSettings_savingsEmpty => '登録された貯金箱がありません';

  @override
  String get widgetSettings_fridgeExpiryEmpty => '賞味期限間近の食品はありません';

  @override
  String get widgetSettings_scheduleWeek => '今週の予定';

  @override
  String get widgetSettings_scheduleMonth => '今月の予定';

  @override
  String get widgetSettings_scheduleEmptyToday => '今日の予定はありません';

  @override
  String get widgetSettings_scheduleEmptyWeek => '今週の予定はありません';

  @override
  String get widgetSettings_scheduleEmptyMonth => '今月の予定はありません';

  @override
  String get widgetSettings_weather => '天気';

  @override
  String get widgetSettings_weatherDesc => '現在地の天気情報を表示します';

  @override
  String get themeSettings_title => 'テーマ設定';

  @override
  String get themeSettings_selectTheme => 'テーマ選択';

  @override
  String get themeSettings_description =>
      'アプリの明るさテーマを選択してください。システム設定に従うか、手動で選択できます。';

  @override
  String get themeSettings_lightMode => 'ライトモード';

  @override
  String get themeSettings_lightModeDesc => '明るいテーマを使用します';

  @override
  String get themeSettings_darkMode => 'ダークモード';

  @override
  String get themeSettings_darkModeDesc => '暗いテーマを使用します';

  @override
  String get themeSettings_systemMode => 'システム設定';

  @override
  String get themeSettings_systemModeDesc => 'デバイスのシステム設定に従います';

  @override
  String get themeSettings_colorTitle => 'カラーテーマ';

  @override
  String get themeSettings_brightnessTitle => '明るさモード';

  @override
  String get themeSettings_currentThemePreview => '現在のテーマプレビュー';

  @override
  String get themeSettings_currentTheme => '現在のテーマ';

  @override
  String get profile_title => 'プロフィール設定';

  @override
  String get profile_save => '保存';

  @override
  String get profile_name => '名前';

  @override
  String get profile_nameRequired => '名前を入力してください';

  @override
  String get profile_phoneNumber => '電話番号（任意）';

  @override
  String get profile_phoneNumberHint => '例: 010-1234-5678';

  @override
  String get profile_uploadSuccess => 'プロフィール写真がアップロードされました';

  @override
  String get profile_uploadFailed => 'プロフィール写真のアップロードに失敗しました';

  @override
  String get profile_changePassword => 'パスワード変更';

  @override
  String get profile_currentPassword => '現在のパスワード';

  @override
  String get profile_currentPasswordRequired => '現在のパスワードを入力してください';

  @override
  String get profile_newPassword => '新しいパスワード';

  @override
  String get profile_newPasswordRequired => '新しいパスワードを入力してください';

  @override
  String get profile_newPasswordMinLength => 'パスワードは6文字以上である必要があります';

  @override
  String get profile_confirmNewPassword => '新しいパスワード確認';

  @override
  String get profile_confirmNewPasswordRequired => '新しいパスワード確認を入力してください';

  @override
  String get profile_passwordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get profile_updateSuccess => 'プロフィールが更新されました';

  @override
  String get profile_updateFailed => 'プロフィール更新失敗';

  @override
  String get theme_light => 'ライトモード';

  @override
  String get theme_dark => 'ダークモード';

  @override
  String get theme_system => 'システム設定';

  @override
  String get language_korean => '한국어';

  @override
  String get language_english => 'English';

  @override
  String get language_japanese => '日本語';

  @override
  String get language_chinese => '中国語';

  @override
  String get language_selectDescription => 'アプリで使用する言語を選択してください';

  @override
  String get language_useSystemLanguage => 'システム言語を使用';

  @override
  String get language_useSystemLanguageDescription => 'デバイスの言語設定に従います';

  @override
  String get widgetSettings_title => 'ホームウィジェット設定';

  @override
  String get widgetSettings_description => 'ホーム画面に表示するウィジェットを選択してください';

  @override
  String get widgetSettings_todaySchedule => '今日の予定';

  @override
  String get widgetSettings_investmentSummary => '投資指標サマリー';

  @override
  String get widgetSettings_todoSummary => 'タスクサマリー';

  @override
  String get widgetSettings_assetSummary => '資産サマリー';

  @override
  String get settings_screenSettings => '画面設定';

  @override
  String get settings_bottomNavigationTitle => '下部ナビゲーション設定';

  @override
  String get settings_bottomNavigationSubtitle => '下部メニューの順序と表示/非表示を設定します';

  @override
  String get settings_homeWidgetsTitle => 'ホームウィジェット設定';

  @override
  String get settings_homeWidgetsSubtitle => 'ホーム画面に表示するウィジェットを選択します';

  @override
  String get settings_themeTitle => 'テーマ設定';

  @override
  String get settings_themeSubtitle => 'ライト/ダークモードを変更します';

  @override
  String get settings_languageTitle => '言語設定';

  @override
  String get settings_languageSubtitle => 'アプリで使用する言語を変更します';

  @override
  String get settings_userSettings => 'ユーザー設定';

  @override
  String get settings_profileTitle => 'プロフィール設定';

  @override
  String get settings_profileSubtitle => 'プロフィール情報を編集します';

  @override
  String get settings_groupManagementTitle => 'グループ管理';

  @override
  String get settings_groupManagementSubtitle => 'グループとメンバーを管理します';

  @override
  String get settings_notificationSettings => '通知設定';

  @override
  String get settings_notificationTitle => '通知設定';

  @override
  String get settings_notificationSubtitle => '通知受信設定を変更します';

  @override
  String get settings_information => '情報';

  @override
  String get settings_appInfoTitle => 'アプリ情報';

  @override
  String get settings_appInfoSubtitle => 'バージョン情報';

  @override
  String get settings_appDescription => '家族と一緒に日常を管理するプランナー';

  @override
  String get settings_termsOfServiceTitle => '利用規約';

  @override
  String get settings_termsOfServiceSubtitle => '利用規約を確認する';

  @override
  String get settings_privacyPolicyTitle => 'プライバシーポリシー';

  @override
  String get settings_privacyPolicySubtitle => 'プライバシーポリシーを確認する';

  @override
  String get settings_helpTitle => 'ヘルプ';

  @override
  String get settings_helpSubtitle => '使い方を確認します';

  @override
  String get settings_user => 'ユーザー';

  @override
  String get settings_logout => 'ログアウト';

  @override
  String get settings_logoutConfirmTitle => 'ログアウト';

  @override
  String get settings_logoutConfirmMessage => 'ログアウトしますか？';

  @override
  String get settings_passwordSetupRequired => 'パスワード設定が必要です';

  @override
  String get settings_passwordSetupMessage1 =>
      'ソーシャルログインのみで登録されたため、パスワードが設定されていません。';

  @override
  String get settings_passwordSetupMessage2 =>
      'プロフィールを編集したり、アカウントのセキュリティを強化するには、パスワードの設定を推奨します。';

  @override
  String get settings_passwordSetupMessage3 => 'パスワード設定画面に移動しますか？';

  @override
  String get settings_passwordSetupLater => '後で';

  @override
  String get settings_passwordSetupNow => 'パスワードを設定';

  @override
  String get settings_adminMenu => '管理者専用';

  @override
  String get settings_permissionManagementTitle => '権限管理';

  @override
  String get settings_permissionManagementSubtitle => 'Roleに割り当てる権限タイプを管理します';

  @override
  String get permission_title => '権限管理';

  @override
  String get permission_search => '権限検索（コード、名前、説明）';

  @override
  String get permission_allCategories => 'すべて';

  @override
  String get permission_create => '権限作成';

  @override
  String get permission_code => '権限コード';

  @override
  String get permission_category => 'カテゴリ';

  @override
  String get permission_description => '説明';

  @override
  String get permission_status => '状態';

  @override
  String get permission_active => '有効';

  @override
  String get permission_inactive => '無効';

  @override
  String get permission_count => '件';

  @override
  String get permission_noPermissions => '権限が見つかりません';

  @override
  String get permission_loadFailed => '権限の読み込みに失敗しました';

  @override
  String get permission_deleteConfirm => '権限削除';

  @override
  String permission_deleteMessage(String name) {
    return '$name権限を削除しますか？';
  }

  @override
  String get permission_deleteSoftDescription => 'ソフト削除：無効化しますがデータは保持されます';

  @override
  String get permission_deleteHardDescription => 'ハード削除：データベースから完全に削除されます（注意！）';

  @override
  String get permission_softDelete => 'ソフト削除';

  @override
  String get permission_hardDelete => 'ハード削除';

  @override
  String get permission_deleteSuccess => '権限が削除されました';

  @override
  String get permission_deleteFailed => '権限の削除に失敗しました';

  @override
  String get permission_name => '権限名';

  @override
  String get permission_codeAndNameRequired => 'コードと名前は必須です';

  @override
  String get permission_createSuccess => '権限が作成されました';

  @override
  String get permission_createFailed => '権限の作成に失敗しました';

  @override
  String get permission_updateSuccess => '権限が更新されました';

  @override
  String get permission_updateFailed => '権限の更新に失敗しました';

  @override
  String get group_title => 'グループ管理';

  @override
  String get group_myGroups => 'マイグループ';

  @override
  String get group_createGroup => 'グループ作成';

  @override
  String get group_joinGroup => 'グループ参加';

  @override
  String get group_groupName => 'グループ名';

  @override
  String get group_groupDescription => '説明';

  @override
  String get group_groupColor => 'グループカラー';

  @override
  String get group_defaultColor => 'デフォルトカラー';

  @override
  String get group_customColor => 'カスタムカラー';

  @override
  String get group_inviteCode => '招待コード';

  @override
  String get group_members => 'メンバー';

  @override
  String get group_pending => '保留中';

  @override
  String get group_noPendingRequests => '保留中の参加リクエストはありません';

  @override
  String group_memberCount(int count) {
    return '$count人';
  }

  @override
  String get group_role => '役割';

  @override
  String get group_owner => 'オーナー';

  @override
  String get group_admin => '管理者';

  @override
  String get group_member => 'メンバー';

  @override
  String get group_joinedAt => '参加日';

  @override
  String get group_createdAt => '作成日';

  @override
  String get group_settings => 'グループ設定';

  @override
  String get group_editGroup => 'グループ情報編集';

  @override
  String get group_deleteGroup => 'グループ削除';

  @override
  String get group_leaveGroup => 'グループを退出';

  @override
  String get group_inviteMembers => 'メンバー招待';

  @override
  String get group_manageMembers => 'メンバー管理';

  @override
  String get group_regenerateCode => '招待コード再生成';

  @override
  String get group_copyCode => 'コードをコピー';

  @override
  String get group_enterInviteCode => '招待コード入力';

  @override
  String get group_inviteByEmail => 'メールで招待';

  @override
  String get group_email => 'メールアドレス';

  @override
  String get group_send => '送信';

  @override
  String get group_join => '参加';

  @override
  String get group_cancel => 'キャンセル';

  @override
  String get group_save => '保存';

  @override
  String get group_delete => '削除';

  @override
  String get group_leave => '退出';

  @override
  String get group_create => '作成';

  @override
  String get group_edit => '編集';

  @override
  String get group_confirm => '確認';

  @override
  String get group_accept => '承認';

  @override
  String get group_reject => '拒否';

  @override
  String get group_requestedAt => 'リクエスト日';

  @override
  String get group_invitedAt => '招待日';

  @override
  String get group_acceptSuccess => '参加リクエストが承認されました';

  @override
  String get group_rejectSuccess => '参加リクエストが拒否されました';

  @override
  String get group_rejectConfirmMessage => '本当にこの参加リクエストを拒否しますか？';

  @override
  String get group_groupNameRequired => 'グループ名を入力してください';

  @override
  String get group_inviteCodeRequired => '招待コードを入力してください';

  @override
  String get group_emailRequired => 'メールアドレスを入力してください';

  @override
  String get group_deleteConfirmTitle => 'グループ削除';

  @override
  String get group_deleteConfirmMessage =>
      '本当にこのグループを削除しますか？\nすべてのデータが削除され、復元できません。';

  @override
  String get group_leaveConfirmTitle => 'グループ退出';

  @override
  String get group_leaveConfirmMessage => '本当にこのグループを退出しますか？';

  @override
  String get group_ownerCannotLeave =>
      'オーナーはグループを退出できません。\nオーナー権限を譲渡するか、グループを削除してください。';

  @override
  String get group_createSuccess => 'グループが作成されました';

  @override
  String get group_joinSuccess => 'グループに参加しました';

  @override
  String get group_updateSuccess => 'グループ情報が更新されました';

  @override
  String get group_deleteSuccess => 'グループが削除されました';

  @override
  String get group_leaveSuccess => 'グループから退出しました';

  @override
  String get group_inviteSent => '招待メールが送信されました';

  @override
  String get group_codeRegenerated => '招待コードが再生成されました';

  @override
  String get group_codeCopied => '招待コードがコピーされました';

  @override
  String get group_codeExpired => '招待コードが期限切れです';

  @override
  String group_codeExpiresInDays(int count) {
    return '$count日後に期限切れ';
  }

  @override
  String group_codeExpiresInHours(int count) {
    return '$count時間後に期限切れ';
  }

  @override
  String group_codeExpiresInMinutes(int count) {
    return '$count分後に期限切れ';
  }

  @override
  String get group_noGroups => '参加中のグループがありません';

  @override
  String get group_noGroupsDescription => '新しいグループを作成するか\n招待コードでグループに参加してください';

  @override
  String get group_myJoinRequests => '参加申請リスト';

  @override
  String get group_noJoinRequests => '参加申請履歴がありません';

  @override
  String get group_joinRequestStatusAll => 'すべて';

  @override
  String get group_joinRequestStatusPending => '保留中';

  @override
  String get group_joinRequestStatusDone => '処理済み';

  @override
  String get group_joinRequestAccepted => '承認済み';

  @override
  String get group_joinRequestRejected => '拒否済み';

  @override
  String get group_codeExpiredLabel => '招待コード期限切れ';

  @override
  String get group_defaultGroupTooltip => 'デフォルトグループ';

  @override
  String get group_setDefaultGroupTooltip => 'デフォルトグループに設定';

  @override
  String get group_unsetDefaultGroupTooltip => 'デフォルトグループを解除';

  @override
  String group_setDefaultSuccess(String name) {
    return '\'$name\'をデフォルトグループに設定しました';
  }

  @override
  String get group_unsetDefaultSuccess => 'デフォルトグループを解除しました';

  @override
  String get group_myColorTitle => 'マイグループカラー';

  @override
  String get group_myColorNotSet => '未設定（グループデフォルトカラーを使用）';

  @override
  String get group_myColorSet => '設定済み';

  @override
  String get group_myColorReset => 'リセット';

  @override
  String get group_dangerZone => '危険ゾーン';

  @override
  String get group_dangerZoneDesc => 'グループを削除すると、すべてのデータが完全に削除されます。';

  @override
  String get group_leaveTitle => 'グループを退出';

  @override
  String get group_leaveDesc => 'グループを退出すると、グループのデータにアクセスできなくなります。';

  @override
  String group_leaveConfirmBody(String name) {
    return '本当に「$name」グループを退出しますか？\n\n退出後はグループのデータにアクセスできなくなり、再参加には招待コードが必要です。';
  }

  @override
  String get group_leaveButton => '退出';

  @override
  String get group_roleManagementTitle => 'ロール管理';

  @override
  String get group_roleManagementDesc => 'このグループのロール一覧です。';

  @override
  String get group_roleEmpty => 'ロールがありません';

  @override
  String get group_roleDefaultBadge => 'デフォルト';

  @override
  String group_rolePermissionCount(int count) {
    return '権限: $count個';
  }

  @override
  String get group_roleEdit => 'ロールを編集';

  @override
  String get group_roleDelete => 'ロールを削除';

  @override
  String get group_roleSortSaved => '並び順を保存しました';

  @override
  String get group_roleLoadError => 'ロール一覧を読み込めません';

  @override
  String get group_roleInfoTitle => 'ご案内';

  @override
  String get group_roleInfoBullet1 =>
      '共通ロール（OWNER、ADMIN、MEMBER）はすべてのグループにデフォルトで提供されます。';

  @override
  String get group_roleInfoBullet2 => 'カスタムロールはグループOWNERのみ作成・編集・削除できます。';

  @override
  String get group_roleInfoBullet3 => 'ロールを管理するにはグループOWNER権限が必要です。';

  @override
  String get group_roleCreateTitle => 'ロールを作成';

  @override
  String get group_roleEditTitle => 'ロールを編集';

  @override
  String get group_roleDeleteTitle => 'ロールを削除';

  @override
  String get group_roleNameLabel => 'ロール名';

  @override
  String get group_roleNameRequired => 'ロール名を入力してください';

  @override
  String get group_roleDefaultSwitch => 'デフォルトロール';

  @override
  String get group_roleDefaultSwitchSub => '新規メンバー参加時に自動付与';

  @override
  String get group_roleColorLabel => 'ロールカラー';

  @override
  String get group_rolePermissionsLabel => '権限を選択';

  @override
  String get group_rolePermissionsViewLabel => '権限一覧';

  @override
  String get group_rolePermissionNone => '権限がありません';

  @override
  String get group_roleDefaultLabel => 'デフォルトロール（新規メンバー参加時に自動付与）';

  @override
  String group_roleDeleteConfirm(String name) {
    return '「$name」ロールを削除しますか？';
  }

  @override
  String get group_roleDeleteWarning => '⚠️ このロールを使用中のメンバーがいる場合は削除できません。';

  @override
  String get group_roleCreateSuccess => 'ロールが作成されました';

  @override
  String group_roleCreateFail(String error) {
    return 'ロール作成失敗: $error';
  }

  @override
  String get group_roleEditSuccess => 'ロールが更新されました';

  @override
  String group_roleEditFail(String error) {
    return 'ロール更新失敗: $error';
  }

  @override
  String get group_roleDeleteSuccess => 'ロールが削除されました';

  @override
  String group_roleDeleteFail(String error) {
    return 'ロール削除失敗: $error';
  }

  @override
  String get group_settings_groupManagementTitle => 'グループ管理';

  @override
  String get error_network => 'ネットワーク接続を確認してください';

  @override
  String get error_server => 'サーバーエラーが発生しました';

  @override
  String get error_unknown => '不明なエラーが発生しました';

  @override
  String get common_comingSoon => '準備中';

  @override
  String get common_logoutFailed => 'ログアウト失敗';

  @override
  String get announcement_title => 'お知らせ';

  @override
  String get announcement_list => 'お知らせ一覧';

  @override
  String get announcement_detail => 'お知らせ詳細';

  @override
  String get announcement_create => 'お知らせ作成';

  @override
  String get announcement_edit => 'お知らせ編集';

  @override
  String get announcement_delete => 'お知らせ削除';

  @override
  String get announcement_pin => '上部固定';

  @override
  String get announcement_unpin => '固定解除';

  @override
  String get announcement_pinned => '固定お知らせ';

  @override
  String get announcement_pinDescription => '重要なお知らせをリストの上部に固定します';

  @override
  String get announcement_category => 'カテゴリー';

  @override
  String get announcement_category_none => 'カテゴリーなし';

  @override
  String get announcement_category_announcement => 'お知らせ';

  @override
  String get announcement_category_event => 'イベント';

  @override
  String get announcement_category_update => 'アップデート';

  @override
  String get announcement_content => '内容';

  @override
  String get announcement_author => '作成者';

  @override
  String get announcement_createdAt => '作成日';

  @override
  String get announcement_updatedAt => '更新日';

  @override
  String announcement_readCount(int count) {
    return '$count人が閲覧';
  }

  @override
  String get announcement_createSuccess => 'お知らせを登録しました';

  @override
  String get announcement_createError => 'お知らせの登録に失敗しました';

  @override
  String get announcement_updateSuccess => 'お知らせを更新しました';

  @override
  String get announcement_updateError => 'お知らせの更新に失敗しました';

  @override
  String get announcement_deleteSuccess => 'お知らせを削除しました';

  @override
  String get announcement_deleteError => 'お知らせの削除に失敗しました';

  @override
  String get announcement_deleteDialogTitle => 'お知らせの削除';

  @override
  String get announcement_deleteDialogMessage =>
      'このお知らせを削除しますか？\n削除されたお知らせは復元できません。';

  @override
  String get announcement_pinSuccess => 'お知らせを固定しました';

  @override
  String get announcement_unpinSuccess => '固定を解除しました';

  @override
  String get announcement_deleteConfirm => 'このお知らせを削除しますか？\n削除されたお知らせは復元できません。';

  @override
  String get announcement_loadError => 'お知らせを読み込めません';

  @override
  String get announcement_empty => '登録されたお知らせがありません';

  @override
  String get announcement_titleHint => 'お知らせのタイトルを入力してください';

  @override
  String get announcement_contentHint => 'お知らせの内容を入力してください';

  @override
  String get announcement_categoryHint => 'カテゴリーを選択してください（任意）';

  @override
  String get announcement_titleRequired => 'タイトルを入力してください';

  @override
  String get announcement_titleMinLength => 'タイトルは3文字以上入力してください';

  @override
  String get announcement_contentRequired => '内容を入力してください';

  @override
  String get announcement_contentMinLength => '内容は10文字以上入力してください';

  @override
  String get announcement_attachmentComingSoon => 'ファイル添付機能は今後のアップデートで提供予定です';

  @override
  String get qna_title => 'Q&A';

  @override
  String get qna_publicQuestions => '公開Q&A';

  @override
  String get qna_myQuestions => '私の質問';

  @override
  String get qna_askQuestion => '質問する';

  @override
  String get qna_question => '質問';

  @override
  String get qna_answer => '回答';

  @override
  String get qna_category => 'カテゴリー';

  @override
  String get qna_categoryFilter => 'カテゴリーフィルター';

  @override
  String get qna_categoryAll => 'すべて';

  @override
  String get qna_categoryNone => 'カテゴリーなし';

  @override
  String get qna_status => 'ステータス';

  @override
  String get qna_statusAll => 'すべて';

  @override
  String get qna_statusPending => '回答待ち';

  @override
  String get qna_statusAnswered => '回答済み';

  @override
  String get qna_statusResolved => '解決済み';

  @override
  String get qna_search => '質問検索';

  @override
  String get qna_searchHint => '質問を検索';

  @override
  String get qna_questionTitle => '質問タイトル';

  @override
  String get qna_questionTitleHint => '質問のタイトルを入力してください';

  @override
  String get qna_questionContent => '質問内容';

  @override
  String get qna_questionContentHint => '質問内容を入力してください';

  @override
  String get qna_answerContent => '回答内容';

  @override
  String get qna_answerContentHint => '回答を入力してください';

  @override
  String get qna_isPublic => '公開設定';

  @override
  String get qna_publicQuestion => '公開質問';

  @override
  String get qna_privateQuestion => '非公開質問';

  @override
  String get qna_author => '作成者';

  @override
  String get qna_answerer => '回答者';

  @override
  String get qna_createdAt => '作成日';

  @override
  String get qna_answeredAt => '回答日';

  @override
  String qna_viewCount(int count) {
    return '$count回閲覧';
  }

  @override
  String qna_answerCount(int count) {
    return '$count件の回答';
  }

  @override
  String get qna_empty => '登録された質問がありません';

  @override
  String get qna_noAnswer => 'まだ回答がありません';

  @override
  String get qna_loadError => '質問を読み込めません';

  @override
  String get qna_createSuccess => '質問を登録しました';

  @override
  String get qna_createError => '質問の登録に失敗しました';

  @override
  String get qna_updateSuccess => '質問を更新しました';

  @override
  String get qna_updateError => '質問の更新に失敗しました';

  @override
  String get qna_deleteSuccess => '質問を削除しました';

  @override
  String get qna_deleteError => '質問の削除に失敗しました';

  @override
  String get qna_deleteDialogTitle => '質問の削除';

  @override
  String get qna_deleteDialogMessage => 'この質問を削除しますか？\n削除された質問は復元できません。';

  @override
  String get qna_answerSuccess => '回答を投稿しました';

  @override
  String get qna_answerError => '回答の投稿に失敗しました';

  @override
  String get qna_answerUpdateSuccess => '回答を更新しました';

  @override
  String get qna_answerUpdateError => '回答の更新に失敗しました';

  @override
  String get qna_answerDeleteSuccess => '回答を削除しました';

  @override
  String get qna_answerDeleteError => '回答の削除に失敗しました';

  @override
  String get qna_markResolved => '解決済みにする';

  @override
  String get qna_markUnresolved => '未解決にする';

  @override
  String get qna_resolveSuccess => '質問を解決済みにしました';

  @override
  String get qna_resolveError => 'ステータスの変更に失敗しました';

  @override
  String get qna_titleRequired => 'タイトルを入力してください';

  @override
  String get qna_titleMinLength => 'タイトルは3文字以上入力してください';

  @override
  String get qna_contentRequired => '内容を入力してください';

  @override
  String get qna_contentMinLength => '内容は10文字以上入力してください';

  @override
  String get qna_answerRequired => '回答を入力してください';

  @override
  String get schedule_today => '今日';

  @override
  String get schedule_add => '予定を追加';

  @override
  String get schedule_edit => '予定を編集';

  @override
  String get schedule_delete => '予定を削除';

  @override
  String get schedule_detail => '予定の詳細';

  @override
  String get schedule_allDay => '終日';

  @override
  String get schedule_loadError => '予定を読み込めません';

  @override
  String get schedule_empty => '予定がありません';

  @override
  String get schedule_createSuccess => '予定を登録しました';

  @override
  String get schedule_createError => '予定の登録に失敗しました';

  @override
  String get schedule_updateSuccess => '予定を更新しました';

  @override
  String get schedule_updateError => '予定の更新に失敗しました';

  @override
  String get schedule_deleteSuccess => '予定を削除しました';

  @override
  String get schedule_deleteError => '予定の削除に失敗しました';

  @override
  String get schedule_deleteDialogTitle => '予定の削除';

  @override
  String get schedule_deleteDialogMessage => 'この予定を削除しますか？';

  @override
  String get schedule_title => 'タイトル';

  @override
  String get schedule_titleHint => '予定のタイトルを入力';

  @override
  String get schedule_titleRequired => 'タイトルを入力してください';

  @override
  String get schedule_description => '説明';

  @override
  String get schedule_descriptionHint => '説明を入力（任意）';

  @override
  String get schedule_location => '場所';

  @override
  String get schedule_locationHint => '場所を入力（任意）';

  @override
  String get schedule_startDate => '開始日';

  @override
  String get schedule_endDate => '終了日';

  @override
  String get schedule_startTime => '開始時刻';

  @override
  String get schedule_endTime => '終了時刻';

  @override
  String get schedule_dueDate => '期限を設定';

  @override
  String get schedule_dueDateSelect => '期限日';

  @override
  String get schedule_dueTime => '期限時刻';

  @override
  String get schedule_color => '色';

  @override
  String get schedule_share => '共有設定';

  @override
  String get schedule_sharePrivate => '自分のみ';

  @override
  String get schedule_shareGroup => '特定グループ';

  @override
  String get schedule_reminder => 'リマインダー';

  @override
  String get schedule_reminderNone => 'なし';

  @override
  String get schedule_reminderAtTime => '開始時刻';

  @override
  String get schedule_reminder5Min => '5分前';

  @override
  String get schedule_reminder15Min => '15分前';

  @override
  String get schedule_reminder30Min => '30分前';

  @override
  String get schedule_reminder1Hour => '1時間前';

  @override
  String get schedule_reminder1Day => '1日前';

  @override
  String get schedule_recurrence => '繰り返し';

  @override
  String get schedule_recurrenceNone => '繰り返しなし';

  @override
  String get schedule_recurrenceDaily => '毎日';

  @override
  String get schedule_recurrenceWeekly => '毎週';

  @override
  String get schedule_recurrenceMonthly => '毎月';

  @override
  String get schedule_recurrenceYearly => '毎年';

  @override
  String get schedule_personal => '個人の予定';

  @override
  String get schedule_group => 'グループ';

  @override
  String get schedule_taskType => '予定タイプ';

  @override
  String get schedule_taskTypeCalendarOnly => 'カレンダーのみ';

  @override
  String get schedule_taskTypeCalendarOnlyDesc => 'カレンダーにのみ表示されます';

  @override
  String get schedule_taskTypeTodoLinked => 'ToDo連動';

  @override
  String get schedule_taskTypeTodoLinkedDesc => 'カレンダーとToDoリストの両方に表示されます';

  @override
  String get schedule_taskTypeTodoOnly => 'ToDoのみ';

  @override
  String get schedule_taskTypeTodoOnlyDesc => 'ToDoリストにのみ表示（カレンダー除外）';

  @override
  String get schedule_priority => '優先度';

  @override
  String get schedule_priorityLow => '低';

  @override
  String get schedule_priorityMedium => '中';

  @override
  String get schedule_priorityHigh => '高';

  @override
  String get schedule_priorityUrgent => '緊急';

  @override
  String get schedule_participants => '参加者';

  @override
  String get schedule_participantsHint => 'この予定に参加するグループメンバーを選択してください';

  @override
  String get schedule_noMembers => 'グループメンバーがいません';

  @override
  String get schedule_participantsLoadError => 'メンバーリストを読み込めませんでした';

  @override
  String get schedule_participantsSelectAll => '全員選択';

  @override
  String get schedule_participantsDeselectAll => '全員解除';

  @override
  String get schedule_reminderCustom => 'カスタム';

  @override
  String get schedule_reminderCustomTitle => 'リマインダー時間設定';

  @override
  String get schedule_reminderCustomHint => '予定開始前に通知を受け取る時間を設定してください';

  @override
  String get schedule_reminderDays => '日';

  @override
  String get schedule_reminderHours => '時間';

  @override
  String get schedule_reminderMinutes => '分';

  @override
  String schedule_reminderMinutesBefore(int minutes) {
    return '$minutes分前';
  }

  @override
  String schedule_reminderHoursBefore(int hours) {
    return '$hours時間前';
  }

  @override
  String schedule_reminderHoursMinutesBefore(int hours, int minutes) {
    return '$hours時間$minutes分前';
  }

  @override
  String schedule_reminderDaysBefore(int days) {
    return '$days日前';
  }

  @override
  String schedule_reminderDaysHoursBefore(int days, int hours) {
    return '$days日$hours時間前';
  }

  @override
  String get category_management => 'カテゴリー管理';

  @override
  String get category_filter => 'カテゴリーフィルター';

  @override
  String get category_add => 'カテゴリー追加';

  @override
  String get category_edit => 'カテゴリー編集';

  @override
  String get category_empty => 'カテゴリーがありません';

  @override
  String get category_emptyHint => 'カテゴリーを追加して予定を分類しましょう';

  @override
  String get category_loadError => 'カテゴリーの読み込みに失敗しました';

  @override
  String get category_name => 'カテゴリー名';

  @override
  String get category_nameHint => '例：仕事、個人、家族';

  @override
  String get category_nameRequired => 'カテゴリー名を入力してください';

  @override
  String get category_description => '説明';

  @override
  String get category_descriptionHint => 'カテゴリーの説明（任意）';

  @override
  String get category_emoji => '絵文字';

  @override
  String get category_color => '色';

  @override
  String get category_createSuccess => 'カテゴリーを作成しました';

  @override
  String get category_createError => 'カテゴリーの作成に失敗しました';

  @override
  String get category_updateSuccess => 'カテゴリーを更新しました';

  @override
  String get category_updateError => 'カテゴリーの更新に失敗しました';

  @override
  String get category_deleteSuccess => 'カテゴリーを削除しました';

  @override
  String get category_deleteError => 'カテゴリーの削除に失敗しました';

  @override
  String get category_deleteDialogTitle => 'カテゴリー削除';

  @override
  String get category_deleteDialogMessage =>
      'このカテゴリーを削除しますか？\n関連する予定があると削除できません。';

  @override
  String get schedule_recurringEvery => '毎';

  @override
  String get schedule_recurringIntervalDay => '日ごと';

  @override
  String get schedule_recurringIntervalWeek => '週ごと';

  @override
  String get schedule_recurringIntervalMonth => 'ヶ月ごと';

  @override
  String get schedule_recurringIntervalYear => '年ごと';

  @override
  String get schedule_recurringDaysOfWeek => '繰り返す曜日';

  @override
  String get schedule_daySun => '日';

  @override
  String get schedule_dayMon => '月';

  @override
  String get schedule_dayTue => '火';

  @override
  String get schedule_dayWed => '水';

  @override
  String get schedule_dayThu => '木';

  @override
  String get schedule_dayFri => '金';

  @override
  String get schedule_daySat => '土';

  @override
  String get schedule_daySunday => '日曜日';

  @override
  String get schedule_dayMonday => '月曜日';

  @override
  String get schedule_dayTuesday => '火曜日';

  @override
  String get schedule_dayWednesday => '水曜日';

  @override
  String get schedule_dayThursday => '木曜日';

  @override
  String get schedule_dayFriday => '金曜日';

  @override
  String get schedule_daySaturday => '土曜日';

  @override
  String get schedule_recurringMonthlyType => '月次繰り返しタイプ';

  @override
  String get schedule_recurringMonthlyDayOfMonth => '日付基準';

  @override
  String get schedule_recurringMonthlyWeekOfMonth => '曜日基準';

  @override
  String get schedule_recurringMonthlyEveryMonth => '毎月';

  @override
  String get schedule_recurringDay => '日';

  @override
  String get schedule_recurringWeek1 => '第1';

  @override
  String get schedule_recurringWeek2 => '第2';

  @override
  String get schedule_recurringWeek3 => '第3';

  @override
  String get schedule_recurringWeek4 => '第4';

  @override
  String get schedule_recurringWeekLast => '最終';

  @override
  String get schedule_recurringYearlyType => '年次繰り返しタイプ';

  @override
  String get schedule_recurringYearlyDayOfMonth => '日付基準';

  @override
  String get schedule_recurringYearlyWeekOfMonth => '曜日基準';

  @override
  String get schedule_recurringYearlyEveryYear => '毎年';

  @override
  String get schedule_month1 => '1月';

  @override
  String get schedule_month2 => '2月';

  @override
  String get schedule_month3 => '3月';

  @override
  String get schedule_month4 => '4月';

  @override
  String get schedule_month5 => '5月';

  @override
  String get schedule_month6 => '6月';

  @override
  String get schedule_month7 => '7月';

  @override
  String get schedule_month8 => '8月';

  @override
  String get schedule_month9 => '9月';

  @override
  String get schedule_month10 => '10月';

  @override
  String get schedule_month11 => '11月';

  @override
  String get schedule_month12 => '12月';

  @override
  String get schedule_recurringEndCondition => '終了条件';

  @override
  String get schedule_recurringEndNever => '終了なし';

  @override
  String get schedule_recurringEndDate => '日付まで';

  @override
  String get schedule_recurringEndCount => '回数指定';

  @override
  String get schedule_recurringCountTimes => '回繰り返し';

  @override
  String get schedule_searchHint => 'タイトル、説明、場所で検索';

  @override
  String get schedule_searchNoResults => '検索結果がありません';

  @override
  String schedule_searchResultCount(int count) {
    return '検索結果 $count件';
  }

  @override
  String get todo_add => 'タスク追加';

  @override
  String get todo_edit => 'タスク編集';

  @override
  String get todo_delete => 'タスク削除';

  @override
  String get todo_detail => 'タスク詳細';

  @override
  String get todo_showCompleted => '完了済みを表示';

  @override
  String get todo_priority => '優先度';

  @override
  String get todo_priorityLow => '低';

  @override
  String get todo_priorityMedium => '中';

  @override
  String get todo_priorityHigh => '高';

  @override
  String get todo_priorityUrgent => '緊急';

  @override
  String get todo_noTodos => '登録されたタスクがありません';

  @override
  String get todo_allCompleted => 'すべてのタスクを完了しました！';

  @override
  String get todo_loadError => 'タスクを読み込めません';

  @override
  String get todo_noDueDate => '期限なし';

  @override
  String get todo_viewKanban => 'カンバンボード';

  @override
  String get todo_viewList => 'リスト表示';

  @override
  String get todo_statusPending => '保留中';

  @override
  String get todo_statusInProgress => '進行中';

  @override
  String get todo_statusCompleted => '完了';

  @override
  String get todo_statusHold => '保留';

  @override
  String get todo_statusDrop => 'ドロップ';

  @override
  String get todo_statusFailed => '失敗';

  @override
  String get todo_prevWeek => '前の週';

  @override
  String get todo_nextWeek => '次の週';

  @override
  String get todo_changeStatus => '状態変更';

  @override
  String get todo_viewByDate => '日付別表示';

  @override
  String get todo_viewOverview => '一覧表示';

  @override
  String get todo_overviewOverdue => '期限超過';

  @override
  String get todo_overviewToday => '今日';

  @override
  String get todo_overviewTomorrow => '明日';

  @override
  String get todo_overviewThisWeek => '今週';

  @override
  String get todo_overviewNextWeek => '来週';

  @override
  String get todo_overviewLater => 'それ以降';

  @override
  String get todo_overviewNoDueDate => '期限なし';

  @override
  String get todo_filter => 'フィルター';

  @override
  String get todo_filterAll => 'すべて';

  @override
  String get todo_filterStatus => '状態';

  @override
  String get todo_filterPriority => '優先度';

  @override
  String get todo_sortBy => '並べ替え';

  @override
  String get todo_sortByStatus => '状態順';

  @override
  String get todo_sortByPriority => '優先度順';

  @override
  String get todo_sortByDueDate => '期限順';

  @override
  String get todo_sortByCreatedAt => '作成日順';

  @override
  String get todo_filterApplied => 'フィルター適用中';

  @override
  String get todo_clearFilter => 'フィルターをクリア';

  @override
  String get todo_filterTooltip => 'タスクフィルター';

  @override
  String get todo_widgetTitleToday => '今日のタスク';

  @override
  String get todo_widgetTitleWeek => '今週のタスク';

  @override
  String get todo_widgetTitleMonth => '今月のタスク';

  @override
  String get todo_emptyToday => '今日のタスクはありません';

  @override
  String get todo_emptyWeek => '今週のタスクはありません';

  @override
  String get todo_emptyMonth => '今月のタスクはありません';

  @override
  String get todo_searchHint => 'タイトル、説明で検索';

  @override
  String get todo_searchNoResults => '検索結果がありません';

  @override
  String todo_searchResultCount(int count) {
    return '検索結果 $count件';
  }

  @override
  String get memo_title => 'メモ';

  @override
  String get memo_list => 'メモ一覧';

  @override
  String get memo_detail => 'メモ詳細';

  @override
  String get memo_create => 'メモ作成';

  @override
  String get memo_edit => 'メモ編集';

  @override
  String get memo_delete => 'メモ削除';

  @override
  String get memo_content => '内容';

  @override
  String get memo_category => 'カテゴリー';

  @override
  String get memo_categoryHint => 'カテゴリーを入力してください（任意）';

  @override
  String get memo_personal => 'マイメモ';

  @override
  String get memo_tags => 'タグ';

  @override
  String get memo_tagsHint => 'タグを追加';

  @override
  String get memo_author => '作成者';

  @override
  String get memo_createdAt => '作成日';

  @override
  String get memo_updatedAt => '更新日';

  @override
  String get memo_createSuccess => 'メモを作成しました';

  @override
  String get memo_createError => 'メモの作成に失敗しました';

  @override
  String get memo_updateSuccess => 'メモを更新しました';

  @override
  String get memo_updateError => 'メモの更新に失敗しました';

  @override
  String get memo_deleteSuccess => 'メモを削除しました';

  @override
  String get memo_deleteError => 'メモの削除に失敗しました';

  @override
  String get memo_deleteDialogTitle => 'メモの削除';

  @override
  String get memo_deleteDialogMessage => 'このメモを削除しますか？\n削除されたメモは復元できません。';

  @override
  String get memo_loadError => 'メモを読み込めません';

  @override
  String get memo_empty => '作成されたメモがありません';

  @override
  String get memo_titleHint => 'メモのタイトルを入力';

  @override
  String get memo_contentHint => 'メモの内容を入力';

  @override
  String get memo_titleRequired => 'タイトルを入力してください';

  @override
  String get memo_titleMinLength => 'タイトルは2文字以上入力してください';

  @override
  String get memo_contentRequired => '内容を入力してください';

  @override
  String get memo_searchHint => 'タイトル、内容で検索';

  @override
  String get memo_searchNoResults => '検索結果がありません';

  @override
  String get memo_tagAdd => 'タグ追加';

  @override
  String get memo_tagName => 'タグ名';

  @override
  String get memo_tagNameHint => 'タグ名を入力してください';

  @override
  String get memo_visibility => '公開範囲';

  @override
  String get memo_visibilityPrivate => '自分のみ';

  @override
  String get memo_visibilityGroup => '特定グループ';

  @override
  String get memo_groupSelect => 'グループを選択';

  @override
  String get memo_typeNote => '通常メモ';

  @override
  String get memo_typeChecklist => 'チェックリスト';

  @override
  String get memo_typeSelect => 'メモの種類';

  @override
  String get memo_checklist => 'チェックリスト';

  @override
  String get memo_checklistAdd => '項目を追加';

  @override
  String get memo_checklistAddHint => '新しい項目を入力';

  @override
  String get memo_checklistEmpty => 'チェックリストの項目がありません';

  @override
  String get memo_checklistReset => '全て解除';

  @override
  String get memo_duplicate => 'コピー';

  @override
  String get memo_checklistSelectAll => '全て選択';

  @override
  String get memo_checklistDeleteItem => '項目を削除';

  @override
  String get memo_checklistEditItem => '項目を編集';

  @override
  String memo_checklistProgress(int checked, int total) {
    return '$checked/$total 完了';
  }

  @override
  String get household_title => '家計簿';

  @override
  String get household_expense => '支出';

  @override
  String get household_no_group_selected => 'グループを選択してください';

  @override
  String get household_personal_mode => '個人';

  @override
  String get household_add_expense => '支出を追加';

  @override
  String get household_view_shopping_history => '買い物履歴を見る';

  @override
  String get household_edit_expense => '支出を編集';

  @override
  String get household_refund => '返金登録';

  @override
  String get household_refund_badge => '返金済';

  @override
  String get household_refund_origin_badge => '返金';

  @override
  String get household_refund_amount_label => '返金金額';

  @override
  String get household_refund_origin_label => '元の支出';

  @override
  String get household_view_refund_origin => '元の支出を見る';

  @override
  String get household_refund_total => '合計返金';

  @override
  String get household_delete_expense => '支出を削除';

  @override
  String get household_delete_confirm => 'この支出を削除しますか？';

  @override
  String get household_amount => '金額';

  @override
  String get household_category => 'カテゴリ';

  @override
  String get household_payment_method => '支払い方法';

  @override
  String get household_description => '内容';

  @override
  String get household_date => '日付';

  @override
  String get household_recurring => '固定費';

  @override
  String get household_total_income => '総収入';

  @override
  String get household_total_expense => '総支出';

  @override
  String get household_balance => '残高';

  @override
  String get household_carry_over => '繰越';

  @override
  String get household_carry_over_title => '残高繰越';

  @override
  String household_carry_over_desc(String amount) {
    return '今月の残高 ₩$amount を来月に繰り越します。\n\n· 今月末日に「残高繰越」（資産移動）の支出が登録されます。\n· 来月1日に「前月繰越」の収入が登録されます。';
  }

  @override
  String get household_carry_over_success => '繰越が完了しました';

  @override
  String get household_carry_over_no_balance => '繰越できる残高がありません';

  @override
  String get household_balance_transfer => '残高を移動';

  @override
  String get household_carry_over_mode_next_month => '来月に繰越';

  @override
  String get household_carry_over_mode_asset => '資産口座';

  @override
  String get household_carry_over_mode_savings => '貯金箱';

  @override
  String get household_carry_over_amount_label => '金額';

  @override
  String get household_carry_over_amount_exceeded => '残高を超えることはできません';

  @override
  String get household_carry_over_select_account => '口座を選択してください';

  @override
  String get household_carry_over_select_savings => '貯金箱を選択してください';

  @override
  String get household_carry_over_no_accounts => '登録された口座がありません';

  @override
  String get household_carry_over_no_savings => '登録された貯金箱がありません';

  @override
  String get household_transfer_success => '資産移動が完了しました';

  @override
  String get household_income => '収入';

  @override
  String get household_revenue => '収入';

  @override
  String get household_type => '種別';

  @override
  String get household_total_budget => '総予算';

  @override
  String get household_statistics => '統計';

  @override
  String get household_monthly_statistics => '月間統計';

  @override
  String get household_no_expenses => '支出履歴がありません';

  @override
  String get household_category_food => '食費';

  @override
  String get household_category_transport => '交通費';

  @override
  String get household_category_leisure => 'レジャー費';

  @override
  String get household_category_living => '生活費';

  @override
  String get household_category_health => '医療費';

  @override
  String get household_category_education => '教育費';

  @override
  String get household_category_clothing => '被服費';

  @override
  String get household_category_allowance => 'お小遣い';

  @override
  String get household_category_celebration => '冠婚葬祭費';

  @override
  String get household_category_asset_transfer => '資産移動';

  @override
  String get household_category_carryover => '繰越';

  @override
  String get household_category_childcare => '育児費';

  @override
  String get household_category_communication => '通信費';

  @override
  String get household_category_groceries => '食料品';

  @override
  String get household_category_other => 'その他';

  @override
  String get household_income_category => '収入の種類';

  @override
  String get household_income_category_salary => '給与';

  @override
  String get household_income_category_allowance => '小遣い';

  @override
  String get household_income_category_carryover => '繰越';

  @override
  String get household_income_category_bonus => 'ボーナス';

  @override
  String get household_income_category_interest => '利息';

  @override
  String get household_income_category_rental => '賃貸収入';

  @override
  String get household_income_category_side_income => '副業';

  @override
  String get household_income_category_transfer_in => '振込';

  @override
  String get household_income_category_other => 'その他収入';

  @override
  String get household_payment_cash => '現金';

  @override
  String get household_payment_card => 'カード';

  @override
  String get household_payment_transfer => '振込';

  @override
  String get household_payment_other => 'その他';

  @override
  String get household_budget_settings => '予算設定';

  @override
  String get household_budget_amount => '予算金額';

  @override
  String get household_set_budget => '予算を設定';

  @override
  String get household_amount_hint => '金額を入力してください';

  @override
  String get household_description_hint => '内容を入力してください';

  @override
  String get household_amount_required => '金額を入力してください';

  @override
  String get household_save_success => '保存されました';

  @override
  String get household_delete_success => '削除されました';

  @override
  String get household_budget_saved => '予算が設定されました';

  @override
  String get household_recurring_expenses => '固定費';

  @override
  String get household_recurring_no_expenses => '固定費がありません';

  @override
  String get household_recurring_total => '月合計';

  @override
  String get household_recurring_count => '件数';

  @override
  String household_recurring_count_unit(int count) {
    return '$count件';
  }

  @override
  String get household_recurring_expense_total => '支出合計';

  @override
  String get household_recurring_income_total => '収入合計';

  @override
  String household_unpaid_recurring_expense(int count, String amount) {
    return '支出$count件 · ₩$amount';
  }

  @override
  String household_unpaid_recurring_income(int count, String amount) {
    return '収入$count件 · ₩$amount';
  }

  @override
  String get household_recurring_top_category => 'カテゴリ別内訳';

  @override
  String get household_recurring_fixed => '固定';

  @override
  String get household_recurring_variable => '変動';

  @override
  String get household_recurring_type_label => '定期支出タイプ';

  @override
  String get household_recurring_type_none => 'なし';

  @override
  String get household_recurring_type_fixed => '固定金額';

  @override
  String get household_recurring_type_fixed_desc => '毎月同じ金額が反映されます';

  @override
  String get household_recurring_type_variable => '変動金額';

  @override
  String get household_recurring_type_variable_desc =>
      '毎月発生しますが金額が変わります（例：管理費）';

  @override
  String get household_recurring_amount_variable_label => '基準金額（目安）';

  @override
  String get household_recurring_amount_variable_hint =>
      '毎月金額が異なる場合があります。実際の支出後に修正して確定してください。';

  @override
  String get household_recurring_amount_fixed_hint => '毎月この金額で自動登録されます。';

  @override
  String get household_recurring_inactive => '無効';

  @override
  String get household_recurring_add => '固定費を追加';

  @override
  String get household_recurring_edit => '固定費を編集';

  @override
  String get household_recurring_title => '固定内訳';

  @override
  String get household_recurring_add_title => '固定内訳を追加';

  @override
  String get household_recurring_edit_title => '固定内訳を編集';

  @override
  String get household_recurring_day_of_month => '毎月の発生日';

  @override
  String household_recurring_day_of_month_value(int day) {
    return '毎月$day日';
  }

  @override
  String get household_recurring_backfill_toggle => '過去の支出も登録する';

  @override
  String get household_recurring_backfill_hint =>
      '開始月を選択すると、今日までの支出履歴が一緒に作成されます';

  @override
  String get household_recurring_start_month => '開始月';

  @override
  String get household_recurring_end_option => '繰り返しの終了';

  @override
  String get household_recurring_end_indefinite => '無期限';

  @override
  String get household_recurring_end_fixed_months => '月数を指定';

  @override
  String get household_recurring_total_months_label => '合計月数';

  @override
  String get household_recurring_total_months_hint => '例: 24';

  @override
  String get household_recurring_total_months_required => '月数を入力してください';

  @override
  String household_recurring_end_date_info(
    String endMonth,
    int current,
    int total,
  ) {
    return '$endMonthまで（$totalヶ月中$currentヶ月目）';
  }

  @override
  String get household_recurring_indefinite => '無期限に繰り返し';

  @override
  String get household_recurring_edit_backfill_notice =>
      '開始月や合計月数を変更しても、過去の支出は再生成されません。遡及生成は登録時のみ適用されます。';

  @override
  String get household_estimated_amount => '予想金額';

  @override
  String get household_estimated_amount_hint => '今月の予想金額を入力してください';

  @override
  String get household_estimated_amount_required => '予想金額を入力してください';

  @override
  String get household_variable_badge => '変動';

  @override
  String get household_unconfirmed_badge => '未確認';

  @override
  String get household_exclude_refunds => '返金を除外';

  @override
  String get household_exclude_carryover => '繰越を除外';

  @override
  String get household_unpaid_recurring_title => '今月の残り固定内訳';

  @override
  String household_unpaid_recurring_subtitle(int count, String amount) {
    return '$count件 · 予想合計 ₩$amount';
  }

  @override
  String get household_merchants => '支払先管理';

  @override
  String get household_merchants_my => 'マイ支払先';

  @override
  String get household_merchants_samples => 'よく使う支払先';

  @override
  String get household_merchants_empty => '支払先が登録されていません';

  @override
  String get household_merchants_add => '支払先を追加';

  @override
  String get household_merchants_edit => '支払先を編集';

  @override
  String get household_merchants_name => '支払先名';

  @override
  String get household_merchants_delete => '支払先を削除';

  @override
  String household_merchants_delete_confirm(String name) {
    return '「$name」を削除しますか？';
  }

  @override
  String get household_merchant_select => '支払先を選択';

  @override
  String get household_merchant_none => 'なし';

  @override
  String get household_budget_set => '予算設定';

  @override
  String get household_budget_total_label => '全体予算';

  @override
  String get household_budget_category_label => 'カテゴリ別予算';

  @override
  String get household_budget_not_set => '未設定';

  @override
  String get household_budget_tab_monthly => '今月の予算';

  @override
  String get household_budget_tab_template => '毎月自動予算';

  @override
  String get household_budget_template_info =>
      '毎月1日にテンプレートに基づいて予算が自動設定されます。その月にすでに予算がある場合はスキップされます。';

  @override
  String get household_budget_template_saved => '自動予算テンプレートが設定されました';

  @override
  String get household_budget_template_delete_title => 'テンプレート削除';

  @override
  String get household_budget_template_delete_confirm =>
      'このカテゴリの自動予算テンプレートを削除しますか？';

  @override
  String get household_budget_template_deleted => '自動予算テンプレートが削除されました';

  @override
  String household_budget_category_sum_exceeds(String sum, String total) {
    return 'カテゴリ予算の合計(₩$sum)が全体予算(₩$total)を超えています';
  }

  @override
  String household_budget_category_sum(String amount) {
    return '合計 ₩$amount';
  }

  @override
  String get asset_title => '資産管理';

  @override
  String get asset_statistics => '統計';

  @override
  String get asset_no_group_selected => 'グループを選択してください';

  @override
  String get asset_no_accounts => '登録された口座がありません';

  @override
  String get asset_total_balance => '総残高';

  @override
  String get asset_total_principal => '総元金';

  @override
  String get asset_total_profit => '総利益';

  @override
  String get asset_profit_rate => '利回り';

  @override
  String get asset_account_name => '口座名';

  @override
  String get asset_account_name_hint => '例）住宅積立';

  @override
  String get asset_account_name_required => '口座名を入力してください';

  @override
  String get asset_institution => '金融機関';

  @override
  String get asset_institution_hint => '例）三菱UFJ銀行';

  @override
  String get asset_institution_required => '金融機関名を入力してください';

  @override
  String get asset_account_number => '口座番号（任意）';

  @override
  String get asset_account_number_hint => '例）123-456-789';

  @override
  String get asset_account_type => '口座種別';

  @override
  String get asset_type_savings => '積立';

  @override
  String get asset_type_deposit => '預金';

  @override
  String get asset_type_stock => '株式';

  @override
  String get asset_type_fund => 'ファンド';

  @override
  String get asset_type_real_estate => '不動産';

  @override
  String get asset_type_gold => '現物金';

  @override
  String get asset_type_other => 'その他';

  @override
  String get asset_gold_gram_weight => '保有重量';

  @override
  String get asset_gold_gram_weight_hint => '例: 37.5';

  @override
  String get asset_gold_unit_gram => 'g (グラム)';

  @override
  String get asset_gold_unit_don => '돈（韓国単位）';

  @override
  String get asset_gold_don_hint => '例: 10';

  @override
  String get asset_gold_gram_converted => 'g換算';

  @override
  String get asset_gold_estimated_principal => '予想元金';

  @override
  String get asset_gold_gram_weight_required => '保有重量を入力してください';

  @override
  String get asset_gold_gram_weight_invalid => '有効な数値を入力してください';

  @override
  String get asset_gold_current_price_label => '現在の金相場';

  @override
  String get asset_gold_price_loading => '金相場を取得中…';

  @override
  String get asset_gold_price_error => '金相場を取得できません';

  @override
  String get asset_add_account => '口座追加';

  @override
  String get asset_edit_account => '口座編集';

  @override
  String get asset_delete_account => '口座削除';

  @override
  String get asset_delete_account_confirm => 'この口座を削除しますか？\n関連するすべての記録も削除されます。';

  @override
  String get asset_delete_success => '削除されました';

  @override
  String get asset_save_success => '保存されました';

  @override
  String get asset_account_detail => '口座詳細';

  @override
  String get asset_records => '資産記録';

  @override
  String get asset_holdings => 'ポートフォリオ比率';

  @override
  String get asset_holdings_empty => '登録された銘柄がありません';

  @override
  String get asset_holding_add => '銘柄追加';

  @override
  String get asset_holding_edit => '銘柄編集';

  @override
  String get asset_holding_delete => '銘柄削除';

  @override
  String get asset_holding_name => '銘柄名';

  @override
  String get asset_holding_name_hint => '例: ナスダックETF';

  @override
  String get asset_holding_name_required => '銘柄名を入力してください';

  @override
  String get asset_holding_ticker => 'ティッカー（任意）';

  @override
  String get asset_holding_ticker_hint => '例: QQQ';

  @override
  String get asset_holding_ratio => '比率 (%)';

  @override
  String get asset_holding_ratio_hint => '例: 40';

  @override
  String get asset_holding_ratio_required => '比率を入力してください';

  @override
  String get asset_holding_ratio_invalid => '0.01〜100の数値を入力してください';

  @override
  String get asset_holding_ratio_exceeded => '比率の合計が100%を超えます';

  @override
  String get asset_holding_delete_confirm => 'この銘柄を削除しますか？';

  @override
  String get asset_holding_total_ratio => '合計';

  @override
  String get asset_gold_record_info_title => '金口座の自動管理について';

  @override
  String get asset_gold_record_info_body =>
      'この口座は現物金口座で、以下のように自動管理されます。\n\n• 記録追加時、現在の金現物相場（GOLD_KRW_SPOT）を基に 保有重量 × 相場 = 残高 が自動計算されます。\n\n• 毎月1日、最新の金現物相場を反映して残高・利益・利益率が自動更新されます。\n\n• 元金は手動で変更できます。変更しない場合は最初の記録時に計算された値が維持されます。';

  @override
  String get asset_no_records => '記録がありません';

  @override
  String get asset_add_record => '記録追加';

  @override
  String get asset_record_date => '記録日';

  @override
  String get asset_balance => '残高';

  @override
  String get asset_principal => '元金';

  @override
  String get asset_profit => '利益';

  @override
  String get asset_note => 'メモ（任意）';

  @override
  String get asset_note_hint => '例）利息受取';

  @override
  String get asset_amount_hint => '金額を入力してください';

  @override
  String get asset_amount_required => '金額を入力してください';

  @override
  String get asset_record_date_required => '記録日を選択してください';

  @override
  String get asset_record_save_success => '記録が保存されました';

  @override
  String get asset_statistics_title => '資産統計';

  @override
  String get asset_by_type => '種別別状況';

  @override
  String asset_account_count(int count) {
    return '$count口座';
  }

  @override
  String get asset_savings_total => '貯金箱合計';

  @override
  String get asset_savings_goals => '連動貯金箱';

  @override
  String get asset_trend => '資産推移';

  @override
  String get asset_trend_monthly => '月別';

  @override
  String get asset_trend_yearly => '年別';

  @override
  String get asset_trend_balance => '残高';

  @override
  String get asset_trend_profit_rate => '利回り';

  @override
  String get asset_trend_period_return => '期間別';

  @override
  String get asset_trend_no_data => '表示するデータがありません';

  @override
  String asset_trend_year_label(String year) {
    return '$year年';
  }

  @override
  String get asset_input_mode => '入力方式';

  @override
  String get asset_input_mode_manual => '直接入力';

  @override
  String get asset_input_mode_auto => '自動計算';

  @override
  String get asset_additional_principal => '追加元金';

  @override
  String get asset_additional_principal_hint => '初回記録の場合は初期元金全額を入力してください';

  @override
  String get asset_current_balance => '現在残高';

  @override
  String get asset_duplicate_date_error => 'この日付にはすでに記録が存在します';

  @override
  String get asset_delete_record => '記録削除';

  @override
  String get asset_delete_record_confirm => 'この記録を削除しますか？';

  @override
  String get asset_stat_account_filter => '口座フィルター';

  @override
  String get asset_stat_filter_all => '全て';

  @override
  String get asset_trend_principal => '元金';

  @override
  String get asset_trend_profit => '収益';

  @override
  String get asset_pie_chart_title => '口座別比率';

  @override
  String get asset_pie_mode_type => '種類別';

  @override
  String get asset_pie_mode_account => '口座別';

  @override
  String get asset_pie_mode_portfolio => 'ポートフォリオ合算';

  @override
  String get asset_pie_no_portfolio => 'ポートフォリオデータがありません';

  @override
  String get asset_compare_my_asset => '自分の資産';

  @override
  String get asset_compare_usd_label => 'ドル換算';

  @override
  String get asset_compare_button => '比較';

  @override
  String get childcare_title => '育児ポイント';

  @override
  String get childcare_accounts => '子どものアカウント';

  @override
  String get childcare_add_account => 'アカウント追加';

  @override
  String get childcare_balance => 'ポイント残高';

  @override
  String get childcare_monthly_allowance => '月々のお小遣い';

  @override
  String get childcare_savings_balance => '貯金残高';

  @override
  String get childcare_savings_interest_rate => '利子率';

  @override
  String get childcare_tab_points => 'ポイント';

  @override
  String get childcare_tab_rewards => 'ショップ';

  @override
  String get childcare_tab_rules => 'ルール';

  @override
  String get childcare_tab_history => '履歴';

  @override
  String get childcare_add_transaction => 'ポイント付与/減算';

  @override
  String get childcare_add_reward => '報酬追加';

  @override
  String get childcare_add_rule => 'ルール追加';

  @override
  String get childcare_transaction_type_earn => 'ポイント獲得';

  @override
  String get childcare_transaction_type_spend => 'ポイント使用';

  @override
  String get childcare_transaction_type_penalty => 'ルール違反減算';

  @override
  String get childcare_transaction_type_monthly => '月々のお小遣い';

  @override
  String get childcare_transaction_type_savings_deposit => '貯金入金';

  @override
  String get childcare_transaction_type_savings_withdraw => '貯金出金';

  @override
  String get childcare_transaction_type_interest => '利子支払い';

  @override
  String childcare_reward_points_cost(int points) {
    return '${points}pt';
  }

  @override
  String childcare_rule_penalty(int penalty) {
    return '-${penalty}pt';
  }

  @override
  String get childcare_savings_deposit => '入金';

  @override
  String get childcare_savings_withdraw => '出金';

  @override
  String get childcare_empty_accounts => '子どものアカウントがありません。\nアカウントを追加してください。';

  @override
  String get childcare_empty_transactions => '取引履歴がありません。';

  @override
  String get childcare_empty_rewards => '報酬がありません。\n報酬を追加してください。';

  @override
  String get childcare_empty_rules => 'ルールがありません。\nルールを追加してください。';

  @override
  String get childcare_account_child_id => '子どものユーザーID';

  @override
  String get childcare_account_monthly_allowance => '月々のお小遣い(pt)';

  @override
  String get childcare_account_savings_rate => '貯金利子率(%)';

  @override
  String get childcare_transaction_amount => '金額';

  @override
  String get childcare_transaction_description => '説明';

  @override
  String get childcare_transaction_type => '取引タイプ';

  @override
  String get childcare_reward_name => '報酬名';

  @override
  String get childcare_reward_description => '説明（任意）';

  @override
  String get childcare_reward_points => 'ポイントコスト';

  @override
  String get childcare_rule_name => 'ルール名';

  @override
  String get childcare_rule_description => '説明（任意）';

  @override
  String get childcare_rule_penalty_points => '減算ポイント';

  @override
  String get childcare_savings_amount => '金額';

  @override
  String get childcare_delete_confirm => '削除してもよろしいですか？';

  @override
  String get childcare_select_group => 'グループを選択してください';

  @override
  String get childcare_no_group => 'グループに参加すると育児ポイントが使えます。';

  @override
  String get childcare_no_child => '子どもが登録されていません。\n右上のボタンから子どもを登録してください。';

  @override
  String get household_settings_title => '家計簿の設定';

  @override
  String get household_settings_group_section => 'デフォルトグループ';

  @override
  String get household_settings_auto_section => 'プッシュ自動登録';

  @override
  String get household_settings_auto_toggle => '決済通知の自動登録';

  @override
  String get household_settings_auto_toggle_desc =>
      'カード・銀行の決済通知を検知して家計簿に自動で記録します';

  @override
  String get household_settings_permission_required =>
      '通知へのアクセス権限が必要です。「許可」をタップして設定画面で権限を付与してください。';

  @override
  String get household_settings_permission_grant => '許可';

  @override
  String get household_settings_privacy_section => 'プライバシーポリシー';

  @override
  String get household_settings_privacy_title => '収集情報と処理方針を確認';

  @override
  String get household_settings_privacy_subtitle => 'プッシュ自動登録機能が収集する情報を確認します';

  @override
  String get household_settings_privacy_dialog_title => 'プライバシーポリシー';

  @override
  String get household_settings_auto_scope_notice =>
      'アプリが起動中（フォアグラウンド・バックグラウンド）のときのみ動作します。アプリを完全に終了すると自動登録は停止します。';

  @override
  String get household_settings_privacy_content =>
      '■ 収集する情報\nアプリは、端末に表示されるカード会社・銀行アプリからの決済完了通知から以下の情報を一時的に読み取ります。\n  · 通知のタイトルおよび本文テキスト（例：「KBカード 12,000円 承認」）\n  · 通知を送信したアプリのパッケージ名（例：com.kbcard.kbkookmincard）\n\n■ 収集目的\n読み取った通知テキストから決済金額・支払方法・カテゴリを抽出し、家計簿に自動記録するためにのみ使用されます。\n\n■ 保管および廃棄\n通知テキストは端末内で即座に解析・廃棄され、原文はサーバーへ送信・保存されません。家計簿項目に変換されたデータのみアカウントに保存されます。\n\n■ 第三者への提供\n収集した通知情報は、いかなる第三者にも提供・販売・共有されません。\n\n■ 同意の撤回\nいつでも本設定画面で自動登録をオフにするか、端末設定 > 通知へのアクセスからFamily Plannerの権限を解除できます。';

  @override
  String get fridge_title => '冷蔵庫';

  @override
  String get shopping_title => '買い物';

  @override
  String get fridge_tab_fridge => '冷蔵庫';

  @override
  String get fridge_tab_cart => 'カート';

  @override
  String get fridge_tab_frequent => 'よく買うもの';

  @override
  String get fridge_tab_history => '購入履歴';

  @override
  String get fridge_storage_add => '保管場所を追加';

  @override
  String get fridge_storage_edit => '保管場所を編集';

  @override
  String get fridge_storage_delete => '保管場所を削除';

  @override
  String get fridge_storage_delete_confirm =>
      'この保管場所を削除すると、中の品目もすべて削除されます。続けますか？';

  @override
  String get fridge_storage_name_hint => '例：キッチンの冷蔵庫';

  @override
  String get fridge_storage_type_fridge => '冷蔵';

  @override
  String get fridge_storage_type_freezer => '冷凍';

  @override
  String get fridge_storage_type_pantry => 'パントリー';

  @override
  String get fridge_item_add => '品目を追加';

  @override
  String get fridge_item_edit => '品目を編集';

  @override
  String get fridge_item_delete_title => '品目を削除';

  @override
  String fridge_item_delete_confirm(String name) {
    return '$nameを削除しますか？';
  }

  @override
  String get fridge_item_name => '品目名';

  @override
  String get fridge_item_quantity => '数量';

  @override
  String get fridge_item_unit => '単位（任意）';

  @override
  String get fridge_item_expires_at => '賞味期限（任意）';

  @override
  String fridge_item_alert_days(int days) {
    return '$days日前に通知';
  }

  @override
  String get fridge_item_memo => 'メモ（任意）';

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
  String get fridge_item_no_expiry => '賞味期限なし';

  @override
  String get fridge_empty_storage => '保管場所がありません。追加してみましょう。';

  @override
  String get fridge_empty_items => '品目がありません';

  @override
  String get fridge_item_count => '個';

  @override
  String get fridge_sort_expiry => '期限順';

  @override
  String get fridge_sort_name => '名前順';

  @override
  String get fridge_sort_registered => '登録順';

  @override
  String get fridge_item_elapsed_days => '日';

  @override
  String get fridge_frequent_add => '項目を追加';

  @override
  String get fridge_frequent_auto_add => 'なくなったら自動でカートに追加';

  @override
  String get fridge_frequent_empty => 'よく買うものがありません';

  @override
  String get fridge_frequent_add_to_cart => 'カートに追加';

  @override
  String fridge_frequent_added_snackbar(String name) {
    return '$nameをカートに追加しました';
  }

  @override
  String fridge_frequent_delete_confirm(String name) {
    return '$nameを削除しますか？';
  }

  @override
  String get fridge_frequent_autoAddInfo_title => '自動追加とは？';

  @override
  String get fridge_frequent_autoAddInfo_body =>
      '冷蔵庫でこの品目の数量が0になると、カートに自動で追加されます。\nスイッチをオンにしておくと、冷蔵庫が空になったとき自動で買い物リストに入れます。';

  @override
  String get fridge_frequent_autoAddInfo_hint => '冷蔵庫タブで数量を管理すると連携されます';

  @override
  String get fridge_frequent_coach_fabTitle => 'よく買う品目を追加';

  @override
  String get fridge_frequent_coach_fabDesc =>
      'よく購入する品目を登録しておくと\n次の買い物で素早く追加できます。';

  @override
  String get fridge_frequent_coach_itemTitle => '品目管理';

  @override
  String get fridge_frequent_coach_itemDesc =>
      '品目名・デフォルト単位を設定できます。\nタップで編集、長押しで削除できます。';

  @override
  String get fridge_frequent_coach_autoAddTitle => '自動追加';

  @override
  String get fridge_frequent_coach_autoAddDesc =>
      '冷蔵庫でこの品目の数量が0になると\nカートに自動で追加されます。\n冷蔵庫タブと連携するスマート機能です。';

  @override
  String get fridge_frequent_coach_addToCartTitle => 'カートにすぐ追加';

  @override
  String get fridge_frequent_coach_addToCartDesc => 'ボタン一つで現在のカートに\n即座に追加できます。';

  @override
  String get fridge_frequent_coach_skip => 'スキップ';

  @override
  String get fridge_coach_fabTitle => '保管場所を追加';

  @override
  String get fridge_coach_fabDesc =>
      '冷蔵庫、冷凍室、パントリーなど保管場所を追加できます。\n+ボタンを押して作成してみましょう。';

  @override
  String get fridge_coach_sectionTitle => '保管場所';

  @override
  String get fridge_coach_sectionDesc =>
      'ヘッダーをタップして開閉できます。\n右側の⋮メニューで編集・削除ができます。';

  @override
  String get fridge_coach_itemTitle => '食材管理';

  @override
  String get fridge_coach_itemDesc =>
      '• タップで名前・消費期限・メモを編集できます\n• ±ボタンで数量を調整できます\n• 左スワイプで削除マークが付きます\n• 変更後は保存ボタンを押してください';

  @override
  String get fridge_coach_ddayTitle => '消費期限アラート';

  @override
  String get fridge_coach_ddayDesc =>
      '消費期限を登録すると残り日数が表示されます。\n• 青：余裕あり\n• オレンジ：3日以内\n• 赤：当日または期限切れ\n設定した日前にプッシュ通知が届きます。';

  @override
  String get fridge_coach_addItemTitle => '食材を追加';

  @override
  String get fridge_coach_addItemDesc =>
      '保管場所の右側の+ボタンで追加できます。\n複数の食材を一度に登録でき、\n消費期限・数量・単位・メモも入力できます。';

  @override
  String get fridge_coach_suggestionTitle => '消費期限の自動提案';

  @override
  String get fridge_coach_suggestionDesc =>
      '食材名を入力すると消費期限が自動で提案されます。\n設定 > 消費期限プリセット管理で食材ごとの基準日を\n追加・編集して自動化ルールをカスタマイズできます。';

  @override
  String get fridge_coach_skip => 'スキップ';

  @override
  String get fridge_cart_empty => 'カートが空です';

  @override
  String get fridge_cart_add_item => '品目を追加';

  @override
  String get fridge_cart_complete => '買い物完了';

  @override
  String get fridge_cart_complete_title => '買い物完了';

  @override
  String get fridge_cart_complete_step2_title => '冷蔵庫移送の詳細入力';

  @override
  String get fridge_cart_complete_transfer_hint => '冷蔵庫に移す保管場所を選択してください';

  @override
  String get fridge_cart_complete_add_expense => '家計簿に登録';

  @override
  String get fridge_cart_complete_amount => '合計（品目金額から自動計算）';

  @override
  String get fridge_cart_item_price => '金額（任意）';

  @override
  String get fridge_cart_complete_description => 'メモ（任意）';

  @override
  String get fridge_cart_skip_transfer => '移送しない';

  @override
  String get fridge_history_empty => '購入履歴がありません';

  @override
  String fridge_history_items_count(int count) {
    return '$count点';
  }

  @override
  String get fridge_history_linked_expense => '家計簿連携済み';

  @override
  String get fridge_history_view_expense => '家計簿を見る';

  @override
  String get fridge_history_delete => '履歴を削除';

  @override
  String get fridge_history_delete_confirm_title => '購買履歴の削除';

  @override
  String get fridge_history_delete_confirm_body => 'この購買履歴を削除しますか？';

  @override
  String get fridge_history_delete_expense_notice =>
      '家計簿に連携された支出は、この履歴を削除しても家計簿にそのまま残ります。';

  @override
  String get fridge_group_selector_personal => '個人';

  @override
  String fridge_expiry_suggestion_label(
    String keyword,
    String storageType,
    int days,
  ) {
    return '$keyword基準 · $storageType $days日推奨';
  }

  @override
  String get fridge_expiry_apply => '推奨を適用';

  @override
  String get fridge_expiry_manual => '手動入力';

  @override
  String get fridge_expiry_change_reference => '別の品目を基準にする';

  @override
  String get fridge_expiry_reference_title => '基準品目を選択';

  @override
  String get fridge_expiry_reference_search => '品目を検索';

  @override
  String fridge_expiry_reference_days(int days) {
    return '$days日';
  }

  @override
  String get fridge_expiry_reference_empty => '検索結果がありません';

  @override
  String get fridge_preset_management_title => '賞味期限プリセット管理';

  @override
  String get fridge_preset_management_menu => '賞味期限プリセット管理';

  @override
  String get fridge_preset_edit_shortcut => 'プリセット編集';

  @override
  String fridge_preset_days_label(int days) {
    return '$days日';
  }

  @override
  String get fridge_preset_custom_badge => 'カスタム';

  @override
  String get fridge_preset_reset_confirm => 'デフォルトにリセットしますか？';

  @override
  String get fridge_preset_edit_dialog_title => '賞味期限を編集';

  @override
  String get fridge_preset_add_dialog_title => '新規プリセット登録';

  @override
  String get fridge_preset_days_input_label => '賞味期限（日）';

  @override
  String get fridge_preset_category_input_label => 'カテゴリ';

  @override
  String get fridge_preset_storage_type_label => '保管方法';

  @override
  String get fridge_preset_delete_confirm => 'カスタム設定を削除してデフォルトに戻しますか？';

  @override
  String get fridge_preset_search_hint => 'カテゴリまたは品目を検索';

  @override
  String get dashboard_greetingMorning => 'おはようございます';

  @override
  String get dashboard_greetingAfternoon => 'こんにちは';

  @override
  String get dashboard_greetingEvening => 'こんばんは';

  @override
  String get dashboard_greetingSubtitle => '今日も良い一日を！';

  @override
  String get dashboard_emptyWidgets => '表示するウィジェットがありません';

  @override
  String get dashboard_emptyWidgetsHint => '設定でウィジェットを有効にしてください';

  @override
  String get dashboard_widgetSettings => 'ウィジェット設定';

  @override
  String get dashboard_notifications => '通知';

  @override
  String get weather_widgetTitle => '今日の天気';

  @override
  String get weather_refresh => '天気を更新';

  @override
  String get weather_detail => '詳しく';

  @override
  String get weather_errorMessage => '天気情報を読み込めません';

  @override
  String get weather_dustFine => 'PM10';

  @override
  String get weather_dustUltraFine => 'PM2.5';

  @override
  String get investment_widgetTitle => '投資指標';

  @override
  String get investment_errorMessage => 'データを読み込めません';

  @override
  String get investment_emptyBookmarks => 'お気に入りの指標がありません';

  @override
  String get investment_screenTitle => '投資指標';

  @override
  String get investment_bookmarkSection => 'お気に入り';

  @override
  String get investment_bookmarkReorderHint => '（長押しで並べ替え）';

  @override
  String get investment_allSection => '全指標';

  @override
  String get investment_noData => '指標データがありません';

  @override
  String get investment_loadError => 'データを読み込めませんでした';

  @override
  String get investment_retry => '再試行';

  @override
  String get investment_adminTooltip => '過去データ初期化（管理者）';

  @override
  String get investment_briefingTitle => 'AI市況ブリーフィング';

  @override
  String investment_briefingError(String error) {
    return 'AIブリーフィングエラー: $error';
  }

  @override
  String get investment_briefingMacro => 'マクロ';

  @override
  String get investment_briefingDomestic => '国内市場';

  @override
  String get investment_briefingGlobal => 'グローバル市場';

  @override
  String investment_briefingUpdatedAt(String time) {
    return '更新: $time';
  }

  @override
  String get investment_adminDialogTitle => '過去データ初期化';

  @override
  String get investment_adminDialogDesc =>
      'Yahoo/CoinGecko/BOKから過去の相場を収集しDBに保存します。\n時間がかかる場合があります。';

  @override
  String get investment_adminDaysLabel => '収集日数 (1~3650)';

  @override
  String get investment_adminDaysSuffix => '日';

  @override
  String get investment_adminExecute => '初期化実行';

  @override
  String get investment_adminResultTitle => '初期化完了';

  @override
  String get investment_adminResultYahoo => 'Yahoo（株価/為替/商品）';

  @override
  String get investment_adminResultCrypto => '暗号通貨（BTC/KRW）';

  @override
  String get investment_adminResultBond => '韓国債券';

  @override
  String get investment_adminResultGold => '国内金価格';

  @override
  String investment_adminResultCount(int count) {
    return '$count件';
  }

  @override
  String investment_adminInitError(String error) {
    return '初期化失敗: $error';
  }

  @override
  String get investment_adminLoading => '過去データを収集中...';

  @override
  String get investment_prevPrice => '前日終値';

  @override
  String investment_spreadBadge(String value) {
    return '乖離率 $value%';
  }

  @override
  String get investment_spreadPremium => '国際換算価格比プレミアム';

  @override
  String get investment_spreadDiscount => '国際換算価格比ディスカウント';

  @override
  String get investment_chartTitle => '相場推移';

  @override
  String investment_chartDayChip(int days) {
    return '$days日';
  }

  @override
  String get investment_chartYearChip => '1年';

  @override
  String get investment_chartLoadError => 'チャートを読み込めません';

  @override
  String get investment_chartNoData => 'データがありません';

  @override
  String investment_marketClosed(String date) {
    return '休場中・最終取引日: $date';
  }

  @override
  String get investment_spreadChartTitle => '乖離率推移';

  @override
  String get investment_spreadChartSubtitle => '（国際換算価格比）';

  @override
  String investment_spreadSummaryLabel(String label) {
    return '現在国際換算価格比 $label';
  }

  @override
  String get investment_spreadPremiumLabel => 'プレミアム';

  @override
  String get investment_spreadDiscountLabel => 'ディスカウント';

  @override
  String get investment_coachIndicatorTitle => '投資指標';

  @override
  String get investment_coachIndicatorDesc =>
      '主要株価指数、為替、商品、暗号通貨など\nリアルタイム指標を一目で確認できます。\nタップで詳細チャートと過去の推移を表示。';

  @override
  String get investment_coachBookmarkTitle => 'お気に入り';

  @override
  String get investment_coachBookmarkDesc =>
      '星マークをタップしてお気に入りに追加。\nお気に入りはリスト上部に固定され、\nホームダッシュボードウィジェットで確認できます。';

  @override
  String get householdWidget_groupTooltip => 'グループ選択';

  @override
  String householdWidget_incomeLabel(String month) {
    return '$month 入金';
  }

  @override
  String householdWidget_expenseLabel(String month) {
    return '$month 支出';
  }

  @override
  String get householdWidget_balance => '残高';

  @override
  String householdWidget_budget(String amount) {
    return '予算 $amount';
  }

  @override
  String householdWidget_budgetUsed(int percent) {
    return '$percent% 使用';
  }

  @override
  String householdWidget_budgetOver(String amount) {
    return '$amount 超過';
  }

  @override
  String householdWidget_budgetRemaining(String amount) {
    return '$amount 残り';
  }

  @override
  String get householdWidget_filterTitle => 'フィルター選択';

  @override
  String get householdWidget_filterPersonal => '個人';

  @override
  String get householdWidget_filterPersonalSub => 'グループなしで個人支出のみ';

  @override
  String get householdWidget_applyButton => '適用';

  @override
  String get householdWidget_categoryTitle => 'カテゴリ別支出';

  @override
  String householdWidget_categoryOver(String amount) {
    return '$amount 超過';
  }

  @override
  String householdWidget_categoryUsed(int percent) {
    return '$percent% 使用';
  }

  @override
  String get householdWidget_catTransportation => '交通';

  @override
  String get householdWidget_catFood => '食費';

  @override
  String get householdWidget_catLeisure => 'レジャー';

  @override
  String get householdWidget_catLiving => '生活';

  @override
  String get householdWidget_catMedical => '医療';

  @override
  String get householdWidget_catEducation => '教育';

  @override
  String get householdWidget_catAllowance => 'お小遣い';

  @override
  String get householdWidget_catCelebration => '冠婚葬祭';

  @override
  String get householdWidget_catAssetTransfer => '資産移動';

  @override
  String get householdWidget_catChildcare => '育児費';

  @override
  String get householdWidget_catOther => 'その他';

  @override
  String get assetWidget_title => '資産状況';

  @override
  String assetWidget_groupTitle(String groupName) {
    return '$groupName 資産';
  }

  @override
  String get assetWidget_groupTooltip => 'グループ選択';

  @override
  String get assetWidget_totalAsset => '総資産';

  @override
  String get assetWidget_totalProfit => '総収益';

  @override
  String get assetWidget_profitRate => '収益率';

  @override
  String get assetWidget_distribution => '資産分布';

  @override
  String get assetWidget_groupPickerTitle => 'グループ選択';

  @override
  String get assetWidget_applyButton => '適用';

  @override
  String get assetWidget_typeSavings => '積立';

  @override
  String get assetWidget_typeDeposit => '預金';

  @override
  String get assetWidget_typeStock => '株式';

  @override
  String get assetWidget_typeFund => 'ファンド';

  @override
  String get assetWidget_typeRealEstate => '不動産';

  @override
  String get assetWidget_typeGold => '実物金';

  @override
  String get assetWidget_typeOther => 'その他';

  @override
  String get legal_termsOfService => '利用規約';

  @override
  String get legal_privacyPolicy => 'プライバシーポリシー';

  @override
  String get legal_termsLastUpdated => '施行日: 2026年6月1日';

  @override
  String get legal_termsContact => 'お問い合わせ: hmn.corp.dev@gmail.com';

  @override
  String get legal_agreeToTerms => '利用規約';

  @override
  String get legal_agreeToPrivacy => 'プライバシーポリシー';

  @override
  String get legal_required => '(必須)';

  @override
  String get legal_agreeAll => 'すべてに同意';

  @override
  String get legal_mustAgreeTerms => '利用規約に同意してください。';

  @override
  String get legal_mustAgreePrivacy => 'プライバシーポリシーに同意してください。';

  @override
  String get legal_agreeAgeVerification => '14歳以上です（必須）';

  @override
  String get legal_mustAgreeAgeVerification => '14歳以上であることを確認してください。';

  @override
  String legal_socialLoginConsent(String termsLink, String privacyLink) {
    return '続けることで、$termsLinkおよび$privacyLinkに同意したものとみなされます。';
  }

  @override
  String get legal_terms_section1_title => '第1条（目的）';

  @override
  String get legal_terms_section1_body =>
      '本規約は、エイチエムエン コーポレーション（HMN Corporation）（以下「会社」）が提供するFamily Plannerサービス（以下「サービス」）の利用に関して、会社と会員間の権利・義務および責任事項を定めることを目的とします。';

  @override
  String get legal_terms_section2_title => '第2条（サービスの内容）';

  @override
  String get legal_terms_section2_body =>
      '会社は会員に以下のサービスを提供します：\n• 家族グループ単位のカレンダーおよびタスク共有\n• メンバー間の資産管理および履歴共有\n• 育児報酬（ほめシール等）管理システム\n• AIエージェントを通じた会話、スケジュール管理、マクロ経済/市場ブリーフィングサービス\n• その他会社が追加開発または提携契約等を通じて提供するサービス';

  @override
  String get legal_terms_section3_title => '第3条（会員の義務）';

  @override
  String get legal_terms_section3_body =>
      '• 会員はサービスのAIエージェントに対して、違法または他者に危害を加えるプロンプトを入力してはなりません。\n• 会員は家族グループの招待コードおよびアカウント情報を安全に管理する責任を負います。\n• サービス内の資産管理および市場ブリーフィング機能は参考データの提供を目的としており、会社はこれによる投資結果について法的責任を負いません。';

  @override
  String get legal_terms_section4_title => '第4条（投稿物の著作権および管理）';

  @override
  String get legal_terms_section4_body =>
      '• 会員がサービス内に投稿した情報（チャット、スケジュール、資産情報等）の著作権は当該会員に帰属します。\n• 会社は会員の投稿物をサービス運営・改善（AI機能高度化等）・広報目的にのみ活用し、個人を特定できない形に非識別化して使用します。';

  @override
  String get legal_terms_section5_title => '第5条（サービスの中断および変更）';

  @override
  String get legal_terms_section5_body =>
      '会社は運営上・技術上の必要に応じて提供中のサービスの全部または一部を変更または中断することができ、その場合は事前に告知します。';

  @override
  String get legal_terms_section6_title => '第6条（責任の制限）';

  @override
  String get legal_terms_section6_body =>
      '会社は、天災、サーバー提供業者の障害、第三者AIAPIサービスの障害等の不可抗力によりサービスを提供できない場合、サービス提供に関する責任が免除されます。';

  @override
  String get legal_terms_section7_title => '第7条（施行日）';

  @override
  String get legal_terms_section7_body => '本規約は2026年6月1日より適用されます。';

  @override
  String get legal_privacy_section1_title => '1. 個人情報の処理目的';

  @override
  String get legal_privacy_section1_body =>
      'エイチエムエン コーポレーション（HMN Corporation）（以下「会社」）は、以下の目的のために個人情報を処理します。処理している個人情報は以下の目的以外の用途には使用されず、利用目的が変更される場合には別途同意を取得するなど必要な措置を講じます。\n• 会員登録・管理、家族グループ（招待コード等）の識別\n• サービス提供（カレンダー、タスク、資産管理、育児報酬システム等）\n• AIエージェント（チャットボット、ブリーフィング等）サービスの提供と品質向上\n• 新サービスの開発およびパーソナライズされたサービスの提供';

  @override
  String get legal_privacy_section2_title => '2. 処理する個人情報の項目';

  @override
  String get legal_privacy_section2_body =>
      '会社はサービス提供のために以下の個人情報を処理しています。\n• 必須項目：メールアドレス、パスワード、氏名（またはニックネーム）、プロフィール画像\n• サービス利用過程で収集される情報：カレンダーの予定、タスクリスト、資産データ、家族グループ情報、AIとのチャット履歴、サービス利用記録、端末情報';

  @override
  String get legal_privacy_section3_title => '3. 個人情報の第三者提供および委託';

  @override
  String get legal_privacy_section3_body =>
      'スムーズなAIサービス（文脈分析、ブリーフィング生成等）の提供のため、入力されたデータの一部を外部AIモデルAPI（例：OpenAI、Anthropic、Googleなど）に送信することがあります。\nただし、このデータはサービス提供目的にのみ使用され、モデルの学習には使用されないよう措置を講じます。';

  @override
  String get legal_privacy_section4_title => '4. 個人情報の廃棄';

  @override
  String get legal_privacy_section4_body =>
      '会社は原則として、個人情報の処理目的が達成された場合は速やかに当該個人情報を廃棄します。\n• 廃棄手順：利用者が退会を要請した場合、収集された情報は即時または法令に基づく保存期間の経過後に廃棄されます。\n• 廃棄方法：電子ファイル形式の情報は、記録を再生できない技術的方法を使用します。';

  @override
  String get legal_privacy_section5_title => '5. 情報主体の権利および行使方法';

  @override
  String get legal_privacy_section5_body =>
      '利用者はいつでも自己の個人情報を照会・修正することができ、退会を通じて個人情報の収集・利用への同意を撤回することができます。';

  @override
  String get legal_privacy_section6_title => '6. 個人情報保護責任者';

  @override
  String get legal_privacy_section6_body =>
      '氏名：ユ・ヨンジン\nメール：hmn.corp.dev@gmail.com';

  @override
  String get legal_privacy_section7_title => '7. 施行日';

  @override
  String get legal_privacy_section7_body => '本プライバシーポリシーは2026年6月1日より適用されます。';

  @override
  String get legal_privacyLastUpdated => '施行日: 2026年6月1日';

  @override
  String get shopping_history_delete_title => '購入履歴を削除';

  @override
  String get shopping_history_delete_body => 'このお買い物記録を削除しますか？';

  @override
  String get shopping_history_delete_notice => '家計簿の支出と冷蔵庫の保管品目は削除されずに残ります。';

  @override
  String get shopping_history_readd_all => 'このリストをそのままカートに入れる';

  @override
  String shopping_history_readd_all_snackbar(int count) {
    return '$count件をカートに追加しました。';
  }

  @override
  String shopping_history_readd_item_snackbar(String name) {
    return '$nameをカートに追加しました。';
  }

  @override
  String get shopping_history_price_none => '価格未入力';

  @override
  String get shopping_history_add_to_cart => 'カートに入れる';

  @override
  String get shopping_history_fridge_transferred => '冷蔵庫に移動済み';

  @override
  String get shopping_history_fridge_not_transferred => '移動なし';

  @override
  String get shopping_complete_snackbar => 'お買い物が完了しました。';

  @override
  String get account_management_title => 'アカウント管理';

  @override
  String get account_delete_schedule_title => 'アカウント削除の予約';

  @override
  String get account_delete_schedule_subtitle => '7日の猶予期間後にすべてのデータを削除';

  @override
  String get account_delete_schedule_confirm_title => 'アカウント削除を予約しますか？';

  @override
  String get account_delete_schedule_confirm_body =>
      '7日後にアカウントとすべてのデータが完全に削除されます。\n猶予期間中はキャンセルできます。';

  @override
  String account_delete_schedule_success(String date) {
    return 'アカウント削除が予約されました。$dateに削除されます。';
  }

  @override
  String get account_cancel_delete_title => 'アカウント削除予約のキャンセル';

  @override
  String get account_cancel_delete_subtitle => '予約されたアカウント削除をキャンセルします';

  @override
  String get account_cancel_delete_confirm_title => 'アカウント削除予約をキャンセルしますか？';

  @override
  String get account_cancel_delete_success => 'アカウント削除予約がキャンセルされました';

  @override
  String get account_export_data_title => 'データのエクスポート';

  @override
  String get account_export_data_subtitle => '登録済みのメールアドレスにデータのコピーをお送りします';

  @override
  String get account_export_data_success => 'リクエストが完了しました。メールをご確認ください。';

  @override
  String account_action_failed(String error) {
    return 'エラーが発生しました: $error';
  }

  @override
  String get subscription_free_label => '無料プラン';

  @override
  String get subscription_free_sublabel => '広告が表示されます';

  @override
  String get subscription_trial_label => '2週間無料体験中';

  @override
  String subscription_trial_sublabel_days(int days) {
    return '$days日後に無料プランに切り替わります';
  }

  @override
  String get subscription_trial_sublabel_today => '本日で体験が終了します';

  @override
  String get subscription_ad_free_label => '広告非表示';

  @override
  String subscription_ad_free_sublabel_expires(String date) {
    return '$date まで';
  }

  @override
  String get subscription_ad_free_sublabel_active => '広告なしでご利用中';

  @override
  String get subscription_premium_label => 'Premium';

  @override
  String subscription_premium_sublabel_expires(String date) {
    return '$date まで';
  }

  @override
  String get subscription_premium_sublabel_active => 'すべての機能をご利用中';

  @override
  String get dashboard_trial_banner_title => '広告なし2週間無料体験中';

  @override
  String dashboard_trial_banner_sublabel_days(int days) {
    return '$days日後に通常プランに切り替わります';
  }

  @override
  String get dashboard_trial_banner_sublabel_today => '本日で体験が終了します';

  @override
  String get anniversary_widgetTitle => '近づく記念日';

  @override
  String get anniversary_widgetEmpty => '登録された記念日がありません';

  @override
  String get widgetSettings_anniversarySummary => '記念日';

  @override
  String get widgetSettings_anniversarySummaryDesc =>
      '近づく記念日とD-dayカウントダウンを表示します';

  @override
  String get subscription_manage_title => 'サブスクリプション管理';

  @override
  String get subscription_screen_title => 'サブスクリプション管理';

  @override
  String get subscription_current_plan_label => '現在のプラン';

  @override
  String get subscription_active_status_label => '有効状態';

  @override
  String get subscription_active => '有効';

  @override
  String get subscription_inactive => '無効';

  @override
  String get subscription_expires_at_label => '有効期限';

  @override
  String get subscription_products_section_title => 'サブスクリプション商品';

  @override
  String get subscription_purchase_button => '購読する';

  @override
  String get subscription_restore_button => '購入を復元';

  @override
  String get subscription_purchase_success => '購読が完了しました。';

  @override
  String get subscription_verify_failed_title => '購入確認に失敗しました';

  @override
  String get subscription_verify_failed_message =>
      '既に使用された購入か、検証に失敗しました。問題が続く場合はサポートにお問い合わせください。';

  @override
  String get subscription_verify_network_error =>
      'ネットワークエラーが発生しました。しばらくしてからもう一度お試しください。';

  @override
  String get subscription_restore_success => 'サブスクリプションが復元されました。';

  @override
  String get subscription_product_not_found =>
      'サブスクリプション商品を準備中です。しばらくしてからもう一度お試しください。';

  @override
  String get routine_title => 'ルーティン';

  @override
  String get routine_list_empty => '登録された習慣がありません';

  @override
  String get routine_list_empty_subtitle =>
      '毎日繰り返したい習慣を登録して\nコツコツチェックしながらストリークを積み上げましょう';

  @override
  String get routine_add => '習慣追加';

  @override
  String get routine_edit => '習慣編集';

  @override
  String get routine_delete => '習慣削除';

  @override
  String get routine_delete_confirm => 'この習慣を削除しますか?';

  @override
  String get routine_field_title => 'タイトル';

  @override
  String get routine_field_title_hint => '例: 朝のストレッチ';

  @override
  String get routine_field_title_required => 'タイトルを入力してください';

  @override
  String get routine_field_title_too_long => 'タイトルは100文字以内で入力してください';

  @override
  String get routine_field_emoji => '絵文字';

  @override
  String get routine_field_emoji_custom => '直接入力';

  @override
  String get routine_field_emoji_helper => '絵文字を1つ入力してください(例: 🏃)';

  @override
  String get routine_field_color => '色';

  @override
  String get routine_field_target_count => '週間目標回数';

  @override
  String get routine_field_start_date => '開始日';

  @override
  String get routine_field_end_date => '終了日（任意）';

  @override
  String get routine_field_end_date_none => '無期限';

  @override
  String get routine_field_group => '所属ルーティン';

  @override
  String get routine_field_group_none => 'なし(独立した習慣)';

  @override
  String get routine_save => '保存';

  @override
  String get routine_check => 'チェック';

  @override
  String get routine_uncheck => 'チェック取り消し';

  @override
  String get routine_check_already => 'すでにチェック済みです';

  @override
  String get routine_check_future_date => '未来の日付はチェックできません';

  @override
  String get routine_check_error => 'チェックに失敗しました';

  @override
  String routine_streak_celebration(int days) {
    return '🔥 $days日連続達成!';
  }

  @override
  String get routine_tab_heatmap => 'カレンダー';

  @override
  String get routine_tab_stats => '統計';

  @override
  String get routine_tab_share => '共有';

  @override
  String get routine_streak_current_days => '現在の連続日数';

  @override
  String get routine_streak_longest_days => '最長連続日数';

  @override
  String get routine_streak_current_weeks => '現在の連続週数';

  @override
  String get routine_streak_longest_weeks => '最長連続週数';

  @override
  String get routine_this_week_progress => '今週の進捗';

  @override
  String get routine_weekly_strip_title => '直近8週間の達成状況';

  @override
  String get routine_rate_period_week => '週';

  @override
  String get routine_rate_period_month => '月';

  @override
  String get routine_rate_period_custom => '期間指定';

  @override
  String get routine_rate_achievement => '達成率';

  @override
  String get routine_share_title => '共有グループ管理';

  @override
  String get routine_share_add => 'グループに共有';

  @override
  String get routine_share_remove => '共有解除';

  @override
  String get routine_share_remove_confirm => 'このグループとの共有を解除しますか?';

  @override
  String get routine_share_empty => '共有されたグループがありません';

  @override
  String get routine_share_select_group => '共有するグループを選択';

  @override
  String get routine_group_members_title => 'グループメンバーのルーティン状況';

  @override
  String get routine_group_members_empty => '共有されたルーティンがありません';

  @override
  String get routine_shared_group_select => '共有ルーティンを見るグループを選択';

  @override
  String get routine_shared_group_empty => '所属しているグループがありません';

  @override
  String get routine_sort_order_updated => '順序が変更されました';

  @override
  String get routine_error_generic => 'エラーが発生しました';

  @override
  String get widgetSettings_routineSummary => '今日のルーティン';

  @override
  String get nav_routines => 'ルーティン';

  @override
  String get routine_tab_badges => 'バッジ';

  @override
  String get routine_badges_title => 'マイバッジ';

  @override
  String get routine_badges_empty => 'まだ獲得したバッジがありません';

  @override
  String get routine_badge_earned_title => 'バッジ獲得!';

  @override
  String get routine_badge_earned_confirm => '確認';

  @override
  String get routine_leaderboard_title => 'グループランキング';

  @override
  String get routine_leaderboard_metric_checkCount => 'チェック回数';

  @override
  String get routine_leaderboard_metric_achievementRate => '達成率';

  @override
  String get routine_leaderboard_empty => '共有ルーティンのあるグループメンバーがいません';

  @override
  String get routine_leaderboard_check_count_suffix => '回';

  @override
  String get routine_group_add => 'ルーティン追加';

  @override
  String get routine_group_edit => 'ルーティン編集';

  @override
  String get routine_group_delete => 'ルーティン削除';

  @override
  String get routine_group_delete_confirm =>
      'このルーティンを削除しますか?\n所属する習慣は削除されず、独立した習慣として残ります。';

  @override
  String get routine_group_field_title_hint => '例: 朝のルーティン';

  @override
  String get routine_group_save => '保存';

  @override
  String get routine_group_standalone_section_title => '独立した習慣';

  @override
  String get routine_group_error_generic => 'エラーが発生しました';

  @override
  String get routine_field_memo => 'メモ';

  @override
  String get routine_field_memo_hint => 'この習慣についての説明を残してみましょう';

  @override
  String get routine_field_importance => '重要度';

  @override
  String get routine_importance_low => '低い';

  @override
  String get routine_importance_medium => '普通';

  @override
  String get routine_importance_high => '高い';

  @override
  String get routine_field_time_filter => '時間帯';

  @override
  String get routine_time_filter_morning => '午前';

  @override
  String get routine_time_filter_afternoon => '午後';

  @override
  String get routine_time_filter_evening => '夕方';

  @override
  String get routine_time_filter_none => '指定なし';

  @override
  String get routine_field_category => 'カテゴリー';

  @override
  String get routine_field_category_none => '未分類';

  @override
  String get routine_category_title => 'カテゴリー';

  @override
  String get routine_category_add => 'カテゴリー追加';

  @override
  String get routine_category_edit => 'カテゴリー編集';

  @override
  String get routine_category_delete => 'カテゴリー削除';

  @override
  String get routine_category_delete_confirm =>
      'このカテゴリーを削除しますか?\n所属する習慣は削除されず、未分類として残ります。';

  @override
  String get routine_category_save => '保存';

  @override
  String get routine_category_field_title_hint => '例: 規則正しい生活';

  @override
  String get routine_category_error_generic => 'エラーが発生しました';

  @override
  String get routine_category_empty => '登録されたカテゴリーがありません';

  @override
  String get routine_category_filter_all => 'すべて';

  @override
  String get routine_field_record_type => '記録方式';

  @override
  String get routine_record_type_boolean => 'シンプルチェック';

  @override
  String get routine_record_type_text => 'テキスト';

  @override
  String get routine_record_type_time => '時刻';

  @override
  String get routine_record_type_numeric => '数値';

  @override
  String get routine_record_type_readonly_hint => '記録方式は作成後に変更できません';

  @override
  String get routine_check_dialog_title => '記録入力';

  @override
  String get routine_check_dialog_text_label => '内容';

  @override
  String get routine_check_dialog_numeric_label => '数値';

  @override
  String get routine_check_dialog_time_label => '時刻';

  @override
  String get routine_check_dialog_confirm => 'チェック';

  @override
  String get routine_check_dialog_cancel => 'キャンセル';

  @override
  String get routine_status_active => '有効';

  @override
  String get routine_status_paused => '一時停止';

  @override
  String get routine_status_ended => '終了';

  @override
  String get routine_pause => '一時停止';

  @override
  String get routine_pause_confirm => 'この習慣を一時停止しますか?\n一時停止中はチェックできません。';

  @override
  String get routine_resume => '再開';

  @override
  String get routine_resume_success => '再開しました';

  @override
  String get routine_pause_error => '一時停止に失敗しました';

  @override
  String get routine_resume_error => '再開に失敗しました';

  @override
  String get routine_end => '終了';

  @override
  String get routine_end_confirm => 'この習慣を終了しますか?\nチェック記録は保存されます。';

  @override
  String get routine_frequency_type_daily => '毎日';

  @override
  String get routine_frequency_type_weekly => '毎週';

  @override
  String get routine_frequency_type_monthly => '毎月';

  @override
  String get routine_weekly_mode_count_only => '週N回';

  @override
  String get routine_weekly_mode_fixed_days => '曜日指定';

  @override
  String get routine_field_target_days => '反復曜日';

  @override
  String get routine_day_sun => '日';

  @override
  String get routine_day_mon => '月';

  @override
  String get routine_day_tue => '火';

  @override
  String get routine_day_wed => '水';

  @override
  String get routine_day_thu => '木';

  @override
  String get routine_day_fri => '金';

  @override
  String get routine_day_sat => '土';

  @override
  String get routine_error_weekly_mode_required => '週反復方式を選択してください';

  @override
  String get routine_error_weekly_target_required => '週目標回数を選択してください';

  @override
  String get routine_error_fixed_days_required => '反復する曜日を1つ以上選択してください';

  @override
  String get routine_error_monthly_target_required => '月目標回数を選択してください';
}
