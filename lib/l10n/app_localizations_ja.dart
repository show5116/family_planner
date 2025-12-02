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
  String get auth_signupPasswordHelperText => '最低6文字以上';

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
  String get profile_profileImage => 'プロフィール画像URL（任意）';

  @override
  String get profile_profileImageHint => '画像URLを入力してください';

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
  String get settings_permissionManagementSubtitle => 'ユーザー権限を管理します';

  @override
  String get permission_title => '権限管理';

  @override
  String get permission_userList => 'ユーザーリスト';

  @override
  String get permission_searchUser => 'ユーザー検索（メール、名前）';

  @override
  String get permission_userId => 'ユーザーID';

  @override
  String get permission_email => 'メール';

  @override
  String get permission_name => '名前';

  @override
  String get permission_isAdmin => '管理者権限';

  @override
  String get permission_createdAt => '登録日';

  @override
  String get permission_admin => '管理者';

  @override
  String get permission_user => '一般ユーザー';

  @override
  String get permission_grantAdmin => '管理者権限を付与';

  @override
  String get permission_revokeAdmin => '管理者権限を取り消し';

  @override
  String get permission_confirmGrant => '管理者権限を付与しますか？';

  @override
  String get permission_confirmRevoke => '管理者権限を取り消しますか？';

  @override
  String permission_grantMessage(String name) {
    return '$nameさんに管理者権限を付与します。';
  }

  @override
  String permission_revokeMessage(String name) {
    return '$nameさんの管理者権限を取り消します。';
  }

  @override
  String get permission_updateSuccess => '権限が更新されました';

  @override
  String get permission_updateFailed => '権限の更新に失敗しました';

  @override
  String get permission_loadFailed => 'ユーザーリストの読み込みに失敗しました';

  @override
  String get permission_noUsers => 'ユーザーが見つかりません';

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
}
