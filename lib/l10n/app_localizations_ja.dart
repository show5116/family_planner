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
  String get common_error => 'エラー';

  @override
  String get common_retry => '再試行';

  @override
  String get common_close => '閉じる';

  @override
  String get common_done => '完了';

  @override
  String get common_next => '次へ';

  @override
  String get common_previous => '前へ';

  @override
  String get common_all => 'すべて';

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
  String get settings_appInfoSubtitle => 'バージョン 1.0.0';

  @override
  String get settings_appDescription => '家族と一緒に日常を管理するプランナー';

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
  String get group_leaveSuccess => 'グループを退出しました';

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
  String get household_edit_expense => '支出を編集';

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
  String get household_total_expense => '総支出';

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
  String get household_category_other => 'その他';

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
  String get asset_type_bank => '銀行';

  @override
  String get asset_type_stock => '株式';

  @override
  String get asset_type_fund => 'ファンド';

  @override
  String get asset_type_insurance => '保険';

  @override
  String get asset_type_real_estate => '不動産';

  @override
  String get asset_type_cash => '現金';

  @override
  String get asset_type_other => 'その他';

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
  String get childcare_tab_rewards => 'ポイントショップ';

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
}
